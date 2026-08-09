import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/auth/auth.dart';

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
          listener: (context, state) {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error)));
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
      LoginRequested(_emailController.text.trim(), _passwordController.text),
    );
  }
}
