import 'package:newklikrkw/models/fieldcatatan.dart';
import 'package:newklikrkw/models/user.dart';

class Catatanperm {
  final int id;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  final Fieldcatatan? fieldcatatan;
  final String isiCatatanperm;
  final String transpermohonanId;
  final String imageCatatanperm;

  final User? user;

  const Catatanperm({
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.fieldcatatan,
    required this.isiCatatanperm,
    required this.imageCatatanperm,
    this.user,
    required this.transpermohonanId,
  });

  factory Catatanperm.fromJson(Map<String, dynamic> json) {
    return Catatanperm(
      id: json['id'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      fieldcatatan: json['fieldcatatan'] != null
          ? Fieldcatatan.fromJson(json['fieldcatatan'])
          : null,
      isiCatatanperm: json['isi_catatanperm'] ?? '',
      imageCatatanperm: json['image_catatanperm'] ?? '',
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      transpermohonanId: json['transpermohonan_id'] ?? '',
    );
  }
  bool get hasImage => imageCatatanperm.isNotEmpty;
}
