import 'package:equatable/equatable.dart';

import '../../models/home_dashboard.dart';

class HomeState extends Equatable {
  final bool loading;

  final bool showSaldo;

  final HomeDashboard? dashboard;

  final String? error;
  final int? userId;

  const HomeState({
    this.loading = false,
    this.showSaldo = true,
    this.dashboard,
    this.error,
    this.userId,
  });

  HomeState copyWith({
    bool? loading,
    bool? showSaldo,
    HomeDashboard? dashboard,
    String? error,
    int? userId,
  }) {
    return HomeState(
      loading: loading ?? this.loading,
      showSaldo: showSaldo ?? this.showSaldo,
      dashboard: dashboard ?? this.dashboard,
      error: error,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [loading, showSaldo, dashboard, error, userId];
}
