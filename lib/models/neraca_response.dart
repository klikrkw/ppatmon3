import 'package:equatable/equatable.dart';
import 'package:newklikrkw/models/neraca.dart';
import 'package:newklikrkw/utils/currency_parser.dart';

class NeracaResponse extends Equatable {
  final List<Neraca> neracas;

  final double totalDebet;

  final double totalKredit;

  const NeracaResponse({
    required this.neracas,
    required this.totalDebet,
    required this.totalKredit,
  });

  factory NeracaResponse.fromJson(Map<String, dynamic> json) {
    final data = json["data"] as Map<String, dynamic>;

    return NeracaResponse(
      neracas: (data["neracas"] as List)
          .map((e) => Neraca.fromJson(e))
          .toList(),

      totalDebet: CurrencyParser.parse(data["totDebet"]),

      totalKredit: CurrencyParser.parse(data["totKredit"]),
    );
  }

  bool get isBalance => totalDebet == totalKredit;

  @override
  List<Object?> get props => [neracas, totalDebet, totalKredit];
}
