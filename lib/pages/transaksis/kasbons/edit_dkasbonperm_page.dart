import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/kasbon/kasbon_bloc.dart';
import 'package:newklikrkw/models/db_option.dart';
import 'package:newklikrkw/models/kasbon.dart';
import 'package:newklikrkw/models/transpermohonan.dart';
import 'package:newklikrkw/repositories/transpermohonan_repository.dart';
import 'package:newklikrkw/routes.dart';
import 'package:newklikrkw/services/itemkegiatan_service.dart';
import 'package:newklikrkw/services/kasbon_service.dart';
import 'package:newklikrkw/services/trans_permohonan_service.dart';
import 'package:newklikrkw/widgets/trans_permohonan_bottom_sheet.dart';
import 'package:newklikrkw/widgets/transpermohonans/card_transpermohonan.dart';

class EditDKasbonpermPage extends StatefulWidget {
  final Kasbon kasbon;
  const EditDKasbonpermPage({super.key, required this.kasbon});
  @override
  State<EditDKasbonpermPage> createState() => _EditDKasbonpermPageState();
}

class _EditDKasbonpermPageState extends State<EditDKasbonpermPage> {
  final _formKey = GlobalKey<FormState>();
  final KasbonService _service = KasbonService();
  final ItemkegiatanService _itemkegiatanService = ItemkegiatanService();
  late TextEditingController _jumlahBiayaController;
  late TextEditingController _ketBiayaController;
  late TextEditingController _transpermohonanIdController;
  late final TranspermohonanRepository repository;
  final _transpermohonanService = TranspermohonanService();

  String? _selectedJenisKasbon;
  String? _selectedItemkegiatan;
  bool _isLoading = false;
  List<DbOption> _itemkegiatanOptions = [];
  Transpermohonan _selectedTranspermohonan = Transpermohonan(
    id: '',
    noDaftar: '',
    tglDaftar: '',
    namaPelepas: '',
    namaPenerima: '',
    jenisPermohonan: '',
    alasHak: '',
    letakObyek: '',
    active: false,
  );

  @override
  void initState() {
    super.initState();
    repository = TranspermohonanRepository(_transpermohonanService);

    _jumlahBiayaController = TextEditingController(text: '');
    _ketBiayaController = TextEditingController(text: "");
    _selectedJenisKasbon = widget.kasbon.jenisKasbon;
    _transpermohonanIdController = TextEditingController(text: '');
    _loadItemkegiatan();
  }

  Future<void> _loadItemkegiatan() async {
    try {
      final options = await _itemkegiatanService.getOptions(
        instansiId: widget.kasbon.instansi.id,
      );
      setState(() {
        _itemkegiatanOptions = options;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_selectedJenisKasbon == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pilih jenis kasbon')));
      return;
    }
    if (_selectedItemkegiatan == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pilih Itemkegiatan')));
      return;
    }
    try {
      setState(() {
        _isLoading = true;
      });
      final request = UpdateKasbonPermRequest(
        jenisKasbon: _selectedJenisKasbon!,
        jumlahBiaya: double.parse(_jumlahBiayaController.text),
        itemkegiatanId: int.parse(_selectedItemkegiatan!),
        transpermohonanId: _transpermohonanIdController.text,
        ketBiaya: _ketBiayaController.text,
      );
      final resp = await _service.updateKasbonPerm(
        id: widget.kasbon.id,
        request: request,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Kasbon berhasil diupdate')));

      context.read<KasbonBloc>().add(EditKasbon(resp));
      Navigator.pop(context, MyRoute.editKasbon.name);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _jumlahBiayaController.dispose();
    _ketBiayaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Item Kasbon')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Jenis Kasbon : $_selectedJenisKasbon"),
              const SizedBox(height: 16),
              TextFormField(
                controller: _transpermohonanIdController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'No Daftar',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: cariPermohonan,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'No daftar wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CardTranspermohonan(item: _selectedTranspermohonan),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedItemkegiatan,
                decoration: const InputDecoration(
                  labelText: 'Item Kegiatan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Item kegiatan wajib diisi';
                  }
                  return null;
                },

                items: _itemkegiatanOptions.map((e) {
                  return DropdownMenuItem(value: e.value, child: Text(e.label));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedItemkegiatan = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jumlahBiayaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Biaya',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah biaya wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ketBiayaController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Keterangan Biaya',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Keterangan biaya wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Simpan Perubahan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> cariPermohonan() async {
    final result = await showTranspermohonanBottomSheet(context, repository);

    if (result != null) {
      setState(() {
        _transpermohonanIdController.text = result.id;
        _selectedTranspermohonan = result;
      });
    }
  }
}
