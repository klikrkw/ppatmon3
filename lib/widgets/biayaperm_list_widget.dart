import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:newklikrkw/blocs/biayaperm/biayaperm_bloc.dart';
import 'package:newklikrkw/pages/bayarbiayaperms/bayarbiayaperm_page.dart';
import 'package:newklikrkw/utils/format.dart';
import 'package:newklikrkw/utils/utils.dart';

class BiayapermListWidget extends StatefulWidget {
  final String? transpermohonanId;

  const BiayapermListWidget({super.key, this.transpermohonanId});

  @override
  State<BiayapermListWidget> createState() => _BiayapermListWidgetState();
}

class _BiayapermListWidgetState extends State<BiayapermListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    context.read<BiayapermBloc>().add(
      FilterTranspermohonanBiayaperm(
        widget.transpermohonanId,
        isTranspermohonanId: true,
      ),
    );

    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant BiayapermListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.transpermohonanId != widget.transpermohonanId) {
      context.read<BiayapermBloc>().add(
        FilterTranspermohonanBiayaperm(
          widget.transpermohonanId,
          isTranspermohonanId: true,
        ),
      );
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final max = _scrollController.position.maxScrollExtent;

    final current = _scrollController.position.pixels;

    if (current >= max - 200) {
      context.read<BiayapermBloc>().add(
        LoadBiayaperms(isTranspermohonanId: true),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BiayapermBloc, BiayapermState>(
      builder: (context, state) {
        if (state.loading && state.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.items.isEmpty) {
          return const Center(child: Text('Data biaya belum tersedia'));
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<BiayapermBloc>().add(
              LoadBiayaperms(refresh: true, isTranspermohonanId: true),
            );
          },
          child: ListView.separated(
            controller: _scrollController,

            itemCount: state.items.length + (state.hasReachedMax ? 0 : 1),

            separatorBuilder: (_, _) => const Divider(height: 1),

            itemBuilder: (context, index) {
              if (index >= state.items.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final item = state.items[index];

              return InkWell(
                key: ValueKey(item),
                onTap: () {
                  context.read<BiayapermBloc>().add(LoadBiayaperm(item.id));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BayarbiayapermPage(biayaperm: item),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.all(8),

                  child: ListTile(
                    title: Row(
                      children: [
                        Text(
                          item.id,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Spacer(),
                        Text(
                          DateFormat('dd/MM/yyyy').format(item.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(item.catatanBiayaperm),
                            const Spacer(),
                            Text(
                              item.user.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceBright,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),

                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2, // Takes up 2/6 (33%) of the width
                                    child: Text("Jumlah Biaya "),
                                  ),
                                  Expanded(
                                    flex: 2, // Takes up 2/6 (33%) of the width
                                    child: Text(
                                      '${formatToRupiah<double>(item.jumlahBiayaperm)} ',
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2, // Takes up 2/6 (33%) of the width
                                    child: Text("Jumlah Keluar "),
                                  ),
                                  Expanded(
                                    flex: 2, // Takes up 2/6 (33%) of the width
                                    child: Text(
                                      '${formatToRupiah<double>(item.jumlahKeluar)} ',
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2, // Takes up 2/6 (33%) of the width
                                    child: Text("Jumlah Bayar "),
                                  ),
                                  Expanded(
                                    flex: 2, // Takes up 2/6 (33%) of the width
                                    child: Text(
                                      '${formatToRupiah<double>(item.jumlahBayar)} ',
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2, // Takes up 2/6 (33%) of the width
                                    child: Text("Kurang Bayar "),
                                  ),
                                  Expanded(
                                    flex: 2, // Takes up 2/6 (33%) of the width
                                    child: Text(
                                      '${formatToRupiah<double>(item.kurangBayar)} ',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),

                    trailing: (item.kurangBayar == 0)
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : const Icon(Icons.warning, color: Colors.orange),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
