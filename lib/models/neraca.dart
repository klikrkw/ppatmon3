import 'package:equatable/equatable.dart';
import 'package:newklikrkw/utils/currency_parser.dart';

class Neraca extends Equatable {
  final String kodeAkun;
  final String namaAkun;

  final double debet;
  final double kredit;

  const Neraca({
    required this.kodeAkun,
    required this.namaAkun,
    required this.debet,
    required this.kredit,
  });

  factory Neraca.fromJson(Map<String, dynamic> json) {
    return Neraca(
      kodeAkun: json["kode_akun"] ?? "",
      namaAkun: json["nama_akun"] ?? "",
      debet: CurrencyParser.parse(json["debet"]),
      kredit: CurrencyParser.parse(json["kredit"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "kode_akun": kodeAkun,
      "nama_akun": namaAkun,
      "debet": debet,
      "kredit": kredit,
    };
  }

  bool get isDebet => debet > 0;

  bool get isKredit => kredit > 0;

  double get jumlah => isDebet ? debet : kredit;

  @override
  List<Object?> get props => [kodeAkun, namaAkun, debet, kredit];
}
