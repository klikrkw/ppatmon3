import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:newklikrkw/blocs/dkeluarbiaya_by_item/dkeluarbiaya_by_item_event.dart';
import 'package:newklikrkw/blocs/dkeluarbiaya_by_item/dkeluarbiaya_by_item_state.dart';

import 'package:newklikrkw/enums/date_filter_range.dart';
import 'package:newklikrkw/models/dkeluarbiaya_by_item_response.dart';
import 'package:newklikrkw/repositories/dkeluarbiaya_by_item_repository.dart';
import 'package:newklikrkw/utils/date_filter_helper.dart';

class DkeluarbiayaByItemBloc
    extends Bloc<DkeluarbiayaByItemEvent, DkeluarbiayaByItemState> {
  final DkeluarbiayaByItemRepository repository;

  DkeluarbiayaByItemBloc({required this.repository})
    : super(DkeluarbiayaByItemState.initial()) {
    on<LoadDkeluarbiayasByItem>(_onLoad);

    on<RefreshDkeluarbiayasByItem>(_onRefresh);

    on<LoadMoreDkeluarbiayasByItem>(_onLoadMore);

    on<ChangeDateFilterRange>(_onChangeDateFilterRange);

    on<ChangeCustomDate>(_onChangeCustomDate);

    on<ChangeItemkegiatanFilter>(_onChangeItemFilter);

    on<ResetFilterDkeluarbiayasByItem>(_onResetFilter);
    on<LoadItemkegiatans>(_onLoadItemkegiatans);
    on<ChangeCustomDateRange>(_onChangeCustomRange);
  }

  ///==================================================
  /// Repository
  ///==================================================

  Future<DkeluarbiayaByItemResponse> _fetchData({required int offset}) async {
    final range = _buildDateRange();

    return repository.getDkeluarbiayas(
      offset: offset,
      limit: state.limit,
      itemkegiatanId: state.selectedItemkegiatanId,
      startDate: range.$1,
      endDate: range.$2,
    );
  }

  ///==================================================
  /// Date Range
  ///==================================================

  (DateTime?, DateTime?) _buildDateRange() {
    final now = DateTime.now();

    switch (state.selectedRange) {
      case DateFilterRange.today:
        final today = DateTime(now.year, now.month, now.day);

        return (today, today);

      case DateFilterRange.thisWeek:
        return (
          DateFilterHelper.firstDayOfWeek(now),
          DateFilterHelper.lastDayOfWeek(now),
        );

      case DateFilterRange.thisMonth:
        return (
          DateFilterHelper.firstDayOfMonth(now),
          DateFilterHelper.lastDayOfMonth(now),
        );

      case DateFilterRange.thisYear:
        return (
          DateTime(now.year, 1, 1),
          DateTime(now.year, 12, 31, 23, 59, 59),
        );

      case DateFilterRange.custom:
        final date = DateTime(
          state.selectedDate.year,
          state.selectedDate.month,
          state.selectedDate.day,
        );

        return (state.startDate ?? date, state.endDate ?? date);
      // return (date, date);
    }
  }

  ///==================================================
  /// Reset Pagination
  ///==================================================

  DkeluarbiayaByItemState _resetPagination() {
    return state.copyWith(items: const [], offset: 0, hasMore: true);
  }

  Future<void> _reload(Emitter<DkeluarbiayaByItemState> emit) async {
    emit(_resetPagination().copyWith(loading: true, clearError: true));

    try {
      final result = await _fetchData(offset: 0);

      emit(
        state.copyWith(
          loading: false,
          items: result.items,
          offset: result.items.length,
          hasMore: result.pagination.hasMore,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }
  //==================================================
  // Handler
  // Dibuat pada Bagian 3C-2 dan 3C-3
  //==================================================

  Future<void> _onLoad(
    LoadDkeluarbiayasByItem event,
    Emitter<DkeluarbiayaByItemState> emit,
  ) async {
    await _reload(emit);
  }

  Future<void> _onRefresh(
    RefreshDkeluarbiayasByItem event,
    Emitter<DkeluarbiayaByItemState> emit,
  ) async {
    emit(state.copyWith(refreshing: true, clearError: true));

    try {
      final result = await _fetchData(offset: 0);

      emit(
        state.copyWith(
          refreshing: false,
          items: result.items,
          offset: result.items.length,
          hasMore: result.pagination.hasMore,
        ),
      );
    } catch (e) {
      emit(state.copyWith(refreshing: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreDkeluarbiayasByItem event,
    Emitter<DkeluarbiayaByItemState> emit,
  ) async {
    if (state.loadingMore ||
        state.loading ||
        state.refreshing ||
        !state.hasMore) {
      return;
    }

    emit(state.copyWith(loadingMore: true));

    try {
      final result = await _fetchData(offset: state.offset);

      emit(
        state.copyWith(
          loadingMore: false,
          items: [...state.items, ...result.items],
          offset: state.offset + result.items.length,
          hasMore: result.pagination.hasMore,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loadingMore: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onChangeDateFilterRange(
    ChangeDateFilterRange event,
    Emitter<DkeluarbiayaByItemState> emit,
  ) async {
    emit(state.copyWith(selectedRange: event.range));

    await _reload(emit);
  }

  Future<void> _onChangeCustomDate(
    ChangeCustomDate event,
    Emitter<DkeluarbiayaByItemState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedRange: DateFilterRange.custom,
        selectedDate: event.date,
      ),
    );

    await _reload(emit);
  }

  Future<void> _onChangeItemFilter(
    ChangeItemkegiatanFilter event,
    Emitter<DkeluarbiayaByItemState> emit,
  ) async {
    emit(state.copyWith(selectedItemkegiatanId: event.itemkegiatanId));

    await _reload(emit);
  }

  Future<void> _onResetFilter(
    ResetFilterDkeluarbiayasByItem event,
    Emitter<DkeluarbiayaByItemState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedRange: DateFilterRange.today,
        selectedDate: DateTime.now(),
        clearSelectedItem: true,
        clearError: true,
      ),
    );

    await _reload(emit);
  }

  FutureOr<void> _onLoadItemkegiatans(
    LoadItemkegiatans event,
    Emitter<DkeluarbiayaByItemState> emit,
  ) async {
    try {
      final items = await repository.getItemkegiatans(grup: 'non_permohonan');

      emit(state.copyWith(itemkegiatans: items));
    } catch (_) {}
  }

  Future<void> _onChangeCustomRange(
    ChangeCustomDateRange event,
    Emitter<DkeluarbiayaByItemState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedRange: DateFilterRange.custom,
        startDate: event.startDate,
        endDate: event.endDate,
      ),
    );
    await _reload(emit);
  }
}
