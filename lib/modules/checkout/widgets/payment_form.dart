import 'package:cineticket/core/utils/input_formatters.dart';
import 'package:cineticket/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final VoidCallback onPay;
  final bool isProcessing;

  const PaymentForm({
    super.key,
    required this.formKey,
    required this.onPay,
    this.isProcessing = false,
  });

  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  late final TextEditingController _cpfController;
  late final TextEditingController _nameController;
  late final TextEditingController _cardController;
  late final TextEditingController _expiryController;
  late final TextEditingController _cvvController;

  @override
  void initState() {
    super.initState();
    _cpfController = TextEditingController();
    _nameController = TextEditingController();
    _cardController = TextEditingController();
    _expiryController = TextEditingController();
    _cvvController = TextEditingController();
  }

  @override
  void dispose() {
    _cpfController.dispose();
    _nameController.dispose();
    _cardController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dados do cartão',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            decoration: _buildInputDecoration('Nome no cartão'),
            textCapitalization: TextCapitalization.words,
            style: const TextStyle(color: Colors.white),
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe o nome' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _cpfController,
            decoration: _buildInputDecoration('CPF', hint: '000.000.000-00'),
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            inputFormatters: [CpfInputFormatter()],
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Informe o CPF';
              final digits = v.replaceAll(RegExp(r'\D'), '');
              if (digits.length != 11) return 'CPF deve ter 11 dígitos';
              if (!isValidCpf(digits)) return 'CPF inválido';
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _cardController,
            decoration: _buildInputDecoration('Número do cartão', hint: '0000 0000 0000 0000'),
            inputFormatters: [CardNumberInputFormatter()],
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            validator: (v) =>
                (v == null || v.replaceAll(' ', '').length < 16) ? 'Informe 16 dígitos' : null,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _expiryController,
                  decoration: _buildInputDecoration('Validade', hint: 'MM/AA'),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  inputFormatters: [ExpiryDateInputFormatter()],
                  validator: (v) =>
                      (v == null || !RegExp(r'^\d{2}/\d{2}$').hasMatch(v)) ? 'MM/AA' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _cvvController,
                  decoration: _buildInputDecoration('CVV', hint: '123'),
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  validator: (v) => (v == null || v.length < 3) ? '3 dígitos' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: widget.isProcessing ? null : widget.onPay,
              icon: widget.isProcessing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.payment),
              label: Text(widget.isProcessing ? 'Processando...' : 'Pagar'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Colors.white.withOpacity(0.08),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
