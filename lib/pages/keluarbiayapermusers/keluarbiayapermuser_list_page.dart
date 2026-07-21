import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/auth/auth.dart';
import 'package:newklikrkw/blocs/keluarbiayapermuser/keluarbiayapermuser_bloc.dart';
import 'package:newklikrkw/blocs/keluarbiayapermuser/keluarbiayapermuser_event.dart';
import 'package:newklikrkw/blocs/keluarbiayapermuser/keluarbiayapermuser_state.dart';
import 'package:newklikrkw/models/user.dart';
import 'package:newklikrkw/utils/utils.dart';
import 'package:newklikrkw/widgets/dialogs/add_edit_keluarbiayapermuser_dialog.dart';
import 'package:newklikrkw/widgets/keluarbiayapermuser_list_widget.dart';

class KeluarbiayapermuserListPage extends StatefulWidget {
  const KeluarbiayapermuserListPage({super.key});

  @override
  State<KeluarbiayapermuserListPage> createState() =>
      _KeluarbiayapermuserListPageState();
}

class _KeluarbiayapermuserListPageState
    extends State<KeluarbiayapermuserListPage> {
  @override
  void initState() {
    super.initState();

    final bloc = context.read<KeluarbiayapermuserBloc>();

    // bloc.add(const LoadUsers());
    bloc.add(const LoadStatusKeluarbiayapermusers());
    bloc.add(const LoadKeluarbiayapermusers());
    final currentState = context.read<AuthBloc>().state;
    if (currentState is Authenticated) {
      final luser = currentState.user;
      final cuser = User(id: luser.id, name: luser.name);
      bloc.add(FilterUserKeluarbiayapermuser(cuser));
      bloc.add(FilterStatusKeluarbiayapermuser('wait_approval'));
    }
  }

  Future<void> _showAddDialog() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => BlocProvider.value(
          value: context.read<KeluarbiayapermuserBloc>(),
          child: const AddEditKeluarbiayapermuserDialog(),
        ),
      ),
    );

    if (!mounted || result != true) return;

    context.read<KeluarbiayapermuserBloc>().add(
      const RefreshKeluarbiayapermusers(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pengeluaran Biaya Perm")),

      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Tambah"),
        onPressed: _showAddDialog,
      ),
      body: Column(
        children: [
          BlocBuilder<KeluarbiayapermuserBloc, KeluarbiayapermuserState>(
            buildWhen: (p, c) =>
                p.users != c.users ||
                p.statusKeluarbiayapermusers != c.statusKeluarbiayapermusers ||
                p.selectedUser != c.selectedUser ||
                p.selectedStatus != c.selectedStatus,
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// USER
                  // Wrap(
                  //   spacing: 8,
                  //   runSpacing: 8,
                  //   children: [

                  //     FilterChip(
                  //       label: const Text(
                  //         "Semua User",
                  //       ),
                  //       selected:
                  //           state.selectedUser ==
                  //               null,
                  //       onSelected: (_) {
                  //         context
                  //             .read<
                  //                 KeluarbiayapermuserBloc>()
                  //             .add(
                  //               const FilterUserKeluarbiayapermuser(
                  //                   null),
                  //             );
                  //       },
                  //     ),

                  //     ...state.users.map(
                  //       (User user) {
                  //         return FilterChip(
                  //           label: Text(
                  //             user.name,
                  //           ),
                  //           selected:
                  //               state
                  //                       .selectedUser
                  //                       ?.id ==
                  //                   user.id,
                  //           onSelected: (_) {
                  //             context
                  //                 .read<
                  //                     KeluarbiayapermuserBloc>()
                  //                 .add(
                  //                   FilterUserKeluarbiayapermuser(
                  //                     user.id,
                  //                   ),
                  //                 );
                  //           },
                  //         );
                  //       },
                  //     ),

                  //   ],
                  // ),

                  ///USER
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, ustate) {
                      if (ustate is Authenticated) {
                        if (ustate.user.isAdmin == false) {
                          return Container();
                        }
                        return SizedBox(
                          height: 50,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: ustate.users.length + 1,
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return FilterChip(
                                  avatar: const CircleAvatar(
                                    child: Icon(Icons.person, size: 16),
                                  ),
                                  label: const Text('All'),
                                  selected: state.selectedUser == null,
                                  showCheckmark: false,
                                  onSelected: (selected) {
                                    context.read<KeluarbiayapermuserBloc>().add(
                                      const FilterUserKeluarbiayapermuser(null),
                                    );
                                  },
                                );
                              }

                              final user = ustate.users[index - 1];
                              return FilterChip(
                                avatar: const CircleAvatar(
                                  child: Icon(Icons.person, size: 16),
                                ),
                                label: Text(
                                  CommonUtils.truncate(user.name, 10),
                                ),
                                selected: state.selectedUser?.id == user.id,
                                onSelected: (selected) {
                                  context.read<KeluarbiayapermuserBloc>().add(
                                    FilterUserKeluarbiayapermuser(user),
                                  );
                                },
                              );
                            },
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                  const SizedBox(height: 12),

                  /// STATUS
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilterChip(
                        label: const Text("All Status"),
                        selected: state.selectedStatus == null,
                        onSelected: (_) {
                          context.read<KeluarbiayapermuserBloc>().add(
                            const FilterStatusKeluarbiayapermuser(null),
                          );
                        },
                      ),

                      ...state.statusKeluarbiayapermusers.map((status) {
                        return FilterChip(
                          label: Text(status),
                          selected: state.selectedStatus == status,
                          onSelected: (_) {
                            context.read<KeluarbiayapermuserBloc>().add(
                              FilterStatusKeluarbiayapermuser(status),
                            );
                          },
                        );
                      }),
                    ],
                  ),
                ],
              );
            },
          ),

          const Divider(height: 1),

          const Expanded(child: KeluarbiayapermuserListWidget()),
        ],
      ),
    );
  }
}
