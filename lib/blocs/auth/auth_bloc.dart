import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/models/user.dart';
import 'package:newklikrkw/models/user_model.dart';
import 'package:newklikrkw/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AppStarted>((event, emit) async {
      final bool hasToken = await authRepository.hasToken();
      if (hasToken) {
        final user = await authRepository.getUser();
        if (user == null) {
          emit(Unauthenticated());
        } else {
          final users = await authRepository.getUsers();
          emit(Authenticated(user, users));
        }
      } else {
        await authRepository.logout();
        emit(Unauthenticated());
      }
    });

    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.login(event.email, event.password);
        final users = await authRepository.getUsers();
        emit(Authenticated(user, users));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        emit(Unauthenticated());
      } catch (e) {
        emit(Unauthenticated()); // Tetap logout di UI meski API gagal
      }
      await authRepository.logout();
    });
  }
}
