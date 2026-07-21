import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/kasbon/kasbon_bloc.dart';
import 'package:newklikrkw/pages/transaksis/kasbons/edit_dkasbon_page.dart';
import 'package:newklikrkw/pages/transaksis/kasbons/edit_dkasbonperm_page.dart';
import 'package:newklikrkw/utils/common_utils.dart';
import 'package:newklikrkw/utils/format.dart';
import 'package:newklikrkw/widgets/kasbons/dkasbon_list_widget.dart';
import 'package:newklikrkw/widgets/kasbons/dkasbonnoperm_list_widget.dart';

import '../../../models/kasbon.dart';
// //`id`, `jumlah_kasbon`, `jumlah_penggunaan`, `sisa_penggunaan`, `keperluan`, `user_id`, `status_kasbon`, `created_at`, `updated_at`, `instansi_id`, `jenis_kasbon`

class EditKasbonPage extends StatefulWidget {
  const EditKasbonPage({super.key});

  @override
  State<EditKasbonPage> createState() => _EditKasbonPageState();
}

class _EditKasbonPageState extends State<EditKasbonPage> {
  Kasbon? _selectedKasbon;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Kasbon'),
        leading: IconButton(
          onPressed: () {
            context.read<KasbonBloc>().add(RefreshKasbonList());
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: BlocConsumer<KasbonBloc, KasbonState>(
          listener: (context, state) {
            if (state is KasbonEdit) {
              setState(() {
                _selectedKasbon = state.kasbon;
              });
            }
          },
          builder: (context, state) {
            if (state is KasbonEdit && _selectedKasbon != null) {
              return Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        '${_selectedKasbon!.id} - ${CommonUtils.formatDate(DateTime.parse(_selectedKasbon!.createdAt), format: 'dd-MMM-yy HH:mm')}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF42A5F5), // Blue 400
                              Color(0xFF1E88E5), // Blue 600
                              Color(0xFF1565C0), // Blue 800
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withValues(alpha: 0.30),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _infoField(
                              label: 'Staf',
                              value: _selectedKasbon!.user!.name,
                              textColor: Colors.white,
                            ),
                            const SizedBox(height: 12),

                            _infoField(
                              label: 'Status',
                              value: _selectedKasbon!.statusKasbon,
                              textColor: Colors.white,
                            ),
                            const SizedBox(height: 12),

                            _infoField(
                              label: 'Keperluan',
                              value: _selectedKasbon!.keperluan!,
                              textColor: Colors.white,
                            ),
                            const SizedBox(height: 12),

                            _infoField(
                              label: 'Instansi',
                              value: _selectedKasbon!.instansi.namaInstansi,
                              textColor: Colors.white,
                            ),
                            const SizedBox(height: 12),

                            _infoField(
                              label: 'Jumlah Kasbon',
                              value: formatRupiah(
                                _selectedKasbon!.sisaPenggunaan,
                              ),
                              textColor: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_selectedKasbon!.jenisKasbon == 'non_permohonan')
                      Expanded(
                        child: DkasbonnopermListWidget(
                          kasbonId: _selectedKasbon!.id,
                          randomCode: state.randomCode,
                        ),
                      ),
                    if (_selectedKasbon!.jenisKasbon == 'permohonan')
                      Expanded(
                        child: DkasbonListWidget(
                          kasbonId: _selectedKasbon!.id,
                          randomCode: state.randomCode,
                        ),
                      ),
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
      floatingActionButton: BlocBuilder<KasbonBloc, KasbonState>(
        builder: (context, state) {
          if (state is KasbonEdit) {
            if (state.kasbon.statusKasbon != 'wait_approval') {
              return Container();
            }
          }
          return FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              final Kasbon kasbon;
              if (state is KasbonEdit) {
                kasbon = state.kasbon;
                if (kasbon.jenisKasbon == 'non_permohonan') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditDKasbonPage(kasbon: kasbon),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditDKasbonpermPage(kasbon: kasbon),
                    ),
                  );
                }
              }
            },
          );
        },
      ),
    );
  }

  Widget _infoField({
    required String label,
    required String value,
    Color textColor = Colors.black,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: TextStyle(
              color: textColor.withValues(alpha: .85),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Text(": ", style: TextStyle(color: Colors.white70)),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
