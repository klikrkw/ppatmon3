import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/prosespermohonan/prosespermohonan_event.dart';
import 'package:newklikrkw/blocs/prosespermohonan/prosespermohonan_state.dart';
import 'package:newklikrkw/core/bloc/event_transformers.dart';
import 'package:newklikrkw/models/validation_exception.dart';
import 'package:newklikrkw/repositories/prosespermohonan_repository.dart';

class ProsespermohonanBloc
    extends Bloc<ProsespermohonanEvent, ProsespermohonanState> {
  final ProsespermohonanRepository repository;

  static const int pageSize = 20;

  ProsespermohonanBloc(this.repository) : super(const ProsespermohonanState()) {
    on<LoadProsespermohonan>(_onLoad);

    on<LoadMoreProsespermohonan>(_onLoadMore, transformer: droppable());

    on<SearchProsespermohonan>(
      _onSearch,
      transformer: debounceRestartable(const Duration(milliseconds: 500)),
    );
    on<FilterStatusProsespermohonan>(
      _onFilterStatus,
      transformer: restartable(),
    );
    on<FilterItemProsespermohonan>(_onFilterItem, transformer: restartable());
    on<FilterUserId>(_onFilterUserId, transformer: restartable());
    on<StoreProsespermohonan>(_onStore);
    on<UpdateProsespermohonan>(_onUpdate);
    on<NewProsespermohonan>(_onNew);
    on<ResetValidationError>((event, emit) {
      emit(
        state.copyWith(
          clearValidationError: true,
          clearSaveError: true,
          saveSuccess: false,
        ),
      );
    });
  }

  Future<void> _onLoad(
    LoadProsespermohonan event,
    Emitter<ProsespermohonanState> emit,
  ) async {
    final statusprosespermOptions = await repository
        .getStatusprosespermOptions();
    final itemprosespermOptions = await repository.getItemprosespermOptions();
    emit(
      state.copyWith(
        loading: true,
        transpermohonanId: event.transpermohonanId,
        statusProsespermId: statusprosespermOptions.isNotEmpty
            ? statusprosespermOptions.first.id
            : event.statusprosespermId,
        userId: event.userId,
        query: event.query,
        itemProsespermId: itemprosespermOptions.isNotEmpty
            ? itemprosespermOptions.first.id
            : event.itemprosespermId,
        availableStatuses: statusprosespermOptions,
        availableItems: itemprosespermOptions,
        isTranspermohonanId: event.isTranspermohonanId,
      ),
    );

    final data = await repository.getData(
      transpermohonanId: event.transpermohonanId,
      userId: event.userId,
      isTranspermohonanId: event.isTranspermohonanId,
      offset: 0,
      limit: pageSize,
    );

    emit(
      state.copyWith(
        loading: false,
        items: data,
        hasReachedMax: data.length < pageSize,
      ),
    );
  }

  Future<void> _onNew(
    NewProsespermohonan event,
    Emitter<ProsespermohonanState> emit,
  ) async {
    emit(state.copyWith(saveError: null, saving: false, validationError: null));
  }

  Future<void> _onSearch(
    SearchProsespermohonan event,
    Emitter<ProsespermohonanState> emit,
  ) async {
    final data = await repository.getData(
      transpermohonanId: state.transpermohonanId,
      userId: state.userId,
      isTranspermohonanId: state.isTranspermohonanId,
      offset: 0,
      limit: pageSize,
      query: event.query,
    );

    emit(
      state.copyWith(
        query: event.query,
        items: data,
        hasReachedMax: data.length < pageSize,
      ),
    );
  }

  Future<void> _onLoadMore(
    LoadMoreProsespermohonan event,
    Emitter<ProsespermohonanState> emit,
  ) async {
    if (state.hasReachedMax) return;

    final data = await repository.getData(
      transpermohonanId: state.transpermohonanId,
      userId: state.userId,
      statusProsespermId: state.statusProsespermId,
      offset: state.items.length,
      limit: pageSize,
      query: state.query,
      isTranspermohonanId: state.isTranspermohonanId,
    );

    emit(
      state.copyWith(
        items: [...state.items, ...data],
        hasReachedMax: data.length < pageSize,
      ),
    );
  }

  Future<void> _onFilterStatus(
    FilterStatusProsespermohonan event,
    Emitter<ProsespermohonanState> emit,
  ) async {
    emit(
      state.copyWith(
        loading: true,
        statusProsespermId: event.statusProsespermId,
      ),
    );

    final data = await repository.getData(
      transpermohonanId: state.transpermohonanId,
      userId: state.userId,
      statusProsespermId: event.statusProsespermId,
      itemProsespermId: event.itemProsespermId,
      offset: 0,
      limit: pageSize,
      query: event.query!,
    );

    emit(
      state.copyWith(
        loading: false,
        items: data,
        hasReachedMax: data.length < pageSize,
      ),
    );
  }

  Future<void> _onFilterItem(
    FilterItemProsespermohonan event,
    Emitter<ProsespermohonanState> emit,
  ) async {
    emit(
      state.copyWith(loading: true, itemProsespermId: event.itemProsespermId),
    );

    final data = await repository.getData(
      transpermohonanId: state.transpermohonanId,
      userId: state.userId,
      statusProsespermId: state.statusProsespermId,
      itemProsespermId: event.itemProsespermId,

      offset: 0,
      limit: pageSize,
      query: state.query,
    );

    emit(
      state.copyWith(
        loading: false,
        items: data,
        hasReachedMax: data.length < pageSize,
      ),
    );
  }

  Future<void> _onFilterUserId(
    FilterUserId event,
    Emitter<ProsespermohonanState> emit,
  ) async {
    emit(state.copyWith(loading: true, userId: event.userId));

    final data = await repository.getData(
      transpermohonanId: state.transpermohonanId,
      userId: event.userId,
      statusProsespermId: state.statusProsespermId,
      itemProsespermId: state.itemProsespermId,

      offset: 0,
      limit: pageSize,
      query: state.query,
    );

    emit(
      state.copyWith(
        loading: false,
        items: data,
        hasReachedMax: data.length < pageSize,
      ),
    );
  }

  Future<void> _onStore(
    StoreProsespermohonan event,
    Emitter<ProsespermohonanState> emit,
  ) async {
    emit(
      state.copyWith(
        saving: true,
        saveSuccess: false,
        saveError: null,
        validationError: null,
      ),
    );
    try {
      await repository.store(event.request);
      emit(state.copyWith(saving: false, saveSuccess: true));
    } on ValidationException catch (e) {
      emit(state.copyWith(validationError: e.validationError));
    } catch (e) {
      emit(
        state.copyWith(
          saveError: e.toString(),
          saving: false,
          validationError: null,
        ),
      );
    } finally {
      emit(
        state.copyWith(saveError: null, saving: false, validationError: null),
      );
    }
    //  catch (e) {
    //   emit(state.copyWith(saving: false, saveError: e.toString()));
    // }
  }

  Future<void> _onUpdate(
    UpdateProsespermohonan event,
    Emitter<ProsespermohonanState> emit,
  ) async {
    emit(
      state.copyWith(
        saving: true,
        saveSuccess: false,
        saveError: null,
        validationError: null,
      ),
    );
    try {
      await repository.update(event.request);
      emit(state.copyWith(saving: false, saveSuccess: true));
    } on ValidationException catch (e) {
      emit(state.copyWith(validationError: e.validationError));
    } catch (e) {
      emit(
        state.copyWith(
          saveError: e.toString(),
          saving: false,
          validationError: null,
        ),
      );
    } finally {
      emit(
        state.copyWith(saveError: null, saving: false, validationError: null),
      );
    }
    //  catch (e) {
    //   emit(state.copyWith(saving: false, saveError: e.toString()));
    // }
  }
}
