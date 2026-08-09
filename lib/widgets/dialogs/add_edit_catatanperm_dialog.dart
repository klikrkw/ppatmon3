import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/auth/auth.dart';
import 'package:newklikrkw/blocs/catatanperm/catatanperm_bloc.dart';
import 'package:newklikrkw/blocs/catatanperm/catatanperm_event.dart';
import 'package:newklikrkw/blocs/catatanperm/catatanperm_state.dart';

import 'package:newklikrkw/models/requests/add_edit_catatanperm_request.dart';
import 'package:newklikrkw/models/catatanperm.dart';
import 'package:newklikrkw/models/fieldcatatan.dart';
import 'package:newklikrkw/utils/dio.dart';

import 'package:newklikrkw/widgets/image_upload_widget.dart';
import 'package:newklikrkw/widgets/searchable_selection_dialog.dart';

class AddEditCatatanpermDialog extends StatefulWidget {
  final String transpermohonanId;
  final Catatanperm? catatanperm;

  const AddEditCatatanpermDialog({
    super.key,
    required this.transpermohonanId,
    this.catatanperm,
  });

  bool get isEdit => catatanperm != null;

  @override
  State<AddEditCatatanpermDialog> createState() =>
      _AddEditCatatanpermDialogState();
}

class _AddEditCatatanpermDialogState extends State<AddEditCatatanpermDialog> {
  final _formKey = GlobalKey<FormState>();

  final _isiCatatanController = TextEditingController();

  Fieldcatatan? _selectedFieldcatatan;

  File? _imageFile;

  String? _oldImage;
  int userId = 0;

