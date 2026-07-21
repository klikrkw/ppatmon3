import 'package:newklikrkw/models/itememprosesperm.dart';
import 'package:newklikrkw/models/statusprosesperm.dart';
import 'package:newklikrkw/models/transpermohonan.dart';
import 'package:newklikrkw/models/user.dart';

class Prosespermohonan {
  final String id;
  final Transpermohonan transpermohonan;
  final User user;
  final Itemprosesperm itemprosesperm;
  final String catatanProsesperm;
  final bool active;
  final bool isAlert;
  final DateTime? start;
  final DateTime? end;
  final List<Statusprosesperm> statusprosesperms;

  Prosespermohonan({
    required this.id,
    required this.transpermohonan,
    required this.user,
    required this.itemprosesperm,
    required this.catatanProsesperm,
    required this.active,
    required this.isAlert,
    required this.start,
    required this.end,
    this.statusprosesperms = const [],
  });

  factory Prosespermohonan.fromJson(Map<String, dynamic> json) {
    return Prosespermohonan(
      id: json['id'],
      transpermohonan: Transpermohonan.fromJson(json['transpermohonan']),
      user: User.fromJson(json['user']),
      itemprosesperm: Itemprosesperm.fromJson(json['itemprosesperm']),
      catatanProsesperm: json['catatan_prosesperm'] ?? '',
      active: json['active'] ?? false,
      isAlert: json['is_alert'] ?? false,
      start: json['start'] != null ? DateTime.parse(json['start']) : null,
      end: json['end'] != null ? DateTime.parse(json['end']) : null,
      statusprosesperms:
          (json['statusprosesperms'] as List?)
              ?.map((e) => Statusprosesperm.fromJson(e))
              .toList() ??
          [],
    );
  }
}
