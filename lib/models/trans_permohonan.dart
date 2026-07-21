class TransPermohonan {
  final String id;
  final String noDaftar;
  final String tglDaftar;
  final String namaPelepas;
  final String namaPenerima;
  final String jenisPermohonan;
  final String alasHak;
  final String letakObyek;

  TransPermohonan({
    required this.id,
    required this.noDaftar,
    required this.tglDaftar,
    required this.namaPelepas,
    required this.namaPenerima,
    required this.jenisPermohonan,
    required this.alasHak,
    required this.letakObyek,
  });

  factory TransPermohonan.fromJson(Map<String, dynamic> json) {
    return TransPermohonan(
      id: json['id'] ?? '',
      noDaftar: json['no_daftar'] ?? '',
      tglDaftar: json['tgl_daftar'] ?? '',
      namaPelepas: json['nama_pelepas'] ?? '',
      namaPenerima: json['nama_penerima'] ?? '',
      jenisPermohonan: json['jenis_permohonan'] ?? '',
      alasHak: json['alas_hak'] ?? '',
      letakObyek: json['letak_obyek'] ?? '',
    );
  }
}
