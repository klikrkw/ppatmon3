import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:newklikrkw/blocs/bukubesar/bukubesar_bloc.dart';
import 'package:newklikrkw/blocs/bukubesar/bukubesar_event.dart';
import 'package:newklikrkw/blocs/bukubesar/bukubesar_state.dart';

import 'package:newklikrkw/models/bukubesar_filter_range.dart';

import 'package:newklikrkw/widgets/bukubesar_card.dart';
import 'package:newklikrkw/widgets/bukubesar_filter_widget.dart';

class BukubesarListPage extends StatefulWidget {
  const BukubesarListPage({super.key});

  @override
  State<BukubesarListPage> createState() => _BukubesarListPageState();
}

class _BukubesarListPageState extends State<BukubesarListPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<BukubesarBloc>().add(const LoadKodeAkuns());
      context.read<BukubesarBloc>().add(
        const ChangeFilterRange(BukubesarFilterRange.today),
      );
    });
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

    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 250) {
      context.read<BukubesarBloc>().add(const LoadMoreBukubesars());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buku Besar"), centerTitle: true),
      body: BlocBuilder<BukubesarBloc, BukubesarState>(
        buildWhen: (previous, current) {
          return previous.items != current.items ||
              previous.loading != current.loading ||
              previous.loadingMore != current.loadingMore ||
              previous.refreshing != current.refreshing ||
              previous.errorMessage != current.errorMessage ||
              previous.selectedRange != current.selectedRange ||
              previous.startDate != current.startDate ||
              previous.endDate != current.endDate;
        },
        builder: (context, state) {
          return Column(
            children: [
              /// Summary Card
              _buildSummaryCard(state),

              /// Filter
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: BukubesarFilterWidget(),
              ),

              /// Periode
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month, size: 18),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        _periodeText(state),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Builder(
                    key: ValueKey(state.selectedRange),
                    builder: (context) {
                      /// isi list akan dibuat pada
                      /// Bagian 2

                      if (state.loading && state.items.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state.errorMessage != null && state.items.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 70,
                                  color: Colors.red,
                                ),

                                const SizedBox(height: 16),

                                Text(
                                  state.errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 16),
                                ),

                                const SizedBox(height: 20),

                                FilledButton.icon(
                                  onPressed: _reload,
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
                              SizedBox(height: 140),

                              Icon(
                                Icons.receipt_long,
                                size: 80,
                                color: Colors.grey,
                              ),

                              SizedBox(height: 12),

                              Center(
                                child: Text(
                                  "Belum ada transaksi",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<BukubesarBloc>().add(
                            const RefreshBukubesars(),
                          );
                        },
                        child: ListView.separated(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 20),
                          itemCount:
                              state.items.length + (state.loadingMore ? 1 : 0),
                          separatorBuilder: (_, _) => const SizedBox(height: 4),
                          itemBuilder: (context, index) {
                            /// Footer Loading
                            if (index >= state.items.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final item = state.items[index];

                            return BukubesarCard(
                              item: item,
                              index: index,
                              onTap: () {
                                /// Optional:
                                /// buka detail transaksi
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
    );
  }

  Widget _buildSummaryCard(BukubesarState state) {
    final currency = NumberFormat.currency(
      locale: "id",
      symbol: "Rp ",
      decimalDigits: 0,
    );

    return Card(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                  child: Icon(
                    Icons.account_balance_wallet,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Saldo Akhir",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        currency.format(state.saldoAkhir),
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Divider(height: 28),

            Row(
              children: [
                Expanded(
                  child: _summaryItem(
                    "Debet",
                    currency.format(state.totalDebet),
                    Colors.green,
                  ),
                ),

                Expanded(
                  child: _summaryItem(
                    "Kredit",
                    currency.format(state.totalKredit),
                    Colors.red,
                  ),
                ),

                Expanded(
                  child: _summaryItem(
                    "Transaksi",
                    state.items.length.toString(),
                    Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryItem(String title, String value, Color color) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.grey)),

        const SizedBox(height: 6),

        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  String _periodeText(BukubesarState state) {
    if (state.startDate == null || state.endDate == null) {
      return "";
    }

    final format = DateFormat("dd MMM yyyy", "id");

    return "${format.format(state.startDate!)} - ${format.format(state.endDate!)}";
  }

  void _reload() {
    context.read<BukubesarBloc>().add(const LoadBukubesars());
  }

  Future<void> _refresh() async {
    context.read<BukubesarBloc>().add(const RefreshBukubesars());
  }
}
