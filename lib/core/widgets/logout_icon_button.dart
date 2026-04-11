import 'package:cineticket/core/router/routes.dart';
import 'package:cineticket/modules/cart/cart_bloc.dart';
import 'package:cineticket/modules/cart/cart_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void logoutAndGoToLogin(BuildContext context) {
  context.read<CartBloc>().add(const ClearCartEvent());
  Navigator.of(context).pushNamedAndRemoveUntil(
    AppRoutes.auth,
    (route) => false,
  );
}

class LogoutIconButton extends StatelessWidget {
  const LogoutIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.logout),
      tooltip: 'Sair',
      onPressed: () => logoutAndGoToLogin(context),
    );
  }
}
