import 'package:newklikrkw/models/neraca_response.dart';
import 'package:newklikrkw/services/neraca_service.dart';

class NeracaRepository {
  final NeracaService service;

  const NeracaRepository({required this.service});

  Future<NeracaResponse> getNeraca({required int year}) {
    return service.getNeraca(year: year);
  }

  Future<NeracaResponse> getNeracaPermohonan({
    required String transpermohonanId,
  }) {
    return service.getNeracaPermohonan(transpermohonanId: transpermohonanId);
  }
}
