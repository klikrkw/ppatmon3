import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:newklikrkw/blocs/dkeluarbiaya_by_item/dkeluarbiaya_by_item_bloc.dart';
import 'package:newklikrkw/blocs/dkeluarbiaya_by_item/dkeluarbiaya_by_item_event.dart';
import 'package:newklikrkw/blocs/dkeluarbiaya_by_item/dkeluarbiaya_by_item_state.dart';

import 'package:newklikrkw/repositories/dkeluarbiaya_by_item_repository.dart';
import 'package:newklikrkw/services/dkeluarbiaya_by_item_service.dart';

import 'package:newklikrkw/widgets/dkeluarbiaya_by_item_filter.dart';
import 'package:newklikrkw/widgets/dkeluarbiaya_by_item_summary.dart';
import 'package:newklikrkw/widgets/dkeluarbiaya_card.dart';

class DkeluarbiayasByItemPage extends StatelessWidget {
  // final List<Itemkegiatan> itemkegiatans;

  const DkeluarbiayasByItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DkeluarbiayaByItemBloc(
        repository: DkeluarbiayaByItemRepository(
          service: DkeluarbiayaByItemService(),
        ),
      )..add(const LoadDkeluarbiayasByItem()),
      child: const _Body(),
    );
  }
}

class _Body extends StatefulWidget {
  // final List<Itemkegiatan> itemkegiatans;

  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    context.read<DkeluarbiayaByItemBloc>().add(const LoadItemkegiatans());

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

    final max = _scrollController.position.maxScrollExtent;

    final current = _scrollController.position.pixels;

    if (current >= max - 250) {
      context.read<DkeluarbiayaByItemBloc>().add(
        const LoadMoreDkeluarbiayasByItem(),
      );
    }
  }

  Future<void> _refresh() async {
    context.read<DkeluarbiayaByItemBloc>().add(
      const RefreshDkeluarbiayasByItem(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pengeluaran Per Item")),
      body: BlocConsumer<DkeluarbiayaByItemBloc, DkeluarbiayaByItemState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Column(
            children: [
              DkeluarbiayaByItemFilter(itemkegiatans: state.itemkegiatans),

              const DkeluarbiayaByItemSummary(),

              Expanded(
                child: Builder(
                  builder: (context) {
                    ///===========================
                    /// Loading Pertama
                    ///===========================
                    if (state.loading && state.items.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    ///===========================
                    /// Error
                    ///===========================
                    if (state.errorMessage != null && state.items.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 72,
                                color: Colors.red,
                              ),

                              const SizedBox(height: 16),

                              Text(
                                state.errorMessage!,
                                textAlign: TextAlign.center,
                              ),

                              const SizedBox(height: 20),

                              FilledButton.icon(
                                onPressed: () {
                                  context.read<DkeluarbiayaByItemBloc>().add(
                                    const LoadDkeluarbiayasByItem(),
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

                    ///===========================
                    /// Empty
                    ///===========================
                    if (state.items.isEmpty) {
                      return RefreshIndicator(
                        onRefresh: _refresh,
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(height: 150),

                            Icon(
                              Icons.receipt_long,
                              size: 80,
                              color: Colors.grey,
                            ),

                            SizedBox(height: 16),

                            Center(child: Text("Tidak ada data")),
                          ],
                        ),
                      );
                    }

                    ///===========================
                    /// List
                    ///===========================

                    return RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount:
                            state.items.length + (state.loadingMore ? 1 : 0),
                        itemBuilder: (_, index) {
                          if (index >= state.items.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          final item = state.items[index];

                          return DkeluarbiayaCard(
                            item: item,

                            onTap: () {
                              // detail
                            },

                            onEdit: () {
                              // edit
                            },

                            onDelete: () {
                              // delete
                            },
                          );
                        },
                      ),
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
}
