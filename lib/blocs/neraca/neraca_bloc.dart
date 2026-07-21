import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:newklikrkw/blocs/neraca/neraca_event.dart';
import 'package:newklikrkw/blocs/neraca/neraca_state.dart';

import 'package:newklikrkw/models/neraca_response.dart';
import 'package:newklikrkw/repositories/neraca_repository.dart';

class NeracaBloc extends Bloc<NeracaEvent, NeracaState> {
  final NeracaRepository repository;

  NeracaBloc({required this.repository}) : super(NeracaState.initial()) {
    on<LoadNeraca>(_onLoadNeraca);
    on<LoadNeracaPermohonan>(_onLoadNeracaPermohonan);
    on<RefreshNeraca>(_onRefreshNeraca);
    on<RefreshNeracaPermohonan>(_onRefreshNeracaPermohonan);
    on<ChangeYear>(_onChangeYear);
  }

  Future<void> _onLoadNeraca(
    LoadNeraca event,
    Emitter<NeracaState> emit,
  ) async {
    emit(state.copyWith(loading: true, clearError: true));

    try {
      final result = await _fetchData();

      emit(
        state.copyWith(
          loading: false,
          items: result.neracas,
          totalDebet: result.totalDebet,
          totalKredit: result.totalKredit,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadNeracaPermohonan(
    LoadNeracaPermohonan event,
    Emitter<NeracaState> emit,
  ) async {
    emit(
      state.copyWith(loading: true, clearError: true, transpermohonanId: null),
    );

    try {
      final result = await _fetchDataNeracaPermohonan(event.transpermohonanId);

      emit(
        state.copyWith(
          loading: false,
          items: result.neracas,
          totalDebet: result.totalDebet,
          totalKredit: result.totalKredit,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onRefreshNeraca(
    RefreshNeraca event,
    Emitter<NeracaState> emit,
  ) async {
    emit(state.copyWith(refreshing: true, clearError: true));

    try {
      final result = await _fetchData();

      emit(
        state.copyWith(
          refreshing: false,
          items: result.neracas,
          totalDebet: result.totalDebet,
          totalKredit: result.totalKredit,
        ),
      );
    } catch (e) {
      emit(state.copyWith(refreshing: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onRefreshNeracaPermohonan(
    RefreshNeracaPermohonan event,
    Emitter<NeracaState> emit,
  ) async {
    emit(state.copyWith(refreshing: true, clearError: true));

    try {
      final result = await _fetchDataNeracaPermohonan(null);

      emit(
        state.copyWith(
          refreshing: false,
          items: result.neracas,
          totalDebet: result.totalDebet,
          totalKredit: result.totalKredit,
        ),
      );
    } catch (e) {
      emit(state.copyWith(refreshing: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onChangeYear(
    ChangeYear event,
    Emitter<NeracaState> emit,
  ) async {
    emit(state.copyWith(selectedYear: event.year));

    add(const LoadNeraca());
  }

  Future<NeracaResponse> _fetchData() {
    return repository.getNeraca(year: state.selectedYear);
  }

  Future<NeracaResponse> _fetchDataNeracaPermohonan(String? transpermohonanId) {
    return repository.getNeracaPermohonan(
      transpermohonanId: transpermohonanId!,
    );
  }
}
