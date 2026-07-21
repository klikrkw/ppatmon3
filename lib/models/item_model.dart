// item_model.dart
import 'package:equatable/equatable.dart';

class GenericItem<T> extends Equatable {
  final int id;
  final T data; // Menampung objek database apa saja (User, Product, dll.)

  const GenericItem({required this.id, required this.data});

  @override
  List<Object?> get props => [id, data];
}
