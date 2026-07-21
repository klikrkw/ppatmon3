import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:newklikrkw/models/db_option.dart';
import 'package:newklikrkw/models/kasbon.dart';
import 'package:newklikrkw/services/kasbon_service.dart';
import 'package:newklikrkw/utils/common_utils.dart';

part 'kasbon_event.dart';
part 'kasbon_state.dart';

class KasbonBloc extends Bloc<KasbonEvent, KasbonState> {
  final KasbonService kasbonService;
  KasbonBloc({required this.kasbonService}) : super(KasbonInitial()) {
    on<NewKasbon>((event, emit) async {
      // final List<DbOption> statusKasbonOptions = await kasbonService
      //     .getStatusKasbonOptions();
      final List<DbOption> instansiOptions = await kasbonService
          .getInstansiOptions();
      final List<String> jenisKabonOptions = kasbonService
          .getJenisKasbonOptions();
      final double totalKasbon = await kasbonService.getTotalKasbon(
        event.userId,
      );
      emit(KasbonNew(jenisKabonOptions, instansiOptions, totalKasbon));
    });
    on<AddKasbon>((event, emit) async {
      try {
        final res = await kasbonService.createKasbon(
          request: event.addKasbonRequest,
        );
        emit(KasbonAddedSuccess(res, 'Kasbon berhasil ditambahkan'));
      } catch (e) {
        emit(KasbonError(e.toString()));
      }
    });
    on<EditKasbon>((event, emit) async {
      final String randomCode = CommonUtils.getRandomString(5);
      final List<DbOption> statusKasbonOptions = await kasbonService
          .getStatusKasbonOptions();
      emit(KasbonEdit(event.kasbon, statusKasbonOptions, randomCode));
    });
    on<RefreshKasbonList>((event, emit) async {
      final String randomCode = CommonUtils.getRandomString(5);
      emit(KasbonRefreshList(randomCode));
    });
  }
}
