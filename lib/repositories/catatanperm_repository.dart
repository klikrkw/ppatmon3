import 'dart:async';

import 'package:newklikrkw/models/catatanperm.dart';
import 'package:newklikrkw/models/catatanperm_response.dart';
import 'package:newklikrkw/models/fieldcatatan.dart';
import 'package:newklikrkw/models/requests/add_edit_catatanperm_request.dart';
import 'package:newklikrkw/services/catatanperm_service.dart';

class CatatanpermRepository {
  final CatatanpermService service;

  CatatanpermRepository({required this.service});

  Future<CatatanpermResponse> getCatatanperms({
    String? transpermohonanId,
    int offset = 0,
    int limit = 20,
    int? fieldcatatanId,
    String? keyword,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return service.getCatatanperms(
      transpermohonanId: transpermohonanId,
      offset: offset,
      limit: limit,
      fieldcatatanId: fieldcatatanId,
      keyword: keyword,
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<List<Fieldcatatan>> getFieldcatatans() async {
    return service.getFieldcatatans();
  }

  Future<void> add(AddEditCatatanpermRequest request) {
    return service.add(request);
  }

  Future<Catatanperm> update(int id, AddEditCatatanpermRequest request) {
    return service.update(id, request);
  }

  Future<void> delete(int id) {
    return service.delete(id);
  }
}
