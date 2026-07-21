import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/keluarbiayapermuser/keluarbiayapermuser_bloc.dart';
import 'package:newklikrkw/blocs/keluarbiayapermuser/keluarbiayapermuser_event.dart';
import 'package:newklikrkw/blocs/keluarbiayapermuser/keluarbiayapermuser_state.dart';
import 'package:newklikrkw/pages/dkeluarbiayapermusers/dkeluarbiayapermuser_list_page.dart';
import 'package:newklikrkw/widgets/keluarbiayapermuser_card.dart';

class KeluarbiayapermuserListWidget extends StatefulWidget {
  const KeluarbiayapermuserListWidget({super.key});

  @override
  State<KeluarbiayapermuserListWidget> createState() =>
      _KeluarbiayapermuserListWidgetState();
}

class _KeluarbiayapermuserListWidgetState
    extends State<KeluarbiayapermuserListWidget> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 200) {
      context.read<KeluarbiayapermuserBloc>().add(
        const LoadMoreKeluarbiayapermusers(),
      );
    }
  }

  Future<void> _refresh() async {
    context.read<KeluarbiayapermuserBloc>().add(
      const RefreshKeluarbiayapermusers(),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KeluarbiayapermuserBloc, KeluarbiayapermuserState>(
      builder: (context, state) {
        /// Loading pertama
        if (state.loading && state.keluarbiayapermusers.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        /// Error
        if (state.error != null && state.keluarbiayapermusers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 50),
                const SizedBox(height: 12),
                Text(state.error!),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<KeluarbiayapermuserBloc>().add(
                      const LoadKeluarbiayapermusers(),
                    );
                  },
                  child: const Text("Coba Lagi"),
                ),
              ],
            ),
          );
        }

        /// Empty
        if (state.keluarbiayapermusers.isEmpty) {
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              children: const [
                SizedBox(height: 120),
                Center(child: Text("Belum ada data")),
              ],
            ),
          );
        }

        /// List
        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(12),
            itemCount:
                state.keluarbiayapermusers.length + (state.loadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= state.keluarbiayapermusers.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final item = state.keluarbiayapermusers[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: KeluarbiayapermuserCard(
                  keluarbiayapermuser: item,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DkeluarbiayapermuserListPage(
                          keluarbiayapermuserId: item.id,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
