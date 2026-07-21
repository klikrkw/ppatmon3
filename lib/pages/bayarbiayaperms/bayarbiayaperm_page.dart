import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:newklikrkw/blocs/bayarbiayaperm/bayarbiayaperm_bloc.dart';
import 'package:newklikrkw/blocs/bayarbiayaperm/bayarbiayaperm_event.dart';
import 'package:newklikrkw/blocs/bayarbiayaperm/bayarbiayaperm_state.dart';
import 'package:newklikrkw/blocs/biayaperm/biayaperm_bloc.dart';
import 'package:newklikrkw/models/biayaperm.dart';
import 'package:newklikrkw/widgets/bayarbiayaperm_list_widget.dart';
import 'package:newklikrkw/widgets/dialogs/add_edit_bayarbiayaperm_dialog.dart';

class BayarbiayapermPage extends StatefulWidget {
  // final String biayapermId;
  final Biayaperm biayaperm;
  const BayarbiayapermPage({super.key, required this.biayaperm});

  @override
  State<BayarbiayapermPage> createState() => _BayarbiayapermPageState();
}

class _BayarbiayapermPageState extends State<BayarbiayapermPage> {
  Widget _buildBiayapermCard() {
    return BlocBuilder<BiayapermBloc, BiayapermState>(
      builder: (context, state) {
        final item = state.biayaperm;
        if (item == null) return const SizedBox.shrink();
        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.receipt_long, color: Colors.blue),

                    const SizedBox(width: 8),

                    Text(
                      "Informasi Biaya Permohonan",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),

                const Divider(height: 24),
                _infoRow(item.id, item.transpermohonan.noDaftar),

                _infoRow("Pemohon", item.transpermohonan.namaPenerima),

                _infoRow("Alas Hak", item.transpermohonan.alasHak),

                _infoRow("Letak Obyek", item.transpermohonan.letakObyek),

                _infoRow(
                  "Biaya",
                  NumberFormat.currency(
                    locale: "id_ID",
                    symbol: "Rp ",
                    decimalDigits: 0,
                  ).format(item.jumlahBiayaperm),
                ),

                _infoRow(
                  "Sudah Dibayar",
                  NumberFormat.currency(
                    locale: "id_ID",
                    symbol: "Rp ",
                    decimalDigits: 0,
                  ).format(item.jumlahBayar),
                ),

                _infoRow(
                  "Kurang Bayar",
                  NumberFormat.currency(
                    locale: "id_ID",
                    symbol: "Rp ",
                    decimalDigits: 0,
                  ).format(item.kurangBayar),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pembayaran Biaya")),

      body: BlocListener<BayarbiayapermBloc, BayarbiayapermState>(
        listenWhen: (previous, current) =>
            previous.saveSuccess != current.saveSuccess,
        listener: (context, state) {
          if (state.saveSuccess) {
            context.read<BiayapermBloc>().add(
              LoadBiayaperm(widget.biayaperm.id),
            );
            context.read<BiayapermBloc>().add(
              FilterTranspermohonanBiayaperm(
                widget.biayaperm.transpermohonan.id,
                isTranspermohonanId: true,
              ),
            );
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBiayapermCard(),
            Expanded(
              child: BayarbiayapermListWidget(biayaperm: widget.biayaperm),
            ),
          ],
        ),
      ),

      floatingActionButton: BlocBuilder<BiayapermBloc, BiayapermState>(
        builder: (context, state) {
          if (state.biayaperm == null) return const SizedBox.shrink();
          if (state.biayaperm!.isLunas) return const SizedBox.shrink();
          return FloatingActionButton.extended(
            icon: const Icon(Icons.add),
            label: const Text("Tambah"),
            onPressed: () async {
              final bloc = context.read<BayarbiayapermBloc>();

              bloc.add(const ClearBayarbiayapermForm());

              final result = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (_) => BlocProvider.value(
                    value: bloc,
                    child: AddEditBayarbiayapermDialog(
                      biayaperm: widget.biayaperm,
                    ),
                  ),
                ),
              );

              if (result == true && context.mounted) {
                bloc.add(
                  FilterBayarbiayaperm(biayapermId: widget.biayaperm.id),
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
