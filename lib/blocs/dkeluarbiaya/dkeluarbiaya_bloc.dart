import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/dkeluarbiaya/dkeluarbiaya_event.dart';
import 'package:newklikrkw/blocs/dkeluarbiaya/dkeluarbiaya_state.dart';
import 'package:newklikrkw/core/helpers/api_validation_ext_exception.dart';
import 'package:newklikrkw/models/dkeluarbiaya.dart';
import 'package:newklikrkw/repositories/dkeluarbiaya_repository.dart';

class DkeluarbiayaBloc extends Bloc<dynamic, DkeluarbiayaState> {
  final DkeluarbiayaRepository repository;

  DkeluarbiayaBloc({required this.repository})
    : super(DkeluarbiayaState.initial()) {
    on<LoadDkeluarbiayas>(_onLoad);

    on<RefreshDkeluarbiayas>(_onRefresh);

    on<LoadMoreDkeluarbiayas>(_onLoadMore);

    on<LoadItemkegiatans>(_onLoadItemkegiatans);
    on<AddDkeluarbiaya>(_onAdd);

    on<UpdateDkeluarbiaya>(_onUpdate);

    on<ResetSaveState>(_onResetSaveState);

    on<ResetValidationError>(_onResetValidation);

    on<ClearForm>(_onClearForm);
    on<GetKeluarbiaya>(_onGetKeluarbiaya);
    on<UpdateStatusKeluarbiaya>(_onUpdateStatusKeluarbiaya);
    on<ResetUpdateStatus>(_onResetUpdateStatus);
    on<DeleteDkeluarbiaya>(_onDeleteDkeluarbiaya);
    on<ResetDeleteState>(_onResetDeleteState);
  }

