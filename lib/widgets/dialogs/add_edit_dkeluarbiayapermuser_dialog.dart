import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newklikrkw/blocs/dkeluarbiayapermuser/dkeluarbiayapermuser_bloc.dart';
import 'package:newklikrkw/blocs/dkeluarbiayapermuser/dkeluarbiayapermuser_event.dart';
import 'package:newklikrkw/blocs/dkeluarbiayapermuser/dkeluarbiayapermuser_state.dart';
import 'package:newklikrkw/models/add_dkeluarbiayapermuser_request.dart';
import 'package:newklikrkw/models/dkeluarbiayapermuser.dart';
import 'package:newklikrkw/models/itemkegiatan.dart';
import 'package:newklikrkw/models/transpermohonan.dart';
import 'package:newklikrkw/repositories/transpermohonan_repository.dart';
import 'package:newklikrkw/services/trans_permohonan_service.dart';
import 'package:newklikrkw/widgets/searchable_selection_dialog.dart';
import 'package:newklikrkw/widgets/trans_permohonan_bottom_sheet.dart';
import 'package:newklikrkw/widgets/transpermohonans/card_transpermohonan.dart';

class AddEditDkeluarbiayapermuserDialog extends StatefulWidget {
  final String keluarbiayapermuserId;
  final Dkeluarbiayapermuser? dkeluarbiayapermuser;

  const AddEditDkeluarbiayapermuserDialog({
    super.key,
    required this.keluarbiayapermuserId,
    this.dkeluarbiayapermuser,
  });

  bool get isEdit => dkeluarbiayapermuser != null;

  @override
  State<AddEditDkeluarbiayapermuserDialog> createState() =>
      _AddEditDkeluarbiayapermuserDialogState();
}

