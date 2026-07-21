import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/transpermohonan/transpermohonan_event.dart';
import 'package:newklikrkw/blocs/transpermohonan/transpermohonan_state.dart';
import 'package:newklikrkw/core/bloc/event_transformers.dart';
import 'package:newklikrkw/repositories/transpermohonan_repository.dart';

class TranspermohonanBloc
    extends Bloc<TranspermohonanEvent, TranspermohonanState> {
  final TranspermohonanRepository repository;

  static const int pageSize = 20;

  TranspermohonanBloc(this.repository) : super(const TranspermohonanState()) {
    on<LoadTranspermohonan>(_load);
    on<LoadMoreTranspermohonan>(_loadMore);
    on<RefreshTranspermohonan>(_refresh);
    on<SearchTranspermohonan>(
      _searchTranspermohonan,
      transformer: debounceRestartable(const Duration(milliseconds: 500)),
    );

    on<FilterActiveChanged>(
      _onFilterChanged,
      transformer: debounceRestartable(const Duration(milliseconds: 100)),
    );
    on<UpdateStatusTranspermohonan>(
      _onUpdateStatus,
      transformer: debounceRestartable(const Duration(milliseconds: 200)),
    );
    on<FilterUserId>(_onFilterUserId, transformer: restartable());
    on<FilterTranspermohonanId>(
      _onFilterTranspermohonanId,
      transformer: restartable(),
    );
    on<FilterQrCode>(_onFilterQrCode, transformer: restartable());

    on<ResetItem>(_onResetItem, transformer: restartable());
    on<ResetFilterQrCode>(_onResetQrCode, transformer: restartable());
  }

  Future<void> _load(
    LoadTranspermohonan event,
    Emitter<TranspermohonanState> emit,
  ) async {
    emit(
      state.copyWith(
        loading: true,
        items: [],
        hasReachedMax: false,
        item: null,
      ),
    );

    try {
      final data = await repository.getData(
        offset: 0,
        limit: pageSize,
        userId: state.userId,
        active: state.active,
      );

      emit(
        state.copyWith(
          loading: false,
          items: data,
          hasReachedMax: data.length < pageSize,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _loadMore(
    LoadMoreTranspermohonan event,
    Emitter<TranspermohonanState> emit,
  ) async {
    if (state.loading || state.hasReachedMax) return;

    emit(state.copyWith(loading: true));

    try {
      final data = await repository.getData(
        offset: state.items.length,
        limit: pageSize,
        query: state.query,
      );

      emit(
        state.copyWith(
          loading: false,
          items: [...state.items, ...data],
          hasReachedMax: data.length < pageSize,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _searchTranspermohonan(
    SearchTranspermohonan event,
    Emitter<TranspermohonanState> emit,
  ) async {
    emit(
      state.copyWith(loading: true, items: [], hasReachedMax: false, query: ''),
    );
    final result = await repository.getData(
      offset: 0,
      limit: pageSize,
      query: event.query,
      active: state.active,
      userId: state.userId,
    );
    emit(
      state.copyWith(
        loading: false,
        items: result,
        query: event.query,
        hasReachedMax: result.length < pageSize,
      ),
    );
  }

  Future<void> _refresh(
    RefreshTranspermohonan event,
    Emitter<TranspermohonanState> emit,
  ) async {
    add(LoadTranspermohonan());
  }

  Future<void> _onFilterChanged(
    FilterActiveChanged event,
    Emitter<TranspermohonanState> emit,
  ) async {
    emit(state.copyWith(loading: true, items: [], hasReachedMax: false));
    final data = await repository.getData(
      offset: 0,
      limit: pageSize,
      query: state.query,
      userId: state.userId,
      active: event.active,
    );

    emit(
      state.copyWith(
        loading: false,
        items: data,
        hasReachedMax: data.length < pageSize,
        active: event.active,
      ),
    );
  }

  Future<void> _onUpdateStatus(
    UpdateStatusTranspermohonan event,
    Emitter<TranspermohonanState> emit,
  ) async {
    await repository.updateStatusPermohonan(id: event.id, active: event.active);

    final updatedItems = state.items.map((item) {
      if (item.id == event.id) {
        return item.copyWith(active: event.active);
      }
      return item;
    }).toList();

    emit(state.copyWith(items: updatedItems));
  }

  Future<void> _onFilterUserId(
    FilterUserId event,
    Emitter<TranspermohonanState> emit,
  ) async {
    emit(state.copyWith(loading: true, userId: event.userId));
    final data = await repository.getData(
      offset: 0,
      limit: pageSize,
      query: state.query,
      active: state.active,
      userId: event.userId,
    );

    emit(
      state.copyWith(
        loading: false,
        items: data,
        hasReachedMax: data.length < pageSize,
      ),
    );
  }

  Future<void> _onFilterTranspermohonanId(
    FilterTranspermohonanId event,
    Emitter<TranspermohonanState> emit,
  ) async {
    emit(
      state.copyWith(
        loading: true,
        transpermohonanId: event.transpermohonanId,
        item: null,
      ),
    );

    final data = await repository.getData(
      offset: 0,
      limit: pageSize,
      query: state.query,
      active: state.active,
      userId: state.userId,
      transpermohonanId: event.transpermohonanId,
      isTranspermohonanId: event.isTranspermohonanId,
    );

    emit(
      state.copyWith(
        loading: false,
        item: data.isEmpty ? null : data.first,
        hasReachedMax: data.length < pageSize,
      ),
    );
  }

  Future<void> _onFilterQrCode(
    FilterQrCode event,
    Emitter<TranspermohonanState> emit,
  ) async {
    emit(state.copyWith(loading: true, transpermohonan: null));

    final data = await repository.getData(
      offset: 0,
      limit: pageSize,
      query: state.query,
      active: state.active,
      userId: state.userId,
      transpermohonanId: event.transpermohonanId,
      isTranspermohonanId: event.isTranspermohonanId,
    );

    emit(
      state.copyWith(
        loading: false,
        transpermohonan: data.isEmpty ? null : data.first,
        hasReachedMax: data.length < pageSize,
      ),
    );
  }

  FutureOr<void> _onResetItem(
    ResetItem event,
    Emitter<TranspermohonanState> emit,
  ) {
    emit(state.copyWith(item: null));
  }

  FutureOr<void> _onResetQrCode(
    ResetFilterQrCode event,
    Emitter<TranspermohonanState> emit,
  ) {
    emit(state.copyWith(transpermohonan: null));
  }
}
