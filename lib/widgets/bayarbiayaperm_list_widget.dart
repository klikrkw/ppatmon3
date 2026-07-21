import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:newklikrkw/blocs/bayarbiayaperm/bayarbiayaperm_bloc.dart';
import 'package:newklikrkw/blocs/bayarbiayaperm/bayarbiayaperm_event.dart';
import 'package:newklikrkw/blocs/bayarbiayaperm/bayarbiayaperm_state.dart';
import 'package:newklikrkw/models/bayarbiayaperm.dart';
import 'package:newklikrkw/models/biayaperm.dart';
import 'package:newklikrkw/utils/dio.dart';
import 'package:newklikrkw/widgets/dialogs/add_edit_bayarbiayaperm_dialog.dart';
import 'package:newklikrkw/widgets/image_preview_dialog.dart';

class BayarbiayapermListWidget extends StatefulWidget {
  final Biayaperm biayaperm;

  const BayarbiayapermListWidget({super.key, required this.biayaperm});

  @override
  State<BayarbiayapermListWidget> createState() =>
      _BayarbiayapermListWidgetState();
}

class _BayarbiayapermListWidgetState extends State<BayarbiayapermListWidget> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(_onScroll);

    context.read<BayarbiayapermBloc>().add(
      FilterBayarbiayaperm(biayapermId: widget.biayaperm.id),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();

    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;

    final current = _scrollController.position.pixels;

    if (current >= maxScroll - 200) {
      context.read<BayarbiayapermBloc>().add(const LoadBayarbiayaperms());
    }
  }

  Future<void> _refresh() async {
    context.read<BayarbiayapermBloc>().add(
      FilterBayarbiayaperm(biayapermId: widget.biayaperm.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BayarbiayapermBloc, BayarbiayapermState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error!)));
        }
      },
      builder: (context, state) {
        if (state.loading && state.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.items.isEmpty) {
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              children: const [
                SizedBox(height: 120),
                Center(child: Text("Belum ada data pembayaran")),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.all(12),
            itemCount: state.hasReachedMax
                ? state.items.length
                : state.items.length + 1,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              if (index >= state.items.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final item = state.items[index];

              return _buildItem(item);
            },
          ),
        );
      },
    );
  }

  final NumberFormat _rupiah = NumberFormat.currency(
    locale: "id_ID",
    symbol: "Rp ",
    decimalDigits: 0,
  );

  final DateFormat _tanggal = DateFormat("dd MMM yyyy HH:mm", "id_ID");

  Widget _buildItem(Bayarbiayaperm item) {
    return Card(
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),

        // leading: CircleAvatar(
        //   child: Text(
        //     item.metodebayar.namaMetodebayar.substring(0, 1).toUpperCase(),
        //   ),
        // ),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.antiAlias,
          child: GestureDetector(
            onTap: item.hasImage
                ? () {
                    showDialog(
                      context: context,
                      barrierColor: Colors.black87,
                      builder: (_) => ImagePreviewDialog(
                        imageUrl: '$myBaseUrl${item.imageBayarbiayaperm}',
                        heroTag: item.id,
                      ),
                    );
                  }
                : null,
            child: item.hasImage
                ? Hero(
                    tag: item.id,
                    child: Container(
                      width: 60,
                      height: 60,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.network(
                        '$myBaseUrl${item.imageBayarbiayaperm}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : const Icon(Icons.receipt_long, color: Colors.grey, size: 36),
          ),
        ),

        title: Text(
          item.catatanBayarbiayaperm.isEmpty ? "-" : item.catatanBayarbiayaperm,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),

            Text("Tanggal : ${_tanggal.format(item.tglBayarbiayaperm)}"),

            Text("Metode : ${item.metodebayar.namaMetodebayar}"),

            Text("Rekening : ${item.rekening.namaRekening}"),

            Text(
              "Jumlah : ${_rupiah.format(item.jumlahBayar)}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            Text("Saldo Awal : ${_rupiah.format(item.saldoAwal)}"),

            Text("Saldo Akhir : ${_rupiah.format(item.saldoAkhir)}"),

            Text("User : ${item.user.name}"),
          ],
        ),

        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case "edit":
                _openEditDialog(item);
                break;

              case "delete":
                _deleteDialog(item);
                break;
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(
              value: "edit",
              child: Row(
                children: [Icon(Icons.edit), SizedBox(width: 8), Text("Edit")],
              ),
            ),

            PopupMenuItem(
              value: "delete",
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),

                  SizedBox(width: 8),

                  Text("Hapus"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future<void> _openAddDialog() async {
  //   if (widget.biayapermId == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Biaya Permohonan belum dipilih.")),
  //     );
  //     return;
  //   }

  //   final bloc = context.read<BayarbiayapermBloc>();

  //   bloc.add(const ClearBayarbiayapermForm());

  //   final result = await Navigator.push<bool>(
  //     context,
  //     MaterialPageRoute(
  //       fullscreenDialog: true,
  //       builder: (_) => BlocProvider.value(
  //         value: bloc,
  //         child: AddEditBayarbiayapermDialog(biayaperm: widget.biayapermId),
  //       ),
  //     ),
  //   );

  //   if (result == true && mounted) {
  //     bloc.add(FilterBayarbiayaperm(biayapermId: widget.biayapermId));
  //   }
  // }

  Future<void> _openEditDialog(Bayarbiayaperm item) async {
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
            bayarbiayaperm: item,
          ),
        ),
      ),
    );

    if (result == true && mounted) {
      bloc.add(FilterBayarbiayaperm(biayapermId: widget.biayaperm.id));
    }
  }

  Future<void> _deleteDialog(Bayarbiayaperm item) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Konfirmasi"),
          content: Text("Hapus pembayaran '${item.catatanBayarbiayaperm}' ?"),
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
    );

    if (result != true) {
      return;
    }

    if (!mounted) {
      return;
    }

    context.read<BayarbiayapermBloc>().add(DeleteBayarbiayaperm(item.id));
  }
}
