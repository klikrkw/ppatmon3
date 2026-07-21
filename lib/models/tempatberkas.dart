import 'package:newklikrkw/models/jenistempatarsip.dart';
import 'package:newklikrkw/models/ruang.dart';

class Tempatberkas {
  final int id;

  final Ruang ruang;

  final Jenistempatarsip jenistempatarsip;

  final String namaTempatberkas;

  final int rowCount;

  final int colCount;

  final String imageTempatberkas;

  const Tempatberkas({
    required this.id,
    required this.ruang,
    required this.jenistempatarsip,
    required this.namaTempatberkas,
    required this.rowCount,
    required this.colCount,
    required this.imageTempatberkas,
  });

  factory Tempatberkas.fromJson(Map<String, dynamic> json) {
    return Tempatberkas(
      id: json['id'] ?? 0,

      ruang: Ruang.fromJson(json['ruang'] ?? {}),

      jenistempatarsip: Jenistempatarsip.fromJson(
        json['jenistempatarsip'] ?? {},
      ),

      namaTempatberkas: json['nama_tempatberkas'] ?? '',

      rowCount: json['row_count'] ?? 0,

      colCount: json['col_count'] ?? 0,

      imageTempatberkas: json['image_tempatberkas'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'ruang': ruang.toJson(),

      'jenistempatarsip': jenistempatarsip.toJson(),

      'nama_tempatberkas': namaTempatberkas,

      'row_count': rowCount,

      'col_count': colCount,

      'image_tempatberkas': imageTempatberkas,
    };
  }
}
