import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/dkeluarbiaya/dkeluarbiaya_bloc.dart';
import 'package:newklikrkw/blocs/dkeluarbiaya/dkeluarbiaya_event.dart';
import 'package:newklikrkw/blocs/dkeluarbiaya/dkeluarbiaya_state.dart';
import 'package:newklikrkw/models/dkeluarbiaya.dart';

import 'dkeluarbiaya_card.dart';

class DkeluarbiayaListWidget extends StatefulWidget {
  final Function(Dkeluarbiaya item)? onDelete;
  const DkeluarbiayaListWidget({super.key, this.onDelete});

  @override
  State<DkeluarbiayaListWidget> createState() => _DkeluarbiayaListWidgetState();
}

class _DkeluarbiayaListWidgetState extends State<DkeluarbiayaListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final maxScroll = _scrollController.position.maxScrollExtent;

    final current = _scrollController.position.pixels;

    if (current >= maxScroll - 200) {
      context.read<DkeluarbiayaBloc>().add(const LoadMoreDkeluarbiayas());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DkeluarbiayaBloc, DkeluarbiayaState>(
      builder: (context, state) {
        ///======================
        /// Loading Awal
        ///======================
        if (state.loading && state.dkeluarbiayas.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        ///======================
        /// Error
        ///======================
        if (state.errorMessage != null && state.dkeluarbiayas.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48),

                  const SizedBox(height: 12),

                  Text(state.errorMessage!, textAlign: TextAlign.center),

                  const SizedBox(height: 12),

                  FilledButton(
                    onPressed: () {
                      context.read<DkeluarbiayaBloc>().add(
                        LoadDkeluarbiayas(state.keluarbiayaId),
                      );
                    },
                    child: const Text("Muat Ulang"),
                  ),
                ],
              ),
            ),
          );
        }

        ///======================
        /// Empty
        ///======================
        if (state.dkeluarbiayas.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<DkeluarbiayaBloc>().add(
                const RefreshDkeluarbiayas(),
              );
            },
            child: ListView(
              children: const [
                SizedBox(height: 150),

                Icon(Icons.inbox_outlined, size: 64),

                SizedBox(height: 12),

                Center(child: Text("Belum ada data")),
              ],
            ),
          );
        }

        ///======================
        /// List Data
        ///======================
        return RefreshIndicator(
          onRefresh: () async {
            context.read<DkeluarbiayaBloc>().add(const RefreshDkeluarbiayas());
          },
          child: ListView.builder(
            controller: _scrollController,

            itemCount: state.dkeluarbiayas.length + (state.loadingMore ? 1 : 0),

            itemBuilder: (context, index) {
              if (index >= state.dkeluarbiayas.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final item = state.dkeluarbiayas[index];

              return DkeluarbiayaCard(
                item: item,

                onTap: () {
                  // detail
                },

                onEdit: () {
                  //                   final result = await Navigator.push<bool>(
                  //   context,
                  //   MaterialPageRoute(
                  //     fullscreenDialog: true,
                  //     builder: (_) => BlocProvider.value(
                  //       value: context.read<DkeluarbiayaBloc>(),
                  //       child: AddEditDkeluarbiayaDialog(
                  //         keluarbiayaId: item.,
                  //         dkeluarbiaya: item,
                  //       ),
                  //     ),
                  //   ),
                  // );

                  // if (result == true && context.mounted) {
                  //   context.read<DkeluarbiayaBloc>().add(
                  //     const RefreshDkeluarbiayas(),
                  //   );
                  // }
                },

                onDelete: () {
                  widget.onDelete?.call(item);
                  // delete
                },
              );
            },
          ),
        );
      },
    );
  }
}
