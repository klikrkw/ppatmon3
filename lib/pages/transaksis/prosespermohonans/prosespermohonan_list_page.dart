import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/auth/auth.dart';
import 'package:newklikrkw/blocs/prosespermohonan/prosespermohonan_bloc.dart';
import 'package:newklikrkw/blocs/prosespermohonan/prosespermohonan_event.dart';
import 'package:newklikrkw/blocs/prosespermohonan/prosespermohonan_state.dart';
import 'package:newklikrkw/utils/common_utils.dart';
import 'package:newklikrkw/utils/dio.dart';

class ProsespermohonanListPage extends StatefulWidget {
  const ProsespermohonanListPage({super.key});

  @override
  State<ProsespermohonanListPage> createState() =>
      _ProsespermohonanListPageState();
}

class _ProsespermohonanListPageState extends State<ProsespermohonanListPage> {
  final ScrollController _scrollController = ScrollController();
  int? _userId = 0;

  // final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final currentState = context.read<AuthBloc>().state;
    if (currentState is Authenticated) {
      _userId = currentState.user.id;
    }

    context.read<ProsespermohonanBloc>().add(
      LoadProsespermohonan(userId: _userId),
    );

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300) {
        context.read<ProsespermohonanBloc>().add(LoadMoreProsespermohonan());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Proses Permohonan')),
      body: BlocBuilder<ProsespermohonanBloc, ProsespermohonanState>(
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: _buildItemFilter(state),
                // TextField(
                //   controller: _searchController,
                //   decoration: const InputDecoration(
                //     hintText: 'Cari proses...',
                //     prefixIcon: Icon(Icons.search),
                //   ),
                //   onChanged: (value) {
                //     context.read<ProsespermohonanBloc>().add(
                //       SearchProsespermohonan(value),
                //     );
                //   },
                // ),
              ),
              _buildStatusFilter(state),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is Authenticated) {
                    return Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              FilterChip(
                                avatar: const CircleAvatar(
                                  child: Icon(Icons.person, size: 16),
                                ),
                                label: const Text('All'),
                                selected: _userId == null,
                                showCheckmark: false,
                                onSelected: (selected) {
                                  setState(() {
                                    _userId = null;
                                  });
                                  context.read<ProsespermohonanBloc>().add(
                                    FilterUserId(null),
                                  );
                                },
                              ),
                            ],
                          ),

                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: state.users.map((user) {
                              return FilterChip(
                                avatar: const CircleAvatar(
                                  child: Icon(Icons.person, size: 16),
                                ),
                                label: Text(
                                  CommonUtils.truncate(user.name, 10),
                                ),
                                selected: _userId == user.id,
                                showCheckmark: false,
                                onSelected: (selected) {
                                  setState(() {
                                    _userId = user.id;
                                  });
                                  context.read<ProsespermohonanBloc>().add(
                                    FilterUserId(_userId),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),

              Expanded(
                child: BlocBuilder<ProsespermohonanBloc, ProsespermohonanState>(
                  builder: (context, state) {
                    if (state.loading && state.items.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount:
                          state.items.length + (state.hasReachedMax ? 0 : 1),
                      itemBuilder: (context, index) {
                        if (index >= state.items.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final item = state.items[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: ListTile(
                            title: Row(
                              children: [
                                Text(
                                  item.itemprosesperm.namaItemprosesperm,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                Spacer(),
                                item.statusprosesperms.isNotEmpty
                                    ? Chip(
                                        avatar:
                                            item.statusprosesperms.isNotEmpty
                                            ? CircleAvatar(
                                                radius: 10,
                                                backgroundColor:
                                                    Colors.transparent,
                                                backgroundImage: NetworkImage(
                                                  '$myBaseUrl${item.statusprosesperms[0].imageStatusprosesperm}',
                                                ),
                                              )
                                            : null,
                                        label: Text(
                                          item
                                              .statusprosesperms[0]
                                              .namaStatusprosesperm,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...item.statusprosesperms.map((
                                  statusprosesperm,
                                ) {
                                  return Row(
                                    children: [
                                      Text(statusprosesperm.updatedAt!),
                                      Text(','),
                                      SizedBox(width: 8),
                                      Text(item.catatanProsesperm),
                                    ],
                                  );
                                }),
                                Divider(
                                  height: 10,
                                  color: Theme.of(context).primaryColor,
                                ),
                                Text(
                                  '${item.transpermohonan.noDaftar} - ${item.transpermohonan.namaPenerima}',
                                ),
                                Text(item.transpermohonan.alasHak),
                                Text(item.transpermohonan.letakObyek),
                                Text(
                                  item.transpermohonan.users
                                      .map((user) => user.name)
                                      .join(', '),
                                ),
                              ],
                            ),
                            // trailing: Column(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     if (item.statusprosesperms.isNotEmpty)
                            //       Padding(
                            //         padding: const EdgeInsets.only(top: 0),
                            //         child: Wrap(
                            //           spacing: 8,
                            //           runSpacing: 8,
                            //           children: [
                            //             item.statusprosesperms.isNotEmpty
                            //                 ? Chip(
                            //                     avatar:
                            //                         item
                            //                             .statusprosesperms
                            //                             .isNotEmpty
                            //                         ? CircleAvatar(
                            //                             radius: 10,
                            //                             backgroundColor:
                            //                                 Colors.transparent,
                            //                             backgroundImage:
                            //                                 NetworkImage(
                            //                                   '$myBaseUrl${item.statusprosesperms[0].imageStatusprosesperm}',
                            //                                 ),
                            //                           )
                            //                         : null,
                            //                     label: Text(
                            //                       item
                            //                           .statusprosesperms[0]
                            //                           .namaStatusprosesperm,
                            //                       style: const TextStyle(
                            //                         fontSize: 12,
                            //                       ),
                            //                     ),
                            //                   )
                            //                 : Container(),
                            //           ],
                            // item.statusprosesperms
                            //     .map((status) {
                            //       return Chip(
                            //         avatar:
                            //             status
                            //                 .imageStatusprosesperm
                            //                 .isNotEmpty
                            //             ? CircleAvatar(
                            //                 radius: 10,
                            //                 backgroundColor:
                            //                     Colors.transparent,
                            //                 backgroundImage: NetworkImage(
                            //                   '$myBaseUrl${status.imageStatusprosesperm}',
                            //                 ),
                            //               )
                            //             : null,
                            //         label: Text(
                            //           status.namaStatusprosesperm,
                            //           style: const TextStyle(
                            //             fontSize: 12,
                            //           ),
                            //         ),
                            //       );
                            //     })
                            //     .toList()
                            //         ),
                            //       ),
                            //   ],
                            // ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusFilter(ProsespermohonanState state) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          ...state.availableStatuses.map((status) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                showCheckmark: false,
                avatar: status.imageStatusprosesperm.isNotEmpty
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(
                          '$myBaseUrl${status.imageStatusprosesperm}',
                        ),
                      )
                    : null,

                label: Text(status.namaStatusprosesperm),

                selected: state.statusProsespermId == status.id,

                onSelected: (_) {
                  context.read<ProsespermohonanBloc>().add(
                    FilterStatusProsespermohonan(
                      status.id,
                      state.query,
                      state.itemProsespermId,
                      // _searchController.text,
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildItemFilter(ProsespermohonanState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: DropdownButtonFormField<int?>(
        initialValue: state.itemProsespermId,
        decoration: const InputDecoration(
          labelText: 'Tahapan Proses',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.list_alt),
        ),
        items: [
          ...state.availableItems.map(
            (item) => DropdownMenuItem<int?>(
              value: item.id,
              child: Text(item.namaItemprosesperm),
            ),
          ),
        ],
        onChanged: (value) {
          context.read<ProsespermohonanBloc>().add(
            FilterItemProsespermohonan(value),
          );
        },
      ),
    );
  }
}
