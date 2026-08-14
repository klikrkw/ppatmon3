import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:newklikrkw/blocs/catatanperm/catatanperm_bloc.dart';
import 'package:newklikrkw/blocs/catatanperm/catatanperm_event.dart';
import 'package:newklikrkw/blocs/catatanperm/catatanperm_state.dart';

// import 'package:newklikrkw/enums/catatanperm_date_filter.dart';

import 'package:newklikrkw/models/catatanperm.dart';

import 'package:newklikrkw/repositories/catatanperm_repository.dart';
import 'package:newklikrkw/services/catatanperm_service.dart';
import 'package:newklikrkw/utils/dio.dart';
import 'package:newklikrkw/widgets/catatanperm_card.dart';
import 'package:newklikrkw/widgets/dialogs/add_edit_catatanperm_dialog.dart';
import 'package:newklikrkw/widgets/image_preview_dialog.dart';

class CatatanpermListPage extends StatelessWidget {
  final String? transpermohonanId;

  const CatatanpermListPage({super.key, this.transpermohonanId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CatatanpermBloc(
              repository: CatatanpermRepository(service: CatatanpermService()),
              transpermohonanId: transpermohonanId,
            )
            ..add(LoadCatatanperms(transpermohonanId: transpermohonanId))
            ..add(const LoadFieldcatatans()),
      child: const _CatatanpermListBody(),
    );
  }
}

class _CatatanpermListBody extends StatefulWidget {
  const _CatatanpermListBody();

  @override
  State<_CatatanpermListBody> createState() => _CatatanpermListBodyState();
}

class _CatatanpermListBodyState extends State<_CatatanpermListBody> {
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();

