import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/keluarbiaya/keluarbiaya_bloc.dart';
import 'package:newklikrkw/blocs/keluarbiaya/keluarbiaya_event.dart';
import 'package:newklikrkw/blocs/keluarbiaya/keluarbiaya_state.dart';
import 'package:newklikrkw/pages/dkeluarbiayas/dkeluarbiaya_list_page.dart';
import 'package:newklikrkw/widgets/keluarbiaya_card.dart';

class KeluarbiayaListWidget extends StatefulWidget {
  const KeluarbiayaListWidget({super.key});

  @override
  State<KeluarbiayaListWidget> createState() => _KeluarbiayaListWidgetState();
}

class _KeluarbiayaListWidgetState extends State<KeluarbiayaListWidget> {
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
      context.read<KeluarbiayaBloc>().add(const LoadMoreKeluarbiayas());
    }
  }

  Future<void> _refresh() async {
    context.read<KeluarbiayaBloc>().add(const RefreshKeluarbiayas());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KeluarbiayaBloc, KeluarbiayaState>(
      builder: (context, state) {
        /// Loading pertama
        if (state.loading && state.keluarbiayas.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        /// Error
        if (state.error != null && state.keluarbiayas.isEmpty) {
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
                    context.read<KeluarbiayaBloc>().add(
                      const LoadKeluarbiayas(),
                    );
                  },
                  child: const Text("Coba Lagi"),
                ),
              ],
            ),
          );
        }

        /// Empty
        if (state.keluarbiayas.isEmpty) {
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
            itemCount: state.keluarbiayas.length + (state.loadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= state.keluarbiayas.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final item = state.keluarbiayas[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: KeluarbiayaCard(
                  keluarbiaya: item,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            DkeluarbiayaListPage(keluarbiayaId: item.id),
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