class _AddEditDkeluarbiayapermuserDialogState
    extends State<AddEditDkeluarbiayapermuserDialog> {
  late final TranspermohonanRepository repository;

  final _formKey = GlobalKey<FormState>();

  final _jumlahBiayaController = TextEditingController();

  final _ketController = TextEditingController();

  final TextEditingController _transpermohonanController =
      TextEditingController();

  final _currencyFormatter = CurrencyTextInputFormatter.currency(
    locale: 'id',
    decimalDigits: 0,
    symbol: '',
  );

  final ImagePicker _picker = ImagePicker();

  Itemkegiatan? _selectedItemkegiatan;
  Transpermohonan? _selectedTranspermohonan;

  XFile? _imageFile;

  String? _imageUrl;
  final _transpermohonanService = TranspermohonanService();

  @override
  void initState() {
    super.initState();

    repository = TranspermohonanRepository(_transpermohonanService);
    context.read<DkeluarbiayapermuserBloc>().add(const LoadItemkegiatans());

    if (widget.isEdit) {
      final item = widget.dkeluarbiayapermuser!;

      _jumlahBiayaController.text = _currencyFormatter.formatString(
        item.jumlahBiaya.toStringAsFixed(0),
      );

      _ketController.text = item.ketBiaya;

      _selectedItemkegiatan = item.itemkegiatan;

      _imageUrl = item.imageDkeluarbiayapermuser;
    }
  }

  @override
  void dispose() {
    _jumlahBiayaController.dispose();
    _ketController.dispose();
    super.dispose();
  }

  double _parseCurrency(String value) {
    return double.tryParse(value.replaceAll('.', '').replaceAll(',', '')) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DkeluarbiayapermuserBloc, DkeluarbiayapermuserState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state.saveSuccess) {
          Navigator.pop(context, true);
          context.read<DkeluarbiayapermuserBloc>().add(const ResetSaveState());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.isEdit
                ? "Edit Detail Keluar Biaya"
                : "Tambah Detail Keluar Biaya",
          ),
        ),
        body: SafeArea(
          child:
              BlocBuilder<DkeluarbiayapermuserBloc, DkeluarbiayapermuserState>(
                builder: (context, state) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _transpermohonanController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: 'No Daftar',
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.search),
                                      onPressed: cariPermohonan,
                                    ),
                                  ),
                                  validator: (_) {
                                    if (_selectedTranspermohonan == null) {
                                      return "Permohonan wajib dipilih";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 8),
                                if (_selectedTranspermohonan != null)
                                  CardTranspermohonan(
                                    item: _selectedTranspermohonan!,
                                  ),
                                SizedBox(height: 16),
                                if (state.itemkegiatans.isEmpty &&
                                    state.loading)
                                  const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(16),
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                else
                                  TextFormField(
                                    readOnly: true,
                                    controller: TextEditingController(
                                      text:
                                          _selectedItemkegiatan
                                              ?.namaItemkegiatan ??
                                          "",
                                    ),
                                    decoration: InputDecoration(
                                      labelText: "Item Kegiatan",
                                      border: const OutlineInputBorder(),
                                      prefixIcon: const Icon(Icons.category),
                                      suffixIcon: const Icon(Icons.search),
                                      errorText: state.errorText(
                                        "itemkegiatan_id",
                                      ),
                                    ),
                                    onTap: () async {
                                      final result =
                                          await Navigator.push<Itemkegiatan>(
                                            context,
                                            MaterialPageRoute(
                                              fullscreenDialog: true,
                                              builder: (_) =>
                                                  SearchableSelectionDialog<
                                                    Itemkegiatan
                                                  >(
                                                    title:
                                                        "Pilih Item Kegiatan",
                                                    searchHint:
                                                        "Cari item kegiatan...",
                                                    items: state.itemkegiatans,
                                                    selectedItem:
                                                        _selectedItemkegiatan,
                                                    itemLabelBuilder: (item) =>
                                                        item.namaItemkegiatan,
                                                  ),
                                            ),
                                          );

                                      if (!mounted || result == null) return;

                                      setState(() {
                                        _selectedItemkegiatan = result;
                                      });

                                      context
                                          .read<DkeluarbiayapermuserBloc>()
                                          .add(const ResetValidationError());
                                    },
                                    validator: (_) {
                                      if (_selectedItemkegiatan == null) {
                                        return "Item kegiatan wajib dipilih";
                                      }
                                      return null;
                                    },
                                  ),
                                const SizedBox(height: 16),

                                TextFormField(
                                  controller: _jumlahBiayaController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [_currencyFormatter],
                                  decoration: InputDecoration(
                                    labelText: "Jumlah Biaya",
                                    prefixText: "Rp ",
                                    prefixIcon: const Icon(Icons.payments),
                                    border: const OutlineInputBorder(),
                                    errorText: state.errorText("jumlah_biaya"),
                                  ),
                                  validator: (value) {
                                    final nominal = _parseCurrency(value ?? "");

                                    if (nominal <= 0) {
                                      return "Jumlah biaya harus diisi";
                                    }

                                    return null;
                                  },
                                  onChanged: (_) {
                                    context
                                        .read<DkeluarbiayapermuserBloc>()
                                        .add(const ResetValidationError());
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _ketController,
                                  minLines: 3,
                                  maxLines: 5,
                                  decoration: InputDecoration(
                                    labelText: "Keterangan",
                                    alignLabelWithHint: true,
                                    prefixIcon: const Padding(
                                      padding: EdgeInsets.only(bottom: 60),
                                      child: Icon(Icons.notes),
                                    ),
                                    border: const OutlineInputBorder(),
                                    errorText: state.errorText("ket_biaya"),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return "Keterangan wajib diisi";
                                    }

                                    return null;
                                  },
                                  onChanged: (_) {
                                    context
                                        .read<DkeluarbiayapermuserBloc>()
                                        .add(const ResetValidationError());
                                  },
                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Foto Bukti",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),

                                    const SizedBox(height: 12),

                                    Center(
                                      child: GestureDetector(
                                        onTap: _showImagePicker,
                                        child: Container(
                                          width: 180,
                                          height: 180,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey.shade400,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          child: _buildImagePreview(),
                                        ),
                                      ),
                                    ),

                                    if (state.errorText("image") != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          state.errorText("image")!,
                                          style: const TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),

                                    const SizedBox(height: 12),

                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton.icon(
                                            onPressed: () =>
                                                _pickImage(ImageSource.camera),
                                            icon: const Icon(Icons.camera_alt),
                                            label: const Text("Kamera"),
                                          ),
                                        ),

                                        const SizedBox(width: 12),

                                        Expanded(
                                          child: OutlinedButton.icon(
                                            onPressed: () =>
                                                _pickImage(ImageSource.gallery),
                                            icon: const Icon(Icons.photo),
                                            label: const Text("Galeri"),
                                          ),
                                        ),
                                      ],
                                    ),

                                    if (_imageFile != null || _imageUrl != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 12),
                                        child: Center(
                                          child: TextButton.icon(
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
                                            label: const Text(
                                              "Hapus Gambar",
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: state.saving ? null : _submit,
                            icon: state.saving
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.save),
                            label: Text(
                              state.saving ? "Menyimpan..." : "Simpan",
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final file = await _picker.pickImage(source: source, imageQuality: 70);

    if (file == null) return;

    setState(() {
      _imageFile = file;

      _imageUrl = null;
    });

    if (mounted) {
      context.read<DkeluarbiayapermuserBloc>().add(
        const ResetValidationError(),
      );
    }
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Kamera"),
                onTap: () {
                  Navigator.pop(context);

                  _pickImage(ImageSource.camera);
                },
              ),

              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Galeri"),
                onTap: () {
                  Navigator.pop(context);

                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImagePreview() {
    if (_imageFile != null) {
      return Image.file(File(_imageFile!.path), fit: BoxFit.cover);
    }

    if (_imageUrl != null && _imageUrl!.isNotEmpty) {
      return Image.network(
        _imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const Icon(Icons.broken_image, size: 60),
      );
    }

    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_a_photo, size: 60),

          SizedBox(height: 8),

          Text("Pilih Foto"),
        ],
      ),
    );
  }

  void _submit() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedTranspermohonan == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Permohonan wajib dipilih")));
      return;
    }

    if (_selectedItemkegiatan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Item kegiatan wajib dipilih")),
      );
      return;
    }

    final request = AddDKeluarbiayapermuserRequest(
      transpermohonanId: _selectedTranspermohonan!.id,
      keluarbiayapermuserId: widget.keluarbiayapermuserId,
      itemkegiatanId: _selectedItemkegiatan!.id,
      jumlahBiaya: _parseCurrency(_jumlahBiayaController.text),
      ketBiaya: _ketController.text.trim(),
      image: _imageFile,
    );

    if (widget.isEdit) {
      context.read<DkeluarbiayapermuserBloc>().add(
        UpdateDkeluarbiayapermuser(
          id: widget.dkeluarbiayapermuser!.id,
          request: request,
        ),
      );
    } else {
      context.read<DkeluarbiayapermuserBloc>().add(
        AddDkeluarbiayapermuser(
          request,
          keluarbiayapermuserId: widget.keluarbiayapermuserId,
        ),
      );
    }
  }

  Future<void> cariPermohonan() async {
    print('cari permohonan');
    final result = await showTranspermohonanBottomSheet(context, repository);
    if (result != null) {
      setState(() {
        _transpermohonanController.text = result.id;
        _selectedTranspermohonan = result;
      });
    }
  }
}
