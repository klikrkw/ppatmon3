import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:newklikrkw/models/posisiberkas.dart';
import 'package:newklikrkw/models/tempatberkas.dart';
import 'package:newklikrkw/models/transpermohonan.dart';
import 'package:newklikrkw/repositories/berkas_lokasi_repository.dart';

part 'berkas_lokasi_event.dart';
part 'berkas_lokasi_state.dart';

class BerkasLokasiBloc extends Bloc<BerkasLokasiEvent, BerkasLokasiState> {
  final BerkasLokasiRepository repository;

  BerkasLokasiBloc(this.repository) : super(BerkasLokasiState.initial()) {
    on<LoadBerkasLokasi>(_onLoad, transformer: restartable());

    on<SelectTempatBerkas>(_onSelectTempat);

    on<RefreshBerkasLokasi>(_onRefresh, transformer: restartable());
    on<ResetLokasiBerkas>((event, emit) async {
      emit(BerkasLokasiState.initial());
      emit(state.copyWith(tempatberkases: [], error: null, loading: true));

      try {
        final result = await repository.getTempatberkases();
        emit(
          state.copyWith(tempatberkases: result, loading: false, error: null),
        );
      } catch (e) {
        emit(
          state.copyWith(
            tempatberkases: [],
            loading: false,
            error: e.toString(),
          ),
        );
      }
    });
    on<SaveBerkasLokasi>(_onSave);
    on<ToggleEditingLokasi>(_onToggleEditing);
    on<UpdatePosisiBerkas>(_onUpdatePosisi, transformer: restartable());
  }

  Future<void> _onLoad(
    LoadBerkasLokasi event,
    Emitter<BerkasLokasiState> emit,
  ) async {
    emit(
      state.copyWith(
        loading: true,
        editing: false,
        error: null,
        transpermohonan: null,
        selectedTempatberkas: null,
        posisiberkas: null,
        // tempatberkases: [],
      ),
    );

    try {
      final result = await repository.getLokasiBerkas(event.transpermohonanId);

      emit(
        state.copyWith(
          loading: false,
          transpermohonan: result.transpermohonan,
          posisiberkas: result.posisiberkas,
          selectedTempatberkas: result.tempatberkas,
          transpermohonanId: event.transpermohonanId,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onRefresh(
    RefreshBerkasLokasi event,
    Emitter<BerkasLokasiState> emit,
  ) async {
    if (state.transpermohonanId == null) {
      return;
    }

    add(LoadBerkasLokasi(state.transpermohonanId!));
  }

  void _onSelectTempat(
    SelectTempatBerkas event,
    Emitter<BerkasLokasiState> emit,
  ) {
    emit(
      state.copyWith(selectedTempatberkas: event.tempatberkas, editing: true),
    );
  }

  FutureOr<void> _onSave(
    SaveBerkasLokasi event,
    Emitter<BerkasLokasiState> emit,
  ) {
    emit(state.copyWith(editing: false));
  }

  void _onToggleEditing(
    ToggleEditingLokasi event,
    Emitter<BerkasLokasiState> emit,
  ) {
    emit(
      state.copyWith(
        editing: event.editing,
        selectedTempatberkas: state.posisiberkas!.tempatberkas,
      ),
    );
  }

  Future<void> _onUpdatePosisi(
    UpdatePosisiBerkas event,
    Emitter<BerkasLokasiState> emit,
  ) async {
    if (state.transpermohonan == null) {
      return;
    }
    try {
      emit(state.copyWith(loading: true));

      final response = await repository.updatePosisiBerkas(
        transpermohonanId: state.transpermohonan!.id,
        tempatberkasId: event.tempatberkas.id,
        row: event.row,
        col: event.col,
      );
      Posisiberkas? posisiBaru;
      if (state.posisiberkas != null) {
        posisiBaru = state.posisiberkas!.copyWith(
          id: response['data'],
          row: event.row,
          col: event.col,
          tempatberkas: event.tempatberkas,
        );
      } else {
        posisiBaru = Posisiberkas(
          id: response['data'],
          row: event.row,
          col: event.col,
          tempatberkas: event.tempatberkas,
        );
      }
      emit(
        state.copyWith(
          loading: false,
          posisiberkas: posisiBaru,
          selectedTempatberkas: event.tempatberkas,
          updateSuccess: true,
        ),
      );
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
