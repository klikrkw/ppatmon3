import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/kasbon/kasbon_bloc.dart';
import 'package:newklikrkw/models/db_option.dart';
import 'package:newklikrkw/models/kasbon.dart';
import 'package:newklikrkw/routes.dart';
import 'package:newklikrkw/services/itemkegiatan_service.dart';
import 'package:newklikrkw/services/kasbon_service.dart';

class EditDKasbonPage extends StatefulWidget {
  final Kasbon kasbon;
  const EditDKasbonPage({super.key, required this.kasbon});
  @override
  State<EditDKasbonPage> createState() => _EditDKasbonPageState();
}

class _EditDKasbonPageState extends State<EditDKasbonPage> {
  final _formKey = GlobalKey<FormState>();
  final KasbonService _service = KasbonService();
  final ItemkegiatanService _itemkegiatanService = ItemkegiatanService();
  late TextEditingController _jumlahBiayaController;
  late TextEditingController _ketBiayaController;
  String? _selectedJenisKasbon;
  String? _selectedItemkegiatan;
  bool _isLoading = false;
  List<String> _jenisKasbonOptions = [];
  List<DbOption> _itemkegiatanOptions = [];
  @override
  void initState() {
    super.initState();
    _jumlahBiayaController = TextEditingController(text: '');
    _ketBiayaController = TextEditingController(text: "");
    _selectedJenisKasbon = widget.kasbon.jenisKasbon;
    _loadJenisKasbon();
    _loadItemkegiatan();
  }

  Future<void> _loadJenisKasbon() async {
    try {
      final options = _service.getJenisKasbonOptions();
      setState(() {
        _jenisKasbonOptions = options;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _loadItemkegiatan() async {
    try {
      final options = await _itemkegiatanService.getOptions();
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
      final request = UpdateKasbonRequest(
        jenisKasbon: _selectedJenisKasbon!,
        jumlahBiaya: double.parse(_jumlahBiayaController.text),
        itemkegiatanId: int.parse(_selectedItemkegiatan!),
        ketBiaya: _ketBiayaController.text,
      );
      final resp = await _service.updateKasbon(
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
            children: [
              // DropdownButtonFormField<String>(
              //   initialValue: _selectedJenisKasbon,
              //   decoration: const InputDecoration(
              //     labelText: 'Jenis Kasbon',
              //     border: OutlineInputBorder(),
              //   ),
              //   items: _jenisKasbonOptions.map((e) {
              //     return DropdownMenuItem(value: e, child: Text(e));
              //   }).toList(),
              //   onChanged: (value) {
              //     setState(() {
              //       _selectedJenisKasbon = value;
              //     });
              //   },
              // ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedItemkegiatan,
                decoration: const InputDecoration(
                  labelText: 'Item Kegiatan',
                  border: OutlineInputBorder(),
                ),
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
}
