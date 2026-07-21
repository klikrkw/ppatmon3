import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/auth/auth.dart';
import 'package:newklikrkw/blocs/dkeluarbiaya/dkeluarbiaya_bloc.dart';
import 'package:newklikrkw/blocs/dkeluarbiaya/dkeluarbiaya_event.dart';
import 'package:newklikrkw/blocs/dkeluarbiaya/dkeluarbiaya_state.dart';
import 'package:newklikrkw/blocs/keluarbiaya/keluarbiaya_bloc.dart';
import 'package:newklikrkw/blocs/keluarbiaya/keluarbiaya_event.dart';
import 'package:newklikrkw/repositories/dkeluarbiaya_repository.dart';
import 'package:newklikrkw/services/dkeluarbiaya_service.dart';
import 'package:newklikrkw/utils/format.dart';
import 'package:newklikrkw/widgets/dialogs/add_edit_dkeluarbiaya_dialog.dart';
import 'package:newklikrkw/widgets/dkeluarbiaya_list_widget.dart';

class DkeluarbiayaListPage extends StatelessWidget {
  final String keluarbiayaId;

  const DkeluarbiayaListPage({super.key, required this.keluarbiayaId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DkeluarbiayaBloc(
        repository: DkeluarbiayaRepository(service: DkeluarbiayaService()),
      )..add(LoadDkeluarbiayas(keluarbiayaId)),
      child: _Body(keluarbiayaId: keluarbiayaId),
    );
  }
}

class _Body extends StatelessWidget {
  final String keluarbiayaId;

