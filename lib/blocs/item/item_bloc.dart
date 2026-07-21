// item_bloc.dart
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/item/item_event.dart';
import 'package:newklikrkw/blocs/item/item_state.dart';
import 'package:newklikrkw/models/item_model.dart';
import 'package:newklikrkw/repositories/database_repository.dart';

class ItemBloc<T> extends Bloc<ItemEvent, ItemState<T>> {
  final DatabaseRepository<T> repository;
  final int _limit = 20;

  ItemBloc({required this.repository}) : super(ItemState<T>()) {
    on<FetchItemsEvent>(_onFetchItems);
    on<SearchItemsEvent>(_onSearchItems);
    on<FilterCategoryEvent>(_onFilterCategory); // Daftarkan handler kategori
    on<RefreshItemsEvent>(_onRefreshItems); // Daftarkan handler refresh
  }

  Future<void> _onFetchItems(
    FetchItemsEvent event,
    Emitter<ItemState<T>> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      if (state.status == ItemStatus.initial) {
        final items = await repository.fetchItemsFromDb(
          offset: 0,
          limit: _limit,
          query: state.searchQuery,
          category: state.selectedCategory, // Kirim parameter kategori
        );
        return emit(
          state.copyWith(
            status: ItemStatus.success,
            items: items,
            hasReachedMax: items.isEmpty || items.length < _limit,
          ),
        );
      }

      final items = await repository.fetchItemsFromDb(
        offset: state.items.length,
        limit: _limit,
        query: state.searchQuery,
        category:
            state.selectedCategory, // Kirim parameter kategori saat load more
      );

      emit(
        items.isEmpty
            ? state.copyWith(hasReachedMax: true)
            : state.copyWith(
                status: ItemStatus.success,
                items: List<GenericItem<T>>.from(state.items)..addAll(items),
                hasReachedMax: items.length < _limit,
              ),
      );
    } catch (_) {
      emit(state.copyWith(status: ItemStatus.initial));
    }
  }

  void _onSearchItems(SearchItemsEvent event, Emitter<ItemState<T>> emit) {
    emit(
      state.copyWith(
        status: ItemStatus.initial,
        items: const [],
        hasReachedMax: false,
        searchQuery: event.query,
      ),
    );
    add(FetchItemsEvent());
  }

  // Handler untuk mengosongkan list dan menerapkan filter kategori baru
  void _onFilterCategory(
    FilterCategoryEvent event,
    Emitter<ItemState<T>> emit,
  ) {
    emit(
      state.copyWith(
        status: ItemStatus.initial,
        items: const [],
        hasReachedMax: false,
        selectedCategory: event.category,
      ),
    );
    add(FetchItemsEvent());
  }

  void _onRefreshItems(ItemEvent event, Emitter<ItemState<T>> emit) {
    debugPrint('refresh product list');
    emit(
      state.copyWith(
        status: ItemStatus.initial,
        items: const [],
        hasReachedMax: false,
      ),
    );
    add(FetchItemsEvent());
  }
}
