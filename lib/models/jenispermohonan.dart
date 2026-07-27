class Jenispermohonan {
  final int id;
  final String namaJenispermohonan;
  final String transpermohonanId;
  final bool active;

  const Jenispermohonan({
    required this.id,
    required this.namaJenispermohonan,
    required this.transpermohonanId,
    required this.active,
  });

  Jenispermohonan copyWith({
    int? id,
    String? namaJenispermohonan,
    String? transpermohonanId,
    bool? active,
  }) => Jenispermohonan(
    id: id ?? this.id,
    namaJenispermohonan: namaJenispermohonan ?? this.namaJenispermohonan,
    transpermohonanId: transpermohonanId ?? this.transpermohonanId,
    active: active ?? this.active,
  );

  factory Jenispermohonan.fromJson(Map<String, dynamic> json) {
    return Jenispermohonan(
      id: json["id"],
      namaJenispermohonan: json["nama_jenispermohonan"] ?? "",
      transpermohonanId: json["transpermohonan_id"] ?? "",
      active: json["active"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "nama_jenispermohonan": namaJenispermohonan,
    "transpermohonan_id": transpermohonanId,
    "active": active,
  };

  @override
  String toString() => namaJenispermohonan;

  static List<Jenispermohonan> fromJsonList(List<dynamic> json) =>
      json.map((e) => Jenispermohonan.fromJson(e)).toList();
}
