import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/keluarbiayapermuser/keluarbiayapermuser_event.dart';
import 'package:newklikrkw/blocs/keluarbiayapermuser/keluarbiayapermuser_state.dart';
import 'package:newklikrkw/core/helpers/api_validation_ext_exception.dart';
import 'package:newklikrkw/models/keluarbiayapermuser.dart';
import 'package:newklikrkw/models/user.dart';
import 'package:newklikrkw/repositories/keluarbiayapermuser_repository.dart';

class KeluarbiayapermuserBloc
    extends Bloc<KeluarbiayapermuserEvent, KeluarbiayapermuserState> {
  final KeluarbiayapermuserRepository repository;

  KeluarbiayapermuserBloc({required this.repository})
    : super(const KeluarbiayapermuserState()) {
    on<LoadKeluarbiayapermusers>(_onLoadKeluarbiayapermusers);

    on<RefreshKeluarbiayapermusers>(_onRefreshKeluarbiayapermusers);

    on<LoadMoreKeluarbiayapermusers>(_onLoadMoreKeluarbiayapermusers);

    on<LoadUsers>(_onLoadUsers);

    on<LoadStatusKeluarbiayapermusers>(_onLoadStatusKeluarbiayapermusers);

    on<FilterUserKeluarbiayapermuser>(_onFilterUserKeluarbiayapermuser);

    on<FilterStatusKeluarbiayapermuser>(_onFilterStatusKeluarbiayapermuser);
    on<LoadInstansis>(_onLoadInstansis);

    on<LoadMetodebayars>(_onLoadMetodebayars);

    on<LoadRekenings>(_onLoadRekenings);

    on<LoadKasbons>(_onLoadKasbons);

    on<ChangeMetodebayar>(_onChangeMetodebayar);

    on<AddKeluarbiayapermuser>(_onAddKeluarbiayapermuser);

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
    return await repository.getKeluarbiayapermusers(
      offset: offset,
      limit: limit,
      userId: state.selectedUser?.id,
      status: state.selectedStatus,
    );
  }

  ///==========================
  /// Handler
  ///==========================

  Future<void> _onLoadKeluarbiayapermusers(
    LoadKeluarbiayapermusers event,
    Emitter<KeluarbiayapermuserState> emit,
  ) async {
    emit(
      state.copyWith(
        loading: true,
        error: null,
        offset: 0,
        hasMore: true,
        keluarbiayapermusers: const [],
      ),
    );

    try {
      final result = await _loadData(offset: 0, limit: state.limit);

      emit(
        state.copyWith(
          loading: false,
          keluarbiayapermusers: result["items"] as List<Keluarbiayapermuser>,
          offset: result["offset"] + result["limit"],
          total: result["total"],
          hasMore: result["hasMore"],
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onRefreshKeluarbiayapermusers(
    RefreshKeluarbiayapermusers event,
    Emitter<KeluarbiayapermuserState> emit,
  ) async {
    emit(state.copyWith(refreshing: true, error: null));

    try {
      final result = await _loadData(offset: 0, limit: state.limit);

      emit(
        state.copyWith(
          refreshing: false,
          keluarbiayapermusers: result["items"] as List<Keluarbiayapermuser>,
          offset: result["offset"] + result["limit"],
          total: result["total"],
          hasMore: result["hasMore"],
        ),
      );
    } catch (e) {
      emit(state.copyWith(refreshing: false, error: e.toString()));
    }
  }

  Future<void> _onLoadMoreKeluarbiayapermusers(
    LoadMoreKeluarbiayapermusers event,
    Emitter<KeluarbiayapermuserState> emit,
  ) async {
    if (state.loadingMore || state.loading || !state.hasMore) {
      return;
    }

    emit(state.copyWith(loadingMore: true));

    try {
      final result = await _loadData(offset: state.offset, limit: state.limit);

      final List<Keluarbiayapermuser> items =
          result["items"] as List<Keluarbiayapermuser>;

      emit(
        state.copyWith(
          loadingMore: false,
          keluarbiayapermusers: [...state.keluarbiayapermusers, ...items],
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
    Emitter<KeluarbiayapermuserState> emit,
  ) async {
    try {
      final users = await repository.getUsers();

      emit(state.copyWith(users: users));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onLoadStatusKeluarbiayapermusers(
    LoadStatusKeluarbiayapermusers event,
    Emitter<KeluarbiayapermuserState> emit,
  ) async {
    try {
      final statuses = await repository.getStatusKeluarbiayapermusers();

      emit(state.copyWith(statusKeluarbiayapermusers: statuses));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onFilterUserKeluarbiayapermuser(
    FilterUserKeluarbiayapermuser event,
    Emitter<KeluarbiayapermuserState> emit,
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
        keluarbiayapermusers: const [],
        error: null,
      ),
    );

    add(const LoadKeluarbiayapermusers());
  }

  Future<void> _onFilterStatusKeluarbiayapermuser(
    FilterStatusKeluarbiayapermuser event,
    Emitter<KeluarbiayapermuserState> emit,
  ) async {
    emit(
      state.copyWith(
        clearSelectedStatus: event.status == null,
        selectedStatus: event.status,
        offset: 0,
        hasMore: true,
        keluarbiayapermusers: const [],
        error: null,
      ),
    );

    add(const LoadKeluarbiayapermusers());
  }

  Future<void> _onLoadInstansis(
    LoadInstansis event,
    Emitter<KeluarbiayapermuserState> emit,
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
    Emitter<KeluarbiayapermuserState> emit,
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
    Emitter<KeluarbiayapermuserState> emit,
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
    Emitter<KeluarbiayapermuserState> emit,
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
    Emitter<KeluarbiayapermuserState> emit,
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

  Future<void> _onAddKeluarbiayapermuser(
    AddKeluarbiayapermuser event,
    Emitter<KeluarbiayapermuserState> emit,
  ) async {
    emit(
      state.copyWith(
        saving: true,
        saveSuccess: false,
        clearValidationErrors: true,
      ),
    );

    try {
      await repository.addKeluarbiayapermuser(event.request);

      emit(
        state.copyWith(
          saving: false,
          saveSuccess: true,
          clearValidationErrors: true,
        ),
      );

      /// Refresh list keluar biaya
      add(const RefreshKeluarbiayapermusers());
    } on ApiValidationExtException catch (e) {
      emit(
        state.copyWith(
          saving: false,
          saveSuccess: false,
          validationErrors: e.errors,
        ),
      );
    } catch (e) {
      print('error save : $e');
      emit(
        state.copyWith(saving: false, saveSuccess: false, error: e.toString()),
      );
    }
  }

  Future<void> _onResetValidationError(
    ResetValidationError event,
    Emitter<KeluarbiayapermuserState> emit,
  ) async {
    emit(state.copyWith(clearValidationErrors: true));
  }

  Future<void> _onResetSaveState(
    ResetSaveState event,
    Emitter<KeluarbiayapermuserState> emit,
  ) async {
    emit(state.copyWith(saveSuccess: false));
  }

  Future<void> _onClearForm(
    ClearForm event,
    Emitter<KeluarbiayapermuserState> emit,
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
