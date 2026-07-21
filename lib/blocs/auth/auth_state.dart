part of 'auth_bloc.dart';

@immutable
sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class Authenticated extends AuthState {
  final UserModel user;
  final List<User> users;
  const Authenticated(this.user, this.users);
}

final class Unauthenticated extends AuthState {}

final class AuthFailure extends AuthState {
  final String error;
  const AuthFailure(this.error);
}
