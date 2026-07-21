import 'package:equatable/equatable.dart';

import 'package:newklikrkw/enums/postingjurnal_filter_range.dart';
import 'package:newklikrkw/models/akun.dart';
import 'package:newklikrkw/models/postingjurnal.dart';
import 'package:newklikrkw/models/validation_error.dart';

class PostingjurnalState extends Equatable {
  ///==============================
  /// Data
  ///==============================

  final List<Postingjurnal> items;
  final List<Akun> akuns;

  ///==============================
  /// Pagination
  ///==============================

  final int offset;
  final int limit;
  final bool hasMore;

  ///==============================
  /// Operation State
  ///==============================

  final bool loading;
  final bool refreshing;
  final bool loadingMore;
  final bool saving;
  final bool deleting;

  ///==============================
  /// Error
  ///==============================

  final String? errorMessage;
  final ValidationError? validationError;

  ///==============================
  /// Filter
  ///==============================

  final PostingjurnalFilterRange selectedRange;
  final bool deleteSuccess;
  final bool saveSuccess;
  final String? deleteErrorMessage;

  /// untuk filter periode
  final DateTime startDate;
  final DateTime endDate;
  final bool loadingAkuns;
  const PostingjurnalState({
    this.items = const [],

    this.offset = 0,
    this.limit = 20,
    this.hasMore = true,

    this.loading = false,
    this.refreshing = false,
    this.loadingMore = false,

    this.errorMessage,

    this.loadingAkuns = false,
    this.selectedRange = PostingjurnalFilterRange.today,

    required this.startDate,
    required this.endDate,

    this.deleting = false,
    this.deleteSuccess = false,
    this.deleteErrorMessage,
    this.validationError,
    this.saving = false,
    this.akuns = const [],
    this.saveSuccess = false,
  });

  factory PostingjurnalState.initial() {
    final now = DateTime.now();

    return PostingjurnalState(
      startDate: DateTime(now.year, now.month, now.day),
      endDate: DateTime(now.year, now.month, now.day, 23, 59, 59),
    );
  }

  ///==============================
  /// Summary
  ///==============================

  double get totalJumlah {
    return items.fold(0, (sum, e) => sum + e.jumlah);
  }

  int get totalPosting => items.length;

  ///==============================
  /// copyWith
  ///==============================

  PostingjurnalState copyWith({
    List<Postingjurnal>? items,

    int? offset,
    int? limit,
    bool? hasMore,

    bool? loading,
    bool? refreshing,
    bool? loadingMore,

    String? errorMessage,
    bool clearError = false,

    PostingjurnalFilterRange? selectedRange,

    DateTime? startDate,
    DateTime? endDate,

    bool? deleting,
    bool? deleteSuccess,
    String? deleteErrorMessage,

    ValidationError? validationError,
    bool? saving,
    List<Akun>? akuns,
    bool? saveSuccess,
    bool clearErrorMessage = false,
    bool clearDeleteErrorMessage = false,
    bool clearValidationError = false,
    bool? loadingAkuns,
  }) {
    return PostingjurnalState(
      items: items ?? this.items,

      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      hasMore: hasMore ?? this.hasMore,

      loading: loading ?? this.loading,
      refreshing: refreshing ?? this.refreshing,
      loadingMore: loadingMore ?? this.loadingMore,

      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),

      selectedRange: selectedRange ?? this.selectedRange,

      startDate: startDate ?? this.startDate,

      endDate: endDate ?? this.endDate,

      deleting: deleting ?? this.deleting,
      deleteSuccess: deleteSuccess ?? this.deleteSuccess,
      deleteErrorMessage: deleteErrorMessage ?? this.deleteErrorMessage,

      validationError: clearValidationError
          ? null
          : (validationError ?? this.validationError),
      saving: saving ?? this.saving,
      akuns: akuns ?? this.akuns,
      saveSuccess: saveSuccess ?? this.saveSuccess,
      loadingAkuns: loadingAkuns ?? this.loadingAkuns,
    );
  }

  ///==============================
  /// Helper
  ///==============================

  bool get isEmpty => items.isEmpty;

  bool get isNotEmpty => items.isNotEmpty;

  bool get isFirstLoading => loading && items.isEmpty;

  bool get canLoadMore => hasMore && !loadingMore && !loading;

  String? errorText(String field) {
    return validationError?.firstError(field);
  }

  @override
  List<Object?> get props => [
    items,

    offset,
    limit,
    hasMore,

    loading,
    refreshing,
    loadingMore,

    errorMessage,

    selectedRange,

    startDate,
    endDate,

    deleting,
    deleteSuccess,
    deleteErrorMessage,

    validationError,
    saving,
    akuns,
    saveSuccess,
  ];
}
