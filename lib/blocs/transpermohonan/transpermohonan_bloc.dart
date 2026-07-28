import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/transpermohonan/transpermohonan_event.dart';
import 'package:newklikrkw/blocs/transpermohonan/transpermohonan_state.dart';
import 'package:newklikrkw/core/bloc/event_transformers.dart';
import 'package:newklikrkw/models/desa.dart';
import 'package:newklikrkw/models/jenishak.dart';
import 'package:newklikrkw/models/jenispermohonan.dart';
import 'package:newklikrkw/models/user.dart';
import 'package:newklikrkw/models/validation_exception.dart';
import 'package:newklikrkw/repositories/desa_repository.dart';
import 'package:newklikrkw/repositories/jenishak_repository.dart';
import 'package:newklikrkw/repositories/jenispermohonan_repository.dart';
import 'package:newklikrkw/repositories/transpermohonan_repository.dart';
import 'package:newklikrkw/repositories/user_repository.dart';

class TranspermohonanBloc
    extends Bloc<TranspermohonanEvent, TranspermohonanState> {
  final TranspermohonanRepository repository;

  final JenishakRepository jenishakRepository;

  final JenispermohonanRepository jenispermohonanRepository;

  final UserRepository userRepository;

  final DesaRepository desaRepository;

  static const int pageSize = 20;

  TranspermohonanBloc(
    this.repository,
    this.jenishakRepository,
    this.jenispermohonanRepository,
    this.userRepository,
    this.desaRepository,
  ) : super(const TranspermohonanState()) {
    on<LoadTranspermohonan>(_load);
    on<LoadMoreTranspermohonan>(_loadMore);
    on<RefreshTranspermohonan>(_refresh);
    on<SearchTranspermohonan>(
      _searchTranspermohonan,
      transformer: debounceRestartable(const Duration(milliseconds: 500)),
    );

    on<FilterActiveChanged>(
      _onFilterChanged,
      transformer: debounceRestartable(const Duration(milliseconds: 100)),
    );
    on<UpdateStatusTranspermohonan>(
      _onUpdateStatus,
      transformer: debounceRestartable(const Duration(milliseconds: 200)),
    );
    on<FilterUserId>(_onFilterUserId, transformer: restartable());
    on<FilterTranspermohonanId>(
      _onFilterTranspermohonanId,
      transformer: restartable(),
    );
    on<FilterQrCode>(_onFilterQrCode, transformer: restartable());

    on<ResetItem>(_onResetItem, transformer: restartable());
    on<ResetFilterQrCode>(_onResetQrCode, transformer: restartable());

    on<LoadMasterTranspermohonan>(_onLoadMasterTranspermohonan);

    on<LoadJenishaks>(_onLoadJenishaks);

    on<LoadJenispermohonans>(_onLoadJenispermohonans);

    on<LoadUsers>(_onLoadUsers);

    on<LoadDesas>(_onLoadDesas);

    on<ResetValidationError>(_onResetValidationError);

    on<ResetSaveState>(_onResetSaveState);
    on<AddTranspermohonan>(_onAddTranspermohonan);
    on<UpdateTranspermohonan>(_onUpdateTranspermohonan);
    on<DetailTranspermohonan>(_onDetailTranspermohonan);
  }

  Future<void> _load(
    LoadTranspermohonan event,
    Emitter<TranspermohonanState> emit,
  ) async {
    emit(
      state.copyWith(
        loading: true,
        items: [],
        hasReachedMax: false,
        item: null,
        query: event.query,
        active: event.active,
        userId: event.userId,
      ),
    );

    try {
      final data = await repository.getData(
        offset: 0,
        limit: pageSize,
        userId: event.userId,
        active: event.active,
        query: event.query!,
      );

      emit(
        state.copyWith(
          loading: false,
          items: data,
          hasReachedMax: data.length < pageSize,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _loadMore(
    LoadMoreTranspermohonan event,
    Emitter<TranspermohonanState> emit,
  ) async {
    if (state.loading || state.hasReachedMax) return;

    emit(state.copyWith(loading: true));

    try {
      final data = await repository.getData(
        offset: state.items.length,
        limit: pageSize,
        query: state.query,
        active: state.active,
        userId: state.userId,
      );

      emit(
        state.copyWith(
          loading: false,
          items: [...state.items, ...data],
          hasReachedMax: data.length < pageSize,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _searchTranspermohonan(
    SearchTranspermohonan event,
    Emitter<TranspermohonanState> emit,
  ) async {
    emit(
      state.copyWith(loading: true, items: [], hasReachedMax: false, query: ''),
    );
    final result = await repository.getData(
      offset: 0,
      limit: pageSize,
      query: event.query,
      active: state.active,
      userId: state.userId,
    );
    emit(
      state.copyWith(
        loading: false,
        items: result,
        query: event.query,
        hasReachedMax: result.length < pageSize,
      ),
    );
  }

  Future<void> _refresh(
    RefreshTranspermohonan event,
    Emitter<TranspermohonanState> emit,
  ) async {
    add(
      LoadTranspermohonan(
        query: state.query,
        active: state.active,
        userId: state.userId,
      ),
    );
  }

  Future<void> _onFilterChanged(
    FilterActiveChanged event,
    Emitter<TranspermohonanState> emit,
  ) async {
    emit(state.copyWith(loading: true, items: [], hasReachedMax: false));
    final data = await repository.getData(
      offset: 0,
      limit: pageSize,
      query: state.query,
      userId: state.userId,
      active: event.active,
    );

    emit(
      state.copyWith(
        loading: false,
        items: data,
        hasReachedMax: data.length < pageSize,
        active: event.active,
      ),
    );
  }

  Future<void> _onUpdateStatus(
    UpdateStatusTranspermohonan event,
    Emitter<TranspermohonanState> emit,
  ) async {
    await repository.updateStatusPermohonan(id: event.id, active: event.active);

    final updatedItems = state.items.map((item) {
      if (item.id == event.id) {
        return item.copyWith(active: event.active);
      }
      return item;
    }).toList();

    emit(state.copyWith(items: updatedItems));
  }

  Future<void> _onFilterUserId(
    FilterUserId event,
    Emitter<TranspermohonanState> emit,
  ) async {
    emit(state.copyWith(loading: true, userId: event.userId));
    final data = await repository.getData(
      offset: 0,
      limit: pageSize,
      query: state.query,
      active: state.active,
      userId: event.userId,
    );

    emit(
      state.copyWith(
        loading: false,
        items: data,
        hasReachedMax: data.length < pageSize,
      ),
    );
  }

  Future<void> _onFilterTranspermohonanId(
    FilterTranspermohonanId event,
    Emitter<TranspermohonanState> emit,
  ) async {
    emit(
      state.copyWith(
        loading: true,
        transpermohonanId: event.transpermohonanId,
        item: null,
      ),
    );

    final data = await repository.getData(
      offset: 0,
      limit: pageSize,
      query: state.query,
      active: state.active,
      userId: state.userId,
      transpermohonanId: event.transpermohonanId,
      isTranspermohonanId: event.isTranspermohonanId,
    );

    emit(
      state.copyWith(
        loading: false,
        item: data.isEmpty ? null : data.first,
        hasReachedMax: data.length < pageSize,
      ),
    );
  }

  Future<void> _onFilterQrCode(
    FilterQrCode event,
    Emitter<TranspermohonanState> emit,
  ) async {
    emit(state.copyWith(loading: true, transpermohonan: null));
    final data = await repository.getData(
      offset: 0,
      limit: pageSize,
      transpermohonanId: event.transpermohonanId,
      isTranspermohonanId: event.isTranspermohonanId!,
    );

    emit(
      state.copyWith(
        loading: false,
        transpermohonan: data.isEmpty ? null : data.first,
        hasReachedMax: data.length < pageSize,
      ),
    );
  }

  FutureOr<void> _onResetItem(
    ResetItem event,
    Emitter<TranspermohonanState> emit,
  ) {
    emit(state.copyWith(item: null));
  }

  FutureOr<void> _onResetQrCode(
    ResetFilterQrCode event,
    Emitter<TranspermohonanState> emit,
  ) {
    emit(state.copyWith(transpermohonan: null));
  }

  Future<void> _onLoadMasterTranspermohonan(
    LoadMasterTranspermohonan event,
    Emitter<TranspermohonanState> emit,
  ) async {
    emit(state.copyWith(loadingMasters: true));
    try {
      final results = await Future.wait([
        jenishakRepository.getAll(),
        jenispermohonanRepository.getAll(),
        userRepository.getUsers(),
        desaRepository.getDesas(),
      ]);

      emit(
        state.copyWith(
          loadingMasters: false,
          jenishaks: results[0] as List<Jenishak>,
          jenispermohonans: results[1] as List<Jenispermohonan>,
          users: results[2] as List<User>,
          desas: results[3] as List<Desa>,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loadingMasters: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadJenishaks(
    LoadJenishaks event,
    Emitter<TranspermohonanState> emit,
  ) async {
    final list = await jenishakRepository.getAll();

    emit(state.copyWith(jenishaks: list));
  }

  Future<void> _onLoadJenispermohonans(
    LoadJenispermohonans event,
    Emitter<TranspermohonanState> emit,
  ) async {
    final list = await jenispermohonanRepository.getAll();

    emit(state.copyWith(jenispermohonans: list));
  }

  Future<void> _onLoadUsers(
    LoadUsers event,
    Emitter<TranspermohonanState> emit,
  ) async {
    final list = await userRepository.getUsers();

    emit(state.copyWith(users: list));
  }

  Future<void> _onLoadDesas(
    LoadDesas event,
    Emitter<TranspermohonanState> emit,
  ) async {
    final list = await desaRepository.getDesas(query: event.query);

    emit(state.copyWith(desas: list));
  }

  void _onResetValidationError(
    ResetValidationError event,
    Emitter<TranspermohonanState> emit,
  ) {
    emit(state.copyWith(validationError: null));
  }

  void _onResetSaveState(
    ResetSaveState event,
    Emitter<TranspermohonanState> emit,
  ) {
    emit(state.copyWith(saveSuccess: false));
  }

  Future<void> _onAddTranspermohonan(
    AddTranspermohonan event,
    Emitter<TranspermohonanState> emit,
  ) async {
    emit(
      state.copyWith(
        saving: true,
        saveSuccess: false,
        validationError: null,
        errorMessage: null,
        transpermohonanModel: null,
      ),
    );

    try {
      await repository.add(event.request);

      emit(
        state.copyWith(
          saving: false,
          saveSuccess: true,
          // transpermohonans: [
          //   item,
          //   ...state.transpermohonans,
          // ],
        ),
      );
    } on ValidationException catch (e) {
      emit(state.copyWith(saving: false, validationError: e.validationError));
    } catch (e) {
      emit(state.copyWith(saving: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdateTranspermohonan(
    UpdateTranspermohonan event,
    Emitter<TranspermohonanState> emit,
  ) async {
    emit(
      state.copyWith(
        saving: true,
        saveSuccess: false,
        validationError: null,
        errorMessage: null,
        transpermohonanModel: null,
      ),
    );

    try {
      await repository.update(event.id, event.request);

      // final list = state.transpermohonans
      //     .map(
      //       (e) => e.id == item.id ? item : e,
      //     )
      //     .toList();

      emit(
        state.copyWith(
          saving: false,
          saveSuccess: true,
          // transpermohonans: list,
          // transpermohonan: item,
        ),
      );
    } on ValidationException catch (e) {
      emit(state.copyWith(saving: false, validationError: e.validationError));
    } catch (e) {
      emit(state.copyWith(saving: false, errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onDetailTranspermohonan(
    DetailTranspermohonan event,
    Emitter<TranspermohonanState> emit,
  ) async {
    emit(state.copyWith(transpermohonanModel: null, loadingDetail: true));
    try {
      final item = await repository.detail(event.id);
      emit(state.copyWith(transpermohonanModel: item, loadingDetail: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
