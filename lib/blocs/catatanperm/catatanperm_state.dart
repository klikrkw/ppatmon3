import 'package:equatable/equatable.dart';
import 'package:newklikrkw/enums/catatanperm_date_filter.dart';
import 'package:newklikrkw/models/catatanperm.dart';
import 'package:newklikrkw/models/fieldcatatan.dart';
import 'package:newklikrkw/models/validation_error.dart';

class CatatanpermState extends Equatable {
  final List<Catatanperm> items;

  final bool loading;
  final bool loadingMore;
  final bool refreshing;

  final bool hasMore;

  final int offset;
  final int limit;
  final int total;

  final String? transpermohonanId;

  final CatatanpermDateFilter selectedDateFilter;

  final DateTime selectedDate;

  final DateTime? startDate;
  final DateTime? endDate;

  final int? selectedFieldcatatanId;

  final String keyword;

  final String? errorMessage;
  final ValidationError? validationError;
  final List<Fieldcatatan> fieldcatatans;
  final bool loadingFieldcatatans;
  // ============================================================
  // ERROR
  // ============================================================

  // ============================================================
  // SAVE
  // ============================================================

  final bool saving;

  final bool saveSuccess;

  // ============================================================
  // DELETE
  // ============================================================

  final bool deleting;

  final bool deleteSuccess;

  // ============================================================
  // CONSTRUCTOR
  // ======================
  const CatatanpermState({
    this.items = const [],
    this.loading = false,
    this.loadingMore = false,
    this.refreshing = false,
    this.hasMore = true,
    this.offset = 0,
    this.limit = 20,
    this.total = 0,
    this.transpermohonanId,
    this.selectedDateFilter = CatatanpermDateFilter.today,
    required this.selectedDate,
    this.startDate,
    this.endDate,
    this.selectedFieldcatatanId,
    this.keyword = '',
    this.errorMessage,
    this.validationError,
    this.fieldcatatans = const [],
    this.loadingFieldcatatans = false,

    this.saving = false,
    this.saveSuccess = false,

    this.deleting = false,
    this.deleteSuccess = false,
  });

  factory CatatanpermState.initial() {
    return CatatanpermState(selectedDate: DateTime.now());
  }

  CatatanpermState copyWith({
    List<Catatanperm>? items,
    bool? loading,
    bool? loadingMore,
    bool? refreshing,
    bool? hasMore,
    int? offset,
    int? limit,
    int? total,
    String? transpermohonanId,
    bool clearTranspermohonanId = false,
    CatatanpermDateFilter? selectedDateFilter,
    DateTime? selectedDate,
    DateTime? startDate,
    DateTime? endDate,
    bool clearDateRange = false,
    int? selectedFieldcatatanId,
    bool clearFieldcatatan = false,
    String? keyword,
    String? errorMessage,
    ValidationError? validationError,
    bool clearError = false,
    List<Fieldcatatan>? fieldcatatans,
    bool? loadingFieldcatatans,

    bool? saving,
    bool? saveSuccess,

    bool? deleting,
    bool? deleteSuccess,

    // clear nullable values
    bool clearSelectedFieldcatatan = false,
    bool clearStartDate = false,
    bool clearEndDate = false,
    bool clearValidationError = false,
  }) {
    return CatatanpermState(
      items: items ?? this.items,
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      refreshing: refreshing ?? this.refreshing,
      hasMore: hasMore ?? this.hasMore,
      offset: offset ?? this.offset,
      limit: limit ?? this.limit,
      total: total ?? this.total,

      transpermohonanId: clearTranspermohonanId
          ? null
          : transpermohonanId ?? this.transpermohonanId,

      selectedDateFilter: selectedDateFilter ?? this.selectedDateFilter,

      selectedDate: selectedDate ?? this.selectedDate,

      startDate: clearDateRange ? null : startDate ?? this.startDate,

      endDate: clearDateRange ? null : endDate ?? this.endDate,

      selectedFieldcatatanId: clearFieldcatatan
          ? null
          : selectedFieldcatatanId ?? this.selectedFieldcatatanId,

      keyword: keyword ?? this.keyword,

      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      fieldcatatans: fieldcatatans ?? this.fieldcatatans,
      loadingFieldcatatans: loadingFieldcatatans ?? this.loadingFieldcatatans,
      validationError: clearValidationError
          ? null
          : validationError ?? this.validationError,

      saving: saving ?? this.saving,
      saveSuccess: saveSuccess ?? this.saveSuccess,

      deleting: deleting ?? this.deleting,
      deleteSuccess: deleteSuccess ?? this.deleteSuccess,
    );
  }

  // ============================================================
  // ERROR FIELD
  // ============================================================

  String? errorText(String field) {
    return validationError?.firstError(field);
  }

  // ============================================================
  // RESET FILTER
  // ============================================================

  CatatanpermState resetFilters() {
    return copyWith(
      clearTranspermohonanId: true,
      clearSelectedFieldcatatan: true,
      clearStartDate: true,
      clearEndDate: true,
      keyword: '',
      clearError: true,
    );
  }

  // ============================================================
  // EQUATABLE
  // ============================================================

  @override
  List<Object?> get props => [
    items,
    loading,
    loadingMore,
    refreshing,
    hasMore,
    offset,
    limit,
    total,
    transpermohonanId,
    selectedDateFilter,
    selectedDate,
    startDate,
    endDate,
    selectedFieldcatatanId,
    keyword,
    errorMessage,
    validationError,
    fieldcatatans,
    loadingFieldcatatans,

    saving,
    saveSuccess,

    deleting,
    deleteSuccess,
  ];
}
