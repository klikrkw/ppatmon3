import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/auth/auth.dart';
import 'package:newklikrkw/blocs/kasbon/kasbon_bloc.dart';
import 'package:newklikrkw/models/kasbon.dart';
import 'package:newklikrkw/routes.dart';
import 'package:newklikrkw/utils/format.dart';

class AddKasbonPage extends StatefulWidget {
  const AddKasbonPage({super.key});

  @override
  State<AddKasbonPage> createState() => _AddKasbonPageState();
}

class _AddKasbonPageState extends State<AddKasbonPage> {
  final _formKey = GlobalKey<FormState>();

  // final KasbonService _service =
  //     KasbonService();

  final TextEditingController _keperluanController = TextEditingController();

  final String _selectedJenisKasbon = 'non_permohonan';
  final String _selectedStatusKasbon = 'wait_approval';

  final bool _isLoading = false;

  String? _selectedInstansi;

  // List<String> _jenisKasbonOptions = [];
  // List<String> _statusKasbonOptions = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _keperluanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Kasbon')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: BlocConsumer<KasbonBloc, KasbonState>(
            listener: (context, state) {
              final kasbonBloc = context.read<KasbonBloc>();
              if (state is KasbonAddedSuccess) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
                kasbonBloc.add(EditKasbon(state.kasbon));
                Navigator.pushReplacementNamed(
                  context,
                  MyRoute.editKasbon.name,
                );
              }
              if (state is KasbonError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
            builder: (context, state) {
              final kasbonBloc = context.read<KasbonBloc>();
              if (state is KasbonNew) {
                // final statusKasbonOptions = state.statusKasbonOptions;
                // final jenisKasbonOptions = state.jenisKasbonOptions;
                final instansiOptions = state.instansiOptions;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _keperluanController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Keperluan',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Keperluan wajib diisi';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // DropdownButtonFormField<String>(
                    //   initialValue: _selectedJenisKasbon,
                    //   decoration: const InputDecoration(
                    //     labelText: 'Jenis Kasbon',
                    //     border: OutlineInputBorder(),
                    //   ),
                    //   items: jenisKasbonOptions
                    //       .map(
                    //         (e) => DropdownMenuItem(value: e, child: Text(e)),
                    //       )
                    //       .toList(),
                    //   onChanged: (value) {
                    //     setState(() {
                    //       _selectedJenisKasbon = value;
                    //     });
                    //   },
                    // ),
                    // DropdownButtonFormField<String>(
                    //   initialValue: _selectedStatusKasbon,
                    //   decoration: const InputDecoration(
                    //     labelText: 'Status Kasbon',
                    //     border: OutlineInputBorder(),
                    //   ),
                    //   items: statusKasbonOptions
                    //       .map(
                    //         (e) => DropdownMenuItem(
                    //           value: e.value,
                    //           child: Text(e.label),
                    //         ),
                    //       )
                    //       .toList(),
                    //   onChanged: (value) {
                    //     setState(() {
                    //       _selectedStatusKasbon = value;
                    //     });
                    //   },
                    // ) : Text(state.statusKasbon),
                    _infoField(
                      label: "Total Kasbon",
                      value: formatRupiah(state.totalKasbon),
                    ),

                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedInstansi,
                      decoration: const InputDecoration(
                        labelText: 'Instansi',
                        border: OutlineInputBorder(),
                        hintText: 'Pilih Instansi',
                      ),
                      items: instansiOptions
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.value,
                              child: Text(e.label),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedInstansi = value;
                        });
                      },
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  final currentState = context
                                      .read<AuthBloc>()
                                      .state;
                                  int userId = 0;
                                  if (currentState is Authenticated) {
                                    userId = currentState.user.id;
                                  }
                                  final AddKasbonRequest request =
                                      AddKasbonRequest(
                                        jumlahKasbon: state.totalKasbon,
                                        jumlahPenggunaan: 0,
                                        sisaPenggunaan: state.totalKasbon,
                                        keperluan: _keperluanController.text,
                                        jenisKasbon: _selectedJenisKasbon,
                                        statusKasbon: _selectedStatusKasbon,
                                        userId: userId,
                                        instansiId: int.parse(
                                          _selectedInstansi!,
                                        ),
                                      );
                                  // debugPrint(request.toJson().toString());
                                  kasbonBloc.add(AddKasbon(request));
                                }
                              },
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Simpan'),
                      ),
                    ),
                  ],
                );
              }
              return Container(
                color: Colors.amber,
                child: const Center(child: Text('UnAutenticated')),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _infoField({required String label, required String value}) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.amberAccent),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              "$label ",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "$value ",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
