import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/keluarbiaya/keluarbiaya_event.dart';
import 'package:newklikrkw/blocs/keluarbiaya/keluarbiaya_state.dart';
import 'package:newklikrkw/core/helpers/api_validation_ext_exception.dart';
import 'package:newklikrkw/models/keluarbiaya.dart';
import 'package:newklikrkw/models/user.dart';
import 'package:newklikrkw/repositories/keluarbiaya_repository.dart';

class KeluarbiayaBloc extends Bloc<KeluarbiayaEvent, KeluarbiayaState> {
  final KeluarbiayaRepository repository;

  KeluarbiayaBloc({required this.repository})
    : super(const KeluarbiayaState()) {
    on<LoadKeluarbiayas>(_onLoadKeluarbiayas);

    on<RefreshKeluarbiayas>(_onRefreshKeluarbiayas);

    on<LoadMoreKeluarbiayas>(_onLoadMoreKeluarbiayas);

    on<LoadUsers>(_onLoadUsers);

    on<LoadStatusKeluarbiayas>(_onLoadStatusKeluarbiayas);

    on<FilterUserKeluarbiaya>(_onFilterUserKeluarbiaya);

    on<FilterStatusKeluarbiaya>(_onFilterStatusKeluarbiaya);
    on<LoadInstansis>(_onLoadInstansis);

    on<LoadMetodebayars>(_onLoadMetodebayars);

    on<LoadRekenings>(_onLoadRekenings);

    on<LoadKasbons>(_onLoadKasbons);

    on<ChangeMetodebayar>(_onChangeMetodebayar);

    on<AddKeluarbiaya>(_onAddKeluarbiaya);

    on<ResetValidationError>(_onResetValidationError);

    on<ResetSaveState>(_onResetSaveState);

    on<ClearForm>(_onClearForm);
  }

  ///======================================
  /// Helper mengambil data dari repository
  ///======================================
  Future<Map<String, dynamic>> _loadData({
    required int offset,
    required int limit,
  }) async {
    return await repository.getKeluarbiayas(
      offset: offset,
      limit: limit,
      userId: state.selectedUser?.id,
      status: state.selectedStatus,
    );
  }

  ///==========================
  /// Handler
  ///==========================

