import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/api_client.dart';
import 'features/auth/auth_bloc.dart';
import 'features/auth/auth_repository.dart';
import 'features/products/product_bloc.dart';
import 'features/products/product_repository.dart';
import 'app_routes.dart';

class AppProviders extends StatelessWidget {
  const AppProviders({super.key});

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            AuthRepository(apiClient),
          ),
        ),
        BlocProvider(
          create: (_) => ProductBloc(
            ProductRepository(apiClient),
          ),
        ),
      ],
      child: const AppRoutes(),
    );
  }
}