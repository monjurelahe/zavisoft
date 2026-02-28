import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliver/features/auth/auth_event.dart';
import 'package:sliver/features/auth/auth_state.dart';
import '../../features/auth/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  void initState() {
    super.initState();

    // start login automatically (fake store demo)
    context.read<AuthBloc>().add(AuthStarted());
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthLoaded) {

              Navigator.pushReplacementNamed(context, '/home');
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {

              if (state is AuthLoading) {
                return const CircularProgressIndicator();
              }

              if (state is AuthError) {
                return const Text('Login failed');
              }

              return const Text('Logging in...');
            },
          ),
        ),
      ),
    );
  }
}