import 'package:newklikrkw/models/itememprosesperm.dart';
import 'package:newklikrkw/models/prosespermohonan.dart';
import 'package:newklikrkw/models/statusprosesperm.dart';
import 'package:newklikrkw/models/validation_error.dart';

class ProsespermohonanState {
  final List<Prosespermohonan> items;
  final bool loading;
  final bool hasReachedMax;
  final String? transpermohonanId;
  final String query;
  final int? statusProsespermId;
  final List<Statusprosesperm> availableStatuses;
  final int? itemProsespermId;
  final List<Itemprosesperm> availableItems;
  final bool isTranspermohonanId;
  final bool saving;
  final List<Statusprosesperm> statusOptions;
  final String? saveError;
  final bool saveSuccess;
  final ValidationError? validationError;
  final int? userId;

  const ProsespermohonanState({
    this.items = const [],
    this.loading = false,
    this.hasReachedMax = false,
    this.transpermohonanId,
    this.query = '',
    this.statusProsespermId,
    this.availableStatuses = const [],
    this.itemProsespermId,
    this.availableItems = const [],
    this.isTranspermohonanId = false,
    this.saving = false,
    this.statusOptions = const [],
    this.saveError,
    this.saveSuccess = false,
    this.validationError,
    this.userId,
  });

  ProsespermohonanState copyWith({
    List<Prosespermohonan>? items,
    bool? loading,
    bool? hasReachedMax,
    String? transpermohonanId,
    int? statusProsespermId,
    int? itemProsespermId,
    List<Statusprosesperm>? availableStatuses,
    List<Itemprosesperm>? availableItems,
    String? query,
    bool? isTranspermohonanId,
    bool? saving,
    List<Statusprosesperm>? statusOptions,
    String? saveError,
    bool? saveSuccess,
    ValidationError? validationError,
    bool clearValidationError = false,
    bool clearSaveError = false,
    int? userId,
  }) {
    return ProsespermohonanState(
      items: items ?? this.items,
      loading: loading ?? this.loading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      transpermohonanId: transpermohonanId ?? this.transpermohonanId,
      statusProsespermId: statusProsespermId ?? this.statusProsespermId,
      itemProsespermId: itemProsespermId ?? this.itemProsespermId,
      availableStatuses: availableStatuses ?? this.availableStatuses,
      availableItems: availableItems ?? this.availableItems,
      query: query ?? this.query,
      isTranspermohonanId: isTranspermohonanId ?? this.isTranspermohonanId,
      saving: saving ?? this.saving,
      statusOptions: statusOptions ?? this.statusOptions,
      saveError: clearSaveError ? null : saveError ?? this.saveError,
      saveSuccess: saveSuccess ?? this.saveSuccess,
      validationError: clearValidationError
          ? null
          : validationError ?? this.validationError,
      userId: userId ?? this.userId,
    );
  }
}
