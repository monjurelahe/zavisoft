import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoaded extends AuthState {
  final String token;
  final Map<String, dynamic> profile;

  const AuthLoaded(this.token, this.profile);

  @override
  List<Object?> get props => [token, profile];
}

class AuthError extends AuthState {}