  Future<void> _onLoadKeluarbiayas(
    LoadKeluarbiayas event,
    Emitter<KeluarbiayaState> emit,
  ) async {
    emit(
      state.copyWith(
        loading: true,
        error: null,
        offset: 0,
        hasMore: true,
        keluarbiayas: const [],
      ),
    );

    try {
      final result = await _loadData(offset: 0, limit: state.limit);

      emit(
        state.copyWith(
          loading: false,
          keluarbiayas: result["items"] as List<Keluarbiaya>,
          offset: result["offset"] + result["limit"],
          total: result["total"],
          hasMore: result["hasMore"],
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onRefreshKeluarbiayas(
    RefreshKeluarbiayas event,
    Emitter<KeluarbiayaState> emit,
  ) async {
    emit(state.copyWith(refreshing: true, error: null));

    try {
      final result = await _loadData(offset: 0, limit: state.limit);

      emit(
        state.copyWith(
          refreshing: false,
          keluarbiayas: result["items"] as List<Keluarbiaya>,
          offset: result["offset"] + result["limit"],
          total: result["total"],
          hasMore: result["hasMore"],
        ),
      );
    } catch (e) {
      emit(state.copyWith(refreshing: false, error: e.toString()));
    }
  }

  Future<void> _onLoadMoreKeluarbiayas(
    LoadMoreKeluarbiayas event,
    Emitter<KeluarbiayaState> emit,
  ) async {
    if (state.loadingMore || state.loading || !state.hasMore) {
      return;
    }

    emit(state.copyWith(loadingMore: true));

    try {
      final result = await _loadData(offset: state.offset, limit: state.limit);

      final List<Keluarbiaya> items = result["items"] as List<Keluarbiaya>;

      emit(
        state.copyWith(
          loadingMore: false,
          keluarbiayas: [...state.keluarbiayas, ...items],
          offset: result["offset"] + result["limit"],
          total: result["total"],
          hasMore: result["hasMore"],
        ),
      );
    } catch (e) {
      emit(state.copyWith(loadingMore: false, error: e.toString()));
    }
  }

  Future<void> _onLoadUsers(
    LoadUsers event,
    Emitter<KeluarbiayaState> emit,
  ) async {
    try {
      final users = await repository.getUsers();

      emit(state.copyWith(users: users));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onLoadStatusKeluarbiayas(
    LoadStatusKeluarbiayas event,
    Emitter<KeluarbiayaState> emit,
  ) async {
    try {
      final statuses = await repository.getStatusKeluarbiayas();

      emit(state.copyWith(statusKeluarbiayas: statuses));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onFilterUserKeluarbiaya(
    FilterUserKeluarbiaya event,
    Emitter<KeluarbiayaState> emit,
  ) async {
    User? selected;

    // if (event.userId != null) {
    //   try {
    //     selected = state.users.firstWhere((e) => e.id == event.userId);
    //   } catch (_) {
    //     selected = null;
    //   }
    // }
    if (event.user != null) {
      try {
        selected = event.user;
      } catch (_) {
        selected = null;
      }
    }

    emit(
      state.copyWith(
        clearSelectedUser: selected == null,
        selectedUser: selected,
        offset: 0,
        hasMore: true,
        keluarbiayas: const [],
        error: null,
      ),
    );

    add(const LoadKeluarbiayas());
  }

  Future<void> _onFilterStatusKeluarbiaya(
    FilterStatusKeluarbiaya event,
    Emitter<KeluarbiayaState> emit,
  ) async {
    emit(
      state.copyWith(
        clearSelectedStatus: event.status == null,
        selectedStatus: event.status,
        offset: 0,
        hasMore: true,
        keluarbiayas: const [],
        error: null,
      ),
    );

    add(const LoadKeluarbiayas());
  }

  Future<void> _onLoadInstansis(
    LoadInstansis event,
    Emitter<KeluarbiayaState> emit,
  ) async {
    try {
      emit(state.copyWith(instansis: const [], clearSelectedRekening: true));
      final instansis = await repository.getInstansis(kasbonId: event.kasbonId);
      emit(state.copyWith(instansis: instansis));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onLoadMetodebayars(
    LoadMetodebayars event,
    Emitter<KeluarbiayaState> emit,
  ) async {
    try {
      final metodebayars = await repository.getMetodebayars();

      emit(state.copyWith(metodebayars: metodebayars));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onLoadKasbons(
    LoadKasbons event,
    Emitter<KeluarbiayaState> emit,
  ) async {
    try {
      final kasbons = await repository.getKasbons(userId: event.userId);
      emit(state.copyWith(kasbons: kasbons));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onLoadRekenings(
    LoadRekenings event,
    Emitter<KeluarbiayaState> emit,
  ) async {
    try {
      emit(state.copyWith(rekenings: const [], clearSelectedRekening: true));

      final rekenings = await repository.getRekenings(
        metodebayarId: event.metodebayarId,
      );

      emit(state.copyWith(rekenings: rekenings));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onChangeMetodebayar(
    ChangeMetodebayar event,
    Emitter<KeluarbiayaState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedMetodebayar: event.metodebayar,
        rekenings: const [],
        clearSelectedRekening: true,
        clearValidationErrors: true,
      ),
    );

    add(LoadRekenings(metodebayarId: event.metodebayar.id));
  }

  Future<void> _onAddKeluarbiaya(
    AddKeluarbiaya event,
    Emitter<KeluarbiayaState> emit,
  ) async {
    emit(
      state.copyWith(
        saving: true,
        saveSuccess: false,
        clearValidationErrors: true,
      ),
    );

    try {
      await repository.addKeluarbiaya(event.request);

      emit(
        state.copyWith(
          saving: false,
          saveSuccess: true,
          clearValidationErrors: true,
        ),
      );

      /// Refresh list keluar biaya
      add(const RefreshKeluarbiayas());
    } on ApiValidationExtException catch (e) {
      emit(
        state.copyWith(
          saving: false,
          saveSuccess: false,
          validationErrors: e.errors,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(saving: false, saveSuccess: false, error: e.toString()),
      );
    }
  }

  Future<void> _onResetValidationError(
    ResetValidationError event,
    Emitter<KeluarbiayaState> emit,
  ) async {
    emit(state.copyWith(clearValidationErrors: true));
  }

  Future<void> _onResetSaveState(
    ResetSaveState event,
    Emitter<KeluarbiayaState> emit,
  ) async {
    emit(state.copyWith(saveSuccess: false));
  }

  Future<void> _onClearForm(
    ClearForm event,
    Emitter<KeluarbiayaState> emit,
  ) async {
    emit(
      state.copyWith(
        clearSelectedInstansi: true,
        clearSelectedMetodebayar: true,
        clearSelectedRekening: true,
        clearSelectedKasbon: true,

        rekenings: const [],

        saveSuccess: false,
        saving: false,

        clearValidationErrors: true,
      ),
    );
  }
}
