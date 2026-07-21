import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:newklikrkw/blocs/postingjurnal/postingjurnal_bloc.dart';
import 'package:newklikrkw/blocs/postingjurnal/postingjurnal_event.dart';
import 'package:newklikrkw/blocs/postingjurnal/postingjurnal_state.dart';
import 'package:newklikrkw/models/akun.dart';

import 'package:newklikrkw/models/postingjurnal.dart';
import 'package:newklikrkw/models/requests/add_postingjurnal_request.dart';
import 'package:newklikrkw/models/requests/update_postingjurnal_request.dart';
import 'package:newklikrkw/utils/dio.dart';

import 'package:newklikrkw/widgets/image_upload_widget.dart';
import 'package:newklikrkw/widgets/searchable_selection_dialog.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class AddEditPostingjurnalDialog extends StatefulWidget {
  final Postingjurnal? existingData;

  const AddEditPostingjurnalDialog({super.key, this.existingData});

  bool get isEdit => existingData != null;

  @override
  State<AddEditPostingjurnalDialog> createState() =>
      _AddEditPostingjurnalDialogState();
}

class _AddEditPostingjurnalDialogState
    extends State<AddEditPostingjurnalDialog> {
  final _formKey = GlobalKey<FormState>();

  //------------------------------------------
  // Controller
  //------------------------------------------

  late final TextEditingController _uraianController;

  late final TextEditingController _jumlahController;
  double get jumlahValue {
    final value = toNumericString(_jumlahController.text);

    return double.tryParse(value) ?? 0;
  }

  bool get hasNewImage {
    return _imageFile != null;
  }

  bool get hasOldImage {
    return _oldImage != null && _oldImage!.isNotEmpty;
  }

  bool get hasImage {
    return hasNewImage || hasOldImage;
  }
  //------------------------------------------
  // Selected Data
  //------------------------------------------

  Akun? _selectedAkunDebet;

  Akun? _selectedAkunKredit;

  //------------------------------------------
  // Image
  //------------------------------------------

  File? _imageFile;

  String? _oldImage;
  // bool _saving = false;

  //------------------------------------------
  // Loading
  //------------------------------------------

  // late bool _saving = false;

  @override
  void initState() {
    super.initState();
    _uraianController = TextEditingController(
      text: widget.existingData?.uraian ?? "",
    );

    _jumlahController = TextEditingController(
      text: widget.existingData == null
          ? ""
          : widget.existingData!.jumlah.toStringAsFixed(0),
    );

    _oldImage = "$myBaseUrl${widget.existingData?.image}";

    final akunState = context.read<PostingjurnalBloc>().state;

    if (widget.existingData != null) {
      if (akunState.akuns.isNotEmpty) {
        _selectedAkunDebet = akunState.akuns.firstWhere(
          (element) => element.id == widget.existingData!.akunDebet,
        );
        _selectedAkunKredit = akunState.akuns.firstWhere(
          (element) => element.id == widget.existingData!.akunKredit,
        );
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostingjurnalBloc>().add(const LoadAkuns());
    });
  }

  @override
  void dispose() {
    _uraianController.dispose();
    _jumlahController.dispose();

    super.dispose();
  }

  bool get isEdit => widget.isEdit;

  PostingjurnalBloc get bloc => context.read<PostingjurnalBloc>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostingjurnalBloc, PostingjurnalState>(
      listenWhen: (previous, current) {
        return previous.saveSuccess != current.saveSuccess ||
            previous.validationError != current.validationError ||
            previous.errorMessage != current.errorMessage ||
            previous.saving != current.saving;
      },

      listener: (context, state) {
        // _saving = state.saving;

        if (state.saveSuccess) {
          Navigator.of(context).pop(true);

          context.read<PostingjurnalBloc>().add(const ResetSaveState());
        }

        if (state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },

      builder: (context, state) {
        return Stack(
          children: [
            AlertDialog(
              insetPadding: const EdgeInsets.all(16),

              title: Text(
                isEdit ? "Edit Posting Jurnal" : "Tambah Posting Jurnal",
              ),

              content: SizedBox(
                width: 650,

                child: Form(
                  key: _formKey,

                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //-------------------------------------------------
                        // Bagian 3
                        // Akun Debet
                        //-------------------------------------------------
                        BlocBuilder<PostingjurnalBloc, PostingjurnalState>(
                          buildWhen: (previous, current) =>
                              previous.akuns != current.akuns ||
                              previous.validationError !=
                                  current.validationError,
                          builder: (context, state) {
                            return TextFormField(
                              readOnly: true,
                              controller: TextEditingController(
                                text: _selectedAkunDebet == null
                                    ? ""
                                    : "${_selectedAkunDebet!.kodeAkun} - ${_selectedAkunDebet!.namaAkun}",
                              ),
                              decoration: InputDecoration(
                                labelText: "Akun Debet",
                                prefixIcon: const Icon(
                                  Icons.account_balance_wallet,
                                ),
                                suffixIcon: const Icon(Icons.search),
                                border: const OutlineInputBorder(),
                                errorText: state.validationError?.firstError(
                                  "akun_debet",
                                ),
                              ),
                              validator: (_) {
                                if (_selectedAkunDebet == null) {
                                  return "Akun Debet wajib dipilih";
                                }
                                return null;
                              },
                              onTap: () async {
                                FocusScope.of(context).unfocus();

                                final result =
                                    await SearchableSelectionDialog.show<Akun>(
                                      context: context,
                                      title: "Pilih Akun Debet",
                                      items: state.akuns,
                                      // itemAsString: (item) =>
                                      //     "${item.kodeAkun} - ${item.namaAkun}",
                                      itemLabelBuilder: (item) => item.namaAkun,

                                      itemSubtitleBuilder: (item) =>
                                          "${item.kodeAkun} ",
                                      searchHint: "Cari akun...",
                                    );

                                if (!mounted || result == null) return;

                                setState(() {
                                  _selectedAkunDebet = result;
                                });

                                bloc.add(const ResetValidationError());
                              },
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        //-------------------------------------------------
                        // Bagian 4
                        // Akun Kredit
                        //-------------------------------------------------
                        BlocBuilder<PostingjurnalBloc, PostingjurnalState>(
                          buildWhen: (previous, current) =>
                              previous.akuns != current.akuns ||
                              previous.validationError !=
                                  current.validationError,
                          builder: (context, state) {
                            return TextFormField(
                              readOnly: true,

                              controller: TextEditingController(
                                text: _selectedAkunKredit == null
                                    ? ""
                                    : "${_selectedAkunKredit!.kodeAkun} - "
                                          "${_selectedAkunKredit!.namaAkun}",
                              ),

                              decoration: InputDecoration(
                                labelText: "Akun Kredit",
                                prefixIcon: const Icon(Icons.account_balance),

                                suffixIcon: const Icon(Icons.search),

                                border: const OutlineInputBorder(),

                                errorText: state.validationError?.firstError(
                                  "akun_kredit",
                                ),
                              ),

                              validator: (_) {
                                if (_selectedAkunKredit == null) {
                                  return "Akun Kredit wajib dipilih";
                                }

                                if (_selectedAkunDebet != null &&
                                    _selectedAkunDebet!.id ==
                                        _selectedAkunKredit!.id) {
                                  return "Akun Debet dan Kredit tidak boleh sama";
                                }

                                return null;
                              },

                              onTap: () async {
                                FocusScope.of(context).unfocus();

                                final result =
                                    await SearchableSelectionDialog.show<Akun>(
                                      context: context,

                                      title: "Pilih Akun Kredit",

                                      items: state.akuns,

                                      // itemAsString: (item) =>
                                      //     "${item.kodeAkun} - ${item.namaAkun}",
                                      itemLabelBuilder: (item) => item.namaAkun,

                                      itemSubtitleBuilder: (item) =>
                                          "${item.kodeAkun} ",
                                      searchHint: "Cari akun...",
                                    );

                                if (!mounted || result == null) {
                                  return;
                                }

                                setState(() {
                                  _selectedAkunKredit = result;
                                });

                                bloc.add(const ResetValidationError());
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        //-------------------------------------------------
                        // Bagian 5
                        // Uraian
                        //-------------------------------------------------
                        BlocBuilder<PostingjurnalBloc, PostingjurnalState>(
                          buildWhen: (previous, current) =>
                              previous.validationError !=
                              current.validationError,
                          builder: (context, state) {
                            return TextFormField(
                              controller: _uraianController,
                              textCapitalization: TextCapitalization.sentences,
                              minLines: 2,
                              maxLines: 4,
                              decoration: InputDecoration(
                                labelText: "Uraian",
                                hintText: "Masukkan uraian posting jurnal",
                                prefixIcon: const Icon(Icons.description),
                                border: const OutlineInputBorder(),
                                errorText: state.validationError?.firstError(
                                  "uraian",
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Uraian wajib diisi";
                                }
                                return null;
                              },
                              onChanged: (_) {
                                bloc.add(const ResetValidationError());
                              },
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        //-------------------------------------------------
                        // Bagian 5B
                        // Jumlah
                        //-------------------------------------------------
                        BlocBuilder<PostingjurnalBloc, PostingjurnalState>(
                          buildWhen: (previous, current) =>
                              previous.validationError !=
                              current.validationError,
                          builder: (context, state) {
                            return TextFormField(
                              controller: _jumlahController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              inputFormatters: [
                                CurrencyInputFormatter(
                                  thousandSeparator: ThousandSeparator.Period,
                                  mantissaLength: 0,
                                  leadingSymbol: "Rp ",
                                ),
                              ],
                              decoration: InputDecoration(
                                labelText: "Jumlah",
                                prefixIcon: const Icon(Icons.payments),
                                border: const OutlineInputBorder(),
                                errorText: state.validationError?.firstError(
                                  "jumlah",
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Jumlah wajib diisi";
                                }

                                final amount = toNumericString(value);

                                if (double.tryParse(amount) == null) {
                                  return "Jumlah tidak valid";
                                }

                                if (double.parse(amount) <= 0) {
                                  return "Jumlah harus lebih dari 0";
                                }

                                return null;
                              },
                              onChanged: (_) {
                                bloc.add(const ResetValidationError());
                              },
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        //-------------------------------------------------
                        // Bagian 6
                        // Upload Image
                        //-------------------------------------------------
                        BlocBuilder<PostingjurnalBloc, PostingjurnalState>(
                          buildWhen: (previous, current) =>
                              previous.validationError !=
                              current.validationError,
                          builder: (context, state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Lampiran",
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),

                                const SizedBox(height: 8),

                                ImageUploadWidget(
                                  imageFile: _imageFile,

                                  imageUrl: _oldImage,

                                  folderName: "postingjurnal",

                                  maxSizeInMB: 1,

                                  onChanged: (file) {
                                    setState(() {
                                      _imageFile = file;
                                    });

                                    bloc.add(const ResetValidationError());
                                  },

                                  onRemove: () {
                                    setState(() {
                                      _imageFile = null;
                                      _oldImage = null;
                                    });

                                    bloc.add(const ResetValidationError());
                                  },
                                ),

                                if (state.validationError?.firstError(
                                      "image",
                                    ) !=
                                    null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      state.validationError!.firstError(
                                        "image",
                                      )!,
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.error,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              actions: [
                TextButton(
                  onPressed: state.saving
                      ? null
                      : () {
                          Navigator.pop(context);
                        },
                  child: const Text("Batal"),
                ),

                FilledButton.icon(
                  onPressed: state.saving ? null : _submit,

                  icon: const Icon(Icons.save),

                  label: Text(isEdit ? "Update" : "Simpan"),
                ),
              ],
            ),

            //----------------------------------------------------
            // Loading Overlay
            //----------------------------------------------------
            if (state.saving)
              Positioned.fill(
                child: Container(
                  color: Colors.black26,

                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        );
      },
    );
  }

  void _submit() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedAkunDebet == null) {
      return;
    }

    if (_selectedAkunKredit == null) {
      return;
    }

    final jumlah = jumlahValue;

    if (isEdit) {
      bloc.add(
        UpdatePostingjurnal(
          widget.existingData!.id,

          UpdatePostingjurnalRequest(
            uraian: _uraianController.text.trim(),

            akunDebet: _selectedAkunDebet!.id,

            akunKredit: _selectedAkunKredit!.id,

            jumlah: jumlah,

            imageFile: _imageFile,
          ),
        ),
      );
    } else {
      bloc.add(
        AddPostingjurnal(
          AddPostingjurnalRequest(
            uraian: _uraianController.text.trim(),

            akunDebet: _selectedAkunDebet!.id,

            akunKredit: _selectedAkunKredit!.id,

            jumlah: jumlah,

            imageFile: _imageFile,
          ),
        ),
      );
    }
  }
}
