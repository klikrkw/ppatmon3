import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:newklikrkw/blocs/postingjurnal/postingjurnal_bloc.dart';
import 'package:newklikrkw/blocs/postingjurnal/postingjurnal_event.dart';
import 'package:newklikrkw/blocs/postingjurnal/postingjurnal_state.dart';

import 'package:newklikrkw/enums/postingjurnal_filter_range.dart';

class PostingjurnalFilter extends StatefulWidget {
  const PostingjurnalFilter({super.key});

  @override
  State<PostingjurnalFilter> createState() => _PostingjurnalFilterState();
}

class _PostingjurnalFilterState extends State<PostingjurnalFilter> {
  final _searchController = TextEditingController();
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostingjurnalBloc, PostingjurnalState>(
      builder: (context, state) {
        _searchController.text = state.keyword;

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
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Cari uraian ...",
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: state.keyword.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();

                                  context.read<PostingjurnalBloc>().add(
                                    const SearchUraianChanged(""),
                                  );
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) {
                        context.read<PostingjurnalBloc>().add(
                          SearchUraianChanged(value),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      context.read<PostingjurnalBloc>().add(
                        const ResetPostingjurnalFilter(),
                      );
                    },
                    icon: const Icon(Icons.refresh),
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
