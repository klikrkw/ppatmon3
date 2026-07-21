import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/models/postingjurnal.dart';
import 'package:newklikrkw/models/validation_exception.dart';

import 'postingjurnal_event.dart';
import 'postingjurnal_state.dart';

import 'package:newklikrkw/enums/postingjurnal_filter_range.dart';
import 'package:newklikrkw/models/postingjurnal_response.dart';
import 'package:newklikrkw/repositories/postingjurnal_repository.dart';

class PostingjurnalBloc extends Bloc<PostingjurnalEvent, PostingjurnalState> {
  final PostingjurnalRepository repository;

  PostingjurnalBloc({required this.repository})
    : super(PostingjurnalState.initial()) {
    on<LoadPostingjurnals>(_onLoad);

    on<RefreshPostingjurnals>(_onRefresh);

    on<LoadMorePostingjurnals>(_onLoadMore);

    on<ChangePostingjurnalFilterRange>(_onChangeRange);

    on<ChangePostingjurnalPeriod>(_onChangePeriod);

    on<ResetPostingjurnalFilter>(_onResetFilter);
    //------------------------------------------
    // Akun
    //------------------------------------------

    on<LoadAkuns>(_onLoadAkuns, transformer: restartable());

    //------------------------------------------
    // CRUD
    //------------------------------------------

    on<AddPostingjurnal>(_onAddPostingjurnal, transformer: sequential());

    on<UpdatePostingjurnal>(_onUpdatePostingjurnal, transformer: sequential());

    on<DeletePostingjurnal>(_onDeletePostingjurnal, transformer: sequential());

    //------------------------------------------
    // Reset
    //------------------------------------------

    on<ResetValidationError>(_onResetValidationError);

    on<ResetSaveState>(_onResetSaveState);

    on<ResetDeleteState>(_onResetDeleteState);
    on<ResetPostingjurnalState>(_onResetPostingjurnalState);
  }

  ///==========================================================
  /// Reset Pagination
  ///==========================================================

  // PostingjurnalState _resetPagination() {
  //   return state.copyWith(items: [], offset: 0, hasMore: true);
  // }

  ///==========================================================
  /// Calculate Date Range
  ///==========================================================

  (DateTime, DateTime) _calculateRange(PostingjurnalFilterRange range) {
    final now = DateTime.now();

    switch (range) {
      case PostingjurnalFilterRange.today:
        return (
          DateTime(now.year, now.month, now.day),
          DateTime(now.year, now.month, now.day, 23, 59, 59),
        );

      case PostingjurnalFilterRange.thisWeek:
        final start = now.subtract(Duration(days: now.weekday - 1));

        final end = start.add(const Duration(days: 6));

        return (
          DateTime(start.year, start.month, start.day),
          DateTime(end.year, end.month, end.day, 23, 59, 59),
        );

      case PostingjurnalFilterRange.thisMonth:
        return (
          DateTime(now.year, now.month, 1),
          DateTime(now.year, now.month + 1, 0, 23, 59, 59),
        );

      case PostingjurnalFilterRange.thisYear:
        return (
          DateTime(now.year, 1, 1),
          DateTime(now.year, 12, 31, 23, 59, 59),
        );

      case PostingjurnalFilterRange.custom:
        return (state.startDate, state.endDate);
    }
  }

  ///==========================================================
  /// Fetch Data
  ///==========================================================

