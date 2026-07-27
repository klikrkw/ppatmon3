import '../models/jenishak.dart';
import '../services/jenishak_service.dart';

class JenishakRepository {
  final JenishakService service;

  const JenishakRepository({required this.service});

  Future<List<Jenishak>> getAll({String query = ""}) {
    return service.getAll(query: query);
  }
}
