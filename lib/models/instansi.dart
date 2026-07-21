// id, nama_instansi
class Instansi {
  final int id;
  final String namaInstansi;

  Instansi({required this.id, required this.namaInstansi});

  factory Instansi.fromJson(Map<String, dynamic> json) {
    return Instansi(id: json['id'], namaInstansi: json['nama_instansi']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'nama_instansi': namaInstansi};
}