  @override
  void initState() {
    super.initState();

    final item = widget.catatanperm;
    final userState = context.read<AuthBloc>().state;
    if (userState is Authenticated) {
      userId = userState.user.id;
    }

    if (item != null) {
      _isiCatatanController.text = item.isiCatatanperm;

      _selectedFieldcatatan = item.fieldcatatan;

      _oldImage = '$myBaseUrl${item.imageCatatanperm}';
    }

    // Bersihkan validation error yang mungkin tertinggal
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<CatatanpermBloc>().add(const LoadFieldcatatans());
      context.read<CatatanpermBloc>().add(
        const ResetCatatanpermValidationError(),
      );
    });
  }

  @override
  void dispose() {
    _isiCatatanController.dispose();
    super.dispose();
  }

  CatatanpermBloc get bloc => context.read<CatatanpermBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Catatan' : 'Tambah Catatan'),
        actions: [
          BlocBuilder<CatatanpermBloc, CatatanpermState>(
            buildWhen: (previous, current) => previous.saving != current.saving,
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TextButton.icon(
                  onPressed: state.saving ? null : _submit,
                  icon: state.saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: Text(state.saving ? 'Menyimpan...' : 'Simpan'),
                ),
              );
            },
          ),
        ],
      ),

      body: BlocListener<CatatanpermBloc, CatatanpermState>(
        listenWhen: (previous, current) =>
            previous.saveSuccess != current.saveSuccess ||
            previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          if (state.saveSuccess) {
            Navigator.of(context).pop(true);

            // Reset setelah dialog ditutup
            context.read<CatatanpermBloc>().add(
              const ResetCatatanpermSaveState(),
            );
          }

          if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },

        child: SafeArea(
          child: BlocBuilder<CatatanpermBloc, CatatanpermState>(
            buildWhen: (previous, current) =>
                previous.validationError != current.validationError ||
                previous.fieldcatatans != current.fieldcatatans ||
                previous.saving != current.saving,

            builder: (context, state) {
              return Form(
                key: _formKey,

                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldcatatanField(state),

                            const SizedBox(height: 16),

                            _buildIsiCatatanField(state),

                            const SizedBox(height: 20),

                            _buildImageSection(state),
                          ],
                        ),
                      ),
                    ),

                    _buildBottomButton(state),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ============================================================
  // FIELD CATATAN
  // ============================================================

  Widget _buildFieldcatatanField(CatatanpermState state) {
    final selected = _selectedFieldcatatan;

    return TextFormField(
      readOnly: true,

      controller: TextEditingController(text: selected?.namaFieldcatatan ?? ''),

      decoration: InputDecoration(
        labelText: 'Field Catatan',
        hintText: 'Pilih field catatan',
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.category_outlined),
        suffixIcon: const Icon(Icons.search),
        errorText: state.errorText('fieldcatatan_id'),
      ),

      onTap: () async {
        if (state.fieldcatatans.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data field catatan belum tersedia')),
          );

          return;
        }

        final result = await SearchableSelectionDialog.show<Fieldcatatan>(
          context: context,
          items: state.fieldcatatans,
          selectedItem: _selectedFieldcatatan,
          title: 'Pilih Field Catatan',
          searchHint: 'Cari field catatan...',
          itemLabelBuilder: (item) => item.namaFieldcatatan,
        );

        if (!mounted || result == null) {
          return;
        }

        setState(() {
          _selectedFieldcatatan = result;
        });

        bloc.add(const ResetCatatanpermValidationError());
      },

      validator: (_) {
        if (_selectedFieldcatatan == null) {
          return 'Field catatan wajib dipilih';
        }

        return null;
      },
    );
  }

  // ============================================================
  // ISI CATATAN
  // ============================================================

  Widget _buildIsiCatatanField(CatatanpermState state) {
    return TextFormField(
      controller: _isiCatatanController,

      minLines: 5,
      maxLines: 10,

      textInputAction: TextInputAction.newline,

      decoration: InputDecoration(
        labelText: 'Isi Catatan',
        hintText: 'Masukkan isi catatan...',
        alignLabelWithHint: true,
        border: const OutlineInputBorder(),
        prefixIcon: const Padding(
          padding: EdgeInsets.only(bottom: 70),
          child: Icon(Icons.notes),
        ),
        errorText: state.errorText('isi_catatanperm'),
      ),

      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Isi catatan wajib diisi';
        }

        return null;
      },

      onChanged: (_) {
        bloc.add(const ResetCatatanpermValidationError());
      },
    );
  }

  // ============================================================
  // IMAGE
  // ============================================================

  Widget _buildImageSection(CatatanpermState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Lampiran', style: Theme.of(context).textTheme.titleSmall),

        const SizedBox(height: 8),

        ImageUploadWidget(
          imageFile: _imageFile,

          imageUrl: _oldImage,

          folderName: 'catatanperm',

          maxSizeInMB: 1,

          onChanged: (file) {
            setState(() {
              _imageFile = file;
            });

            bloc.add(const ResetCatatanpermValidationError());
          },

          onRemove: () {
            setState(() {
              _imageFile = null;
              _oldImage = null;
            });

            bloc.add(const ResetCatatanpermValidationError());
          },
        ),

        if (state.errorText('image_file') != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              state.errorText('image_file')!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),

        if (state.errorText('image') != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              state.errorText('image')!,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  // ============================================================
  // BOTTOM BUTTON
  // ============================================================

  Widget _buildBottomButton(CatatanpermState state) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),

      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,

        boxShadow: [
          BoxShadow(blurRadius: 8, color: Colors.black.withValues(alpha: 0.08)),
        ],
      ),

      child: FilledButton.icon(
        onPressed: state.saving ? null : _submit,

        icon: state.saving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.save),

        label: Text(state.saving ? 'Menyimpan...' : 'Simpan Catatan'),
      ),
    );
  }

  // ============================================================
  // SUBMIT
  // ============================================================

  void _submit() {
    FocusScope.of(context).unfocus();

    bloc.add(const ResetCatatanpermValidationError());

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedFieldcatatan == null) {
      return;
    }

    final request = AddEditCatatanpermRequest(
      fieldcatatanId: _selectedFieldcatatan!.id,
      transpermohonanId: widget.transpermohonanId,
      isiCatatanperm: _isiCatatanController.text.trim(),
      userId: userId,
      imageFile: _imageFile,
    );

    if (widget.isEdit) {
      bloc.add(UpdateCatatanperm(id: widget.catatanperm!.id, request: request));
    } else {
      bloc.add(AddCatatanperm(request));
    }
  }
}
