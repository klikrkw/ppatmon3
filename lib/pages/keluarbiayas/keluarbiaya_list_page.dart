import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/auth/auth.dart';
import 'package:newklikrkw/blocs/keluarbiaya/keluarbiaya_bloc.dart';
import 'package:newklikrkw/blocs/keluarbiaya/keluarbiaya_event.dart';
import 'package:newklikrkw/blocs/keluarbiaya/keluarbiaya_state.dart';
import 'package:newklikrkw/models/user.dart';
import 'package:newklikrkw/utils/utils.dart';
import 'package:newklikrkw/widgets/dialogs/add_edit_keluarbiaya_dialog.dart';
import 'package:newklikrkw/widgets/keluarbiaya_list_widget.dart';

class KeluarbiayaListPage extends StatefulWidget {
  const KeluarbiayaListPage({super.key});

  @override
  State<KeluarbiayaListPage> createState() => _KeluarbiayaListPageState();
}

class _KeluarbiayaListPageState extends State<KeluarbiayaListPage> {
  @override
  void initState() {
    super.initState();

    final bloc = context.read<KeluarbiayaBloc>();

    // bloc.add(const LoadUsers());
    bloc.add(const LoadStatusKeluarbiayas());
    bloc.add(const LoadKeluarbiayas());
    final currentState = context.read<AuthBloc>().state;
    if (currentState is Authenticated) {
      final luser = currentState.user;
      final cuser = User(id: luser.id, name: luser.name);
      bloc.add(FilterUserKeluarbiaya(cuser));
      bloc.add(FilterStatusKeluarbiaya('wait_approval'));
    }
  }

  Future<void> _showAddDialog() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => BlocProvider.value(
          value: context.read<KeluarbiayaBloc>(),
          child: const AddEditKeluarbiayaDialog(),
        ),
      ),
    );

    if (!mounted || result != true) return;

    context.read<KeluarbiayaBloc>().add(const RefreshKeluarbiayas());
  }

  @override
  Widget build(BuildContext context) {
    // final authState = context.watch<AuthBloc>().state;
    // final user = authState is Authenticated ? authState.user : null;

    return Scaffold(
      appBar: AppBar(title: const Text("Pengeluaran Biaya")),

      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Tambah"),
        onPressed: _showAddDialog,
      ),
      body: Column(
        children: [
          BlocBuilder<KeluarbiayaBloc, KeluarbiayaState>(
            buildWhen: (p, c) =>
                p.users != c.users ||
                p.statusKeluarbiayas != c.statusKeluarbiayas ||
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
                  //                 KeluarbiayaBloc>()
                  //             .add(
                  //               const FilterUserKeluarbiaya(
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
                  //                     KeluarbiayaBloc>()
                  //                 .add(
                  //                   FilterUserKeluarbiaya(
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
                                    context.read<KeluarbiayaBloc>().add(
                                      const FilterUserKeluarbiaya(null),
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
                                  context.read<KeluarbiayaBloc>().add(
                                    FilterUserKeluarbiaya(user),
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
                          context.read<KeluarbiayaBloc>().add(
                            const FilterStatusKeluarbiaya(null),
                          );
                        },
                      ),

                      ...state.statusKeluarbiayas.map((status) {
                        return FilterChip(
                          label: Text(status),
                          selected: state.selectedStatus == status,
                          onSelected: (_) {
                            context.read<KeluarbiayaBloc>().add(
                              FilterStatusKeluarbiaya(status),
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

          const Expanded(child: KeluarbiayaListWidget()),
        ],
      ),
    );
  }
}
