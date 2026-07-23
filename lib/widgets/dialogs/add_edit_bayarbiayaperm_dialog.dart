import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:newklikrkw/blocs/bayarbiayaperm/bayarbiayaperm_bloc.dart';
import 'package:newklikrkw/blocs/bayarbiayaperm/bayarbiayaperm_event.dart';
import 'package:newklikrkw/blocs/bayarbiayaperm/bayarbiayaperm_state.dart';
import 'package:newklikrkw/models/add_bayarbiayaperm_request.dart';
import 'package:newklikrkw/models/bayarbiayaperm.dart';
import 'package:newklikrkw/models/biayaperm.dart';
import 'package:newklikrkw/models/metodebayar.dart';
import 'package:newklikrkw/models/rekening.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

final currency = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);
final _rupiahFormatter = CurrencyTextInputFormatter.currency(
  locale: 'id_ID',
  symbol: '',
  decimalDigits: 0,
);

double _toDouble(TextEditingController controller) {
  return double.tryParse(
        controller.text.replaceAll(".", "").replaceAll(",", "").trim(),
      ) ??
      0;
}

class AddEditBayarbiayapermDialog extends StatefulWidget {
  final Biayaperm biayaperm;
  final Bayarbiayaperm? bayarbiayaperm;

  const AddEditBayarbiayapermDialog({
    super.key,
    required this.biayaperm,
    this.bayarbiayaperm,
  });

  bool get isEdit => bayarbiayaperm != null;

  @override
  State<AddEditBayarbiayapermDialog> createState() =>
      _AddEditBayarbiayapermDialogState();
}

