part of 'berkas_lokasi_bloc.dart';

abstract class BerkasLokasiEvent {}

class ResetLokasiBerkas extends BerkasLokasiEvent {}

class LoadBerkasLokasi extends BerkasLokasiEvent {
  final String transpermohonanId;

  LoadBerkasLokasi(this.transpermohonanId);
}

class SelectTempatBerkas extends BerkasLokasiEvent {
  final Tempatberkas tempatberkas;

  SelectTempatBerkas(this.tempatberkas);
}

class RefreshBerkasLokasi extends BerkasLokasiEvent {}

class SaveBerkasLokasi extends BerkasLokasiEvent {
  final Tempatberkas tempatberkas;
  SaveBerkasLokasi(this.tempatberkas);
}

class ToggleEditingLokasi extends BerkasLokasiEvent {
  final bool editing;

  ToggleEditingLokasi(this.editing);
}

class UpdatePosisiBerkas extends BerkasLokasiEvent {
  final int row;
  final int col;
  final Tempatberkas tempatberkas;

  UpdatePosisiBerkas({
    required this.row,
    required this.col,
    required this.tempatberkas,
  });
}
