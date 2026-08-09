import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/catatanperm/catatanperm_event.dart';
import 'package:newklikrkw/blocs/catatanperm/catatanperm_state.dart';
import 'package:newklikrkw/enums/catatanperm_date_filter.dart';
import 'package:newklikrkw/models/catatanperm.dart';
import 'package:newklikrkw/models/catatanperm_response.dart';
import 'package:newklikrkw/models/validation_error.dart';
import 'package:newklikrkw/repositories/catatanperm_repository.dart';
import 'package:stream_transform/stream_transform.dart';

class CatatanpermBloc extends Bloc<CatatanpermEvent, CatatanpermState> {
  final CatatanpermRepository repository;

  CatatanpermBloc({required this.repository, String? transpermohonanId})
    : super(
        CatatanpermState.initial().copyWith(
          transpermohonanId: transpermohonanId,
        ),
      ) {
    on<LoadCatatanperms>(_onLoad);

    on<RefreshCatatanperms>(_onRefresh);

    on<LoadMoreCatatanperms>(_onLoadMore);

    on<ChangeCatatanpermDateFilter>(_onChangeDateFilter);

    on<ChangeCatatanpermCustomDate>(_onChangeCustomDate);

    on<ChangeCatatanpermFieldcatatanFilter>(_onChangeFieldcatatan);

    on<SearchCatatanpermChanged>(
      _onSearchChanged,
      transformer: _debounce(const Duration(milliseconds: 500)),
    );

    on<ResetCatatanpermFilter>(_onResetFilter);
    on<LoadFieldcatatans>(_onLoadFieldcatatans);
    on<AddCatatanperm>(_onAddCatatanperm);
    on<UpdateCatatanperm>(_onUpdateCatatanperm);
    on<ResetCatatanpermValidationError>(_onResetValidationError);
    on<ResetCatatanpermSaveState>(_onResetSaveState);
    on<DeleteCatatanperm>(_onDeleteCatatanperm);
  }

  EventTransformer<T> _debounce<T>(Duration duration) {
    return (events, mapper) {
      return events.debounce(duration).switchMap(mapper);
    };
  }

  Future<CatatanpermResponse> _fetch({required int offset}) {
    final range = _buildDateRange();

    return repository.getCatatanperms(
      transpermohonanId: state.transpermohonanId,
      offset: offset,
      limit: state.limit,
      fieldcatatanId: state.selectedFieldcatatanId,
      keyword: state.keyword,
      startDate: range.$1,
      endDate: range.$2,
    );
  }

  (DateTime?, DateTime?) _buildDateRange() {
    final now = DateTime.now();

    switch (state.selectedDateFilter) {
      case CatatanpermDateFilter.today:
        final start = DateTime(now.year, now.month, now.day);

        final end = DateTime(now.year, now.month, now.day, 23, 59, 59);

        return (start, end);

      case CatatanpermDateFilter.last7Days:
        final end = DateTime(now.year, now.month, now.day, 23, 59, 59);

        final start = DateTime(now.year, now.month, now.day - 6);

        return (start, end);

      case CatatanpermDateFilter.thisMonth:
        final start = DateTime(now.year, now.month, 1);

        final end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

        return (start, end);

      case CatatanpermDateFilter.thisYear:
        final start = DateTime(now.year, 1, 1);

        final end = DateTime(now.year, 12, 31, 23, 59, 59);

        return (start, end);

      case CatatanpermDateFilter.custom:
        if (state.startDate == null) {
          return (
            DateTime(
              state.selectedDate.year,
              state.selectedDate.month,
              state.selectedDate.day,
            ),
            DateTime(
              state.selectedDate.year,
              state.selectedDate.month,
              state.selectedDate.day,
              23,
              59,
              59,
            ),
          );
        }

        return (state.startDate, state.endDate);
    }
  }

