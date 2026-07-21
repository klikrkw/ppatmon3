import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/models/home_dashboard.dart';
import 'package:newklikrkw/repositories/home_repository.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc(this.repository) : super(const HomeState()) {
    on<LoadHome>(_onLoad);

    on<RefreshHome>(_onRefresh);

    on<ToggleSaldo>(_onToggle);
  }

  Future<void> _onLoad(LoadHome event, Emitter<HomeState> emit) async {
    emit(
      state.copyWith(
        userId: event.userId,
        loading: true,
        dashboard: null,
        showSaldo: false,
        error: null,
      ),
    );
    final result = _fetchData();
    emit(
      state.copyWith(
        dashboard: await result,
        loading: false,
        showSaldo: false,
        error: null,
      ),
    );
  }

  void _onToggle(ToggleSaldo event, Emitter<HomeState> emit) {
    emit(state.copyWith(showSaldo: !state.showSaldo));
  }

  FutureOr<void> _onRefresh(RefreshHome event, Emitter<HomeState> emit) async {
    emit(
      state.copyWith(
        loading: true,
        dashboard: null,
        showSaldo: false,
        error: null,
      ),
    );

    final result = _fetchData();
    emit(
      state.copyWith(
        dashboard: await result,
        loading: false,
        showSaldo: false,
        error: null,
      ),
    );
  }

  Future<HomeDashboard> _fetchData() {
    return repository.dashboard(state.userId);
  }
}
