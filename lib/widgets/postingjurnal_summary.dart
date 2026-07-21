import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:newklikrkw/blocs/postingjurnal/postingjurnal_bloc.dart';
import 'package:newklikrkw/blocs/postingjurnal/postingjurnal_state.dart';

class PostingjurnalSummary extends StatelessWidget {
  const PostingjurnalSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(
      locale: "id",
      symbol: "Rp ",
      decimalDigits: 0,
    );

    return BlocBuilder<PostingjurnalBloc, PostingjurnalState>(
      buildWhen: (previous, current) => previous.items != current.items,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Posting",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),

                        const SizedBox(height: 8),

                        Text(
                          state.totalPosting.toString(),
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Nominal",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),

                        const SizedBox(height: 8),

                        Text(
                          currency.format(state.totalJumlah),
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
