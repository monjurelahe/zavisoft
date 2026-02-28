import 'package:bloc/bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';
import 'auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repo;

  AuthBloc(this.repo) : super(AuthInitial()) {
    on<AuthStarted>((event, emit) async {
      emit(AuthLoading());

      try {
        final token = await repo.login();
        final profile = await repo.fetchProfile();

        emit(AuthLoaded(token, profile));
      } catch (e) {
        emit(AuthError());
      }
    });
  }
}