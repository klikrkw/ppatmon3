import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/biayaperm/biayaperm_bloc.dart';
import 'package:newklikrkw/models/biayaperm.dart';
import 'package:newklikrkw/models/rincianbiayaperm.dart';
import 'package:intl/intl.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:newklikrkw/models/add_biayaperm_request.dart';
// import 'package:newklikrkw/widgets/image_upload_widget.dart';

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

final ImagePicker _picker = ImagePicker();

XFile? _pickedImage;

double _parseCurrency(String value) {
  return double.tryParse(
        value
            .replaceAll("Rp", "")
            .replaceAll(".", "")
            .replaceAll(",", "")
            .trim(),
      ) ??
      0;
}

class AddEditBiayapermDialog extends StatefulWidget {
  final Biayaperm? biayaperm;

  /// untuk mode Add
  final String transpermohonanId;

  const AddEditBiayapermDialog({
    super.key,
    this.biayaperm,
    required this.transpermohonanId,
  });

  bool get isEdit => biayaperm != null;

  @override
  State<AddEditBiayapermDialog> createState() => _AddEditBiayapermDialogState();
  static Future<void> show(
    BuildContext context, {
    required String transpermohonanId,
    Biayaperm? biayaperm,
  }) {
    final bloc = context.read<BiayapermBloc>();

    bloc
      ..add(ClearBiayapermForm())
      ..add(LoadRincianBiayaperm(transpermohonanId));

    return Navigator.push<bool>(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: AddEditBiayapermDialog(
            transpermohonanId: transpermohonanId,
            biayaperm: biayaperm,
          ),
        ),
      ),
    );
  }
}

