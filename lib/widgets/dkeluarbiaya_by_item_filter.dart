import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:newklikrkw/blocs/dkeluarbiaya_by_item/dkeluarbiaya_by_item_bloc.dart';
import 'package:newklikrkw/blocs/dkeluarbiaya_by_item/dkeluarbiaya_by_item_event.dart';
import 'package:newklikrkw/blocs/dkeluarbiaya_by_item/dkeluarbiaya_by_item_state.dart';

import 'package:newklikrkw/enums/date_filter_range.dart';
import 'package:newklikrkw/models/itemkegiatan.dart';
import 'package:newklikrkw/widgets/searchable_selection_dialog.dart';

class DkeluarbiayaByItemFilter extends StatelessWidget {
  final List<Itemkegiatan> itemkegiatans;

  const DkeluarbiayaByItemFilter({super.key, required this.itemkegiatans});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DkeluarbiayaByItemBloc, DkeluarbiayaByItemState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///===========================
            /// Date Filter
            ///===========================
            SizedBox(
              height: 42,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  const SizedBox(width: 12),

                  ...DateFilterRange.values.map((range) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(range.label),
                        selected: state.selectedRange == range,
                        onSelected: (_) async {
                          if (range == DateFilterRange.custom) {
                            final picked = await showDateRangePicker(
                              context: context,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                              initialDateRange:
                                  state.startDate != null &&
                                      state.endDate != null
                                  ? DateTimeRange(
                                      start: state.startDate!,
                                      end: state.endDate!,
                                    )
                                  : null,
                            );

                            if (picked != null && context.mounted) {
                              context.read<DkeluarbiayaByItemBloc>().add(
                                ChangeCustomDateRange(
                                  startDate: picked.start,
                                  endDate: picked.end,
                                ),
                              );
                            }

                            return;

                            // final picked = await showDatePicker(
                            //   context: context,
                            //   initialDate: state.selectedDate,
                            //   firstDate: DateTime(2020),
                            //   lastDate: DateTime(2100),
                            // );

                            // if (picked != null && context.mounted) {
                            //   context.read<DkeluarbiayaByItemBloc>().add(
                            //     ChangeCustomDate(picked),
                            //   );
                            // }
                          } else {
                            context.read<DkeluarbiayaByItemBloc>().add(
                              ChangeDateFilterRange(range),
                            );
                          }
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 8),

            ///===========================
            /// Item Kegiatan
            ///===========================
            // SizedBox(
            //   height: 42,
            //   child: ListView(
            //     scrollDirection: Axis.horizontal,
            //     children: [
            //       const SizedBox(width: 12),

            //       FilterChip(
            //         label: const Text("Semua"),
            //         selected: state.selectedItemkegiatanId == null,
            //         onSelected: (_) {
            //           context.read<DkeluarbiayaByItemBloc>().add(
            //             const ChangeItemkegiatanFilter(null),
            //           );
            //         },
            //       ),

            //       const SizedBox(width: 8),
            //       // ...itemkegiatans.map((item) {
            //   return Padding(
            //     padding: const EdgeInsets.only(right: 8),
            //     child: FilterChip(
            //       label: Text(item.namaItemkegiatan),
            //       selected: state.selectedItemkegiatanId == item.id,
            //       onSelected: (_) {
            //         context.read<DkeluarbiayaByItemBloc>().add(
            //           ChangeItemkegiatanFilter(item.id),
            //         );
            //       },
            //     ),
            //   );
            // }),
            //     ],
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: TextFormField(
                readOnly: true,
                controller: TextEditingController(
                  text: state.selectedItemkegiatanId == null
                      ? ''
                      : itemkegiatans
                            .firstWhere(
                              (item) => item.id == state.selectedItemkegiatanId,
                            )
                            .namaItemkegiatan,
                ),
                decoration: InputDecoration(
                  labelText: "Item Kegiatan",
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.category),
                  suffixIcon: const Icon(Icons.search),
                ),
                onTap: () async {
                  final result = await Navigator.push<Itemkegiatan>(
                    context,
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (_) => SearchableSelectionDialog<Itemkegiatan>(
                        title: "Pilih Item Kegiatan",
                        searchHint: "Cari item kegiatan...",
                        items: itemkegiatans,
                        selectedItem: state.selectedItemkegiatanId == null
                            ? null
                            : itemkegiatans.firstWhere(
                                (item) =>
                                    item.id == state.selectedItemkegiatanId,
                              ),
                        itemLabelBuilder: (item) => item.namaItemkegiatan,
                      ),
                    ),
                  );

                  if (!context.mounted) return;
                  if (result != null) {
                    context.read<DkeluarbiayaByItemBloc>().add(
                      ChangeItemkegiatanFilter(result.id),
                    );
                  }
                },
              ),
            ),
            if (state.selectedRange == DateFilterRange.custom)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Periode : ${_periodeText(state)}",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),

            ///===========================
            /// Selected Date
            ///===========================
            // if (state.selectedRange == DateFilterRange.custom)
            //   Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 16),
            //     child: Text(
            //       "Tanggal : ${DateFormat('dd MMM yyyy', 'id').format(state.selectedDate)}",
            //       style: Theme.of(context).textTheme.bodyMedium,
            //     ),
            //   ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  context.read<DkeluarbiayaByItemBloc>().add(
                    const ResetFilterDkeluarbiayasByItem(),
                  );
                },
                icon: const Icon(Icons.refresh),
                label: const Text("Reset Filter"),
              ),
            ),
          ],
        );
      },
    );
  }

  String _periodeText(DkeluarbiayaByItemState state) {
    if (state.startDate == null || state.endDate == null) {
      return "";
    }

    final format = DateFormat("dd MMM yyyy", "id");

    return "${format.format(state.startDate!)} - ${format.format(state.endDate!)}";
  }
}
