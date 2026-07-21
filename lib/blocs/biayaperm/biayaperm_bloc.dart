import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/material.dart';
import 'package:newklikrkw/models/add_biayaperm_request.dart';
import 'package:newklikrkw/models/biayaperm.dart';
import 'package:newklikrkw/models/rincianbiayaperm.dart';
import 'package:newklikrkw/models/validation_error.dart';
import 'package:newklikrkw/models/validation_exception.dart';
import 'package:newklikrkw/repositories/biayaperm_repository.dart';

part 'biayaperm_event.dart';
part 'biayaperm_state.dart';

class BiayapermBloc extends Bloc<BiayapermEvent, BiayapermState> {
  final BiayapermRepository repository;

  static const int limit = 20;

  BiayapermBloc(this.repository) : super(const BiayapermState()) {
    on<LoadBiayaperms>(_onLoad, transformer: droppable());

    on<FilterTranspermohonanBiayaperm>(_onFilter, transformer: restartable());
    on<LoadRincianBiayaperm>(
      _onLoadRincianBiayaperm,
      transformer: restartable(),
    );

    // Tahap berikutnya
    on<AddBiayaperm>(_onAddBiayaperm);
    on<UpdateBiayaperm>(_onUpdateBiayaperm);
    on<ResetValidationError>(_onResetValidationError);
    on<ResetSaveState>(_onResetSaveState);
    on<ClearBiayapermForm>(_onClearForm);
    on<LoadBiayaperm>(_onLoadBiayaperm, transformer: restartable());

    on<FilterStatusBiayaperm>(_onFilterStatusBiayaperm);
  }

  Future<void> _onLoad(
    LoadBiayaperms event,
    Emitter<BiayapermState> emit,
  ) async {
    if (state.hasReachedMax && !event.refresh) {
      return;
    }

    try {
      final offset = event.refresh ? 0 : state.items.length;

      if (event.refresh) {
        emit(state.copyWith(loading: true, items: [], hasReachedMax: false));
      }
      final data = await repository.getBiayaperms(
        offset: offset,
        limit: limit,
        transpermohonanId: state.transpermohonanId,
        isTranspermohonanId: state.isTranspermohonanId,
        statusBiayaperm: state.status,
      );

      emit(
        state.copyWith(
          loading: false,

          items: event.refresh ? data : [...state.items, ...data],

          hasReachedMax: data.length < limit,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onFilter(
    FilterTranspermohonanBiayaperm event,
    Emitter<BiayapermState> emit,
  ) async {
    emit(
      state.copyWith(
        transpermohonanId: event.transpermohonanId,
        isTranspermohonanId: event.isTranspermohonanId,
        items: [],
        hasReachedMax: false,
        error: null,
      ),
    );

    add(LoadBiayaperms(refresh: true));
    if (event.transpermohonanId != null &&
        event.transpermohonanId!.isNotEmpty) {
      add(LoadRincianBiayaperm(event.transpermohonanId!));
    } else {
      emit(state.copyWith(rincianBiayaperms: const []));
    }

    add(LoadBiayaperms(refresh: true));
  }

  Future<void> _onLoadRincianBiayaperm(
    LoadRincianBiayaperm event,
    Emitter<BiayapermState> emit,
  ) async {
    try {
      final result = await repository.getRincianBiayaperm(
        event.transpermohonanId,
      );

      emit(state.copyWith(rincianBiayaperms: result));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
  // ==========================================================
  // Handler berikutnya dibuat pada tahap selanjutnya
  // ==========================================================

  Future<void> _onAddBiayaperm(
    AddBiayaperm event,
    Emitter<BiayapermState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          saving: true,
          saveSuccess: false,
          error: null,
          validationError: null,
        ),
      );

      await repository.addBiayaperm(event.request);
      emit(state.copyWith(saving: false, saveSuccess: true));

      // Refresh daftar Biaya Permohonan
      add(LoadBiayaperms(refresh: true));

      // Refresh daftar rincian biaya agar saldo ikut berubah
      if (state.transpermohonanId != null &&
          state.transpermohonanId!.isNotEmpty) {
        add(LoadRincianBiayaperm(state.transpermohonanId!));
      }
    } on ValidationException catch (e) {
      emit(state.copyWith(saving: false, validationError: e.validationError));
    } catch (e) {
      emit(state.copyWith(saving: false, error: e.toString()));
    }
  }

  Future<void> _onUpdateBiayaperm(
    UpdateBiayaperm event,
    Emitter<BiayapermState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          saving: true,
          saveSuccess: false,
          error: null,
          validationError: null,
        ),
      );

      // final updated = await repository.updateBiayaperm(event.id, event.request);

      // final items = state.items.map((e) {
      //   if (e.id == updated.id) {
      //     return updated;
      //   }
      //   return e;
      // }).toList();

      // emit(state.copyWith(saving: false, saveSuccess: true, items: items));

      await repository.updateBiayaperm(event.id, event.request);
      emit(state.copyWith(saving: false, saveSuccess: true));

      // Refresh daftar biaya
      add(LoadBiayaperms(refresh: true));

      // Refresh rincian biaya agar saldo berubah
      if (state.transpermohonanId != null &&
          state.transpermohonanId!.isNotEmpty) {
        add(LoadRincianBiayaperm(state.transpermohonanId!));
      }
    } on ValidationException catch (e) {
      emit(state.copyWith(saving: false, validationError: e.validationError));
    } catch (e) {
      emit(state.copyWith(saving: false, error: e.toString()));
    }
  }

  void _onResetValidationError(
    ResetValidationError event,
    Emitter<BiayapermState> emit,
  ) {
    emit(state.copyWith(validationError: null, error: null));
  }

  void _onResetSaveState(ResetSaveState event, Emitter<BiayapermState> emit) {
    emit(state.copyWith(saving: false, saveSuccess: false, error: null));
  }

  void _onClearForm(ClearBiayapermForm event, Emitter<BiayapermState> emit) {
    emit(
      state.copyWith(
        saving: false,
        saveSuccess: false,
        validationError: null,
        error: null,
        rincianBiayaperms: const [],
      ),
    );
  }

  Future<void> _onLoadBiayaperm(
    LoadBiayaperm event,
    Emitter<BiayapermState> emit,
  ) async {
    try {
      final result = await repository.getBiayaperm(event.biayapermId);
      emit(state.copyWith(biayaperm: result));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  FutureOr<void> _onFilterStatusBiayaperm(
    FilterStatusBiayaperm event,
    Emitter<BiayapermState> emit,
  ) {
    emit(state.copyWith(status: event.status));
    add(LoadBiayaperms(refresh: true));
  }
}