  const _Body({required this.keluarbiayaId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Keluar Biaya")),

      body: BlocListener<DkeluarbiayaBloc, DkeluarbiayaState>(
        listenWhen: (previous, current) =>
            previous.deleteSuccess != current.deleteSuccess,
        listener: (context, state) {
          if (state.deleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Data berhasil dihapus")),
            );

            context.read<DkeluarbiayaBloc>().add(const ResetDeleteState());
          }
        },
        child: Column(
          children: [
            BlocBuilder<DkeluarbiayaBloc, DkeluarbiayaState>(
              builder: (context, state) {
                if (state.keluarbiaya == null) return Container();
                return Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  height: 150,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListTile(
                          title: Text(state.keluarbiaya!.id),
                          subtitle: Text('${state.keluarbiaya!.user.name} '),
                          trailing: IconButton(
                            icon:
                                state.keluarbiaya!.statusKeluarbiaya ==
                                    'approved'
                                ? const Icon(Icons.check_box_sharp)
                                : const Icon(Icons.check_box_outline_blank),
                            onPressed: () {
                              //show dialog
                              final userState = context.read<AuthBloc>().state;
                              if (userState is Authenticated) {
                                if (userState.user.isAdmin) {
                                  showUpdateStatusBottomSheet(
                                    context: context,
                                    keluarbiayaId: keluarbiayaId,
                                    currentStatus:
                                        state.keluarbiaya!.statusKeluarbiaya,
                                  );
                                }
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('Saldo Awal'),
                                  const Spacer(),
                                  Text(
                                    formatRupiah(state.keluarbiaya!.saldoAwal),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Jumlah Keluar'),
                                  const Spacer(),
                                  Text(
                                    formatRupiah(
                                      state.keluarbiaya!.jumlahBiaya,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Saldo Akhir'),
                                  const Spacer(),
                                  Text(
                                    formatRupiah(state.keluarbiaya!.saldoAkhir),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: DkeluarbiayaListWidget(
                onDelete: (item) {
                  final status = context.read<DkeluarbiayaBloc>().state;
                  if (status.keluarbiaya == null) return;
                  if (status.keluarbiaya!.statusKeluarbiaya ==
                      'wait_approval') {
                    showDeleteDialog(context, item.id);
                  }
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: BlocBuilder<DkeluarbiayaBloc, DkeluarbiayaState>(
        builder: (context, state) {
          if (state.keluarbiaya == null) return Container();
          if (state.keluarbiaya!.statusKeluarbiaya == 'wait_approval') {
            return FloatingActionButton.extended(
              icon: const Icon(Icons.add),
              label: const Text("Tambah"),
              onPressed: () {
                final status = context.read<DkeluarbiayaBloc>().state;
                if (status.keluarbiaya == null) return;
                if (status.keluarbiaya!.statusKeluarbiaya == 'wait_approval') {
                  _showAddDialog(context);
                }
              },
            );
          }
          return Container();
        },
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => BlocProvider.value(
          value: context.read<DkeluarbiayaBloc>(),
          child: AddEditDkeluarbiayaDialog(keluarbiayaId: keluarbiayaId),
        ),
      ),
    );

    if (result == true && context.mounted) {
      context.read<DkeluarbiayaBloc>().add(const RefreshDkeluarbiayas());
    }
  }

  Future<void> showUpdateStatusBottomSheet({
    required BuildContext context,
    required String keluarbiayaId,
    required String currentStatus,
  }) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<DkeluarbiayaBloc>(),
          child: UpdateStatusKeluarbiayaSheet(
            keluarbiayaId: keluarbiayaId,
            currentStatus: currentStatus,
          ),
        );
      },
    );

    if (result == true && context.mounted) {
      context.read<DkeluarbiayaBloc>().add(const RefreshDkeluarbiayas());
      context.read<KeluarbiayaBloc>().add(const RefreshKeluarbiayas());
    }
  }

  Future<void> showDeleteDialog(BuildContext context, String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Hapus Data"),
          content: const Text("Yakin ingin menghapus data ini?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Batal"),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Hapus"),
            ),
          ],
        );
      },
    );

    if (confirm == true && context.mounted) {
      context.read<DkeluarbiayaBloc>().add(DeleteDkeluarbiaya(id));
    }
  }
}

class UpdateStatusKeluarbiayaSheet extends StatefulWidget {
  final String keluarbiayaId;
  final String currentStatus;

  const UpdateStatusKeluarbiayaSheet({
    super.key,
    required this.keluarbiayaId,
    required this.currentStatus,
  });

  @override
  State<UpdateStatusKeluarbiayaSheet> createState() =>
      _UpdateStatusKeluarbiayaSheetState();
}

class _UpdateStatusKeluarbiayaSheetState
    extends State<UpdateStatusKeluarbiayaSheet> {
  late String selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.currentStatus;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DkeluarbiayaBloc, DkeluarbiayaState>(
      listenWhen: (previous, current) =>
          previous.updateStatusSuccess != current.updateStatusSuccess,
      listener: (context, state) {
        if (state.updateStatusSuccess) {
          Navigator.of(context).pop(true);

          context.read<DkeluarbiayaBloc>().add(const ResetUpdateStatus());
        }
      },
      child: BlocBuilder<DkeluarbiayaBloc, DkeluarbiayaState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Update Status Keluar Biaya",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                RadioGroup<String>(
                  groupValue: selectedStatus,
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value!;
                    });
                  },
                  child: const Column(
                    children: [
                      RadioListTile(
                        value: "wait_approval",
                        title: Text("Wait Approval"),
                      ),
                      RadioListTile(value: "approved", title: Text("Approved")),
                      RadioListTile(
                        value: "cancelled",
                        title: Text("Cancelled"),
                      ),
                      RadioListTile(value: "rejected", title: Text("Rejected")),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: state.updatingStatus
                        ? null
                        : () {
                            context.read<DkeluarbiayaBloc>().add(
                              UpdateStatusKeluarbiaya(
                                keluarbiayaId: widget.keluarbiayaId,
                                status: selectedStatus,
                              ),
                            );
                          },
                    child: state.updatingStatus
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text("Simpan"),
                  ),
                ),

                const SizedBox(height: 12),
              ],
            ),
          );
        },
      ),
    );
  }
}
