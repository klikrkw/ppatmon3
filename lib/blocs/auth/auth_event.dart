part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}

final class AppStarted extends AuthEvent {
  const AppStarted();
}

final class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  final bool rememberMe;

  const LoginRequested(this.email, this.password, {this.rememberMe = false});
}

final class BiometricLoginRequested extends AuthEvent {
  const BiometricLoginRequested();
}

final class EnableBiometricRequested extends AuthEvent {
  const EnableBiometricRequested();
}

final class DisableBiometricRequested extends AuthEvent {
  const DisableBiometricRequested();
}

final class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}
