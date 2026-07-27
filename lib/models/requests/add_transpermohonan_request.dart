import 'package:newklikrkw/models/jenispermohonan.dart';
import 'package:newklikrkw/models/user.dart';

class AddTranspermohonanRequest {
  final int jenishakId;

  final String nomorHak;

  final String persil;

  final String klas;

  final int bidang;

  final int luasTanah;

  final String atasNama;

  final String namaPelepas;

  final String namaPenerima;

  final String jenisTanah;

  final String desaId;

  final bool active;

  final bool cekBiaya;

  final List<User> users;

  final String periodCekbiaya;

  final DateTime? dateCekbiaya;

  final List<Jenispermohonan> jenispermohonans;
  final Jenispermohonan activeJenispermohonan;

  final String kodeUnik;

  const AddTranspermohonanRequest({
    required this.jenishakId,
    required this.nomorHak,
    required this.persil,
    required this.klas,
    required this.bidang,
    required this.luasTanah,
    required this.atasNama,
    required this.namaPelepas,
    required this.namaPenerima,
    required this.jenisTanah,
    required this.desaId,
    required this.active,
    required this.cekBiaya,
    required this.users,
    required this.periodCekbiaya,
    this.dateCekbiaya,
    required this.jenispermohonans,
    required this.kodeUnik,
    required this.activeJenispermohonan,
  });

  Map<String, dynamic> toJson() {
    return {
      "jenishak_id": jenishakId,
      "nomor_hak": nomorHak,
      "persil": persil,
      "klas": klas,
      "bidang": bidang,
      "luas_tanah": luasTanah,
      "atas_nama": atasNama,
      "nama_pelepas": namaPelepas,
      "nama_penerima": namaPenerima,
      "jenis_tanah": jenisTanah,
      "desa_id": desaId,
      "active": active ? 1 : 0,
      "cek_biaya": cekBiaya ? 1 : 0,
      "period_cekbiaya": periodCekbiaya,
      "date_cekbiaya": dateCekbiaya != null
          ? dateCekbiaya.toString()
          : DateTime.now().toString(),
      "kode_unik": kodeUnik,

      /// hanya kirim id
      "users": users.map((e) => e.id).toList(),

      "jenispermohonans": jenispermohonans.map((e) => e.id).toList(),
      "active_jenispermohonan": activeJenispermohonan.id,
    };
  }
}
