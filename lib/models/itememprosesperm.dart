class Itemprosesperm {
  final int id;
  final String namaItemprosesperm;

  Itemprosesperm({required this.id, required this.namaItemprosesperm});

  factory Itemprosesperm.fromJson(Map<String, dynamic> json) {
    return Itemprosesperm(
      id: json['id'],
      namaItemprosesperm: json['nama_itemprosesperm'] ?? '',
    );
  }
}
