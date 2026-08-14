import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/auth/auth.dart';
import 'package:newklikrkw/enums/login_method.dart';
import 'package:newklikrkw/repositories/auth_repository.dart';
import 'package:newklikrkw/services/biometric_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  // bool _showBiometricPrompt = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          // listenWhen: (previous, current) {
          //   return previous is! Authenticated && current is Authenticated;
          // },
          listener: (context, state) async {
            // if (state is Authenticated) {
            //   if (!_showBiometricPrompt) {
            //     return;
            //   }

            //   _showBiometricPrompt = false;

            //   await _showEnableBiometricDialog();
            // }
            if (state is Authenticated &&
                state.loginMethod == LoginMethod.password) {
              print('state sekarang: $state');
              _showEnableBiometricDialog();
            }
          },
          builder: (context, state) {
            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,

                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),

                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 48,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 420),

                        child: Form(
                          key: _formKey,

                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,

                              children: [
                                /// =========================
                                /// ICON / LOGO
                                /// =========================
                                Icon(
                                  Icons.account_balance,
                                  size: 72,
                                  color: Theme.of(context).colorScheme.primary,
                                ),

                                const SizedBox(height: 20),

                                /// =========================
                                /// TITLE
                                /// =========================
                                Text(
                                  "Welcome to E-PPAT!",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  "Enter your email and password to continue.",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),

                                const SizedBox(height: 32),

                                // / =========================
                                // / ERROR
                                // / =========================
                                if (state is AuthFailure) ...[
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.errorContainer,

                                      borderRadius: BorderRadius.circular(8),
                                    ),

                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.error_outline,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onErrorContainer,
                                        ),

                                        const SizedBox(width: 10),

                                        Expanded(
                                          child: Text(
                                            state.error,
                                            style: TextStyle(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onErrorContainer,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 20),
                                ],

                                /// =========================
                                /// EMAIL
                                /// =========================
                                ///
                                TextFormField(
                                  controller: _emailController,

                                  keyboardType: TextInputType.emailAddress,

                                  textInputAction: TextInputAction.next,

                                  autofillHints: const [AutofillHints.email],

                                  decoration: const InputDecoration(
                                    labelText: "Email",
                                    hintText: "Masukkan email",

                                    prefixIcon: Icon(Icons.email_outlined),

                                    border: OutlineInputBorder(),
                                  ),

                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "Email wajib diisi";
                                    }

                                    final emailValid = RegExp(
                                      r'^[^@]+@[^@]+\.[^@]+$',
                                    ).hasMatch(value.trim());

                                    if (!emailValid) {
                                      return "Format email tidak valid";
                                    }

                                    return null;
                                  },
                                ),

                                const SizedBox(height: 18),

                                /// =========================
                                /// PASSWORD
                                /// =========================
                                TextFormField(
                                  controller: _passwordController,

                                  obscureText: !_isPasswordVisible,

                                  textInputAction: TextInputAction.done,

                                  autofillHints: const [AutofillHints.password],

                                  decoration: InputDecoration(
                                    labelText: "Password",

                                    hintText: "Masukkan password",

                                    prefixIcon: const Icon(Icons.lock_outline),

                                    border: const OutlineInputBorder(),

                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordVisible
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),

                                      onPressed: () {
                                        setState(() {
                                          _isPasswordVisible =
                                              !_isPasswordVisible;
                                        });
                                      },
                                    ),
                                  ),

                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Password wajib diisi";
                                    }

                                    if (value.length < 6) {
                                      return "Password minimal 6 karakter";
                                    }

                                    return null;
                                  },

                                  onFieldSubmitted: (_) {
                                    _login(state);
                                  },
                                ),

                                const SizedBox(height: 10),

                                /// =========================
                                /// REMEMBER ME
                                /// =========================
                                CheckboxListTile(
                                  value: _rememberMe,

                                  contentPadding: EdgeInsets.zero,

                                  controlAffinity:
                                      ListTileControlAffinity.leading,

                                  title: const Text("Remember me"),

                                  dense: true,

                                  onChanged: state is AuthLoading
                                      ? null
                                      : (value) {
                                          setState(() {
                                            _rememberMe = value ?? false;
                                          });
                                        },
                                ),

                                const SizedBox(height: 20),

                                /// =========================
                                /// LOGIN BUTTON
                                /// =========================
                                SizedBox(
                                  height: 52,

                                  child: FilledButton.icon(
                                    onPressed: state is AuthLoading
                                        ? null
                                        : () {
                                            _login(state);
                                          },

                                    icon: state is AuthLoading
                                        ? const SizedBox(
                                            width: 22,
                                            height: 22,

                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Icon(Icons.login),

                                    label: Text(
                                      state is AuthLoading
                                          ? "Memproses..."
                                          : "Sign In",
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // const SizedBox(height: 12),
                                if (state is Unauthenticated &&
                                    state.biometricAvailable &&
                                    state.biometricEnabled)
                                  Column(
                                    children: [
                                      const SizedBox(height: 12),

                                      SizedBox(
                                        width: double.infinity,
                                        height: 48,
                                        child: OutlinedButton.icon(
                                          onPressed: () {
                                            context.read<AuthBloc>().add(
                                              const BiometricLoginRequested(),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.fingerprint,
                                            size: 28,
                                          ),
                                          label: const Text(
                                            'Login dengan Biometrik',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                Text(
                                  "E-PPAT",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _login(AuthState state) {
    if (state is AuthLoading) {
      return;
    }

    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    context.read<AuthBloc>().add(
      LoginRequested(
        _emailController.text.trim(),
        _passwordController.text,
        rememberMe: _rememberMe,
      ),
    );
  }

  // Future<bool> _biometricAvailable() async {
  //   final service = BiometricService();

  //   final supported = await service.isAvailable();

  //   if (!supported) {
  //     return false;
  //   }

  //   return service.hasBiometrics();
  // }

  // void _loginBiometric() {
  //   FocusScope.of(context).unfocus();

  //   context.read<AuthBloc>().add(const BiometricLoginRequested());
  // }

  // Future<void> _askEnableBiometric() async {
  //   final service = BiometricService();

  //   final available = await service.isAvailable();

  //   if (!available) return;

  //   final enrolled = await service.hasBiometrics();

  //   if (!enrolled) return;

  //   if (!mounted) return;

  //   final result = await showDialog<bool>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text('Aktifkan Login Biometrik?'),
  //         content: const Text(
  //           'Gunakan fingerprint atau Face ID '
  //           'untuk login lebih cepat pada perangkat ini.',
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context, false);
  //             },
  //             child: const Text('Nanti'),
  //           ),
  //           FilledButton(
  //             onPressed: () {
  //               Navigator.pop(context, true);
  //             },
  //             child: const Text('Aktifkan'),
  //           ),
  //         ],
  //       );
  //     },
  //   );

  //   if (result == true && mounted) {
  //     context.read<AuthBloc>().add(const EnableBiometricRequested());
  //   }
  // }
  Future<void> _showEnableBiometricDialog() async {
    final service = BiometricService();

    final available = await service.isAvailable();
    if (!available || !mounted) {
      return;
    }

    final enrolled = await service.hasBiometrics();

    if (!enrolled || !mounted) {
      return;
    }

    final enabled = await context.read<AuthRepository>().isBiometricEnabled();

    if (enabled || !mounted) {
      return;
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Aktifkan Login Biometrik?'),
          content: const Text(
            'Gunakan fingerprint atau Face ID '
            'untuk login lebih cepat pada perangkat ini.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Nanti'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Aktifkan'),
            ),
          ],
        );
      },
    );

    if (result == true && mounted) {
      context.read<AuthBloc>().add(const EnableBiometricRequested());
    }
  }
}
