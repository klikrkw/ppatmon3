import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/enums/login_method.dart';
import 'package:newklikrkw/models/user.dart';
import 'package:newklikrkw/models/user_model.dart';

import 'package:newklikrkw/repositories/auth_repository.dart';
import 'package:newklikrkw/services/biometric_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final BiometricService biometricService;

  AuthBloc({required this.authRepository, required this.biometricService})
    : super(const AuthInitial()) {
    on<AppStarted>(_onAppStarted);

    on<LoginRequested>(_onLoginRequested);

    on<BiometricLoginRequested>(_onBiometricLoginRequested);

    on<EnableBiometricRequested>(_onEnableBiometricRequested);

    on<DisableBiometricRequested>(_onDisableBiometricRequested);

    on<LogoutRequested>(_onLogoutRequested);
  }

  // ============================================================
  // APP START
  // ============================================================

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    bool biometricAvailable = false;
    bool biometricEnabled = false;

    try {
      biometricAvailable =
          await biometricService.isAvailable() &&
          await biometricService.hasBiometrics();

      biometricEnabled = await authRepository.isBiometricEnabled();
    } catch (_) {
      biometricAvailable = false;
      biometricEnabled = false;
    }

    try {
      final hasToken = await authRepository.hasToken();

      if (!hasToken) {
        emit(
          Unauthenticated(
            biometricAvailable: biometricAvailable,
            biometricEnabled: biometricEnabled,
          ),
        );

        return;
      }

      // ========================================================
      // REMEMBER ME
      // ========================================================

      final rememberMe = await authRepository.isRememberMeEnabled();

      if (!rememberMe) {
        // Token hanya berlaku untuk
        // session sebelumnya.
        await authRepository.clearSessionToken();

        emit(
          Unauthenticated(
            biometricAvailable: biometricAvailable,
            biometricEnabled: biometricEnabled,
          ),
        );

        return;
      }

      final user = await authRepository.getUser();

      if (user == null) {
        await authRepository.clearSessionToken();

        emit(
          Unauthenticated(
            biometricAvailable: biometricAvailable,
            biometricEnabled: biometricEnabled,
          ),
        );

        return;
      }

      final users = await authRepository.getUsers();

      emit(
        Authenticated(
          user,
          users,
          biometricEnabled: biometricEnabled,
          rememberMe: rememberMe,
        ),
      );
    } catch (e) {
      emit(
        AuthFailure(
          e.toString(),
          biometricAvailable: biometricAvailable,
          biometricEnabled: biometricEnabled,
        ),
      );
    }
  }

  // ============================================================
  // NORMAL LOGIN
  // ============================================================

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final user = await authRepository.login(
        event.email,
        event.password,
        rememberMe: event.rememberMe,
      );

      final users = await authRepository.getUsers();

      final biometricEnabled = await authRepository.isBiometricEnabled();

      emit(
        Authenticated(
          user,
          users,
          biometricEnabled: biometricEnabled,
          rememberMe: event.rememberMe,
          loginMethod: LoginMethod.password,
        ),
      );
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  // ============================================================
  // BIOMETRIC LOGIN
  // ============================================================

  Future<void> _onBiometricLoginRequested(
    BiometricLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final available = await biometricService.isAvailable();

      if (!available) {
        emit(const AuthFailure('Biometric tidak tersedia pada perangkat ini.'));

        return;
      }

      final enrolled = await biometricService.hasBiometrics();

      if (!enrolled) {
        emit(
          const AuthFailure(
            'Belum ada fingerprint atau Face ID yang terdaftar.',
          ),
        );

        return;
      }

      final enabled = await authRepository.isBiometricEnabled();

      if (!enabled) {
        emit(const AuthFailure('Login biometrik belum diaktifkan.'));

        return;
      }

      final authenticated = await biometricService.authenticate();

      if (!authenticated) {
        emit(const AuthFailure('Autentikasi biometrik dibatalkan atau gagal.'));

        return;
      }

      final user = await authRepository.loginWithBiometric();

      if (user == null) {
        emit(
          const AuthFailure(
            'Credential biometrik sudah tidak valid. Silakan login menggunakan email dan password.',
          ),
        );

        return;
      }

      final users = await authRepository.getUsers();

      emit(
        Authenticated(
          user,
          users,
          biometricEnabled: true,
          rememberMe: true,
          loginMethod: LoginMethod.biometric,
        ),
      );
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  // ============================================================
  // ENABLE BIOMETRIC
  // ============================================================

  Future<void> _onEnableBiometricRequested(
    EnableBiometricRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final available = await biometricService.isAvailable();

      if (!available) return;

      final enrolled = await biometricService.hasBiometrics();

      if (!enrolled) return;

      final authenticated = await biometricService.authenticate();

      if (!authenticated) return;

      await authRepository.enableBiometric();

      final current = state;

      if (current is Authenticated) {
        emit(
          Authenticated(
            current.user,
            current.users,
            biometricEnabled: true,
            rememberMe: current.rememberMe,
          ),
        );
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  // ============================================================
  // DISABLE BIOMETRIC
  // ============================================================

  Future<void> _onDisableBiometricRequested(
    DisableBiometricRequested event,
    Emitter<AuthState> emit,
  ) async {
    await authRepository.disableBiometric();

    final current = state;

    if (current is Authenticated) {
      emit(
        Authenticated(
          current.user,
          current.users,
          biometricEnabled: false,
          rememberMe: current.rememberMe,
        ),
      );
    }
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  // Future<void> _onLogoutRequested(
  //   LogoutRequested event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   emit(const AuthLoading());

  //   try {
  //     await authRepository.logout();

  //     bool available = false;

  //     try {
  //       available =
  //           await biometricService.isAvailable() &&
  //           await biometricService.hasBiometrics();
  //     } catch (_) {}

  //     final enabled = await authRepository.isBiometricEnabled();

  //     emit(
  //       Unauthenticated(
  //         biometricAvailable: available,
  //         biometricEnabled: enabled,
  //       ),
  //     );
  //   } catch (e) {
  //     emit(AuthFailure(e.toString()));
  //   }
  // }
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      await authRepository.logout();

      final biometricAvailable =
          await biometricService.isAvailable() &&
          await biometricService.hasBiometrics();

      final biometricEnabled = await authRepository.isBiometricEnabled();

      emit(
        Unauthenticated(
          biometricAvailable: biometricAvailable,
          biometricEnabled: biometricEnabled,
        ),
      );
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
