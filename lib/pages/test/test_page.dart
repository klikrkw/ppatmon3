import 'package:flutter/material.dart';
import 'package:newklikrkw/models/desa.dart';
import 'package:newklikrkw/repositories/desa_repository.dart';
import 'package:newklikrkw/services/desa_service.dart';
import 'package:newklikrkw/widgets/searchable_selection_dialog.dart';
import 'dart:async';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final DesaRepository _repository = DesaRepository(service: DesaService());

  Desa? _selectedDesa;

  bool _loading = false;

  Future<void> _pilihDesa() async {
    setState(() {
      _loading = true;
    });

    try {
      // final desas = await _repository.getDesas();

      if (!mounted) return;

      final desa = await SearchableSelectionDialog.show<Desa>(
        context: context,
        title: "Pilih Desa",
        searchHint: "Cari nama desa...",
        selectedItem: _selectedDesa,
        asyncItems: (keyword) {
          return _repository.getDesas(query: keyword);
        },
        itemLabelBuilder: (e) => e.namaDesa,
        itemSubtitleBuilder: (e) => e.namaKecamatan,
      );

      if (desa != null) {
        setState(() {
          _selectedDesa = desa;
        });
      }

      // final result = await Navigator.push<Desa>(
      //   context,
      //   MaterialPageRoute(
      //     fullscreenDialog: true,
      //     builder: (_) => SearchableSelectionDialog<Desa>(
      //       title: "Pilih Desa",
      //       searchHint: "Cari desa...",
      //       selectedItem: _selectedDesa,
      //       asyncItems: (keyword) {
      //         return _repository.getDesas(query: keyword);
      //       },
      //       itemLabelBuilder: (e) => e.namaDesa,
      //       itemSubtitleBuilder: (e) => e.namaKecamatan,
      //       items: [],
      //     ),
      //   ),
      // );

      // if (result != null) {
      //   setState(() {
      //     _selectedDesa = result;
      //   });
      // }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test Pilih Desa")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              readOnly: true,
              controller: TextEditingController(
                text: _selectedDesa == null
                    ? ""
                    : "${_selectedDesa!.namaDesa} (${_selectedDesa!.namaKecamatan})",
              ),
              decoration: const InputDecoration(
                labelText: "Desa",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_city),
                suffixIcon: Icon(Icons.search),
              ),
              onTap: _loading ? null : _pilihDesa,
            ),

            const SizedBox(height: 24),

            if (_selectedDesa != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text("ID"),
                        subtitle: Text(_selectedDesa!.id),
                      ),
                      ListTile(
                        title: const Text("Nama Desa"),
                        subtitle: Text(_selectedDesa!.namaDesa),
                      ),
                      ListTile(
                        title: const Text("Kecamatan"),
                        subtitle: Text(_selectedDesa!.namaKecamatan),
                      ),
                    ],
                  ),
                ),
              ),

            if (_loading)
              const Padding(
                padding: EdgeInsets.only(top: 24),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
