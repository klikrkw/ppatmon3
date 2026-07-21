class Statusprosesperm {
  final int id;
  final String namaStatusprosesperm;
  final String imageStatusprosesperm;
  final String? updatedAt;

  Statusprosesperm({
    required this.id,
    required this.namaStatusprosesperm,
    required this.imageStatusprosesperm,
    this.updatedAt,
  });

  factory Statusprosesperm.fromJson(Map<String, dynamic> json) {
    return Statusprosesperm(
      id: json['id'] ?? 0,
      namaStatusprosesperm: json['nama_statusprosesperm'] ?? '',
      imageStatusprosesperm: json['image_statusprosesperm'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}
