import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/bukubesar/bukubesar_event.dart';
import 'package:newklikrkw/blocs/bukubesar/bukubesar_state.dart';
import 'package:newklikrkw/models/bukubesar.dart';
import 'package:newklikrkw/models/bukubesar_filter_range.dart';
import 'package:newklikrkw/repositories/bukubesar_repository.dart';

class BukubesarBloc extends Bloc<BukubesarEvent, BukubesarState> {
  final BukubesarRepository repository;

  // DateTime get _today => DateTime.now();

  BukubesarBloc({required this.repository}) : super(const BukubesarState()) {
    on<LoadBukubesars>(_onLoad);

    on<RefreshBukubesars>(_onRefresh);

    on<LoadMoreBukubesars>(_onLoadMore);

    on<ChangeFilterRange>(_onChangeFilter);

    on<ChangeCustomDateRange>(_onChangeCustomRange);
    on<LoadKodeAkuns>(_onLoadKodeAkuns);

    on<ChangeKodeAkun>(_onChangeKodeAkun);
  }

  // (DateTime, DateTime) _currentRange(BukubesarFilterRange range) {
  //   final now = DateTime.now();

  //   switch (range) {
  //     case BukubesarFilterRange.today:
  //       return (
  //         DateTime(now.year, now.month, now.day),
  //         DateTime(now.year, now.month, now.day, 23, 59, 59),
  //       );

  //     case BukubesarFilterRange.thisWeek:
  //       final start = now.subtract(Duration(days: now.weekday - 1));

  //       final end = start.add(const Duration(days: 6));

  //       return (start, end);

  //     case BukubesarFilterRange.thisMonth:
  //       return (
  //         DateTime(now.year, now.month, 1),
  //         DateTime(now.year, now.month + 1, 0, 23, 59, 59),
  //       );

  //     case BukubesarFilterRange.thisYear:
  //       return (
  //         DateTime(now.year, 1, 1),
  //         DateTime(now.year, 12, 31, 23, 59, 59),
  //       );

  //     case BukubesarFilterRange.custom:
  //       return (state.startDate!, state.endDate!);
  //   }
  // }

  Future<Map<String, dynamic>> _fetchData({required int offset}) {
    return repository.getBukubesars(
      offset: offset,
      limit: state.limit,
      startDate: state.startDate,
      endDate: state.endDate,
      akunId: state.selectedKodeAkun,
    );
  }

  Future<void> _onLoad(
    LoadBukubesars event,
    Emitter<BukubesarState> emit,
  ) async {
    emit(
      state.copyWith(
        loading: true,
        errorMessage: null,
        offset: 0,
        hasReachedMax: false,
      ),
    );

    try {
      final result = await _fetchData(offset: 0);

      final items = result["items"] as List<Bukubesar>;

      final pagination = result["pagination"] as Map<String, dynamic>;

      emit(
        state.copyWith(
          loading: false,
          items: items,
          offset: items.length,
          hasReachedMax: !(pagination["has_more"] as bool),
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onRefresh(
    RefreshBukubesars event,
    Emitter<BukubesarState> emit,
  ) async {
    emit(
      state.copyWith(
        refreshing: true,
        errorMessage: null,
        offset: 0,
        hasReachedMax: false,
      ),
    );

    try {
      final result = await _fetchData(offset: 0);

      final items = result["items"] as List<Bukubesar>;

      final pagination = result["pagination"] as Map<String, dynamic>;

      emit(
        state.copyWith(
          refreshing: false,
          items: items,
          offset: items.length,
          hasReachedMax: !(pagination["has_more"] as bool),
        ),
      );
    } catch (e) {
      emit(state.copyWith(refreshing: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreBukubesars event,
    Emitter<BukubesarState> emit,
  ) async {
    if (state.loadingMore ||
        state.loading ||
        state.refreshing ||
        state.hasReachedMax) {
      return;
    }

    emit(state.copyWith(loadingMore: true, errorMessage: null));

    try {
      final result = await _fetchData(offset: state.offset);

      final items = result["items"] as List<Bukubesar>;

      final pagination = result["pagination"] as Map<String, dynamic>;

      emit(
        state.copyWith(
          loadingMore: false,
          items: [...state.items, ...items],
          offset: state.offset + items.length,
          hasReachedMax: !(pagination["has_more"] as bool),
        ),
      );
    } catch (e) {
      emit(state.copyWith(loadingMore: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onChangeFilter(
    ChangeFilterRange event,
    Emitter<BukubesarState> emit,
  ) async {
    DateTime start;
    DateTime end;

    final now = DateTime.now();

    switch (event.range) {
      case BukubesarFilterRange.today:
        start = DateTime(now.year, now.month, now.day);
        end = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;

      case BukubesarFilterRange.thisWeek:
        start = now.subtract(Duration(days: now.weekday - 1));

        end = DateTime(start.year, start.month, start.day + 6, 23, 59, 59);
        break;

      case BukubesarFilterRange.thisMonth:
        start = DateTime(now.year, now.month);

        end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        break;

      case BukubesarFilterRange.thisYear:
        start = DateTime(now.year);

        end = DateTime(now.year, 12, 31, 23, 59, 59);
        break;

      case BukubesarFilterRange.custom:
        return;
    }

    emit(
      state.copyWith(
        selectedRange: event.range,
        startDate: start,
        endDate: end,
      ),
    );

    add(const LoadBukubesars());
  }

  Future<void> _onChangeCustomRange(
    ChangeCustomDateRange event,
    Emitter<BukubesarState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedRange: BukubesarFilterRange.custom,
        startDate: event.startDate,
        endDate: event.endDate,
      ),
    );

    add(const LoadBukubesars());
  }

  Future<void> _onLoadKodeAkuns(
    LoadKodeAkuns event,
    Emitter<BukubesarState> emit,
  ) async {
    final items = await repository.getKodeAkuns();

    emit(state.copyWith(kodeAkuns: items));
  }

  Future<void> _onChangeKodeAkun(
    ChangeKodeAkun event,
    Emitter<BukubesarState> emit,
  ) async {
    emit(state.copyWith(selectedKodeAkun: event.akunId));

    add(const LoadBukubesars());
  }
}
