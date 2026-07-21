import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:newklikrkw/blocs/postingjurnal/postingjurnal_bloc.dart';
import 'package:newklikrkw/blocs/postingjurnal/postingjurnal_event.dart';
import 'package:newklikrkw/blocs/postingjurnal/postingjurnal_state.dart';

import 'package:newklikrkw/enums/postingjurnal_filter_range.dart';

class PostingjurnalFilter extends StatelessWidget {
  const PostingjurnalFilter({super.key});

  Future<void> _selectPeriod(BuildContext context) async {
    final bloc = context.read<PostingjurnalBloc>();

    final state = bloc.state;

    final result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDateRange: DateTimeRange(
        start: state.startDate,
        end: state.endDate,
      ),
    );

    if (result == null) {
      return;
    }

    bloc.add(
      ChangePostingjurnalPeriod(
        startDate: result.start,
        endDate: DateTime(
          result.end.year,
          result.end.month,
          result.end.day,
          23,
          59,
          59,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostingjurnalBloc, PostingjurnalState>(
      builder: (context, state) {
        return Column(
          children: [
            const SizedBox(height: 8),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  ...PostingjurnalFilterRange.values.map((range) {
                    final selected = state.selectedRange == range;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(range.label),
                        selected: selected,
                        onSelected: (_) async {
                          if (range == PostingjurnalFilterRange.custom) {
                            await _selectPeriod(context);
                            return;
                          }

                          context.read<PostingjurnalBloc>().add(
                            ChangePostingjurnalFilterRange(range),
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),

            if (state.selectedRange == PostingjurnalFilterRange.custom)
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 8,
                  bottom: 8,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.date_range, size: 18),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        "${DateFormat('dd MMM yyyy').format(state.startDate)}  -  ${DateFormat('dd MMM yyyy').format(state.endDate)}",
                      ),
                    ),

                    TextButton.icon(
                      onPressed: () => _selectPeriod(context),
                      icon: const Icon(Icons.edit),
                      label: const Text("Ubah"),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
