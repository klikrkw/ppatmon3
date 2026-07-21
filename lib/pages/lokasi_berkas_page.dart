import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/berkas_lokasi/berkas_lokasi_bloc.dart';
import 'package:newklikrkw/models/tempatberkas.dart';
import 'package:newklikrkw/models/transpermohonan.dart';
import 'package:newklikrkw/repositories/transpermohonan_repository.dart';
import 'package:newklikrkw/services/trans_permohonan_service.dart';
import 'package:newklikrkw/widgets/rak_grid_widget.dart';
import 'package:newklikrkw/widgets/trans_permohonan_bottom_sheet.dart';
import 'package:newklikrkw/widgets/transpermohonans/card_transpermohonan.dart';

class LokasiBerkasPage extends StatefulWidget {
  final Transpermohonan? transpermohonan;
  const LokasiBerkasPage({super.key, this.transpermohonan});

  @override
  State<LokasiBerkasPage> createState() => _LokasiBerkasPageState();
}

class _LokasiBerkasPageState extends State<LokasiBerkasPage> {
  final TextEditingController _transpermohonanController =
      TextEditingController();
  late final TranspermohonanRepository repository;
  final _transpermohonanService = TranspermohonanService();

  @override
  void initState() {
    context.read<BerkasLokasiBloc>().add(ResetLokasiBerkas());
    repository = TranspermohonanRepository(_transpermohonanService);
    if (widget.transpermohonan != null) {
      _transpermohonanController.text = widget.transpermohonan!.id;
      _loadData(widget.transpermohonan!.id);
    }
    super.initState();
  }

  @override
  void dispose() {
    _transpermohonanController.dispose();
    super.dispose();
  }

  void _loadData(String transpermohonanId) {
    // final id = _transpermohonanController.text.trim();

    if (transpermohonanId.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Masukkan ID Permohonan')));
      return;
    }
    context.read<BerkasLokasiBloc>().add(LoadBerkasLokasi(transpermohonanId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lokasi Berkas')),
      body: BlocConsumer<BerkasLokasiBloc, BerkasLokasiState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _transpermohonanController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'No Daftar',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: cariPermohonan,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              if (state.loading) const LinearProgressIndicator(),
              BlocBuilder<BerkasLokasiBloc, BerkasLokasiState>(
                builder: (context, state) {
                  return state.transpermohonan != null
                      ? CardTranspermohonan(item: state.transpermohonan!)
                      : Container();
                },
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<Tempatberkas>(
                        initialValue:
                            state.tempatberkases.isNotEmpty &&
                                state.selectedTempatberkas != null
                            ? state.tempatberkases.firstWhere(
                                (e) => e.id == state.selectedTempatberkas?.id,
                              )
                            : null,
                        decoration: const InputDecoration(
                          labelText: 'Tempat Berkas',
                          border: OutlineInputBorder(),
                        ),
                        items: state.tempatberkases
                            .map(
                              (e) => DropdownMenuItem<Tempatberkas>(
                                value: e,
                                child: Text(e.namaTempatberkas),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          if (value == state.selectedTempatberkas) {
                            return;
                          }

                          context.read<BerkasLokasiBloc>().add(
                            SelectTempatBerkas(value),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    BlocBuilder<BerkasLokasiBloc, BerkasLokasiState>(
                      builder: (context, state) {
                        return state.selectedTempatberkas != null &&
                                state.transpermohonanId != null
                            ? IconButton(
                                icon: Icon(
                                  state.editing ? Icons.check : Icons.edit,
                                ),
                                onPressed: () {
                                  if (state.posisiberkas != null) {
                                    context.read<BerkasLokasiBloc>().add(
                                      ToggleEditingLokasi(!state.editing),
                                    );
                                  }
                                },
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Builder(
                  builder: (context) {
                    if (state.loading && state.selectedTempatberkas == null) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.selectedTempatberkas == null) {
                      return const Center(
                        child: Text('Masukkan ID Permohonan'),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Card(
                            //   child: ListTile(
                            //     leading: const Icon(Icons.folder),
                            //     title: Text(
                            //       state.selectedTempatberkas!.namaTempatberkas,
                            //     ),
                            //     subtitle: Text(
                            //       '${state.selectedTempatberkas!.rowCount} x ${state.selectedTempatberkas!.colCount}',
                            //     ),
                            //   ),
                            // ),
                            // const SizedBox(height: 16),
                            if (
                            // state.posisiberkas != null &&
                            state.selectedTempatberkas != null)
                              RakGridWidget(
                                tempatberkas: state.selectedTempatberkas!,
                                posisiberkas: state.posisiberkas,
                                editing: state.editing,
                                onTapCell: (row, col) {
                                  context.read<BerkasLokasiBloc>().add(
                                    UpdatePosisiBerkas(
                                      row: row,
                                      col: col,
                                      tempatberkas: state.selectedTempatberkas!,
                                    ),
                                  );
                                },
                              ),
                            const SizedBox(height: 24),

                            if (state.posisiberkas != null)
                              Card(
                                child: ListTile(
                                  leading: const Icon(Icons.location_on),
                                  title: Text('Posisi Berkas'),
                                  subtitle: Text(
                                    'Row ${state.posisiberkas!.row}, Col ${state.posisiberkas!.col}',
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> cariPermohonan() async {
    final result = await showTranspermohonanBottomSheet(context, repository);
    if (result != null) {
      setState(() {
        _transpermohonanController.text = result.id;
        _loadData(result.id);
      });
    }
  }
}
