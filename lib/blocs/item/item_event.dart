// item_event.dart
import 'package:equatable/equatable.dart';

abstract class ItemEvent extends Equatable {
  const ItemEvent();
  @override
  List<Object?> get props => [];
}

class FetchItemsEvent extends ItemEvent {}

class RefreshItemsEvent extends ItemEvent {}

class SearchItemsEvent extends ItemEvent {
  final String query;
  const SearchItemsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

// Event baru saat user memilih kategori
class FilterCategoryEvent extends ItemEvent {
  final String category;
  const FilterCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}