class _AddEditBiayapermDialogState extends State<AddEditBiayapermDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _jumlahBiayaController;

  late final TextEditingController _jumlahKeluarController;
  late final TextEditingController _jumlahBayarController;

  late final TextEditingController _kurangBayarController;

  late final TextEditingController _catatanController;

  Rincianbiayaperm? _selectedRincian;

  String? _imagePath;

  @override
  void initState() {
    super.initState();

    _jumlahBiayaController = TextEditingController();

    _jumlahKeluarController = TextEditingController();
    _jumlahBayarController = TextEditingController();

    _kurangBayarController = TextEditingController();

    _catatanController = TextEditingController();

    // context.read<BiayapermBloc>()
    //   ..add(ClearBiayapermForm())
    //   ..add(ResetValidationError());

    // if (widget.biayaperm != null) {
    //   _fillForm();
    // } else {
    //   _fillFormNew();
    // }

    _jumlahBiayaController.addListener(_calculateKurangBayar);

    _jumlahBayarController.addListener(_calculateKurangBayar);
  }

  @override
  void dispose() {
    _jumlahBiayaController.dispose();

    _jumlahBayarController.dispose();
    _jumlahKeluarController.dispose();

    _kurangBayarController.dispose();

    _catatanController.dispose();

    super.dispose();
  }

  // void _fillForm() {
  //   final item = widget.biayaperm!;

  //   _jumlahBiayaController.text = item.jumlahBiayaperm.toString();

  //   _jumlahBayarController.text = item.jumlahBayar.toString();

  //   _kurangBayarController.text = item.kurangBayar.toString();

  //   _catatanController.text = item.catatanBiayaperm;

  //   _imagePath = item.imageBiayaperm;

  //   context.read<BiayapermBloc>().add(
  //     LoadRincianBiayaperm(item.transpermohonan.id),
  //   );

  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     final bloc = context.read<BiayapermBloc>();
  //     final item = bloc.state.rincianBiayaperms.where(
  //       (e) => e.id == widget.biayaperm!.rincianbiayaperms[0].id,
  //     );

  //     if (item.isNotEmpty) {
  //       setState(() {
  //         _selectedRincian = item.first;
  //       });
  //     }
  //   });
  // }

  void _fillFormNew(Rincianbiayaperm? item) {
    if (item != null) {
      _jumlahBiayaController.text = NumberFormat.decimalPattern(
        "id",
      ).format(item.totalPemasukan);
      _jumlahKeluarController.text = NumberFormat.decimalPattern(
        "id",
      ).format(item.totalPengeluaran);
    }
  }

  void _calculateKurangBayar() {
    final biaya = _toDouble(_jumlahBiayaController);
    final bayar = _toDouble(_jumlahBayarController);

    final kurang = biaya - bayar;

    _kurangBayarController.text = NumberFormat.decimalPattern(
      "id",
    ).format(kurang);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BiayapermBloc, BiayapermState>(
      listenWhen: (previous, current) =>
          previous.saveSuccess != current.saveSuccess,
      listener: (context, state) {
        // TODO: implement listener
        if (state.saveSuccess) {
          setState(() {
            _pickedImage = null;
            _imagePath = null;
          });

          Navigator.pop(context, true);
          context.read<BiayapermBloc>().add(ResetSaveState());
        }

        if (state.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error!)));
        }
      },
      child: BlocBuilder<BiayapermBloc, BiayapermState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.isEdit ? 'Edit Biaya' : 'Tambah Biaya'),
              actions: [
                TextButton.icon(
                  onPressed: state.saving ? null : _submit,
                  icon: const Icon(Icons.save),
                  label: const Text("SIMPAN"),
                ),
              ],
            ),
            body: Stack(
              children: [
                SafeArea(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Bagian 2
                          BlocBuilder<BiayapermBloc, BiayapermState>(
                            builder: (context, state) {
                              final validation = state.validationError?.errors;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Rincian Biaya",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  DropdownButtonFormField<Rincianbiayaperm>(
                                    initialValue: _selectedRincian,

                                    isExpanded: true,

                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),

                                      errorText:
                                          validation?["rincianbiayaperm_id"]
                                              ?.first,
                                    ),

                                    items: state.rincianBiayaperms
                                        .map(
                                          (item) => DropdownMenuItem(
                                            value: item,
                                            child: Text(
                                              item.ketRincianbiayaperm,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        )
                                        .toList(),

                                    onChanged: (value) {
                                      setState(() {
                                        _selectedRincian = value;
                                      });
                                      if (value != null) {
                                        _fillFormNew(value);
                                      }
                                    },

                                    // validator: (_) {
                                    //   if (_selectedRincian == null) {
                                    //     return "Pilih rincian biaya";
                                    //   }
                                    //   return null;
                                    // },
                                  ),

                                  if (_selectedRincian != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons
                                                        .account_balance_wallet,
                                                  ),

                                                  const SizedBox(width: 8),

                                                  Expanded(
                                                    child: Text(
                                                      _selectedRincian!
                                                          .ketRincianbiayaperm,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),

                                                  Chip(
                                                    label: Text(
                                                      _selectedRincian!
                                                          .statusRincianbiayaperm,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              const Divider(),

                                              _buildInfoRow(
                                                "Pemasukan",
                                                currency.format(
                                                  _selectedRincian!
                                                      .totalPemasukan,
                                                ),
                                              ),

                                              _buildInfoRow(
                                                "Pengeluaran",
                                                currency.format(
                                                  _selectedRincian!
                                                      .totalPengeluaran,
                                                ),
                                              ),

                                              _buildInfoRow(
                                                "Piutang",
                                                currency.format(
                                                  _selectedRincian!
                                                      .totalPiutang,
                                                ),
                                              ),

                                              const Divider(),

                                              _buildInfoRow(
                                                "Sisa Saldo",
                                                currency.format(
                                                  _selectedRincian!.sisaSaldo,
                                                ),
                                                valueStyle: TextStyle(
                                                  color:
                                                      _selectedRincian!
                                                              .sisaSaldo <
                                                          0
                                                      ? Colors.red
                                                      : Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 24),
                                  const Text(
                                    "Nominal Pembayaran",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  TextFormField(
                                    controller: _jumlahBiayaController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [_rupiahFormatter],
                                    decoration: InputDecoration(
                                      labelText: "Jumlah Biaya",
                                      prefixText: "Rp ",
                                      border: const OutlineInputBorder(),
                                      errorText: state
                                          .validationError
                                          ?.errors["jumlah_biayaperm"]
                                          ?.first,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Jumlah biaya wajib diisi";
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _jumlahKeluarController,
                                    readOnly: true,
                                    decoration: const InputDecoration(
                                      labelText: "Pengeluaran",
                                      prefixText: "Rp ",
                                      border: OutlineInputBorder(),
                                      filled: true,
                                    ),
                                  ),

                                  const SizedBox(height: 26),

                                  TextFormField(
                                    controller: _jumlahBayarController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [_rupiahFormatter],
                                    decoration: InputDecoration(
                                      labelText: "Jumlah Bayar",
                                      prefixText: "Rp ",
                                      border: const OutlineInputBorder(),
                                      errorText: state
                                          .validationError
                                          ?.errors["jumlah_bayar"]
                                          ?.first,
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  TextFormField(
                                    controller: _kurangBayarController,
                                    readOnly: true,
                                    decoration: const InputDecoration(
                                      labelText: "Kurang Bayar",
                                      prefixText: "Rp ",
                                      border: OutlineInputBorder(),
                                      filled: true,
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  Card(
                                    color: Colors.blue.shade50,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.info_outline,
                                            color: Colors.blue,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              double.tryParse(
                                                        _kurangBayarController
                                                            .text
                                                            .replaceAll(".", "")
                                                            .replaceAll(",", "")
                                                            .trim(),
                                                      ) ==
                                                      0
                                                  ? "Pembayaran sudah lunas."
                                                  : "Masih terdapat kekurangan pembayaran.",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  const Text(
                                    "Catatan",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  TextFormField(
                                    controller: _catatanController,
                                    maxLines: 4,
                                    decoration: InputDecoration(
                                      hintText: "Catatan pembayaran...",
                                      border: const OutlineInputBorder(),
                                      errorText: state
                                          .validationError
                                          ?.errors["catatan_biayaperm"]
                                          ?.first,
                                    ),
                                  ),

                                  const SizedBox(height: 24),

                                  const Text(
                                    "Bukti Pembayaran",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),

                                  const SizedBox(height: 12),
                                  // ImageUploadWidget(
                                  //   onImageReady: (file) async {
                                  //     // debugPrint(file.path);
                                  //     // upload ke API
                                  //     // dio / http multipart
                                  //     // await _api.uploadImage(file);
                                  //     setState(() {
                                  //       _pickedImage = file;
                                  //       _imagePath = null;
                                  //     });
                                  //   },
                                  // ),
                                  // if (state
                                  //         .validationError
                                  //         ?.errors["image_biayaperm"] !=
                                  //     null)
                                  //   Padding(
                                  //     padding: const EdgeInsets.all(12),
                                  //     child: Text(
                                  //       state
                                  //           .validationError!
                                  //           .errors["image_biayaperm"]!
                                  //           .first,
                                  //       style: const TextStyle(
                                  //         color: Colors.red,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // SizedBox(height: 16),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade400,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 16),

                                        if (_pickedImage != null)
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: Image.file(
                                              File(_pickedImage!.path),
                                              height: 220,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        else if ((_imagePath ?? "").isNotEmpty)
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: Image.network(
                                              _imagePath!,
                                              height: 220,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        else
                                          Container(
                                            height: 220,
                                            alignment: Alignment.center,
                                            child: const Icon(
                                              Icons.image,
                                              size: 80,
                                              color: Colors.grey,
                                            ),
                                          ),

                                        const SizedBox(height: 12),

                                        Wrap(
                                          spacing: 8,
                                          children: [
                                            FilledButton.icon(
                                              onPressed: _pickFromCamera,
                                              icon: const Icon(
                                                Icons.camera_alt,
                                              ),
                                              label: const Text("Kamera"),
                                            ),

                                            FilledButton.icon(
                                              onPressed: _pickFromGallery,
                                              icon: const Icon(Icons.photo),
                                              label: const Text("Galeri"),
                                            ),

                                            if (_pickedImage != null ||
                                                (_imagePath ?? "").isNotEmpty)
                                              OutlinedButton.icon(
                                                onPressed: () {
                                                  setState(() {
                                                    _pickedImage = null;
                                                    _imagePath = null;
                                                  });
                                                },
                                                icon: const Icon(Icons.delete),
                                                label: const Text("Hapus"),
                                              ),
                                          ],
                                        ),

                                        if (state
                                                .validationError
                                                ?.errors["image_biayaperm"] !=
                                            null)
                                          Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Text(
                                              state
                                                  .validationError!
                                                  .errors["image_biayaperm"]!
                                                  .first,
                                              style: const TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),

                                        const SizedBox(height: 16),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                ],
                              );
                            },
                          ),

                          // Seluruh Form Input
                          // Dropdown
                          // Validation Error
                          // Currency Field
                        ],
                      ),
                    ),
                  ),
                ),

                if (state.saving)
                  Container(
                    color: Colors.black26,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _submit() {
    FocusScope.of(context).unfocus();

    context.read<BiayapermBloc>().add(ResetValidationError());

    if (!_formKey.currentState!.validate()) {
      return;
    }

    // if (_selectedRincian == null) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text("Silahkan pilih rincian biaya.")),
    //   );
    //   return;
    // }

    final request = AddBiayapermRequest(
      transpermohonanId: widget.isEdit
          ? widget.biayaperm!.transpermohonan.id
          : widget.transpermohonanId,

      rincianbiayapermId: _selectedRincian?.id,

      jumlahBiayaperm: _parseCurrency(_jumlahBiayaController.text),
      jumlahKeluar: _parseCurrency(_jumlahKeluarController.text),

      jumlahBayar: _parseCurrency(_jumlahBayarController.text),

      kurangBayar: _parseCurrency(_kurangBayarController.text),

      catatanBiayaperm: _catatanController.text.trim(),

      imageFile: _pickedImage == null ? null : File(_pickedImage!.path),

      imageUrl: _imagePath,
    );

    final bloc = context.read<BiayapermBloc>();

    if (widget.isEdit) {
      bloc.add(UpdateBiayaperm(id: widget.biayaperm!.id, request: request));
    } else {
      bloc.add(AddBiayaperm(request));
    }
  }

  Widget _buildInfoRow(String title, String value, {TextStyle? valueStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(title)),

          Text(value, style: valueStyle),
        ],
      ),
    );
  }

  Future<void> _pickFromCamera() async {
    final image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (image == null) return;

    setState(() {
      _pickedImage = image;
      _imagePath = null;
    });
  }

  Future<void> _pickFromGallery() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    setState(() {
      _pickedImage = image;
      _imagePath = null;
    });
  }
}
