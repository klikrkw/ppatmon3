import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/transpermohonan/transpermohonan_bloc.dart';
import 'package:newklikrkw/blocs/transpermohonan/transpermohonan_event.dart';
import 'package:newklikrkw/blocs/transpermohonan/transpermohonan_state.dart';
import 'package:newklikrkw/pages/biayaperms/biayaperm_page.dart';
import 'package:newklikrkw/pages/dkeluarbiayapermusers/dkeluarbiayapermuser_tp_list_page.dart';
import 'package:newklikrkw/pages/lapkeuangans/neraca_permohonan_page.dart';
import 'package:newklikrkw/pages/lokasi_berkas_page.dart';
import 'package:newklikrkw/pages/transaksis/prosespermohonans/prosespermohonan_page.dart';
import 'package:newklikrkw/widgets/feature_grid_permohonan.dart';
import 'package:newklikrkw/widgets/transpermohonans/add_edit_transpermohonan_dialog.dart';
import 'package:newklikrkw/widgets/transpermohonans/card_transpermohonan.dart';

class TranspermohonanMenuPage extends StatelessWidget {
  const TranspermohonanMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<TranspermohonanBloc, TranspermohonanState>(
      listenWhen: (previous, current) =>
          previous.transpermohonan != current.transpermohonan ||
          previous.saveSuccess != current.saveSuccess,
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error!)));
        }
        if (state.saveSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Perubahan berhasil disimpan')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Transaksi Permohonan')),
        body: BlocBuilder<TranspermohonanBloc, TranspermohonanState>(
          builder: (context, state) {
            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.transpermohonan == null) {
              return const Center(child: Text("Tidak ada data"));
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  CardTranspermohonan(item: state.transpermohonan!),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: FeatureGridPermohonan(
                      features: _buildFeatures(context, state),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

List<HomeFeature> _buildFeatures(
  BuildContext context,
  TranspermohonanState state,
) {
  return [
    HomeFeature(
      title: "Lokasi Berkas",
      icon: Icons.account_balance_wallet_outlined,
      color: Colors.green,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                LokasiBerkasPage(transpermohonan: state.transpermohonan!),
          ),
        );
      },
    ),
    HomeFeature(
      title: "Proses",
      icon: Icons.assignment_outlined,
      color: Colors.orange,
      badge: 5,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                ProsespermohonanPage(transpermohonan: state.transpermohonan!),
          ),
        );
      },
    ),
    HomeFeature(
      title: "Biaya",
      icon: Icons.receipt_long_outlined,
      color: Colors.red,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                BiayapermPage(transpermohonan: state.transpermohonan!),
          ),
        );
      },
    ),
    HomeFeature(
      title: "Pengeluaran",
      icon: Icons.payments_outlined,
      color: Colors.indigo,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DkeluarbiayapermuserTpListPage(
              transpermohonanId: state.transpermohonan!.id,
            ),
          ),
        );
      },
    ),
    HomeFeature(
      title: "Neraca",
      icon: Icons.folder_open_outlined,
      color: Colors.teal,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NeracaPermohonanPage(
              transpermohonanId: state.transpermohonan!.id,
            ),
          ),
        );
      },
    ),
    HomeFeature(
      title: "Edit",
      icon: Icons.edit_outlined,
      color: Colors.yellow.shade700,
      onTap: () async {
        context.read<TranspermohonanBloc>().add(
          DetailTranspermohonan(state.transpermohonan!.id),
        );
        final result = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => AddEditTranspermohonanDialog(
              transpermohonanId: state.transpermohonan!.id,
            ),
          ),
        );

        if (result == true && context.mounted) {
          // context.read<TranspermohonanBloc>().add(
          //   FilterQrCode(transpermohonanId: state.transpermohonan!.id),
          // );
        }
      },
    ),
  ];
}
