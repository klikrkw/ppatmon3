// item_state.dart
import 'package:equatable/equatable.dart';
import 'package:newklikrkw/models/item_model.dart';

enum ItemStatus { initial, success, failure }

class ItemState<T> extends Equatable {
  final ItemStatus status;
  final List<GenericItem<T>> items;
  final bool hasReachedMax;
  final String searchQuery;
  final String selectedCategory; // Tambahkan pelacak kategori aktif

  const ItemState({
    this.status = ItemStatus.initial,
    this.items = const [],
    this.hasReachedMax = false,
    this.searchQuery = '',
    this.selectedCategory = 'Semua', // Default menampilkan semua data
  });

  ItemState<T> copyWith({
    ItemStatus? status,
    List<GenericItem<T>>? items,
    bool? hasReachedMax,
    String? searchQuery,
    String? selectedCategory,
  }) {
    return ItemState<T>(
      status: status ?? this.status,
      items: items ?? this.items,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    hasReachedMax,
    searchQuery,
    selectedCategory,
  ];
}
