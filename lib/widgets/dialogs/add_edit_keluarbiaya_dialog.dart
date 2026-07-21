import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/auth/auth.dart';
import 'package:newklikrkw/blocs/keluarbiaya/keluarbiaya_bloc.dart';
import 'package:newklikrkw/blocs/keluarbiaya/keluarbiaya_event.dart';
import 'package:newklikrkw/blocs/keluarbiaya/keluarbiaya_state.dart';
import 'package:newklikrkw/models/add_keluarbiaya_request.dart';
import 'package:newklikrkw/models/instansi.dart';
import 'package:newklikrkw/models/kasbon.dart';
import 'package:newklikrkw/models/metodebayar.dart';
import 'package:newklikrkw/models/rekening.dart';
import 'package:newklikrkw/utils/format.dart';

class AddEditKeluarbiayaDialog extends StatefulWidget {
  const AddEditKeluarbiayaDialog({super.key});

  @override
  State<AddEditKeluarbiayaDialog> createState() =>
      _AddEditKeluarbiayaDialogState();
}

class _AddEditKeluarbiayaDialogState extends State<AddEditKeluarbiayaDialog> {
  final _formKey = GlobalKey<FormState>();

  // final NumberFormat _currency = NumberFormat("#,##0", "id_ID");

  // late final TextEditingController _saldoAwalController;

  // late final TextEditingController _jumlahBiayaController;

  // late final TextEditingController _saldoAkhirController;

  Instansi? _selectedInstansi;

  Metodebayar? _selectedMetodebayar;

  Rekening? _selectedRekening;

  Kasbon? _selectedKasbon;
  late int _userId = 0;
  late double _saldoAwal = 0;
  final double _jumlah = 0;
  late double _saldoAkhir = 0;

  @override
  void initState() {
    super.initState();

    // _saldoAwalController = TextEditingController();

    // _jumlahBiayaController = TextEditingController();

    // _saldoAkhirController = TextEditingController();

    final bloc = context.read<KeluarbiayaBloc>();

    bloc.add(const ClearForm());

    bloc.add(const LoadInstansis());

    bloc.add(const LoadMetodebayars());

    final userState = context.read<AuthBloc>().state;
    if (userState is Authenticated) {
      setState(() {
        _userId = userState.user.id;
      });
      bloc.add(LoadKasbons(userId: userState.user.id));
    }
  }

  @override
  void dispose() {
    // _saldoAwalController.dispose();

    // _jumlahBiayaController.dispose();

    // _saldoAkhirController.dispose();

    super.dispose();
  }

  // double _toDouble(TextEditingController controller) {
  //   return double.tryParse(
  //         controller.text.replaceAll(".", "").replaceAll(",", "").trim(),
  //       ) ??
  //       0;
  // }

  // void _hitungSaldoAkhir() {
  //   final saldoAwal = _toDouble(_saldoAwalController);

  //   final jumlah = _toDouble(_jumlahBiayaController);

  //   final saldo = saldoAwal - jumlah;

  //   setState(() {
  //     _saldoAkhirController.text = saldo.toStringAsFixed(0);
  //   });
  // }

  // final _rupiahFormatter = CurrencyTextInputFormatter.currency(
  //   locale: 'id',
  //   decimalDigits: 0,
  //   symbol: '',
  // );

