import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:intl/intl.dart';
import 'package:newklikrkw/blocs/auth/auth.dart';

import '../../blocs/transpermohonan/transpermohonan_bloc.dart';
import '../../blocs/transpermohonan/transpermohonan_event.dart';
import '../../blocs/transpermohonan/transpermohonan_state.dart';

import '../../models/requests/add_transpermohonan_request.dart';
import '../../models/desa.dart';
import '../../models/jenishak.dart';
import '../../models/jenispermohonan.dart';
import '../../models/user.dart';

import '../../widgets/searchable_selection_dialog.dart';

class AddEditTranspermohonanDialog extends StatefulWidget {
  final String? transpermohonanId;

  const AddEditTranspermohonanDialog({super.key, this.transpermohonanId});

  bool get isEdit => transpermohonanId != null;

  @override
  State<AddEditTranspermohonanDialog> createState() =>
      _AddEditTranspermohonanDialogState();
}

class _AddEditTranspermohonanDialogState
    extends State<AddEditTranspermohonanDialog> {
  final _formKey = GlobalKey<FormState>();

  // final bloc = TranspermohonanBloc.instance;
  TranspermohonanBloc get bloc => context.read<TranspermohonanBloc>();

  final _nomorHakController = TextEditingController();

  final _persilController = TextEditingController();

  final _klasController = TextEditingController();

  final _bidangController = TextEditingController();

  final _luasController = TextEditingController();

  final _atasNamaController = TextEditingController();

  final _namaPelepasController = TextEditingController();

  final _namaPenerimaController = TextEditingController();

  final _kodeUnikController = TextEditingController();

  final _currencyFormatter = CurrencyTextInputFormatter.currency(
    locale: 'id',
    decimalDigits: 0,
    symbol: '',
  );

  Jenishak? _selectedJenishak;

  Desa? _selectedDesa;

  String _jenisTanah = "non_pertanian";

  bool _active = true;

  bool _cekBiaya = false;

  String _periodCekBiaya = 'forever';

  DateTime _tanggalCekBiaya = DateTime.now();

  final List<User> _selectedUsers = [];

  final List<Jenispermohonan> _selectedJenispermohonan = [];
  Jenispermohonan? _activeJenispermohonan;

  bool get isEdit => widget.isEdit;

  String? permohonanId;

  @override
  void initState() {
    super.initState();

    bloc.add(ResetValidationError());

    bloc.add(ResetSaveState());

    bloc.add(LoadMasterTranspermohonan());

    if (isEdit) {
    } else {
      _kodeUnikController.text = '';
      _bidangController.text = '1';
    }
  }

  @override
  void dispose() {
    _nomorHakController.dispose();

    _persilController.dispose();

    _klasController.dispose();

    _bidangController.dispose();

    _luasController.dispose();

    _atasNamaController.dispose();

    _namaPelepasController.dispose();

    _namaPenerimaController.dispose();

    _kodeUnikController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TranspermohonanBloc, TranspermohonanState>(
      listenWhen: (previous, current) =>
          previous.saveSuccess != current.saveSuccess ||
          previous.transpermohonanModel != current.transpermohonanModel,
      listener: (context, state) {
        if (state.saveSuccess) {
          Navigator.pop(context, true);

          bloc.add(ResetSaveState());
        }

        if (state.transpermohonanModel != null) {
          final item = state.transpermohonanModel!;

          permohonanId = item.id;

          _selectedJenishak = item.jenishak;

          _selectedDesa = item.desa;

          _jenisTanah = item.jenisTanah;

          _active = item.active;

          _cekBiaya = item.cekBiaya;

          _periodCekBiaya = item.periodCekbiaya;

          _tanggalCekBiaya = item.dateCekbiaya ?? DateTime.now();

          _selectedUsers.addAll(item.users);

          _selectedJenispermohonan.addAll(item.jenispermohonans);

          _nomorHakController.text = item.nomorHak;

          _persilController.text = item.persil;

          _klasController.text = item.klas;

          _bidangController.text = item.bidang.toString();

          _luasController.text = _currencyFormatter.formatString(
            item.luasTanah.toString(),
          );

          _atasNamaController.text = item.atasNama;

          _namaPelepasController.text = item.namaPelepas;

          _namaPenerimaController.text = item.namaPenerima;

          _kodeUnikController.text = item.kodeUnik;
          _activeJenispermohonan = item.jenispermohonans
              .where((e) => e.active)
              .first;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEdit ? "Edit Permohonan" : "Tambah Permohonan"),
          actions: [
            IconButton(icon: const Icon(Icons.save), onPressed: _submit),
          ],
        ),
        body: BlocBuilder<TranspermohonanBloc, TranspermohonanState>(
          builder: (context, state) {
            if (state.loadingDetail) {
              return const Center(child: CircularProgressIndicator());
            }
            return Stack(
              children: [
                Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildIdentitasSection(state),

                        const SizedBox(height: 24),

                        _buildLokasiSection(state),

                        const SizedBox(height: 20),

                        _buildJenisPermohonanSection(state),

                        const SizedBox(height: 20),
                        TextFormField(
                          readOnly: true,
                          controller: TextEditingController(
                            text:
                                _activeJenispermohonan?.namaJenispermohonan ??
                                "",
                          ),
                          decoration: InputDecoration(
                            labelText: "Permohonan Aktif",
                            suffixIcon: const Icon(Icons.search),
                            border: const OutlineInputBorder(),
                            errorText: state.validationError?.firstError(
                              "active_jenispermohonan",
                            ),
                          ),
                          onTap: () async {
                            final result =
                                await SearchableSelectionDialog.show<
                                  Jenispermohonan
                                >(
                                  context: context,
                                  title: "Pilih Jenis Permohonan",
                                  items: _selectedJenispermohonan,
                                  selectedItem: _activeJenispermohonan,
                                  itemLabelBuilder: (e) =>
                                      e.namaJenispermohonan,
                                );

                            if (result == null) return;

                            setState(() {
                              _activeJenispermohonan = result;
                            });

                            // bloc.add(ResetValidationError());
                          },
                        ),

                        const SizedBox(height: 20),

                        _buildPetugasSection(state),

                        const SizedBox(height: 20),

                        _buildStatusSection(state),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),

                if (state.saving)
                  Container(
                    color: Colors.black26,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildIdentitasSection(TranspermohonanState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.badge),

                const SizedBox(width: 8),

                Text(
                  "Identitas Permohonan",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),

            const SizedBox(height: 20),

            TextFormField(
              readOnly: true,
              controller: TextEditingController(
                text: _selectedJenishak?.namaJenishak ?? "",
              ),
              decoration: InputDecoration(
                labelText: "Jenis Hak",
                suffixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                errorText: state.validationError?.firstError("jenishak_id"),
              ),
              onTap: () async {
                final result = await SearchableSelectionDialog.show<Jenishak>(
                  context: context,
                  title: "Pilih Jenis Hak",
                  items: state.jenishaks,
                  selectedItem: _selectedJenishak,
                  itemLabelBuilder: (e) => e.namaJenishak,
                );

                if (result == null) return;

                setState(() {
                  _selectedJenishak = result;
                });

                bloc.add(ResetValidationError());
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _nomorHakController,
              decoration: InputDecoration(
                labelText: "Nomor Hak",
                border: const OutlineInputBorder(),
                errorText: state.validationError?.firstError("nomor_hak"),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _persilController,
                    decoration: InputDecoration(
                      labelText: "Persil",
                      border: const OutlineInputBorder(),
                      errorText: state.validationError?.firstError("persil"),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: TextFormField(
                    controller: _klasController,
                    decoration: InputDecoration(
                      labelText: "Klas",
                      border: const OutlineInputBorder(),
                      errorText: state.validationError?.firstError("klas"),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _bidangController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Bidang",
                      border: const OutlineInputBorder(),
                      errorText: state.validationError?.firstError("bidang"),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: TextFormField(
                    controller: _luasController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [_currencyFormatter],
                    decoration: InputDecoration(
                      labelText: "Luas Tanah",
                      suffixText: "m²",
                      border: const OutlineInputBorder(),
                      errorText: state.validationError?.firstError(
                        "luas_tanah",
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _atasNamaController,
              decoration: InputDecoration(
                labelText: "Atas Nama",
                border: const OutlineInputBorder(),
                errorText: state.validationError?.firstError("atas_nama"),
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _namaPelepasController,
              decoration: InputDecoration(
                labelText: "Nama Pelepas",
                border: const OutlineInputBorder(),
                errorText: state.validationError?.firstError("nama_pelepas"),
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _namaPenerimaController,
              decoration: InputDecoration(
                labelText: "Nama Penerima",
                border: const OutlineInputBorder(),
                errorText: state.validationError?.firstError("nama_penerima"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLokasiSection(TranspermohonanState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on),

                const SizedBox(width: 8),

                Text(
                  "Lokasi Tanah",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),

            const SizedBox(height: 20),

            TextFormField(
              readOnly: true,
              controller: TextEditingController(
                text: _selectedDesa == null
                    ? ""
                    : "${_selectedDesa!.namaDesa} - ${_selectedDesa!.namaKecamatan}",
              ),
              decoration: InputDecoration(
                labelText: "Desa",
                suffixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                errorText: state.validationError?.firstError("desa_id"),
              ),
              onTap: () async {
                final result = await SearchableSelectionDialog.show<Desa>(
                  context: context,
                  title: "Pilih Desa",
                  searchHint: "Cari desa...",
                  asyncItems: (keyword) {
                    return bloc.desaRepository.service.getDesas(query: keyword);
                  },
                  selectedItem: _selectedDesa,
                  itemLabelBuilder: (e) => e.namaDesa,
                  itemSubtitleBuilder: (e) => e.namaKecamatan,
                );

                if (result == null) return;

                setState(() {
                  _selectedDesa = result;
                });

                bloc.add(ResetValidationError());
              },
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              initialValue: _jenisTanah,
              decoration: const InputDecoration(
                labelText: "Jenis Tanah",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: "non_pertanian",
                  child: Text("Non Pertanian"),
                ),
                DropdownMenuItem(value: "pertanian", child: Text("Pertanian")),
              ],
              onChanged: (value) {
                setState(() {
                  _jenisTanah = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJenisPermohonanSection(TranspermohonanState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.assignment),

                const SizedBox(width: 8),

                Text(
                  "Jenis Permohonan",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),

            const SizedBox(height: 16),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: state.jenispermohonans.map((item) {
                final selected = _selectedJenispermohonan.any(
                  (e) => e.id == item.id,
                );

                return FilterChip(
                  selected: selected,
                  label: Text(item.namaJenispermohonan),
                  onSelected: (value) {
                    if (widget.isEdit) return;
                    setState(() {
                      if (value) {
                        _selectedJenispermohonan.add(item);
                      } else {
                        _selectedJenispermohonan.removeWhere(
                          (e) => e.id == item.id,
                        );
                      }
                    });

                    bloc.add(ResetValidationError());
                  },
                );
              }).toList(),
            ),

            if (state.validationError?.firstError("jenispermohonans") != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  state.validationError!.firstError("jenispermohonans")!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetugasSection(TranspermohonanState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.people),

                const SizedBox(width: 8),

                Text("Petugas", style: Theme.of(context).textTheme.titleMedium),
              ],
            ),

            const SizedBox(height: 16),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: state.users.map((user) {
                final selected = _selectedUsers.any((e) => e.id == user.id);

                return FilterChip(
                  selected: selected,

                  avatar: CircleAvatar(
                    child: Text(
                      user.name.isEmpty ? "-" : user.name.substring(0, 1),
                    ),
                  ),

                  label: Text(user.name),

                  onSelected: (value) {
                    setState(() {
                      if (value) {
                        _selectedUsers.add(user);
                      } else {
                        _selectedUsers.removeWhere((e) => e.id == user.id);
                      }
                    });

                    bloc.add(ResetValidationError());
                  },
                );
              }).toList(),
            ),

            if (state.validationError?.firstError("users") != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  state.validationError!.firstError("users")!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // String _generateKodeUnik() {
  //   const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  //   final random = Random.secure();

  //   final kode = List.generate(
  //     8,
  //     (_) => chars[random.nextInt(chars.length)],
  //   ).join();
  //   return kode;
  // }

  void _submit() {
    FocusScope.of(context).unfocus();

    bloc.add(ResetValidationError());

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedJenishak == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Jenis hak wajib dipilih")));
      return;
    }

    if (_selectedDesa == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Desa wajib dipilih")));
      return;
    }

    if (_selectedJenispermohonan.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Jenis permohonan wajib dipilih")),
      );
      return;
    }

    if (_selectedUsers.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Petugas wajib dipilih")));
      return;
    }
    if (_activeJenispermohonan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Active Permohonan wajib dipilih")),
      );
      return;
    }

    final code =
        '${_selectedJenishak?.id}.${int.parse(_nomorHakController.text.trim())}${_persilController.text.trim()}${_klasController.text.trim()}.${_selectedDesa?.id}.${_bidangController.text.trim()}';

    _kodeUnikController.text = code;
    final request = AddTranspermohonanRequest(
      jenishakId: _selectedJenishak!.id,

      nomorHak: _nomorHakController.text.trim(),

      persil: _persilController.text.trim(),

      klas: _klasController.text.trim(),

      bidang: _toInt(_bidangController),

      luasTanah: _toInt(_luasController),

      atasNama: _atasNamaController.text.trim(),

      namaPelepas: _namaPelepasController.text.trim(),

      namaPenerima: _namaPenerimaController.text.trim(),

      jenisTanah: _jenisTanah,

      desaId: _selectedDesa!.id,

      active: _active,

      cekBiaya: _cekBiaya,

      periodCekbiaya: _periodCekBiaya,

      dateCekbiaya: _tanggalCekBiaya,

      users: _selectedUsers,

      jenispermohonans: _selectedJenispermohonan,

      kodeUnik: code,

      activeJenispermohonan: _activeJenispermohonan!,
    );
    if (widget.isEdit) {
      bloc.add(UpdateTranspermohonan(id: permohonanId!, request: request));
      context.read<TranspermohonanBloc>().add(
        FilterQrCode(
          transpermohonanId: _activeJenispermohonan!.transpermohonanId,
          isTranspermohonanId: true,
        ),
      );
    } else {
      bloc.add(AddTranspermohonan(request));
    }
  }

  int _toInt(TextEditingController controller) {
    return int.tryParse(
          controller.text.replaceAll('.', '').replaceAll(',', '').trim(),
        ) ??
        0;
  }

  Widget _buildStatusSection(TranspermohonanState state) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, userState) {
        if (userState is Authenticated) {
          final isAdmin = userState.user.isAdmin;
          return Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.settings,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Pengaturan Permohonan",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  SwitchListTile(
                    value: _active,
                    contentPadding: EdgeInsets.zero,
                    secondary: const Icon(Icons.check_circle_outline),
                    title: const Text("Permohonan Aktif"),
                    subtitle: const Text("Permohonan dapat diproses"),
                    onChanged: (value) {
                      if (!isAdmin) {
                        return;
                      }
                      setState(() {
                        _active = value;
                      });
                    },
                  ),

                  const Divider(),

                  SwitchListTile(
                    value: _cekBiaya,
                    contentPadding: EdgeInsets.zero,
                    secondary: const Icon(Icons.payments_outlined),
                    title: const Text("Cek Biaya"),
                    subtitle: const Text("Aktifkan pengecekan biaya"),
                    onChanged: (value) {
                      if (!isAdmin) {
                        return;
                      }
                      setState(() {
                        _cekBiaya = value;
                      });
                    },
                  ),

                  const Divider(),
                  if (!isAdmin) Text("Periode : $_periodCekBiaya"),
                  if (isAdmin)
                    DropdownButtonFormField<String>(
                      initialValue: _periodCekBiaya,
                      decoration: const InputDecoration(
                        labelText: "Periode",
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "forever",
                          child: Text("Forever"),
                        ),
                        DropdownMenuItem(
                          value: "limited",
                          child: Text("Limited"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _periodCekBiaya = value!;
                        });
                      },
                    ),

                  if (_periodCekBiaya == "limited") ...[
                    const SizedBox(height: 20),

                    InkWell(
                      onTap: _pickDateCekBiaya,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: "Tanggal Cek Biaya",
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.calendar_month),
                          errorText: state.validationError?.firstError(
                            "date_cekbiaya",
                          ),
                        ),
                        child: Text(
                          DateFormat("dd MMM yyyy").format(_tanggalCekBiaya),
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _kodeUnikController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Kode Unik",
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.qr_code),

                      errorText: state.validationError?.firstError("kode_unik"),

                      // suffixIcon: IconButton(
                      //   tooltip: "Generate",
                      //   icon: const Icon(Icons.refresh),
                      //   onPressed: _generateKodeUnik,
                      // ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }

  Future<void> _pickDateCekBiaya() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _tanggalCekBiaya,
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    setState(() {
      _tanggalCekBiaya = date;
    });

    bloc.add(ResetValidationError());
  }
}
