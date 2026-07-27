import 'package:newklikrkw/models/desa.dart';
import 'package:newklikrkw/services/desa_service.dart';

class DesaRepository {
  final DesaService service;

  const DesaRepository({required this.service});

  Future<List<Desa>> getDesas({String? query}) {
    
    return service.getDesas(query: query);
  }
}
