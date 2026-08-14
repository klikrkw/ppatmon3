part of 'auth_bloc.dart';

sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class Authenticated extends AuthState {
  final UserModel user;
  final List<User> users;

  final bool biometricEnabled;
  final bool rememberMe;
  final LoginMethod loginMethod;
  const Authenticated(
    this.user,
    this.users, {
    this.biometricEnabled = false,
    this.rememberMe = false,
    this.loginMethod = LoginMethod.password,
  });
}

final class Unauthenticated extends AuthState {
  final bool biometricAvailable;
  final bool biometricEnabled;

  const Unauthenticated({
    this.biometricAvailable = false,
    this.biometricEnabled = false,
  });
}

final class AuthFailure extends AuthState {
  final String error;

  final bool biometricAvailable;
  final bool biometricEnabled;

  const AuthFailure(
    this.error, {
    this.biometricAvailable = false,
    this.biometricEnabled = false,
  });
}
