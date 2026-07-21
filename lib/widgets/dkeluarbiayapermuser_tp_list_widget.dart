import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/dkeluarbiayapermuser/dkeluarbiayapermuser_bloc.dart';
import 'package:newklikrkw/blocs/dkeluarbiayapermuser/dkeluarbiayapermuser_event.dart';
import 'package:newklikrkw/blocs/dkeluarbiayapermuser/dkeluarbiayapermuser_state.dart';

import 'dkeluarbiayapermuser_card.dart';

class DkeluarbiayapermuserTpListWidget extends StatefulWidget {
  const DkeluarbiayapermuserTpListWidget({super.key});

  @override
  State<DkeluarbiayapermuserTpListWidget> createState() =>
      _DkeluarbiayapermuserTpListWidgetState();
}

class _DkeluarbiayapermuserTpListWidgetState
    extends State<DkeluarbiayapermuserTpListWidget> {
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
      context.read<DkeluarbiayapermuserBloc>().add(
        const LoadMoreDkeluarbiayapermusers(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DkeluarbiayapermuserBloc, DkeluarbiayapermuserState>(
      builder: (context, state) {
        ///======================
        /// Loading Awal
        ///======================
        if (state.loading && state.dkeluarbiayapermusers.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        ///======================
        /// Error
        ///======================
        if (state.errorMessage != null && state.dkeluarbiayapermusers.isEmpty) {
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
                      context.read<DkeluarbiayapermuserBloc>().add(
                        LoadDkeluarbiayapermusers(state.keluarbiayapermuserId),
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
        if (state.dkeluarbiayapermusers.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<DkeluarbiayapermuserBloc>().add(
                const RefreshDkeluarbiayapermusers(),
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
            context.read<DkeluarbiayapermuserBloc>().add(
              const RefreshDkeluarbiayapermusers(),
            );
          },
          child: ListView.builder(
            controller: _scrollController,

            itemCount:
                state.dkeluarbiayapermusers.length +
                (state.loadingMore ? 1 : 0),

            itemBuilder: (context, index) {
              if (index >= state.dkeluarbiayapermusers.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final item = state.dkeluarbiayapermusers[index];

              return DkeluarbiayapermuserCard(
                item: item,
                withTranspermohonan: false,
                onTap: () {
                  // detail
                },

                onEdit: () {},

                onDelete: () {},
              );
            },
          ),
        );
      },
    );
  }
}
