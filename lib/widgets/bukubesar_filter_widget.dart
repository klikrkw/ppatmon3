import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:newklikrkw/blocs/bukubesar/bukubesar_bloc.dart';
import 'package:newklikrkw/blocs/bukubesar/bukubesar_event.dart';
import 'package:newklikrkw/blocs/bukubesar/bukubesar_state.dart';
import 'package:newklikrkw/models/bukubesar_filter_range.dart';

class BukubesarFilterWidget extends StatelessWidget {
  const BukubesarFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BukubesarBloc, BukubesarState>(
      buildWhen: (previous, current) =>
          previous.selectedRange != current.selectedRange ||
          previous.startDate != current.startDate ||
          previous.endDate != current.endDate ||
          previous.selectedKodeAkun != current.selectedKodeAkun,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: BukubesarFilterRange.values.map((range) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(range.label),
                      selected: state.selectedRange == range,
                      onSelected: (_) async {
                        if (range == BukubesarFilterRange.custom) {
                          final picked = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                            initialDateRange:
                                state.startDate != null && state.endDate != null
                                ? DateTimeRange(
                                    start: state.startDate!,
                                    end: state.endDate!,
                                  )
                                : null,
                          );

                          if (picked != null && context.mounted) {
                            context.read<BukubesarBloc>().add(
                              ChangeCustomDateRange(
                                startDate: picked.start,
                                endDate: picked.end,
                              ),
                            );
                          }

                          return;
                        }

                        context.read<BukubesarBloc>().add(
                          ChangeFilterRange(range),
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            if (state.selectedRange == BukubesarFilterRange.custom &&
                state.startDate != null &&
                state.endDate != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Text(
                  "${DateFormat('dd MMM yyyy', 'id').format(state.startDate!)}"
                  "  -  "
                  "${DateFormat('dd MMM yyyy', 'id').format(state.endDate!)}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            if (state.kodeAkuns.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    // FilterChip(
                    //   label: const Text("Semua"),
                    //   selected: state.selectedKodeAkun == null,
                    //   onSelected: (_) {
                    //     context.read<BukubesarBloc>().add(
                    //       const ChangeKodeAkun(null),
                    //     );
                    //   },
                    // ),
                    const SizedBox(width: 8),

                    ...state.kodeAkuns.map((e) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(e.namaAkun),
                          selected: state.selectedKodeAkun == e.id,
                          onSelected: (_) {
                            context.read<BukubesarBloc>().add(
                              ChangeKodeAkun(e.id),
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
