import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/dkeluarbiayapermuser/dkeluarbiayapermuser_event.dart';
import 'package:newklikrkw/blocs/dkeluarbiayapermuser/dkeluarbiayapermuser_state.dart';
import 'package:newklikrkw/core/helpers/api_validation_ext_exception.dart';
import 'package:newklikrkw/models/dkeluarbiayapermuser.dart';
import 'package:newklikrkw/models/validation_error.dart';
import 'package:newklikrkw/repositories/dkeluarbiayapermuser_repository.dart';

class DkeluarbiayapermuserBloc
    extends Bloc<dynamic, DkeluarbiayapermuserState> {
  final DkeluarbiayapermuserRepository repository;

  DkeluarbiayapermuserBloc({required this.repository})
    : super(DkeluarbiayapermuserState.initial()) {
    on<LoadDkeluarbiayapermusers>(_onLoad);

    on<RefreshDkeluarbiayapermusers>(_onRefresh);

    on<LoadMoreDkeluarbiayapermusers>(_onLoadMore);

    on<LoadItemkegiatans>(_onLoadItemkegiatans);
    on<AddDkeluarbiayapermuser>(_onAdd);

    on<UpdateDkeluarbiayapermuser>(_onUpdate);

    on<ResetSaveState>(_onResetSaveState);

    on<ResetValidationError>(_onResetValidation);

    on<ClearForm>(_onClearForm);
    on<GetKeluarbiaya>(_onGetKeluarbiaya);
    on<UpdateStatusKeluarbiaya>(_onUpdateStatusKeluarbiaya);
    on<ResetUpdateStatus>(_onResetUpdateStatus);
    on<DeleteDkeluarbiayapermuser>(_onDeleteDkeluarbiayapermuser);
    on<ResetDeleteState>(_onResetDeleteState);
    on<FilterByTranspermohonanId>(_onFilterByTranspermohonanId);
  }

  Future<void> _onLoad(
    LoadDkeluarbiayapermusers event,
    Emitter<DkeluarbiayapermuserState> emit,
  ) async {
    emit(
      state.copyWith(
        loading: true,
        errorMessage: null,
        keluarbiayapermuserId: event.keluarbiayapermuserId,
        transpermohonanId: null,
      ),
    );

    try {
      final result = await repository.getDkeluarbiayapermusers(
        keluarbiayapermuserId: event.keluarbiayapermuserId,
        offset: 0,
        limit: state.limit,
      );

      emit(
        state.copyWith(
          loading: false,
          dkeluarbiayapermusers: List<Dkeluarbiayapermuser>.from(
            result["items"],
          ),
          offset: result["offset"] + result["items"].length,
          limit: result["limit"],
          total: result["total"],
          hasMore: result["hasMore"],
        ),
      );
      add(GetKeluarbiaya(event.keluarbiayapermuserId));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onRefresh(
    RefreshDkeluarbiayapermusers event,
    Emitter<DkeluarbiayapermuserState> emit,
  ) async {
    emit(state.copyWith(refreshing: true));

    try {
      final result = await repository.getDkeluarbiayapermusers(
        keluarbiayapermuserId: state.keluarbiayapermuserId,
        transpermohonanId: state.transpermohonanId,
        offset: 0,
        limit: state.limit,
      );

      emit(
        state.copyWith(
          refreshing: false,
          dkeluarbiayapermusers: List<Dkeluarbiayapermuser>.from(
            result["items"],
          ),
          offset: result["items"].length,
          total: result["total"],
          hasMore: result["hasMore"],
        ),
      );
      add(GetKeluarbiaya(state.keluarbiayapermuserId));
    } catch (e) {
      emit(state.copyWith(refreshing: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreDkeluarbiayapermusers event,
    Emitter<DkeluarbiayapermuserState> emit,
  ) async {
    if (!state.hasMore) return;

    if (state.loadingMore) return;

    emit(state.copyWith(loadingMore: true));

    try {
      final result = await repository.getDkeluarbiayapermusers(
        keluarbiayapermuserId: state.keluarbiayapermuserId,
        transpermohonanId: state.transpermohonanId,
        offset: state.offset,
        limit: state.limit,
      );

      final List<Dkeluarbiayapermuser> items = List.from(
        state.dkeluarbiayapermusers,
      )..addAll(result["items"]);

      emit(
        state.copyWith(
          loadingMore: false,
          dkeluarbiayapermusers: items,
          offset: state.offset + result["items"].length as int,
          total: result["total"],
          hasMore: result["hasMore"],
        ),
      );
    } catch (e) {
      emit(state.copyWith(loadingMore: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadItemkegiatans(
    LoadItemkegiatans event,
    Emitter<DkeluarbiayapermuserState> emit,
  ) async {
    try {
      int? instansiId;
      if (state.keluarbiayapermuser != null) {
        instansiId = state.keluarbiayapermuser!.instansi.id;
      }
      final items = await repository.getItemkegiatans(instansiId!);

      emit(state.copyWith(itemkegiatans: items));
    } catch (_) {}
  }

  Future<void> _onAdd(
    AddDkeluarbiayapermuser event,
    Emitter<DkeluarbiayapermuserState> emit,
  ) async {
    emit(
      state.copyWith(saving: true, saveSuccess: false, validationError: null),
    );

    try {
      await repository.addDkeluarbiayapermuser(
        event.keluarbiayapermuserId,
        event.request,
      );

      emit(state.copyWith(saving: false, saveSuccess: true));
    } on ValidationError catch (e) {
      emit(state.copyWith(saving: false, validationError: e));
    } catch (e) {
      emit(state.copyWith(saving: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdate(
    UpdateDkeluarbiayapermuser event,
    Emitter<DkeluarbiayapermuserState> emit,
  ) async {
    emit(
      state.copyWith(saving: true, saveSuccess: false, validationError: null),
    );

    try {
      await repository.updateDkeluarbiayapermuser(event.id, event.request);

      emit(state.copyWith(saving: false, saveSuccess: true));
    } on ValidationError catch (e) {
      emit(state.copyWith(saving: false, validationError: e));
    } catch (e) {
      emit(state.copyWith(saving: false, errorMessage: e.toString()));
    }
  }

  void _onResetSaveState(
    ResetSaveState event,
    Emitter<DkeluarbiayapermuserState> emit,
  ) {
    emit(state.copyWith(saveSuccess: false));
  }

  void _onResetValidation(
    ResetValidationError event,
    Emitter<DkeluarbiayapermuserState> emit,
  ) {
    emit(state.copyWith(validationError: null));
  }

  void _onClearForm(ClearForm event, Emitter<DkeluarbiayapermuserState> emit) {
    emit(state.copyWith(saveSuccess: false, validationError: null));
  }

  FutureOr<void> _onGetKeluarbiaya(
    GetKeluarbiaya event,
    Emitter<DkeluarbiayapermuserState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          keluarbiayapermuser: null,
          loadingKeluarbiayapermuser: true,
        ),
      );
      final item = await repository.getKeluarbiayapermuser(
        keluarbiayapermuserId: event.keluarbiayapermuserId,
      );
      emit(
        state.copyWith(
          keluarbiayapermuser: item,
          loadingKeluarbiayapermuser: false,
        ),
      );
    } catch (_) {}
  }

  Future<void> _onUpdateStatusKeluarbiaya(
    UpdateStatusKeluarbiaya event,
    Emitter<DkeluarbiayapermuserState> emit,
  ) async {
    emit(state.copyWith(updatingStatus: true, updateStatusSuccess: false));

    try {
      await repository.updateStatusKeluarbiayapermuser(
        keluarbiayapermuserId: event.keluarbiayapermuserId,
        status: event.status,
      );

      emit(state.copyWith(updatingStatus: false, updateStatusSuccess: true));

      add(const RefreshDkeluarbiayapermusers());
    } catch (e) {
      emit(state.copyWith(updatingStatus: false, errorMessage: e.toString()));
    }
  }

  void _onResetUpdateStatus(
    ResetUpdateStatus event,
    Emitter<DkeluarbiayapermuserState> emit,
  ) {
    emit(
      state.copyWith(
        updatingStatus: false,
        updateStatusSuccess: false,
        errorMessage: null,
      ),
    );
  }

  Future<void> _onDeleteDkeluarbiayapermuser(
    DeleteDkeluarbiayapermuser event,
    Emitter<DkeluarbiayapermuserState> emit,
  ) async {
    emit(state.copyWith(deleting: true, deleteSuccess: false));

    try {
      await repository.deleteDkeluarbiayapermuser(event.id);

      emit(state.copyWith(deleting: false, deleteSuccess: true));

      add(const RefreshDkeluarbiayapermusers());
    } catch (e) {
      emit(state.copyWith(deleting: false, errorMessage: e.toString()));
    }
  }

  void _onResetDeleteState(
    ResetDeleteState event,
    Emitter<DkeluarbiayapermuserState> emit,
  ) {
    emit(state.copyWith(deleteSuccess: false, deleting: false));
  }

  FutureOr<void> _onFilterByTranspermohonanId(
    FilterByTranspermohonanId event,
    Emitter<DkeluarbiayapermuserState> emit,
  ) async {
    emit(
      state.copyWith(
        loading: true,
        errorMessage: null,
        keluarbiayapermuserId: null,
      ),
    );

    try {
      final result = await repository.getDkeluarbiayapermusers(
        transpermohonanId: event.transpermohonanId,
        offset: 0,
        limit: state.limit,
      );

      emit(
        state.copyWith(
          loading: false,
          dkeluarbiayapermusers: List<Dkeluarbiayapermuser>.from(
            result["items"],
          ),
          offset: result["offset"] + result["items"].length,
          limit: result["limit"],
          total: result["total"],
          hasMore: result["hasMore"],
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }
}
