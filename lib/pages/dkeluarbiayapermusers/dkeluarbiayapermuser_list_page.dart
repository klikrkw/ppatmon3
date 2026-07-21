import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/auth/auth.dart';
import 'package:newklikrkw/blocs/dkeluarbiayapermuser/dkeluarbiayapermuser_bloc.dart';
import 'package:newklikrkw/blocs/dkeluarbiayapermuser/dkeluarbiayapermuser_event.dart';
import 'package:newklikrkw/blocs/dkeluarbiayapermuser/dkeluarbiayapermuser_state.dart';
import 'package:newklikrkw/blocs/keluarbiayapermuser/keluarbiayapermuser_bloc.dart';
import 'package:newklikrkw/blocs/keluarbiayapermuser/keluarbiayapermuser_event.dart';
import 'package:newklikrkw/repositories/dkeluarbiayapermuser_repository.dart';
import 'package:newklikrkw/services/dkeluarbiayapermuser_service.dart';
import 'package:newklikrkw/utils/format.dart';
import 'package:newklikrkw/widgets/dialogs/add_edit_dkeluarbiayapermuser_dialog.dart';
import 'package:newklikrkw/widgets/dkeluarbiayapermuser_list_widget.dart';

class DkeluarbiayapermuserListPage extends StatelessWidget {
  final String keluarbiayapermuserId;

  const DkeluarbiayapermuserListPage({
    super.key,
    required this.keluarbiayapermuserId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DkeluarbiayapermuserBloc(
        repository: DkeluarbiayapermuserRepository(
          service: DkeluarbiayapermuserService(),
        ),
      )..add(LoadDkeluarbiayapermusers(keluarbiayapermuserId)),
      child: _Body(keluarbiayapermuserId: keluarbiayapermuserId),
    );
  }
}

class _Body extends StatelessWidget {
  final String keluarbiayapermuserId;

  const _Body({required this.keluarbiayapermuserId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Keluar Biaya Perm")),

      body: BlocListener<DkeluarbiayapermuserBloc, DkeluarbiayapermuserState>(
        listenWhen: (previous, current) =>
            previous.deleteSuccess != current.deleteSuccess,
        listener: (context, state) {
          if (state.deleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Data berhasil dihapus")),
            );

            context.read<DkeluarbiayapermuserBloc>().add(
              const ResetDeleteState(),
            );
          }
        },
        child: Column(
          children: [
            BlocBuilder<DkeluarbiayapermuserBloc, DkeluarbiayapermuserState>(
              builder: (context, state) {
                if (state.keluarbiayapermuser == null) return Container();
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
                          title: Text(state.keluarbiayapermuser!.id),
                          subtitle: Text(
                            '${state.keluarbiayapermuser!.user.name} ',
                          ),
                          trailing: IconButton(
                            icon:
                                state
                                        .keluarbiayapermuser!
                                        .statusKeluarbiayapermuser ==
                                    'approved'
                                ? const Icon(Icons.check_box_sharp)
                                : const Icon(Icons.check_box_outline_blank),
                            onPressed: () {
                              final userState = context.read<AuthBloc>().state;
                              if (userState is Authenticated) {
                                if (userState.user.isAdmin) {
                                  showUpdateStatusBottomSheet(
                                    context: context,
                                    keluarbiayapermuserId:
                                        keluarbiayapermuserId,
                                    currentStatus: state
                                        .keluarbiayapermuser!
                                        .statusKeluarbiayapermuser,
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
                                    formatRupiah(
                                      state.keluarbiayapermuser!.saldoAwal,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Jumlah Keluar'),
                                  const Spacer(),
                                  Text(
                                    formatRupiah(
                                      state.keluarbiayapermuser!.jumlahBiaya,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Saldo Akhir'),
                                  const Spacer(),
                                  Text(
                                    formatRupiah(
                                      state.keluarbiayapermuser!.saldoAkhir,
                                    ),
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
              child: DkeluarbiayapermuserListWidget(
                onDelete: (item) {
                  final status = context.read<DkeluarbiayapermuserBloc>().state;
                  if (status.keluarbiayapermuser == null) return;
                  if (status.keluarbiayapermuser!.statusKeluarbiayapermuser ==
                      'wait_approval') {
                    showDeleteDialog(context, item.id);
                  }
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Tambah"),
        onPressed: () {
          final status = context.read<DkeluarbiayapermuserBloc>().state;
          if (status.keluarbiayapermuser == null) return;
          if (status.keluarbiayapermuser!.statusKeluarbiayapermuser ==
              'wait_approval') {
            _showAddDialog(context);
          }
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
          value: context.read<DkeluarbiayapermuserBloc>(),
          child: AddEditDkeluarbiayapermuserDialog(
            keluarbiayapermuserId: keluarbiayapermuserId,
          ),
        ),
      ),
    );

    if (result == true && context.mounted) {
      context.read<DkeluarbiayapermuserBloc>().add(
        const RefreshDkeluarbiayapermusers(),
      );
      context.read<KeluarbiayapermuserBloc>().add(
        const RefreshKeluarbiayapermusers(),
      );
    }
  }

  Future<void> showUpdateStatusBottomSheet({
    required BuildContext context,
    required String keluarbiayapermuserId,
    required String currentStatus,
  }) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) {
        return BlocProvider.value(
          value: context.read<DkeluarbiayapermuserBloc>(),
          child: UpdateStatusKeluarbiayaSheet(
            keluarbiayapermuserId: keluarbiayapermuserId,
            currentStatus: currentStatus,
          ),
        );
      },
    );

    if (result == true && context.mounted) {
      context.read<DkeluarbiayapermuserBloc>().add(
        const RefreshDkeluarbiayapermusers(),
      );
      context.read<KeluarbiayapermuserBloc>().add(
        const RefreshKeluarbiayapermusers(),
      );
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
      context.read<DkeluarbiayapermuserBloc>().add(
        DeleteDkeluarbiayapermuser(id),
      );
    }
  }
}

class UpdateStatusKeluarbiayaSheet extends StatefulWidget {
  final String keluarbiayapermuserId;
  final String currentStatus;

  const UpdateStatusKeluarbiayaSheet({
    super.key,
    required this.keluarbiayapermuserId,
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
    return BlocListener<DkeluarbiayapermuserBloc, DkeluarbiayapermuserState>(
      listenWhen: (previous, current) =>
          previous.updateStatusSuccess != current.updateStatusSuccess,
      listener: (context, state) {
        if (state.updateStatusSuccess) {
          Navigator.of(context).pop(true);

          context.read<DkeluarbiayapermuserBloc>().add(
            const ResetUpdateStatus(),
          );
        }
      },
      child: BlocBuilder<DkeluarbiayapermuserBloc, DkeluarbiayapermuserState>(
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
                            context.read<DkeluarbiayapermuserBloc>().add(
                              UpdateStatusKeluarbiaya(
                                keluarbiayapermuserId:
                                    widget.keluarbiayapermuserId,
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
