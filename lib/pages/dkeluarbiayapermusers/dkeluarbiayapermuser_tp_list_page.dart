import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/dkeluarbiayapermuser/dkeluarbiayapermuser_bloc.dart';
import 'package:newklikrkw/blocs/dkeluarbiayapermuser/dkeluarbiayapermuser_event.dart';
import 'package:newklikrkw/blocs/dkeluarbiayapermuser/dkeluarbiayapermuser_state.dart';
import 'package:newklikrkw/blocs/transpermohonan/transpermohonan_bloc.dart';
import 'package:newklikrkw/blocs/transpermohonan/transpermohonan_event.dart';
import 'package:newklikrkw/blocs/transpermohonan/transpermohonan_state.dart';
import 'package:newklikrkw/repositories/dkeluarbiayapermuser_repository.dart';
import 'package:newklikrkw/repositories/transpermohonan_repository.dart';
import 'package:newklikrkw/services/dkeluarbiayapermuser_service.dart';
import 'package:newklikrkw/services/trans_permohonan_service.dart';
import 'package:newklikrkw/utils/format.dart';
import 'package:newklikrkw/widgets/dkeluarbiayapermuser_tp_list_widget.dart';

class DkeluarbiayapermuserTpListPage extends StatelessWidget {
  final String transpermohonanId;

  const DkeluarbiayapermuserTpListPage({
    super.key,
    required this.transpermohonanId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => DkeluarbiayapermuserBloc(
            repository: DkeluarbiayapermuserRepository(
              service: DkeluarbiayapermuserService(),
            ),
          )..add(FilterByTranspermohonanId(transpermohonanId)),
        ),
        BlocProvider(
          create: (context) =>
              TranspermohonanBloc(
                TranspermohonanRepository(TranspermohonanService()),
              )..add(
                FilterTranspermohonanId(
                  transpermohonanId: transpermohonanId,
                  isTranspermohonanId: true,
                ),
              ),
        ),
      ],
      child: _Body(transpermohonanId: transpermohonanId),
    );
  }
}

class _Body extends StatelessWidget {
  final String transpermohonanId;

  const _Body({required this.transpermohonanId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pengeluaran Biaya")),

      body: BlocListener<DkeluarbiayapermuserBloc, DkeluarbiayapermuserState>(
        listenWhen: (previous, current) =>
            previous.deleteSuccess != current.deleteSuccess,
        listener: (context, state) {
          if (state.deleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Data berhasil dihapus")),
            );

            context.read<DkeluarbiayapermuserBloc>().add(
              const ResetDeleteState(),
            );
          }
        },
        child: Column(
          children: [
            BlocBuilder<TranspermohonanBloc, TranspermohonanState>(
              builder: (context, state) {
                if (state.item == null) return Container();
                return Container(
                  // padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  height: 130,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(state.item!.id),
                        subtitle: Text('${state.item!.namaPenerima} '),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${state.item!.noDaftar} | ${state.item!.jenisPermohonan} ',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const Spacer(),
                                Text(
                                  state.item!.users
                                      .map((user) => user.name)
                                      .join(', '),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  state.item!.alasHak,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const Spacer(),
                                Text(
                                  state.item!.letakObyek,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            BlocBuilder<DkeluarbiayapermuserBloc, DkeluarbiayapermuserState>(
              builder: (context, state) {
                if (state.keluarbiayapermuser == null) return Container();
                return Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  height: 150,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListTile(
                          title: Text(state.keluarbiayapermuser!.id),
                          subtitle: Text(
                            '${state.keluarbiayapermuser!.user.name} ',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('Saldo Awal'),
                                  const Spacer(),
                                  Text(
                                    formatRupiah(
                                      state.keluarbiayapermuser!.saldoAwal,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Jumlah Keluar'),
                                  const Spacer(),
                                  Text(
                                    formatRupiah(
                                      state.keluarbiayapermuser!.jumlahBiaya,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Saldo Akhir'),
                                  const Spacer(),
                                  Text(
                                    formatRupiah(
                                      state.keluarbiayapermuser!.saldoAkhir,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Expanded(child: DkeluarbiayapermuserTpListWidget()),
          ],
        ),
      ),
    );
  }
}
