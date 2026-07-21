import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/auth/auth.dart';

import 'package:newklikrkw/blocs/postingjurnal/postingjurnal_bloc.dart';
import 'package:newklikrkw/blocs/postingjurnal/postingjurnal_event.dart';
import 'package:newklikrkw/blocs/postingjurnal/postingjurnal_state.dart';

import 'package:newklikrkw/models/postingjurnal.dart';

import 'package:newklikrkw/repositories/postingjurnal_repository.dart';
import 'package:newklikrkw/services/postingjurnal_service.dart';
import 'package:newklikrkw/widgets/dialogs/add_edit_postingjurnal_dialog.dart';

import 'package:newklikrkw/widgets/postingjurnal_card.dart';
import 'package:newklikrkw/widgets/postingjurnal_filter.dart';
import 'package:newklikrkw/widgets/postingjurnal_summary.dart';
import 'package:newklikrkw/widgets/image_preview_dialog.dart';

import 'package:newklikrkw/utils/dio.dart';

class PostingjurnalListPage extends StatelessWidget {
  const PostingjurnalListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostingjurnalBloc(
        repository: PostingjurnalRepository(service: PostingjurnalService()),
      )..add(const LoadPostingjurnals()),
      child: const _PostingjurnalView(),
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     return RepositoryProvider.value(
//       value: context.read<PostingjurnalRepository>(),
//       child: BlocProvider(
//         create: (_) => PostingjurnalBloc(
//           repository: PostingjurnalRepository(service: PostingjurnalService()),
//         )..add(const LoadPostingjurnals()),
//         child: const _PostingjurnalView(),
//       ),
//     );
//   }
// }

class _PostingjurnalView extends StatefulWidget {
  const _PostingjurnalView();

  @override
  State<_PostingjurnalView> createState() => _PostingjurnalViewState();
}

class _PostingjurnalViewState extends State<_PostingjurnalView> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();

    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<PostingjurnalBloc>().add(const LoadMorePostingjurnals());
    }
  }

  Future<void> _refresh() async {
    context.read<PostingjurnalBloc>().add(const RefreshPostingjurnals());
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text("Konfirmasi"),
              content: const Text("Yakin ingin menghapus posting jurnal ini?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text("Batal"),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text("Hapus"),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void _showImage(Postingjurnal item) {
    if (!item.hasImage) {
      return;
    }

    showDialog(
      context: context,
      builder: (_) => ImagePreviewDialog(
        imageUrl: "$myBaseUrl${item.image}",
        heroTag: 'postingjurnal',
      ),
    );
  }

  void _deleteItem(Postingjurnal item) async {
    final ok = await _confirmDelete(context);

    if (!mounted || !ok) {
      return;
    }

    context.read<PostingjurnalBloc>().add(DeletePostingjurnal(item.id));
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final user = authState is Authenticated ? authState.user : null;

    return Scaffold(
      appBar: AppBar(title: const Text("Posting Jurnal"), centerTitle: true),

      floatingActionButton: user?.isAdmin == true
          ? FloatingActionButton.extended(
              heroTag: "postingjurnal_add",
              onPressed: () {
                _showAddEditPostingjurnalDialog();
              },
              icon: const Icon(Icons.add),
              label: const Text("Tambah"),
            )
          : null,
      body: MultiBlocListener(
        listeners: [
          BlocListener<PostingjurnalBloc, PostingjurnalState>(
            listenWhen: (previous, current) {
              return previous.deleteSuccess != current.deleteSuccess ||
                  previous.deleteErrorMessage != current.deleteErrorMessage;
            },
            listener: (context, state) {
              if (state.deleteSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Posting jurnal berhasil dihapus"),
                  ),
                );

                context.read<PostingjurnalBloc>().add(const ResetDeleteState());
              }

              if (state.deleteErrorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.deleteErrorMessage!)),
                );

                context.read<PostingjurnalBloc>().add(const ResetDeleteState());
              }
            },
          ),
        ],
        child: BlocBuilder<PostingjurnalBloc, PostingjurnalState>(
          buildWhen: (previous, current) {
            return previous.items != current.items ||
                previous.loading != current.loading ||
                previous.loadingMore != current.loadingMore ||
                previous.refreshing != current.refreshing ||
                previous.selectedRange != current.selectedRange ||
                previous.errorMessage != current.errorMessage;
          },
          builder: (context, state) {
            return Column(
              children: [
                ///===========================
                /// FILTER
                ///===========================
                const PostingjurnalFilter(),

                ///===========================
                /// SUMMARY
                ///===========================
                const PostingjurnalSummary(),

                const Divider(height: 1),

                ///===========================
                /// LIST AREA
                ///===========================
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Builder(
                      builder: (context) {
                        if (state.loading && state.items.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state.errorMessage != null && state.items.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.cloud_off,
                                    color: Colors.red,
                                    size: 70,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    state.errorMessage!,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  FilledButton.icon(
                                    onPressed: () {
                                      context.read<PostingjurnalBloc>().add(
                                        const LoadPostingjurnals(),
                                      );
                                    },
                                    icon: const Icon(Icons.refresh),
                                    label: const Text("Coba Lagi"),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        if (state.items.isEmpty) {
                          return RefreshIndicator(
                            onRefresh: _refresh,
                            child: ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: const [
                                SizedBox(height: 120),
                                Icon(
                                  Icons.receipt_long,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Center(child: Text("Belum ada posting jurnal")),
                              ],
                            ),
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: _refresh,
                          child: ListView.separated(
                            key: ValueKey(state.items.length),
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 90),
                            itemCount:
                                state.items.length +
                                (state.loadingMore ? 1 : 0),
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 2),
                            itemBuilder: (context, index) {
                              if (index >= state.items.length) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 24),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              final item = state.items[index];

                              return PostingjurnalCard(
                                index: index,
                                item: item,
                                onTap: () {
                                  if (item.hasImage) {
                                    _showImage(item);
                                  }
                                },
                                onEdit: () {
                                  if (user!.isAdmin == true) {
                                    _showAddEditPostingjurnalDialog(data: item);
                                  }
                                },
                                onDelete: () {
                                  if (user!.isAdmin == true) {
                                    _deleteItem(item);
                                  }
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _showAddEditPostingjurnalDialog({Postingjurnal? data}) async {
    final result = await showDialog<bool>(
      context: context,

      barrierDismissible: false,

      builder: (dialogContext) {
        return AddEditPostingjurnalDialog(existingData: data);
      },
    );

    if (result == true && mounted) {
      context.read<PostingjurnalBloc>().add(const RefreshPostingjurnals());
    }
  }
}
