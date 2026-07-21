import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(themeMode: ThemeMode.light)) {
    on<ToggleThemeEvent>(_toggleTheme);
    on<SetThemeEvent>(_setTheme);
  }

  void _toggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) {
    emit(
      state.copyWith(
        themeMode: state.isDark ? ThemeMode.light : ThemeMode.dark,
      ),
    );
  }

  void _setTheme(SetThemeEvent event, Emitter<ThemeState> emit) {
    emit(state.copyWith(themeMode: event.themeMode));
  }
}
