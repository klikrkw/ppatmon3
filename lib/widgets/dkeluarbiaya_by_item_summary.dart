import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:newklikrkw/blocs/dkeluarbiaya_by_item/dkeluarbiaya_by_item_bloc.dart';
import 'package:newklikrkw/blocs/dkeluarbiaya_by_item/dkeluarbiaya_by_item_state.dart';

class DkeluarbiayaByItemSummary extends StatelessWidget {
  const DkeluarbiayaByItemSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DkeluarbiayaByItemBloc, DkeluarbiayaByItemState>(
      buildWhen: (previous, current) {
        return previous.items != current.items;
      },
      builder: (context, state) {
        final currency = NumberFormat.currency(
          locale: "id",
          symbol: "Rp ",
          decimalDigits: 0,
        );

        return Card(
          margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  child: const Icon(Icons.payments_outlined),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Pengeluaran",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),

                      const SizedBox(height: 6),

                      Text(
                        currency.format(state.totalBiaya),
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "${state.totalTransaksi} transaksi",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