  Future<void> _reload(Emitter<CatatanpermState> emit) async {
    emit(
      state.copyWith(
        items: const [],
        offset: 0,
        hasMore: true,
        loading: true,
        clearError: true,
      ),
    );

    try {
      final result = await _fetch(offset: 0);

      emit(
        state.copyWith(
          loading: false,
          items: result.items,
          offset: result.items.length,
          total: result.pagination.total,
          hasMore: result.pagination.hasMore,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onLoad(
    LoadCatatanperms event,
    Emitter<CatatanpermState> emit,
  ) async {
    if (event.transpermohonanId != null) {
      emit(state.copyWith(transpermohonanId: event.transpermohonanId));
    }

    await _reload(emit);
  }

  Future<void> _onRefresh(
    RefreshCatatanperms event,
    Emitter<CatatanpermState> emit,
  ) async {
    emit(state.copyWith(refreshing: true, clearError: true));

    try {
      final result = await _fetch(offset: 0);

      emit(
        state.copyWith(
          refreshing: false,
          items: result.items,
          offset: result.items.length,
          total: result.pagination.total,
          hasMore: result.pagination.hasMore,
        ),
      );
    } catch (e) {
      emit(state.copyWith(refreshing: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreCatatanperms event,
    Emitter<CatatanpermState> emit,
  ) async {
    if (state.loading ||
        state.loadingMore ||
        state.refreshing ||
        !state.hasMore) {
      return;
    }

    emit(state.copyWith(loadingMore: true));

    try {
      final result = await _fetch(offset: state.offset);

      emit(
        state.copyWith(
          loadingMore: false,
          items: [...state.items, ...result.items],
          offset: state.offset + result.items.length,
          total: result.pagination.total,
          hasMore: result.pagination.hasMore,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loadingMore: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onChangeDateFilter(
    ChangeCatatanpermDateFilter event,
    Emitter<CatatanpermState> emit,
  ) async {
    emit(state.copyWith(selectedDateFilter: event.filter));

    if (event.filter != CatatanpermDateFilter.custom) {
      await _reload(emit);
    }
  }

  Future<void> _onChangeCustomDate(
    ChangeCatatanpermCustomDate event,
    Emitter<CatatanpermState> emit,
  ) async {
    final start = DateTime(event.date.year, event.date.month, event.date.day);

    final end = DateTime(
      event.date.year,
      event.date.month,
      event.date.day,
      23,
      59,
      59,
    );

    emit(
      state.copyWith(
        selectedDateFilter: CatatanpermDateFilter.custom,
        selectedDate: event.date,
        startDate: start,
        endDate: end,
      ),
    );

    await _reload(emit);
  }

  Future<void> _onChangeFieldcatatan(
    ChangeCatatanpermFieldcatatanFilter event,
    Emitter<CatatanpermState> emit,
  ) async {
    if (event.fieldcatatanId == null) {
      emit(state.copyWith(clearFieldcatatan: true));
    } else {
      emit(state.copyWith(selectedFieldcatatanId: event.fieldcatatanId));
    }

    await _reload(emit);
  }

  Future<void> _onSearchChanged(
    SearchCatatanpermChanged event,
    Emitter<CatatanpermState> emit,
  ) async {
    emit(state.copyWith(keyword: event.keyword));

    await _reload(emit);
  }

  Future<void> _onResetFilter(
    ResetCatatanpermFilter event,
    Emitter<CatatanpermState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedDateFilter: CatatanpermDateFilter.today,
        selectedDate: DateTime.now(),
        clearDateRange: true,
        clearFieldcatatan: true,
        keyword: '',
      ),
    );

    await _reload(emit);
  }

  Future<void> _onLoadFieldcatatans(
    LoadFieldcatatans event,
    Emitter<CatatanpermState> emit,
  ) async {
    emit(state.copyWith(loadingFieldcatatans: true, errorMessage: null));

    try {
      final fieldcatatans = await repository.getFieldcatatans();

      emit(
        state.copyWith(
          loadingFieldcatatans: false,
          fieldcatatans: fieldcatatans,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(loadingFieldcatatans: false, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onAddCatatanperm(
    AddCatatanperm event,
    Emitter<CatatanpermState> emit,
  ) async {
    emit(state.copyWith(saving: true, saveSuccess: false));

    try {
      await repository.add(event.request);

      emit(
        state.copyWith(saving: false, saveSuccess: true, validationError: null),
      );
    } on ValidationError catch (e) {
      emit(
        state.copyWith(saving: false, saveSuccess: false, validationError: e),
      );
    } catch (e) {
      emit(
        state.copyWith(
          saving: false,
          saveSuccess: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onUpdateCatatanperm(
    UpdateCatatanperm event,
    Emitter<CatatanpermState> emit,
  ) async {
    emit(state.copyWith(saving: true, saveSuccess: false));

    try {
      await repository.update(event.id, event.request);

      emit(
        state.copyWith(saving: false, saveSuccess: true, validationError: null),
      );
    } on ValidationError catch (e) {
      emit(
        state.copyWith(saving: false, saveSuccess: false, validationError: e),
      );
    } catch (e) {
      emit(
        state.copyWith(
          saving: false,
          saveSuccess: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onResetValidationError(
    ResetCatatanpermValidationError event,
    Emitter<CatatanpermState> emit,
  ) {
    emit(state.copyWith(validationError: null));
  }

  void _onResetSaveState(
    ResetCatatanpermSaveState event,
    Emitter<CatatanpermState> emit,
  ) {
    emit(state.copyWith(saveSuccess: false));
  }

  Future<void> _onDeleteCatatanperm(
    DeleteCatatanperm event,
    Emitter<CatatanpermState> emit,
  ) async {
    emit(
      state.copyWith(deleting: true, deleteSuccess: false, clearError: true),
    );

    try {
      await repository.delete(event.id);

      final items = _removeItem(state.items, event.id);

      emit(
        state.copyWith(
          deleting: false,
          deleteSuccess: true,
          items: items,
          offset: items.length,
        ),
      );
    } on DioException catch (e) {
      emit(state.copyWith(deleting: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(deleting: false, errorMessage: e.toString()));
    }
  }

  List<Catatanperm> _removeItem(List<Catatanperm> items, int id) {
    return items.where((e) => e.id != id).toList();
  }
}
