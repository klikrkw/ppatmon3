import 'package:newklikrkw/models/requests/add_transpermohonan_request.dart';
import 'package:newklikrkw/models/transpermohonan.dart';
import 'package:newklikrkw/models/transpermohonan_model.dart';
import 'package:newklikrkw/models/validation_exception.dart';
import 'package:newklikrkw/services/trans_permohonan_service.dart';

class TranspermohonanRepository {
  final TranspermohonanService service;

  TranspermohonanRepository(this.service);

  Future<List<Transpermohonan>> search(String keyword, int? userId) {
    return service.getPermohonan(keyword, userId);
  }

  Future<List<Transpermohonan>> getData({
    required int offset,
    required int limit,
    String query = '',
    int? userId,
    bool? active,
    String? transpermohonanId,
    bool isTranspermohonanId = false,
  }) {
    return service.getTransPermohonan(
      offset: offset,
      limit: limit,
      query: query,
      active: active,
      userId: userId,
      transpermohonanId: transpermohonanId,
      isTranspermohonanId: isTranspermohonanId,
    );
  }

  Future<void> updateStatusPermohonan({
    required String id,
    required bool active,
  }) {
    return service.updateStatusPermohonan(id: id, active: active);
  }

  Future<void> add(AddTranspermohonanRequest request) async {
    try {
      await service.add(request);
    } on ValidationException {
      rethrow;
    }
  }

  Future<void> update(String id, AddTranspermohonanRequest request) async {
    try {
      await service.update(id, request);
    } on ValidationException {
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    try {
      await service.delete(id);
    } on ValidationException {
      rethrow;
    }
  }

  Future<TranspermohonanModel> detail(String id) async {
    try {
      return await service.detail(id);
    } on ValidationException {
      rethrow;
    }
  }
}
