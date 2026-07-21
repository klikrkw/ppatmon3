import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/theme/theme_bloc.dart';
import '../blocs/theme/theme_event.dart';
import '../blocs/theme/theme_state.dart';

class ToggleThemeButton extends StatelessWidget {
  const ToggleThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      buildWhen: (previous, current) => previous.themeMode != current.themeMode,
      builder: (context, state) {
        return IconButton(
          tooltip: state.isDark
              ? 'Switch to Light Mode'
              : 'Switch to Dark Mode',
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              state.isDark ? Icons.light_mode : Icons.dark_mode,
              key: ValueKey(state.isDark),
            ),
          ),
          onPressed: () {
            context.read<ThemeBloc>().add(ToggleThemeEvent());
          },
        );
      },
    );
  }
}
