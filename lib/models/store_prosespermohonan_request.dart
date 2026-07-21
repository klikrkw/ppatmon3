class StoreProsespermohonanrequest {
  final String? id;
  final String transpermohonanId;
  final int statusprosespermId;
  final int itemprosespermId;
  final String catatanProsesperm;
  final int userId;
  final bool isAlert;
  final DateTime? start;
  final DateTime? end;

  StoreProsespermohonanrequest({
    this.id,
    required this.transpermohonanId,
    required this.statusprosespermId,
    required this.itemprosespermId,
    required this.catatanProsesperm,
    required this.userId,
    required this.isAlert,
    this.start,
    this.end,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "transpermohonan_id": transpermohonanId,
      "statusprosesperm_id": statusprosespermId,
      "itemprosesperm_id": itemprosespermId,
      "catatan_prosesperm": catatanProsesperm,
      "user_id": userId,
      "is_alert": isAlert,
      "start": start?.toIso8601String(),
      "end": end?.toIso8601String(),
    };
  }
}
