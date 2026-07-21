import 'package:newklikrkw/models/posisiberkas.dart';
import 'package:newklikrkw/models/tempatberkas.dart';
import 'package:newklikrkw/models/transpermohonan.dart';

class BerkasLokasiResponse {
  final Transpermohonan transpermohonan;
  final Posisiberkas? posisiberkas;
  final Tempatberkas? tempatberkas;
  // final List<Tempatberkas> tempatberkases;

  const BerkasLokasiResponse({
    required this.transpermohonan,
    required this.posisiberkas,
    required this.tempatberkas,
    // required this.tempatberkases,
  });

  factory BerkasLokasiResponse.fromJson(Map<String, dynamic> json) {
    final data = json;

    return BerkasLokasiResponse(
      transpermohonan: Transpermohonan.fromJson(data['transpermohonan']),

      posisiberkas: data['posisiberkas'] == null
          ? null
          : Posisiberkas.fromJson(data['posisiberkas']),

      tempatberkas: data['tempatberkas'] == null
          ? null
          : Tempatberkas.fromJson(data['tempatberkas']),

      // tempatberkases: (data['tempatberkases'] as List)
      //     .map((e) => Tempatberkas.fromJson(e))
      //     .toList(),
    );
  }
}