  Future<PostingjurnalResponse> _fetchData({
    required int offset,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return repository.getPostingjurnals(
      offset: offset,
      limit: state.limit,
      startDate: startDate ?? state.startDate,
      endDate: endDate ?? state.endDate,
    );
  }

  Future<void> _reload(Emitter<PostingjurnalState> emit) async {
    emit(
      state.copyWith(
        loading: true,
        clearError: true,
        items: const [],
        offset: 0,
        hasMore: true,
      ),
    );

    try {
      final response = await _fetchData(offset: 0);

      emit(
        state.copyWith(
          loading: false,
          items: response.items,
          offset: response.items.length,
          hasMore: response.pagination.hasMore,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }

  ///==========================================================
  /// Event Handler
  ///==========================================================

  Future<void> _onLoad(
    LoadPostingjurnals event,
    Emitter<PostingjurnalState> emit,
  ) async {
    await _reload(emit);
  }

  Future<void> _onRefresh(
    RefreshPostingjurnals event,
    Emitter<PostingjurnalState> emit,
  ) async {
    emit(state.copyWith(refreshing: true, clearError: true));

    try {
      final response = await _fetchData(offset: 0);

      emit(
        state.copyWith(
          refreshing: false,
          items: response.items,
          offset: response.items.length,
          hasMore: response.pagination.hasMore,
        ),
      );
    } catch (e) {
      emit(state.copyWith(refreshing: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadMore(
    LoadMorePostingjurnals event,
    Emitter<PostingjurnalState> emit,
  ) async {
    if (state.loadingMore || state.loading || !state.hasMore) {
      return;
    }

    emit(state.copyWith(loadingMore: true));

    try {
      final response = await _fetchData(offset: state.offset);

      emit(
        state.copyWith(
          loadingMore: false,
          items: [...state.items, ...response.items],
          offset: state.offset + response.items.length,
          hasMore: response.pagination.hasMore,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loadingMore: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onChangeRange(
    ChangePostingjurnalFilterRange event,
    Emitter<PostingjurnalState> emit,
  ) async {
    final (startDate, endDate) = _calculateRange(event.range);

    emit(
      state.copyWith(
        selectedRange: event.range,
        startDate: startDate,
        endDate: endDate,
        items: const [],
        offset: 0,
        hasMore: true,
        clearError: true,
      ),
    );

    await _reload(emit);
  }

  Future<void> _onChangePeriod(
    ChangePostingjurnalPeriod event,
    Emitter<PostingjurnalState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedRange: PostingjurnalFilterRange.custom,
        startDate: event.startDate,
        endDate: event.endDate,
        items: const [],
        offset: 0,
        hasMore: true,
        clearError: true,
      ),
    );

    await _reload(emit);
  }

  Future<void> _onResetFilter(
    ResetPostingjurnalFilter event,
    Emitter<PostingjurnalState> emit,
  ) async {
    final now = DateTime.now();

    emit(
      state.copyWith(
        selectedRange: PostingjurnalFilterRange.today,
        startDate: DateTime(now.year, now.month, now.day),
        endDate: DateTime(now.year, now.month, now.day, 23, 59, 59),
        items: const [],
        offset: 0,
        hasMore: true,
        clearError: true,
      ),
    );

    await _reload(emit);
  }

  Future<void> _onLoadAkuns(
    LoadAkuns event,
    Emitter<PostingjurnalState> emit,
  ) async {
    if (state.loadingAkuns) {
      return;
    }

    if (state.akuns.isNotEmpty) {
      return;
    }

    emit(state.copyWith(loadingAkuns: true, clearErrorMessage: true));

    try {
      final akuns = await repository.getAkuns();

      akuns.sort((a, b) => a.kodeAkun.compareTo(b.kodeAkun));

      emit(state.copyWith(loadingAkuns: false, akuns: akuns));
    } on DioException catch (e) {
      emit(state.copyWith(loadingAkuns: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(loadingAkuns: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onAddPostingjurnal(
    AddPostingjurnal event,
    Emitter<PostingjurnalState> emit,
  ) async {
    emit(
      state.copyWith(
        saving: true,
        saveSuccess: false,
        clearValidationError: true,
        clearErrorMessage: true,
      ),
    );

    try {
      final postingjurnal = await repository.create(event.request);

      final items = [postingjurnal, ...state.items];

      emit(
        state.copyWith(
          saving: false,
          saveSuccess: true,
          items: items,
          offset: items.length,
        ),
      );
    } on ValidationException catch (e) {
      emit(state.copyWith(saving: false, validationError: e.validationError));
    } on DioException catch (e) {
      emit(state.copyWith(saving: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(saving: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdatePostingjurnal(
    UpdatePostingjurnal event,
    Emitter<PostingjurnalState> emit,
  ) async {
    emit(
      state.copyWith(
        saving: true,
        saveSuccess: false,
        clearValidationError: true,
        clearErrorMessage: true,
      ),
    );

    try {
      final updated = await repository.update(event.id, event.request);

      final items = _replaceItem(state.items, updated);

      emit(state.copyWith(saving: false, saveSuccess: true, items: items));
    } on ValidationException catch (e) {
      emit(state.copyWith(saving: false, validationError: e.validationError));
    } on DioException catch (e) {
      emit(state.copyWith(saving: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(saving: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onDeletePostingjurnal(
    DeletePostingjurnal event,
    Emitter<PostingjurnalState> emit,
  ) async {
    emit(
      state.copyWith(
        deleting: true,
        deleteSuccess: false,
        clearDeleteErrorMessage: true,
      ),
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
      emit(state.copyWith(deleting: false, deleteErrorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(deleting: false, deleteErrorMessage: e.toString()));
    }
  }

  void _onResetValidationError(
    ResetValidationError event,
    Emitter<PostingjurnalState> emit,
  ) {
    emit(state.copyWith(clearValidationError: true));
  }

  void _onResetSaveState(
    ResetSaveState event,
    Emitter<PostingjurnalState> emit,
  ) {
    emit(state.copyWith(saveSuccess: false, saving: false));
  }

  void _onResetDeleteState(
    ResetDeleteState event,
    Emitter<PostingjurnalState> emit,
  ) {
    emit(
      state.copyWith(
        deleteSuccess: false,
        deleting: false,
        clearDeleteErrorMessage: true,
      ),
    );
  }

  void _onResetPostingjurnalState(
    ResetPostingjurnalState event,
    Emitter<PostingjurnalState> emit,
  ) {
    emit(
      state.copyWith(
        saveSuccess: false,
        deleteSuccess: false,
        saving: false,
        deleting: false,
        clearValidationError: true,
        clearErrorMessage: true,
        clearDeleteErrorMessage: true,
      ),
    );
  }

  List<Postingjurnal> _replaceItem(
    List<Postingjurnal> items,
    Postingjurnal updated,
  ) {
    return items.map((e) => e.id == updated.id ? updated : e).toList();
  }

  List<Postingjurnal> _removeItem(List<Postingjurnal> items, String id) {
    return items.where((e) => e.id != id).toList();
  }
}
