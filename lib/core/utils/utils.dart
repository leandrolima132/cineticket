import 'package:intl/intl.dart';

/// Formata data para dd/MM/yyyy (pt-BR).
String formatDateToBr(String date) {
  return DateFormat('dd/MM/yyyy', 'pt_BR').format(DateTime.parse(date));
}

bool isValidCpf(String cpf) {
  final digits = cpf.replaceAll(RegExp(r'\D'), '');
  if (digits.length != 11) return false;
  if (RegExp(r'^(\d)\1*$').hasMatch(digits)) return false;
  int sum = 0;
  for (var i = 0; i < 9; i++) {
    sum += int.parse(digits[i]) * (10 - i);
  }
  var remainder = (sum * 10) % 11;
  if (remainder == 10) remainder = 0;
  if (remainder != int.parse(digits[9])) return false;
  sum = 0;
  for (var i = 0; i < 10; i++) {
    sum += int.parse(digits[i]) * (11 - i);
  }
  remainder = (sum * 10) % 11;
  if (remainder == 10) remainder = 0;
  return remainder == int.parse(digits[10]);
}
