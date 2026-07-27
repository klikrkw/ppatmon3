class Jenishak {
  final int id;
  final String namaJenishak;

  const Jenishak({required this.id, required this.namaJenishak});

  factory Jenishak.fromJson(Map<String, dynamic> json) {
    return Jenishak(id: json["id"], namaJenishak: json["nama_jenishak"] ?? "");
  }

  Map<String, dynamic> toJson() => {"id": id, "nama_jenishak": namaJenishak};

  @override
  String toString() => namaJenishak;
}