    _searchController.dispose();

    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 250) {
      context.read<CatatanpermBloc>().add(const LoadMoreCatatanperms());
    }
  }

  // Future<void> _selectDate() async {
  //   final state = context.read<CatatanpermBloc>().state;

  //   final result = await showDatePicker(
  //     context: context,
  //     initialDate: state.selectedDate,
  //     firstDate: DateTime(2020),
  //     lastDate: DateTime.now(),
  //   );

  //   if (result == null) return;

  //   if (!mounted) return;

  //   context.read<CatatanpermBloc>().add(ChangeCatatanpermCustomDate(result));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catatan Permohonan')),
      body: BlocBuilder<CatatanpermBloc, CatatanpermState>(
        builder: (context, state) {
          return Column(
            children: [
              _buildFilter(state),
              SizedBox(height: 16),
              Expanded(child: _buildList(state)),
            ],
          );
        },
      ),

      floatingActionButton: BlocBuilder<CatatanpermBloc, CatatanpermState>(
        builder: (context, state) {
          return FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (_) => AddEditCatatanpermDialog(
                    transpermohonanId: state.transpermohonanId!,
                  ),
                ),
              );

              if (result == true && context.mounted) {
                context.read<CatatanpermBloc>().add(
                  const RefreshCatatanperms(),
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildFilter(CatatanpermState state) {
    return Material(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            /// Search isi catatan
            TextField(
              controller: _searchController,
              onChanged: (value) {
                context.read<CatatanpermBloc>().add(
                  SearchCatatanpermChanged(value),
                );
              },
              decoration: InputDecoration(
                labelText: 'Cari isi catatan',
                hintText: 'Masukkan isi catatan...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();

                          context.read<CatatanpermBloc>().add(
                            const SearchCatatanpermChanged(''),
                          );

                          setState(() {});
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
            ),

            // const SizedBox(height: 10),

            /// Filter tanggal
            // _buildDateFilter(state),
            const SizedBox(height: 10),

            /// Field catatan
            _buildFieldcatatanFilter(state),
          ],
        ),
      ),
    );
  }

  // Widget _buildDateFilter(CatatanpermState state) {
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Row(
  //       children: [
  //         _dateChip(state, CatatanpermDateFilter.today, 'Hari Ini'),

  //         const SizedBox(width: 8),

  //         _dateChip(state, CatatanpermDateFilter.last7Days, '7 Hari Terakhir'),

  //         const SizedBox(width: 8),

  //         _dateChip(state, CatatanpermDateFilter.thisMonth, 'Bulan Ini'),

  //         const SizedBox(width: 8),

  //         _dateChip(state, CatatanpermDateFilter.thisYear, 'Tahun Ini'),

  //         const SizedBox(width: 8),

  //         ActionChip(
  //           avatar: const Icon(Icons.calendar_month, size: 18),
  //           label: Text(
  //             state.selectedDateFilter == CatatanpermDateFilter.custom
  //                 ? _formatDate(state.selectedDate)
  //                 : 'Tanggal',
  //           ),
  //           onPressed: _selectDate,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _dateChip(
  //   CatatanpermState state,
  //   CatatanpermDateFilter filter,
  //   String label,
  // ) {
  //   return ChoiceChip(
  //     label: Text(label),
  //     selected: state.selectedDateFilter == filter,
  //     onSelected: (_) {
  //       context.read<CatatanpermBloc>().add(
  //         ChangeCatatanpermDateFilter(filter),
  //       );
  //     },
  //   );
  // }

  Widget _buildFieldcatatanFilter(CatatanpermState state) {
    final fieldcatatans = state.fieldcatatans;

    return DropdownButtonFormField<int?>(
      initialValue: state.selectedFieldcatatanId,
      decoration: const InputDecoration(
        labelText: 'Field Catatan',
        prefixIcon: Icon(Icons.category),
        border: OutlineInputBorder(),
      ),
      items: [
        const DropdownMenuItem<int?>(value: null, child: Text('Semua Field')),

        ...fieldcatatans.map(
          (item) => DropdownMenuItem<int?>(
            value: item.id,
            child: Text(item.namaFieldcatatan),
          ),
        ),
      ],
      onChanged: (value) {
        context.read<CatatanpermBloc>().add(
          ChangeCatatanpermFieldcatatanFilter(value),
        );
      },
    );
  }

  Widget _buildList(CatatanpermState state) {
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
              const Icon(Icons.error_outline, size: 64, color: Colors.red),

              const SizedBox(height: 16),

              Text(state.errorMessage!, textAlign: TextAlign.center),

              const SizedBox(height: 20),

              FilledButton.icon(
                onPressed: () {
                  context.read<CatatanpermBloc>().add(const LoadCatatanperms());
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.items.isEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          context.read<CatatanpermBloc>().add(const RefreshCatatanperms());
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 120),
            Icon(Icons.notes, size: 72, color: Colors.grey),
            SizedBox(height: 16),
            Center(child: Text('Tidak ada catatan')),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () async {
        context.read<CatatanpermBloc>().add(const RefreshCatatanperms());
      },
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: state.items.length + (state.loadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.items.length) {
            return const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final item = state.items[index];
          return CatatanpermCard(
            item: item,
            index: index,
            onImageTap: () {
              if (item.hasImage) {
                _showImage(item);
              }
            },
            onEdit: () async {
              final result = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (_) => AddEditCatatanpermDialog(
                    transpermohonanId: item.transpermohonanId,
                    catatanperm: item,
                  ),
                ),
              );
              if (!mounted) return;

              if (result == true && context.mounted) {
                context.read<CatatanpermBloc>().add(
                  const RefreshCatatanperms(),
                );
              }
            },
            onDelete: () {
              _deleteItem(item);
            },
          );
        },
      ),
    );
  }

  // String _formatDate(DateTime date) {
  //   final d = date.day.toString().padLeft(2, '0');

  //   final m = date.month.toString().padLeft(2, '0');

  //   return '$d/$m/${date.year}';
  // }

  void _showImage(Catatanperm item) {
    if (!item.hasImage) {
      return;
    }

    showDialog(
      context: context,
      builder: (_) => ImagePreviewDialog(
        imageUrl: "$myBaseUrl${item.imageCatatanperm}",
        heroTag: 'catatanperm',
      ),
    );
  }

  void _deleteItem(Catatanperm item) async {
    final ok = await _confirmDelete(context);

    if (!mounted || !ok) {
      return;
    }
    context.read<CatatanpermBloc>().add(DeleteCatatanperm(item.id));
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text("Konfirmasi"),
              content: const Text("Yakin ingin menghapus catatan ini?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text("Batal"),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text("Hapus"),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
