import '../models/jenispermohonan.dart';
import '../services/jenispermohonan_service.dart';

class JenispermohonanRepository {
  final JenispermohonanService service;

  const JenispermohonanRepository({required this.service});

  Future<List<Jenispermohonan>> getAll({String query = ""}) {
    return service.getAll(query: query);
  }
}