  Future<void> _onLoad(
    LoadDkeluarbiayas event,
    Emitter<DkeluarbiayaState> emit,
  ) async {
    emit(
      state.copyWith(
        loading: true,
        errorMessage: null,
        keluarbiayaId: event.keluarbiayaId,
      ),
    );

    try {
      final result = await repository.getDkeluarbiayas(
        keluarbiayaId: event.keluarbiayaId,
        offset: 0,
        limit: state.limit,
      );

      emit(
        state.copyWith(
          loading: false,
          dkeluarbiayas: List<Dkeluarbiaya>.from(result["items"]),
          offset: result["offset"] + result["items"].length,
          limit: result["limit"],
          total: result["total"],
          hasMore: result["hasMore"],
        ),
      );
      add(GetKeluarbiaya(event.keluarbiayaId));
    } catch (e) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onRefresh(
    RefreshDkeluarbiayas event,
    Emitter<DkeluarbiayaState> emit,
  ) async {
    emit(state.copyWith(refreshing: true));

    try {
      final result = await repository.getDkeluarbiayas(
        keluarbiayaId: state.keluarbiayaId,
        offset: 0,
        limit: state.limit,
      );

      emit(
        state.copyWith(
          refreshing: false,
          dkeluarbiayas: List<Dkeluarbiaya>.from(result["items"]),
          offset: result["items"].length,
          total: result["total"],
          hasMore: result["hasMore"],
        ),
      );
      add(GetKeluarbiaya(state.keluarbiayaId));
    } catch (e) {
      emit(state.copyWith(refreshing: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreDkeluarbiayas event,
    Emitter<DkeluarbiayaState> emit,
  ) async {
    if (!state.hasMore) return;

    if (state.loadingMore) return;

    emit(state.copyWith(loadingMore: true));

    try {
      final result = await repository.getDkeluarbiayas(
        keluarbiayaId: state.keluarbiayaId,
        offset: state.offset,
        limit: state.limit,
      );

      final List<Dkeluarbiaya> items = List.from(state.dkeluarbiayas)
        ..addAll(result["items"]);

      emit(
        state.copyWith(
          loadingMore: false,
          dkeluarbiayas: items,
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
    Emitter<DkeluarbiayaState> emit,
  ) async {
    try {
      int? instansiId;
      if (state.keluarbiaya != null) {
        instansiId = state.keluarbiaya!.instansi.id;
      }
      final items = await repository.getItemkegiatans(instansiId!);

      emit(state.copyWith(itemkegiatans: items));
    } catch (_) {}
  }

  Future<void> _onAdd(
    AddDkeluarbiaya event,
    Emitter<DkeluarbiayaState> emit,
  ) async {
    emit(
      state.copyWith(saving: true, saveSuccess: false, validationErrors: {}),
    );

    try {
      await repository.addDkeluarbiaya(event.keluarbiayaId, event.request);
      emit(state.copyWith(saving: false, saveSuccess: true));
    } on ApiValidationExtException catch (e) {
      emit(state.copyWith(saving: false, validationErrors: e.errors));
    } catch (e) {
      emit(state.copyWith(saving: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdate(
    UpdateDkeluarbiaya event,
    Emitter<DkeluarbiayaState> emit,
  ) async {
    emit(
      state.copyWith(saving: true, saveSuccess: false, validationErrors: {}),
    );

    try {
      await repository.updateDkeluarbiaya(event.id, event.request);

      emit(state.copyWith(saving: false, saveSuccess: true));
    } on ApiValidationExtException catch (e) {
      emit(state.copyWith(saving: false, validationErrors: e.errors));
    } catch (e) {
      emit(state.copyWith(saving: false, errorMessage: e.toString()));
    }
  }

  void _onResetSaveState(
    ResetSaveState event,
    Emitter<DkeluarbiayaState> emit,
  ) {
    emit(state.copyWith(saveSuccess: false));
  }

  void _onResetValidation(
    ResetValidationError event,
    Emitter<DkeluarbiayaState> emit,
  ) {
    emit(state.copyWith(validationErrors: {}));
  }

  void _onClearForm(ClearForm event, Emitter<DkeluarbiayaState> emit) {
    emit(state.copyWith(saveSuccess: false, validationErrors: {}));
  }

  FutureOr<void> _onGetKeluarbiaya(
    GetKeluarbiaya event,
    Emitter<DkeluarbiayaState> emit,
  ) async {
    try {
      emit(state.copyWith(keluarbiaya: null, loadingKeluarbiaya: true));
      final item = await repository.getKeluarbiaya(
        keluarbiayaId: event.keluarbiayaId,
      );
      emit(state.copyWith(keluarbiaya: item, loadingKeluarbiaya: false));
    } catch (_) {}
  }

  Future<void> _onUpdateStatusKeluarbiaya(
    UpdateStatusKeluarbiaya event,
    Emitter<DkeluarbiayaState> emit,
  ) async {
    emit(state.copyWith(updatingStatus: true, updateStatusSuccess: false));

    try {
      await repository.updateStatusKeluarbiaya(
        keluarbiayaId: event.keluarbiayaId,
        status: event.status,
      );

      emit(state.copyWith(updatingStatus: false, updateStatusSuccess: true));

      add(const RefreshDkeluarbiayas());
    } catch (e) {
      emit(state.copyWith(updatingStatus: false, errorMessage: e.toString()));
    }
  }

  void _onResetUpdateStatus(
    ResetUpdateStatus event,
    Emitter<DkeluarbiayaState> emit,
  ) {
    emit(
      state.copyWith(
        updatingStatus: false,
        updateStatusSuccess: false,
        errorMessage: null,
      ),
    );
  }

  Future<void> _onDeleteDkeluarbiaya(
    DeleteDkeluarbiaya event,
    Emitter<DkeluarbiayaState> emit,
  ) async {
    emit(state.copyWith(deleting: true, deleteSuccess: false));

    try {
      await repository.deleteDkeluarbiaya(event.id);

      emit(state.copyWith(deleting: false, deleteSuccess: true));

      add(const RefreshDkeluarbiayas());
    } catch (e) {
      emit(state.copyWith(deleting: false, errorMessage: e.toString()));
    }
  }

  void _onResetDeleteState(
    ResetDeleteState event,
    Emitter<DkeluarbiayaState> emit,
  ) {
    emit(state.copyWith(deleteSuccess: false, deleting: false));
  }
}
