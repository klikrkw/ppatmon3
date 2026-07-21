import 'package:equatable/equatable.dart';
import 'package:newklikrkw/models/transpermohonan.dart';

const _unset = Object();

class TranspermohonanState extends Equatable {
  final List<Transpermohonan> items;
  final bool loading;
  final bool hasReachedMax;
  final String? error;
  final String query;
  final bool? active;
  final int? userId;
  final String? transpermohonanId;
  final Transpermohonan? item;
  final Transpermohonan? transpermohonan;

  const TranspermohonanState({
    this.items = const [],
    this.loading = false,
    this.hasReachedMax = false,
    this.error,
    this.query = '',
    this.active,
    this.userId,
    this.transpermohonanId,
    this.item,
    this.transpermohonan,
  });

  TranspermohonanState copyWith({
    List<Transpermohonan>? items,
    bool? loading,
    bool? hasReachedMax,
    String? error,
    String? query,
    bool? active,
    int? userId,
    String? transpermohonanId,
    Object? item = _unset,
    Object? transpermohonan = _unset,
  }) {
    return TranspermohonanState(
      items: items ?? this.items,
      loading: loading ?? this.loading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      error: error,
      query: query ?? this.query,
      active: active ?? this.active,
      userId: userId ?? this.userId,
      transpermohonanId: transpermohonanId ?? this.transpermohonanId,
      item: item == _unset ? this.item : item as Transpermohonan?,
      transpermohonan: transpermohonan == _unset
          ? this.transpermohonan
          : transpermohonan as Transpermohonan?,
    );
  }

  @override
  List<Object?> get props => [
    items,
    loading,
    hasReachedMax,
    error,
    active,
    userId,
    transpermohonanId,
    item,
    transpermohonan,
  ];
}
