import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:newklikrkw/blocs/neraca/neraca_bloc.dart';
import 'package:newklikrkw/blocs/neraca/neraca_event.dart';
import 'package:newklikrkw/blocs/neraca/neraca_state.dart';
import 'package:newklikrkw/widgets/neraca_card.dart';
import 'package:intl/intl.dart';

final NumberFormat _currency = NumberFormat.currency(
  locale: "id",
  symbol: "Rp ",
  decimalDigits: 0,
);

class NeracaPage extends StatefulWidget {
  const NeracaPage({super.key});

  @override
  State<NeracaPage> createState() => _NeracaPageState();
}

class _NeracaPageState extends State<NeracaPage> {
  late final List<int> _years;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now().year;

    _years = List.generate(10, (index) => now - index);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<NeracaBloc>().add(const LoadNeraca());
    });
  }

  Future<void> _refresh() async {
    context.read<NeracaBloc>().add(const RefreshNeraca());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Neraca"), centerTitle: true),
      body: BlocConsumer<NeracaBloc, NeracaState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          if (state.errorMessage != null && state.items.isNotEmpty) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        buildWhen: (previous, current) {
          return previous != current;
        },
        builder: (context, state) {
          return Column(
            children: [
              /// ===========================
              /// Filter Tahun
              /// ===========================
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: _buildYearDropdown(context, state),
              ),

              /// ===========================
              /// Summary
              /// ===========================
              _buildSummaryCard(state),

              const SizedBox(height: 8),

              /// ===========================
              /// List Neraca
              /// ===========================
              Expanded(
                child: Builder(
                  builder: (context) {
                    ///==========================
                    /// Loading pertama
                    ///==========================
                    if (state.loading && state.items.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    ///==========================
                    /// Error
                    ///==========================
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
                                  context.read<NeracaBloc>().add(
                                    const LoadNeraca(),
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

                    ///==========================
                    /// Empty
                    ///==========================
                    if (state.items.isEmpty) {
                      return RefreshIndicator(
                        onRefresh: _refresh,
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(height: 150),

                            Icon(
                              Icons.account_balance,
                              size: 80,
                              color: Colors.grey,
                            ),

                            SizedBox(height: 16),

                            Center(child: Text("Data neraca tidak tersedia")),
                          ],
                        ),
                      );
                    }

                    ///==========================
                    /// List Neraca
                    ///==========================
                    return RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 20),
                        itemCount: state.items.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 2),
                        itemBuilder: (context, index) {
                          final item = state.items[index];

                          return NeracaCard(item: item);
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

  /// ====================================================
  /// Akan dibuat pada Tahap 4B-3
  /// ====================================================

  Widget _buildYearDropdown(BuildContext context, NeracaState state) {
    return DropdownButtonFormField<int>(
      initialValue: state.selectedYear,
      decoration: const InputDecoration(
        labelText: "Tahun",
        prefixIcon: Icon(Icons.calendar_today),
        border: OutlineInputBorder(),
        isDense: true,
      ),
      items: _years.map((year) {
        return DropdownMenuItem(value: year, child: Text(year.toString()));
      }).toList(),
      onChanged: (value) {
        if (value == null) return;

        context.read<NeracaBloc>().add(ChangeYear(value));
      },
    );
  }

  Widget _buildSummaryCard(NeracaState state) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _summaryTile(
                    title: "Total Debet",
                    value: _currency.format(state.totalDebet),
                    color: Colors.green,
                    icon: Icons.arrow_downward,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _summaryTile(
                    title: "Total Kredit",
                    value: _currency.format(state.totalKredit),
                    color: Colors.red,
                    icon: Icons.arrow_upward,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: state.isBalance
                    ? Colors.green.shade50
                    : Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    state.isBalance ? Icons.check_circle : Icons.warning,
                    color: state.isBalance ? Colors.green : Colors.red,
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.isBalance ? "Balance" : "Tidak Balance",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),

                        if (!state.isBalance)
                          Text("Selisih : ${_currency.format(state.selisih)}"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryTile({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),

          const SizedBox(height: 8),

          Text(
            title,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 6),

          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