class _AddEditBayarbiayapermDialogState
    extends State<AddEditBayarbiayapermDialog> {
  final _formKey = GlobalKey<FormState>();

  final _jumlahController = TextEditingController();
  final _saldoAwalController = TextEditingController();
  final _saldoAkhirController = TextEditingController();

  final _catatanController = TextEditingController();

  // DateTime _tanggal = DateTime.now();

  Metodebayar? _selectedMetode;

  Rekening? _selectedRekening;

  XFile? _imageFile;

  String? _imageUrl;

  bool get isEdit => widget.isEdit;

  @override
  void initState() {
    super.initState();

    context.read<BayarbiayapermBloc>().add(const ResetValidationError());

    context.read<BayarbiayapermBloc>().add(const ResetSaveState());

    context.read<BayarbiayapermBloc>().add(const LoadMetodebayars());
    _jumlahController.addListener(_calculateKurangBayar);

    if (isEdit) {
      context.read<BayarbiayapermBloc>().add(
        LoadRekenings(metodebayarId: widget.bayarbiayaperm!.metodebayar.id),
      );
    }

    if (isEdit) {
      final item = widget.bayarbiayaperm!;
      // _tanggal = item.tglBayarbiayaperm;
      _selectedMetode = item.metodebayar;
      _selectedRekening = item.rekening;
      _jumlahController.text = item.jumlahBayar.toStringAsFixed(0);
      _saldoAwalController.text = item.saldoAwal.toStringAsFixed(0);
      _saldoAkhirController.text = item.saldoAkhir.toStringAsFixed(0);
      _catatanController.text = item.catatanBayarbiayaperm;
      _imageUrl = item.imageBayarbiayaperm;
    } else {
      _saldoAwalController.text = NumberFormat.decimalPattern(
        "id",
      ).format(widget.biayaperm.kurangBayar);
      _saldoAkhirController.text = NumberFormat.decimalPattern(
        "id",
      ).format(widget.biayaperm.kurangBayar);
    }

    /// nanti dipakai load dropdown rekening
    /// berdasarkan metode bayar
  }

  @override
  void dispose() {
    _jumlahController.dispose();
    _catatanController.dispose();
    _saldoAwalController.dispose();
    _saldoAkhirController.dispose();

    super.dispose();
  }

  void _calculateKurangBayar() {
    final biaya = _toDouble(_saldoAwalController);
    final bayar = _toDouble(_jumlahController);

    final kurang = biaya - bayar;

    _saldoAkhirController.text = NumberFormat.decimalPattern(
      "id",
    ).format(kurang);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BayarbiayapermBloc, BayarbiayapermState>(
      listenWhen: (previous, current) =>
          previous.saveSuccess != current.saveSuccess ||
          previous.rekenings != current.rekenings,
      listener: (context, state) {
        if (state.saveSuccess) {
          _imageFile = null;

          Navigator.pop(context, true);

          context.read<BayarbiayapermBloc>().add(const ResetSaveState());
        }
        if (_selectedRekening == null) return;
        final rekening = state.rekenings.where(
          (e) => e.id == _selectedRekening!.id,
        );

        if (rekening.isNotEmpty) {
          setState(() {
            _selectedRekening = rekening.first;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEdit ? "Edit Pembayaran" : "Tambah Pembayaran"),
          actions: [
            IconButton(icon: const Icon(Icons.save), onPressed: _submit),
          ],
        ),

        body: BlocBuilder<BayarbiayapermBloc, BayarbiayapermState>(
          builder: (context, state) {
            return Stack(
              children: [
                Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   "Tanggal Pembayaran",
                        //   style: Theme.of(context).textTheme.titleSmall,
                        // ),

                        // const SizedBox(height: 8),

                        // InkWell(
                        //   onTap: _pickTanggal,
                        //   child: InputDecorator(
                        //     decoration: InputDecoration(
                        //       border: const OutlineInputBorder(),
                        //       prefixIcon: const Icon(Icons.calendar_today),
                        //       errorText: _validation(
                        //         state,
                        //         "tgl_bayarbiayaperm",
                        //       ),
                        //     ),
                        //     child: Text(
                        //       DateFormat("dd MMM yyyy HH:mm").format(_tanggal),
                        //     ),
                        //   ),
                        // ),

                        // const SizedBox(height: 20),
                        DropdownButtonFormField<Metodebayar>(
                          initialValue: state.metodebayars.isNotEmpty
                              ? _selectedMetode != null
                                    ? state.metodebayars.firstWhere(
                                        (e) => e.id == _selectedMetode!.id,
                                      )
                                    : state.metodebayars.first
                              : null,
                          decoration: InputDecoration(
                            labelText: "Metode Pembayaran",
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.payments),
                            errorText: _validation(state, "metodebayar_id"),
                          ),
                          items: state.metodebayars
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.namaMetodebayar),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedMetode = value;
                              _selectedRekening = null;
                            });

                            if (value != null) {
                              context.read<BayarbiayapermBloc>().add(
                                LoadRekenings(metodebayarId: value.id),
                              );
                            }
                          },
                        ),

                        const SizedBox(height: 20),
                        DropdownButtonFormField<Rekening>(
                          initialValue: state.rekenings.isNotEmpty
                              ? _selectedRekening != null
                                    ? state.rekenings.firstWhere(
                                        (e) => e.id == _selectedRekening!.id,
                                      )
                                    : state.rekenings.first
                              : null,
                          decoration: InputDecoration(
                            labelText: "Rekening",
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.account_balance),
                            errorText: _validation(state, "rekening_id"),
                          ),
                          items: state.rekenings
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.namaRekening),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedRekening = value;
                            });
                          },
                        ),

                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _saldoAwalController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: "Saldo Awal",
                            prefixText: "Rp ",
                            border: OutlineInputBorder(),
                            filled: true,
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextFormField(
                          controller: _jumlahController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [_rupiahFormatter],
                          decoration: InputDecoration(
                            labelText: "Jumlah Bayar",
                            prefixIcon: const Icon(Icons.attach_money),
                            border: const OutlineInputBorder(),
                            errorText: _validation(state, "jumlah_bayar"),
                          ),
                        ),

                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _saldoAkhirController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: "Saldo Akhir",
                            prefixText: "Rp ",
                            border: OutlineInputBorder(),
                            filled: true,
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextFormField(
                          controller: _catatanController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            labelText: "Catatan",
                            alignLabelWithHint: true,
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.notes),
                            errorText: _validation(
                              state,
                              "catatan_bayarbiayaperm",
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        const Divider(height: 32),

                        Text(
                          "Bukti Pembayaran",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),

                        const SizedBox(height: 12),

                        Center(
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: _imageFile != null
                                  ? Image.file(
                                      File(_imageFile!.path),
                                      fit: BoxFit.cover,
                                    )
                                  : (_imageUrl != null && _imageUrl!.isNotEmpty)
                                  ? Image.network(
                                      _imageUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) =>
                                          const Icon(Icons.image, size: 60),
                                    )
                                  : const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add_a_photo, size: 50),
                                        SizedBox(height: 8),
                                        Text("Pilih Gambar"),
                                      ],
                                    ),
                            ),
                          ),
                        ),

                        if (_validation(state, "image_bayarbiayaperm") != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              _validation(state, "image_bayarbiayaperm")!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),

                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // OutlinedButton.icon(
                            //   onPressed: _pickImage,
                            //   icon: const Icon(Icons.photo_library),
                            //   label: const Text("Pilih"),
                            // ),

                            // const SizedBox(width: 12),
                            if (_imageFile != null ||
                                (_imageUrl != null && _imageUrl!.isNotEmpty))
                              OutlinedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _imageFile = null;
                                    _imageUrl = null;
                                  });
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                label: const Text("Hapus"),
                              ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: FilledButton.icon(
                            onPressed: state.saving ? null : _submit,
                            icon: const Icon(Icons.save),
                            label: Text(
                              isEdit
                                  ? "UPDATE PEMBAYARAN"
                                  : "SIMPAN PEMBAYARAN",
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                if (state.saving)
                  Container(
                    color: Colors.black26,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  String? _validation(BayarbiayapermState state, String field) {
    return state.validationError?.errors[field]?.first;
  }

  // Future<void> _pickTanggal() async {
  //   final date = await showDatePicker(
  //     context: context,
  //     initialDate: _tanggal,
  //     firstDate: DateTime(2020),
  //     lastDate: DateTime(2100),
  //   );

  //   if (date == null) return;

  //   if (!mounted) return;

  //   final time = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.fromDateTime(_tanggal),
  //   );

  //   if (time == null) return;

  //   setState(() {
  //     _tanggal = DateTime(
  //       date.year,
  //       date.month,
  //       date.day,
  //       time.hour,
  //       time.minute,
  //     );
  //   });
  // }

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Kamera"),
                onTap: () {
                  Navigator.pop(context, ImageSource.camera);
                },
              ),

              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Galeri"),
                onTap: () {
                  Navigator.pop(context, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );

    if (source == null) return;

    final file = await picker.pickImage(source: source, imageQuality: 80);

    if (file == null) return;

    setState(() {
      _imageFile = file;
      _imageUrl = null;
    });
  }

  void _submit() {
    FocusScope.of(context).unfocus();

    context.read<BayarbiayapermBloc>().add(const ResetValidationError());

    if (_selectedMetode == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Metode pembayaran belum dipilih.")),
      );
      return;
    }

    if (_selectedRekening == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Rekening belum dipilih.")));
      return;
    }

    // final jumlah = _toDouble(_jumlahController);
    final saldoAwal = _toDouble(_saldoAwalController);
    final saldoAkhir = _toDouble(_saldoAkhirController);

    final request = AddBayarbiayapermRequest(
      biayapermId: widget.biayaperm.id,
      saldoAwal: saldoAwal,
      saldoAkhir: saldoAkhir,
      // tglBayarbiayaperm: _tanggal,
      metodebayarId: _selectedMetode!.id,
      rekeningId: _selectedRekening!.id,
      jumlahBayar: _toDouble(_jumlahController),
      catatanBayarbiayaperm: _catatanController.text.trim(),
      imageFile: _imageFile,
      imageUrl: _imageUrl,
    );

    if (isEdit) {
      context.read<BayarbiayapermBloc>().add(
        UpdateBayarbiayaperm(id: widget.bayarbiayaperm!.id, request: request),
      );
    } else {
      context.read<BayarbiayapermBloc>().add(AddBayarbiayaperm(request));
    }
  }
}
