import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:newklikrkw/blocs/auth/auth.dart';
import 'package:newklikrkw/blocs/prosespermohonan/prosespermohonan_bloc.dart';
import 'package:newklikrkw/blocs/prosespermohonan/prosespermohonan_event.dart';
import 'package:newklikrkw/blocs/prosespermohonan/prosespermohonan_state.dart';
import 'package:newklikrkw/models/itememprosesperm.dart';
import 'package:newklikrkw/models/store_prosespermohonan_request.dart';
import 'package:newklikrkw/widgets/searchable_selection_dialog.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class AddProsespermohonanBottomSheet extends StatefulWidget {
  final String transpermohonanId;

  /// null = tambah
  final StoreProsespermohonanrequest? existingData;

  const AddProsespermohonanBottomSheet({
    super.key,
    required this.transpermohonanId,
    this.existingData,
  });

  @override
  State<AddProsespermohonanBottomSheet> createState() =>
      _AddProsespermohonanBottomSheetState();
}

class _AddProsespermohonanBottomSheetState
    extends State<AddProsespermohonanBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _catatanController;

  int? _statusId;
  int? _itemprosespermId;

  bool _isAlert = false;

  DateTime? _start;

  DateTime? _end;

  bool get isEdit => widget.existingData != null;

  @override
  void initState() {
    super.initState();

    _catatanController = TextEditingController(
      text: widget.existingData?.catatanProsesperm ?? '',
    );
    _statusId = widget.existingData?.statusprosespermId;
    _itemprosespermId = widget.existingData?.itemprosespermId;
    _isAlert = widget.existingData?.isAlert ?? false;
    _start = widget.existingData?.start ?? DateTime.now();
    _end = widget.existingData?.end ?? DateTime.now();
  }

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  Future<void> _pickStart() async {
    final result = await showOmniDateTimePicker(
      context: context,
      initialDate: _start,
      firstDate: DateTime.now(),
      // lastDate: DateTime.now(),
      is24HourMode: true,
    );

    if (result != null) {
      setState(() {
        _start = result;
      });
    }
  }

  Future<void> _pickEnd() async {
    final result = await showOmniDateTimePicker(
      context: context,
      initialDate: _end,
      firstDate: DateTime.now(),
      // lastDate: DateTime.now(),
      is24HourMode: true,
    );

    if (result != null) {
      setState(() {
        _end = result;
      });
    }
  }

  String _formatDate(DateTime? value) {
    if (value == null) {
      return '-';
    }

    return DateFormat('dd/MM/yyyy HH:mm').format(value);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_statusId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pilih status')));
      return;
    }
    if (_itemprosespermId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pilih item proses')));
      return;
    }

    if (_isAlert) {
      if (_start == null || _end == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Start dan End wajib diisi')),
        );
        return;
      }
    }
    final currentState = context.read<AuthBloc>().state;
    int userId = 0;
    if (currentState is Authenticated) {
      userId = currentState.user.id;
    }
    if (userId == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('anda belum login')));
      return;
    }

    final request = StoreProsespermohonanrequest(
      id: widget.existingData?.id,
      transpermohonanId: widget.transpermohonanId,
      itemprosespermId: _itemprosespermId!,
      statusprosespermId: _statusId!,
      catatanProsesperm: _catatanController.text,
      userId: userId,
      isAlert: _isAlert,
      start: _start,
      end: _end,
    );
    if (widget.existingData == null) {
      context.read<ProsespermohonanBloc>().add(StoreProsespermohonan(request));
    } else {
      context.read<ProsespermohonanBloc>().add(UpdateProsespermohonan(request));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProsespermohonanBloc, ProsespermohonanState>(
      listenWhen: (previous, current) =>
          previous.saveSuccess != current.saveSuccess ||
          previous.saveError != current.saveError,
      listener: (context, state) {
        // WidgetsBinding.instance.addPostFrameCallback((_) {
        //   _formKey.currentState?.validate();
        // });
        if (state.saveSuccess) {
          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isEdit ? 'Data berhasil diperbarui' : 'Data berhasil disimpan',
              ),
            ),
          );

          context.read<ProsespermohonanBloc>().add(
            LoadProsespermohonan(
              transpermohonanId: context
                  .read<ProsespermohonanBloc>()
                  .state
                  .transpermohonanId,
              isTranspermohonanId: true,
            ),
          );
        }
        // if (state.saveError != null) {
        //   ScaffoldMessenger.of(
        //     context,
        //   ).showSnackBar(SnackBar(content: Text(state.saveError!)));
        // }
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    isEdit ? 'Update Status' : 'Tambah Status',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),

                const SizedBox(height: 16),
                // show all errors
                // BlocBuilder<ProsespermohonanBloc, ProsespermohonanState>(
                //   builder: (context, state) {
                //     if (state.validationError != null) {
                //       return Container(
                //         width: double.infinity,
                //         padding: const EdgeInsets.all(12),
                //         margin: const EdgeInsets.only(bottom: 12),
                //         decoration: BoxDecoration(
                //           color: Colors.red.shade50,
                //           borderRadius: BorderRadius.circular(8),
                //         ),
                //         child: Text(
                //           state.validationError!.allErrors,
                //           style: const TextStyle(color: Colors.red),
                //         ),
                //       );
                //     }
                //     return Container();
                //   },
                // ),
                BlocBuilder<ProsespermohonanBloc, ProsespermohonanState>(
                  builder: (context, state) {
                    return DropdownButtonFormField<int>(
                      initialValue: _statusId,
                      decoration: InputDecoration(
                        labelText: 'Status',
                        border: const OutlineInputBorder(),
                        errorText: state.validationError?.firstError(
                          'statusprosesperm_id',
                        ),
                      ),
                      items: state.availableStatuses
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(e.namaStatusprosesperm),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        setState(() {
                          _statusId = v;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Status wajib dipilih';
                        } else if (value == 0) {
                          return 'Status wajib dipilih';
                        }

                        return null;
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),

                // BlocBuilder<ProsespermohonanBloc, ProsespermohonanState>(
                //   builder: (context, state) {
                //     if (widget.existingData != null) {
                //       final result = state.availableItems.firstWhere(
                //         (e) => e.id == widget.existingData!.itemprosespermId,
                //       );
                //       return Text(
                //         result.namaItemprosesperm,
                //         style: Theme.of(context).textTheme.titleMedium,
                //       );
                //     }
                //     return DropdownButtonFormField<int>(
                //       initialValue: _itemprosespermId,
                //       decoration: InputDecoration(
                //         labelText: 'Item Proses',
                //         border: const OutlineInputBorder(),
                //         errorText: state.validationError?.firstError(
                //           'itemprosesperm_id',
                //         ),
                //       ),
                //       items: state.availableItems
                //           .map(
                //             (e) => DropdownMenuItem(
                //               value: e.id,
                //               child: Text(e.namaItemprosesperm),
                //             ),
                //           )
                //           .toList(),
                //       onChanged: (v) {
                //         setState(() {
                //           _itemprosespermId = v;
                //         });
                //       },
                //       validator: (value) {
                //         if (value == null) {
                //           return 'Item wajib dipilih';
                //         } else if (value == 0) {
                //           return 'Item wajib dipilih';
                //         }

                //         return null;
                //       },
                //     );
                //   },
                // ),
                BlocBuilder<ProsespermohonanBloc, ProsespermohonanState>(
                  builder: (context, state) {
                    final selectedItem = state.availableItems.where(
                      (e) => e.id == _itemprosespermId,
                    );

                    return TextFormField(
                      readOnly: true,
                      controller: TextEditingController(
                        text: selectedItem.isEmpty
                            ? ""
                            : selectedItem.first.namaItemprosesperm,
                      ),
                      decoration: InputDecoration(
                        labelText: "Item Proses",
                        border: const OutlineInputBorder(),
                        suffixIcon: const Icon(Icons.search),
                        errorText: state.validationError?.firstError(
                          'itemprosesperm_id',
                        ),
                      ),
                      onTap: () async {
                        final result = await Navigator.push<Itemprosesperm>(
                          context,
                          MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (_) =>
                                SearchableSelectionDialog<Itemprosesperm>(
                                  title: "Pilih Item Proses",

                                  searchHint: "Cari Item...",

                                  items: state.availableItems,

                                  selectedItem: state.availableItems
                                      .where((e) => e.id == _itemprosespermId)
                                      .firstOrNull,

                                  itemLabelBuilder: (e) => e.namaItemprosesperm,
                                ),
                          ),
                        );

                        if (result != null) {
                          setState(() {
                            _itemprosespermId = result.id;
                          });
                        }
                      },
                      validator: (_) {
                        if (_itemprosespermId == null ||
                            _itemprosespermId == 0) {
                          return "Item wajib dipilih";
                        }
                        return null;
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _catatanController,
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Catatan',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 12),

                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Aktifkan Alert'),
                  value: _isAlert,
                  onChanged: (v) {
                    setState(() {
                      _isAlert = v;
                    });
                  },
                ),

                if (_isAlert) ...[
                  const SizedBox(height: 8),

                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(),
                    ),
                    leading: const Icon(Icons.schedule),
                    title: const Text('Start'),
                    subtitle: Text(_formatDate(_start)),
                    onTap: _pickStart,
                  ),

                  const SizedBox(height: 8),

                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(),
                    ),
                    leading: const Icon(Icons.event),
                    title: const Text('End'),
                    subtitle: Text(_formatDate(_end)),
                    onTap: _pickEnd,
                  ),
                ],

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child:
                      BlocBuilder<ProsespermohonanBloc, ProsespermohonanState>(
                        builder: (context, state) {
                          return ElevatedButton.icon(
                            onPressed: state.saving ? null : _submit,
                            icon: state.saving
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.save),
                            label: Text(
                              state.saving
                                  ? 'Menyimpan...'
                                  : isEdit
                                  ? 'Update'
                                  : 'Simpan',
                            ),
                          );
                        },
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
