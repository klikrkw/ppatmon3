import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:newklikrkw/core/helpers/api_validation_exception.dart';
import 'package:newklikrkw/repositories/bayarbiayaperm_repository.dart';
import 'package:stream_transform/stream_transform.dart';

import 'bayarbiayaperm_event.dart';
import 'bayarbiayaperm_state.dart';

EventTransformer<T> debounceRestartable<T>(Duration duration) {
  return (events, mapper) {
    return restartable<T>().call(events.debounce(duration), mapper);
  };
}

class BayarbiayapermBloc
    extends Bloc<BayarbiayapermEvent, BayarbiayapermState> {
  final BayarbiayapermRepository repository;

  BayarbiayapermBloc({required this.repository})
    : super(BayarbiayapermState.initial()) {
    on<LoadBayarbiayaperms>(_onLoadBayarbiayaperms, transformer: droppable());

    on<FilterBayarbiayaperm>(
      _onFilterBayarbiayaperm,
      transformer: debounceRestartable(const Duration(milliseconds: 400)),
    );

    on<AddBayarbiayaperm>(_onAddBayarbiayaperm);

    on<UpdateBayarbiayaperm>(_onUpdateBayarbiayaperm);

    on<DeleteBayarbiayaperm>(_onDeleteBayarbiayaperm);

    on<ResetValidationError>(_onResetValidationError);

    on<ResetSaveState>(_onResetSaveState);

    on<ClearBayarbiayapermForm>(_onClearForm);
    on<LoadMetodebayars>(_onLoadMetodebayars);

    on<LoadRekenings>(_onLoadRekenings);
  }

  Future<void> _onLoadBayarbiayaperms(
    LoadBayarbiayaperms event,
    Emitter<BayarbiayapermState> emit,
  ) async {
    if (state.loading) return;

    if (state.hasReachedMax && !event.refresh) {
      return;
    }

    emit(
      state.copyWith(
        loading: true,
        items: event.refresh ? [] : state.items,
        offset: event.refresh ? 0 : state.offset,
        hasReachedMax: event.refresh ? false : state.hasReachedMax,
        error: null,
      ),
    );

    try {
      final result = await repository.getBayarbiayaperms(
        offset: event.refresh ? 0 : state.offset,
        limit: state.limit,
        query: state.query,
        biayapermId: state.biayapermId,
      );

      final items = event.refresh ? result : [...state.items, ...result];

      emit(
        state.copyWith(
          loading: false,
          items: items,
          offset: items.length,
          hasReachedMax: result.length < state.limit,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onFilterBayarbiayaperm(
    FilterBayarbiayaperm event,
    Emitter<BayarbiayapermState> emit,
  ) async {
    emit(
      state.copyWith(
        query: event.query,
        biayapermId: event.biayapermId,
        offset: 0,
        hasReachedMax: false,
        items: [],
      ),
    );

    add(const LoadBayarbiayaperms(refresh: true));
  }

  // ============================
  // Bagian 2
  // ============================

  Future<void> _onAddBayarbiayaperm(
    AddBayarbiayaperm event,
    Emitter<BayarbiayapermState> emit,
  ) async {
    emit(
      state.copyWith(
        saving: true,
        saveSuccess: false,
        validationError: null,
        error: null,
      ),
    );

    try {
      await repository.add(event.request);

      emit(state.copyWith(saving: false, saveSuccess: true));

      add(const LoadBayarbiayaperms(refresh: true));
    } on ApiValidationException catch (e) {
      emit(state.copyWith(saving: false, validationError: e.validationError));
    } catch (e) {
      emit(state.copyWith(saving: false, error: e.toString()));
    }
  }

  Future<void> _onUpdateBayarbiayaperm(
    UpdateBayarbiayaperm event,
    Emitter<BayarbiayapermState> emit,
  ) async {
    emit(
      state.copyWith(
        saving: true,
        saveSuccess: false,
        validationError: null,
        error: null,
      ),
    );

    try {
      await repository.update(event.id, event.request);

      emit(state.copyWith(saving: false, saveSuccess: true));

      add(const LoadBayarbiayaperms(refresh: true));
    } on ApiValidationException catch (e) {
      emit(state.copyWith(saving: false, validationError: e.validationError));
    } catch (e) {
      emit(state.copyWith(saving: false, error: e.toString()));
    }
  }

  Future<void> _onDeleteBayarbiayaperm(
    DeleteBayarbiayaperm event,
    Emitter<BayarbiayapermState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));

    try {
      await repository.delete(event.id);

      final items = state.items.where((e) => e.id != event.id).toList();

      emit(state.copyWith(loading: false, items: items, offset: items.length));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
  // Future<void> _onUpdateBayarbiayaperm(
  //   UpdateBayarbiayaperm event,
  //   Emitter<BayarbiayapermState> emit,
  // ) async {}

  // ============================
  // Bagian 3
  // ============================

  void _onResetValidationError(
    ResetValidationError event,
    Emitter<BayarbiayapermState> emit,
  ) {
    emit(state.copyWith(validationError: null, error: null));
  }

  void _onResetSaveState(
    ResetSaveState event,
    Emitter<BayarbiayapermState> emit,
  ) {
    emit(state.copyWith(saveSuccess: false));
  }

  void _onClearForm(
    ClearBayarbiayapermForm event,
    Emitter<BayarbiayapermState> emit,
  ) {
    emit(
      state.copyWith(
        saving: false,
        saveSuccess: false,
        validationError: null,
        error: null,
        selectedMetodebayar: null,
        selectedRekening: null,
      ),
    );
  }

  Future<void> _onLoadMetodebayars(
    LoadMetodebayars event,
    Emitter<BayarbiayapermState> emit,
  ) async {
    emit(state.copyWith(loadingMetodebayar: true));

    try {
      final items = await repository.getMetodebayars();

      emit(state.copyWith(loadingMetodebayar: false, metodebayars: items));
    } catch (e) {
      emit(state.copyWith(loadingMetodebayar: false, error: e.toString()));
    }
  }

  Future<void> _onLoadRekenings(
    LoadRekenings event,
    Emitter<BayarbiayapermState> emit,
  ) async {
    emit(state.copyWith(loadingRekening: true, rekenings: []));

    try {
      final items = await repository.getRekenings(
        metodebayarId: event.metodebayarId,
      );

      emit(state.copyWith(loadingRekening: false, rekenings: items));
    } catch (e) {
      emit(state.copyWith(loadingRekening: false, error: e.toString()));
    }
  }
}
