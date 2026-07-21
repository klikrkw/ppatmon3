import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/biayaperm/biayaperm_bloc.dart';
import 'package:newklikrkw/repositories/transpermohonan_repository.dart';
import 'package:newklikrkw/services/trans_permohonan_service.dart';
import 'package:newklikrkw/utils/utils.dart';
import 'package:newklikrkw/widgets/trans_permohonan_bottom_sheet.dart';

class BiayapermListPage extends StatefulWidget {
  final String? transpermohonanId;

  const BiayapermListPage({super.key, this.transpermohonanId});

  @override
  State<BiayapermListPage> createState() => _BiayapermListPageState();
}

class _BiayapermListPageState extends State<BiayapermListPage> {
  final ScrollController _controller = ScrollController();

  final TextEditingController _transController = TextEditingController();
  late final TranspermohonanRepository transpermohonanRepository;
  final _transpermohonanService = TranspermohonanService();

  @override
  void initState() {
    super.initState();

    _transController.text = widget.transpermohonanId ?? '';
    transpermohonanRepository = TranspermohonanRepository(
      _transpermohonanService,
    );

    context.read<BiayapermBloc>().add(
      FilterTranspermohonanBiayaperm(
        widget.transpermohonanId,
        isTranspermohonanId: false,
      ),
    );

    _controller.addListener(() {
      if (_controller.position.pixels >=
          _controller.position.maxScrollExtent - 200) {
        context.read<BiayapermBloc>().add(LoadBiayaperms());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biaya Permohonan')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _transController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'No Daftar Permohonan',
                      prefixIcon: const Icon(Icons.person),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_transController.text.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: _clearText,
                            ),
                          IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: _cariPermohonan,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          BlocBuilder<BiayapermBloc, BiayapermState>(
            builder: (context, state) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: StatusBiayas.values.map((status) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        avatar: Icon(status.icon),
                        label: Text(status.label),
                        showCheckmark: false,
                        selected: state.status == status,
                        onSelected: (_) {
                          context.read<BiayapermBloc>().add(
                            FilterStatusBiayaperm(status),
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
          SizedBox(height: 8),
          const Divider(),
          Expanded(
            child: BlocBuilder<BiayapermBloc, BiayapermState>(
              builder: (context, state) {
                if (state.loading && state.items.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  controller: _controller,

                  itemCount: state.items.length + (state.hasReachedMax ? 0 : 1),

                  itemBuilder: (context, index) {
                    if (index >= state.items.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final item = state.items[index];

                    return Card(
                      margin: const EdgeInsets.all(8),

                      child: ListTile(
                        title: Text(item.id),

                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Wrap(
                                spacing: 2,
                                children: <Widget>[
                                  Text(item.transpermohonan.noDaftar),
                                  Text(', '),
                                  Text(item.transpermohonan.namaPenerima),
                                  Text(', '),
                                  Text(item.transpermohonan.jenisPermohonan),
                                  Text(', '),
                                  Text(item.transpermohonan.alasHak),
                                  Text(', '),
                                  Text(item.transpermohonan.letakObyek),
                                  Text(', users: '),
                                  Text(
                                    item.transpermohonan.users
                                        .map((e) => e.name)
                                        .join(),
                                  ),
                                  Divider(),
                                ],
                              ),
                            ),

                            Text(item.catatanBiayaperm),
                            Container(
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(8),
                                ),
                                color: Theme.of(
                                  context,
                                ).colorScheme.primaryContainer,
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2, // Takes up 2/6 (33%) of the width
                                    child: Text(
                                      'Jumlah',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ),
                                  // Expanded(
                                  //   flex: 2, // Takes up 3/6 (50%) of the width
                                  //   child: Text(
                                  //     'Keluar',
                                  //     style: Theme.of(
                                  //       context,
                                  //     ).textTheme.bodySmall,
                                  //   ),
                                  // ),
                                  Expanded(
                                    flex: 2, // Takes up 3/6 (50%) of the width
                                    child: Text(
                                      'Bayar',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2, // Takes up 1/6 (17%) of the width
                                    child: Text(
                                      'Kurang',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(8),
                                ),
                              ),
                              padding: const EdgeInsets.only(
                                bottom: 8,
                                top: 8,
                                left: 8,
                                right: 8,
                              ),

                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2, // Takes up 2/6 (33%) of the width
                                    child: Text(
                                      '${formatToRupiah<double>(item.jumlahBiayaperm)} ',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ),
                                  // Expanded(
                                  //   flex: 2, // Takes up 3/6 (50%) of the width
                                  //   child: Text(
                                  //     '${formatToRupiah<double>(item.jumlahKeluar)} ',
                                  //     style: Theme.of(
                                  //       context,
                                  //     ).textTheme.bodySmall,
                                  //   ),
                                  // ),
                                  Expanded(
                                    flex: 2, // Takes up 3/6 (50%) of the width
                                    child: Text(
                                      '${formatToRupiah<double>(item.jumlahBayar)} ',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2, // Takes up 1/6 (17%) of the width
                                    child: Text(
                                      '${formatToRupiah<double>(item.kurangBayar)} ',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        trailing: item.kurangBayar == 0
                            ? const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            : const Icon(Icons.warning, color: Colors.orange),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _cariPermohonan() async {
    final result = await showTranspermohonanBottomSheet(
      context,
      transpermohonanRepository,
    );

    if (result != null) {
      setState(() {
        _transController.text = result.id;
      });
      if (mounted) {
        context.read<BiayapermBloc>().add(
          FilterTranspermohonanBiayaperm(result.id, isTranspermohonanId: true),
        );
      }
    }
  }

  void _clearText() {
    setState(() {
      _transController.clear();
    });

    if (mounted) {
      context.read<BiayapermBloc>().add(FilterTranspermohonanBiayaperm(''));
    }
  }
}