  @override
  Widget build(BuildContext context) {
    return BlocListener<KeluarbiayaBloc, KeluarbiayaState>(
      listenWhen: (previous, current) =>
          previous.saveSuccess != current.saveSuccess,
      listener: (context, state) {
        if (state.saveSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Keluar biaya berhasil disimpan")),
          );

          context.read<KeluarbiayaBloc>().add(const ClearForm());

          context.read<KeluarbiayaBloc>().add(
            const ResetSaveState() as KeluarbiayaEvent,
          );

          context.read<KeluarbiayaBloc>().add(const RefreshKeluarbiayas());

          Navigator.pop(context, true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Tambah Keluar Biaya"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: BlocBuilder<KeluarbiayaBloc, KeluarbiayaState>(
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            DropdownButtonFormField<Kasbon>(
                              initialValue: _selectedKasbon,
                              isExpanded: true,
                              decoration: InputDecoration(
                                labelText: "Kasbon",
                                border: const OutlineInputBorder(),
                                errorText: state.errorText("kasbon_id"),
                              ),
                              items: state.kasbons
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(
                                        '${e.id} - ${formatRupiah(e.sisaPenggunaan)}',
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedKasbon = value;
                                  _selectedRekening = null;
                                });
                                if (value != null) {
                                  setState(() {
                                    _saldoAwal = value.sisaPenggunaan;
                                    _saldoAkhir = value.sisaPenggunaan;
                                    _selectedInstansi = value.instansi;
                                  });
                                  final metode = state.metodebayars.firstWhere(
                                    (element) =>
                                        element.namaMetodebayar.toLowerCase() ==
                                        'tunai',
                                  );
                                  setState(() {
                                    _selectedMetodebayar = metode;
                                  });
                                  context.read<KeluarbiayaBloc>().add(
                                    ChangeMetodebayar(metode),
                                  );
                                  // context.read<KeluarbiayaBloc>().add(
                                  //   LoadInstansis(kasbonId: value.id),
                                  // );
                                }
                                context.read<KeluarbiayaBloc>().add(
                                  const ResetValidationError()
                                      as KeluarbiayaEvent,
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            if (_selectedKasbon != null)
                              _infoField(
                                'Instansi ',
                                _selectedInstansi?.namaInstansi,
                              ),
                            if (_selectedKasbon == null)
                              DropdownButtonFormField<Instansi>(
                                initialValue: _selectedInstansi,
                                isExpanded: true,
                                decoration: InputDecoration(
                                  labelText: "Instansi",
                                  border: const OutlineInputBorder(),
                                  errorText: state.errorText("instansi_id"),
                                ),
                                items: state.instansis
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e.namaInstansi),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedInstansi = value;
                                  });

                                  context.read<KeluarbiayaBloc>().add(
                                    const ResetValidationError()
                                        as KeluarbiayaEvent,
                                  );
                                },
                              ),

                            const SizedBox(height: 16),
                            if (_selectedKasbon != null)
                              _infoField(
                                'Metode Bayar ',
                                _selectedMetodebayar?.namaMetodebayar,
                              ),
                            if (_selectedKasbon == null)
                              DropdownButtonFormField<Metodebayar>(
                                initialValue: _selectedMetodebayar,
                                isExpanded: true,
                                decoration: InputDecoration(
                                  labelText: "Metode Bayar",
                                  border: const OutlineInputBorder(),
                                  errorText: state.errorText("metodebayar_id"),
                                ),
                                items: state.metodebayars
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e.namaMetodebayar),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  if (value == null) return;

                                  setState(() {
                                    _selectedMetodebayar = value;
                                    _selectedRekening = null;
                                  });

                                  context.read<KeluarbiayaBloc>().add(
                                    const ResetValidationError()
                                        as KeluarbiayaEvent,
                                  );

                                  context.read<KeluarbiayaBloc>().add(
                                    ChangeMetodebayar(value),
                                  );
                                },
                              ),

                            const SizedBox(height: 16),

                            DropdownButtonFormField<Rekening>(
                              initialValue: _selectedRekening,
                              isExpanded: true,
                              decoration: InputDecoration(
                                labelText: "Rekening",
                                border: const OutlineInputBorder(),
                                errorText: state.errorText("rekening_id"),
                              ),
                              items: state.rekenings
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e.namaRekening),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedRekening = value;
                                });

                                context.read<KeluarbiayaBloc>().add(
                                  const ResetValidationError()
                                      as KeluarbiayaEvent,
                                );
                              },
                            ),

                            const SizedBox(height: 16),

                            // TextFormField(
                            //   readOnly: true,
                            //   controller: _saldoAwalController,
                            //   keyboardType: TextInputType.number,
                            //   inputFormatters: [_rupiahFormatter],
                            //   decoration: InputDecoration(
                            //     labelText: "Saldo Awal",
                            //     prefixText: "Rp ",
                            //     border: const OutlineInputBorder(),
                            //     errorText: state.errorText("saldo_awal"),
                            //     filled: true,
                            //   ),
                            //   onChanged: (_) {
                            //     _hitungSaldoAkhir();

                            //     context.read<KeluarbiayaBloc>().add(
                            //       const ResetValidationError()
                            //           as KeluarbiayaEvent,
                            //     );
                            //   },
                            // ),
                            // const SizedBox(height: 16),

                            // TextFormField(
                            //   readOnly: true,
                            //   controller: _jumlahBiayaController,
                            //   keyboardType: TextInputType.number,

                            //   // inputFormatters: [_rupiahFormatter],
                            //   decoration: InputDecoration(
                            //     labelText: "Jumlah Biaya",
                            //     prefixText: "Rp ",
                            //     border: const OutlineInputBorder(),
                            //     errorText: state.errorText("jumlah_biaya"),
                            //     filled: true,
                            //   ),
                            //   onChanged: (_) {
                            //     _hitungSaldoAkhir();

                            //     context.read<KeluarbiayaBloc>().add(
                            //       const ResetValidationError()
                            //           as KeluarbiayaEvent,
                            //     );
                            //   },
                            // ),
                            // const SizedBox(height: 16),

                            // TextFormField(
                            //   controller: _saldoAkhirController,
                            //   readOnly: true,
                            //   decoration: InputDecoration(
                            //     labelText: "Saldo Akhir",
                            //     prefixText: "Rp ",
                            //     border: const OutlineInputBorder(),
                            //     filled: true,
                            //     errorText: state.errorText("saldo_akhir"),
                            //   ),
                            // ),
                            // const SizedBox(height: 24),
                            Card(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Expanded(
                                          child: Text("Saldo Awal"),
                                        ),

                                        Text(
                                          formatToRupiah<dynamic>(_saldoAwal),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 8),

                                    Row(
                                      children: [
                                        const Expanded(
                                          child: Text("Jumlah Biaya"),
                                        ),

                                        Text(
                                          formatToRupiah<dynamic>(_jumlah),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const Divider(),

                                    Row(
                                      children: [
                                        const Expanded(
                                          child: Text(
                                            "Saldo Akhir",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),

                                        Text(
                                          formatToRupiah<dynamic>(_saldoAwal),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: FilledButton.icon(
                            onPressed: state.saving ? null : _submit,
                            icon: state.saving
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.save),
                            label: Text(
                              state.saving ? "Menyimpan..." : "SIMPAN",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // double _parseCurrency(TextEditingController controller) {
  //   return double.tryParse(
  //         controller.text.replaceAll(".", "").replaceAll(",", ""),
  //       ) ??
  //       0;
  // }

  void _submit() {
    FocusScope.of(context).unfocus();

    final kasbonState = context.read<KeluarbiayaBloc>().state;
    if (_selectedKasbon == null && kasbonState.kasbons.isNotEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Kasbon belum dipilih")));
      return;
    }

    if (_selectedInstansi == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Instansi belum dipilih")));
      return;
    }

    if (_selectedMetodebayar == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Metode bayar belum dipilih")),
      );
      return;
    }

    if (_selectedRekening == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Rekening belum dipilih")));
      return;
    }

    final request = AddKeluarbiayaRequest(
      userId: _userId,
      instansiId: _selectedInstansi!.id,
      metodebayarId: _selectedMetodebayar!.id,
      rekeningId: _selectedRekening!.id,
      kasbonId: _selectedKasbon?.id,

      saldoAwal: _saldoAwal,

      jumlahBiaya: _jumlah,

      saldoAkhir: _saldoAkhir,
    );

    context.read<KeluarbiayaBloc>().add(AddKeluarbiaya(request));
  }

  Container _infoField(String label, dynamic text) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade200,
      ),
      child: Text(
        "$label : $text",
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
