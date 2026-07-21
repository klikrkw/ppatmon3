import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/prosespermohonan/prosespermohonan_bloc.dart';
import 'package:newklikrkw/blocs/prosespermohonan/prosespermohonan_event.dart';
import 'package:newklikrkw/models/store_prosespermohonan_request.dart';
import 'package:newklikrkw/models/transpermohonan.dart';
import 'package:newklikrkw/repositories/transpermohonan_repository.dart';
import 'package:newklikrkw/services/trans_permohonan_service.dart';
import 'package:newklikrkw/widgets/prosespermohonans/add_prosespermohonan_bottom_sheet.dart';
import 'package:newklikrkw/widgets/prosespermohonans/prosespermohonan_widget.dart';
import 'package:newklikrkw/widgets/trans_permohonan_bottom_sheet.dart';
import 'package:newklikrkw/widgets/transpermohonans/card_transpermohonan.dart';

class ProsespermohonanPage extends StatefulWidget {
  final Transpermohonan? transpermohonan;
  const ProsespermohonanPage({super.key, this.transpermohonan});

  @override
  State<ProsespermohonanPage> createState() => _ProsespermohonanPageState();
}

class _ProsespermohonanPageState extends State<ProsespermohonanPage> {
  final transpermohonanIdController = TextEditingController();
  late final TranspermohonanRepository transpermohonanRepository;
  final _transpermohonanService = TranspermohonanService();
  late Transpermohonan? _selectedTranspermohoan;

  @override
  void initState() {
    super.initState();
    transpermohonanRepository = TranspermohonanRepository(
      _transpermohonanService,
    );
    if (widget.transpermohonan != null) {
      transpermohonanIdController.text = widget.transpermohonan!.id.toString();
      setState(() {
        _selectedTranspermohoan = widget.transpermohonan;
      });
    }
    _selectedTranspermohoan = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Proses Permohonan')),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextFormField(
              controller: transpermohonanIdController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'No Daftar',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _cariPermohonan,
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedTranspermohoan != null)
              CardTranspermohonan(item: _selectedTranspermohoan!),
            Expanded(
              child: ProsespermohonanListWidget(
                transpermohonanId: transpermohonanIdController.text,
                onTapItem: (p) {
                  StoreProsespermohonanrequest request =
                      StoreProsespermohonanrequest(
                        id: p.id,
                        transpermohonanId: p.transpermohonan.id,
                        statusprosespermId: p.statusprosesperms.isNotEmpty
                            ? p.statusprosesperms[0].id
                            : 0,
                        itemprosespermId: p.itemprosesperm.id,
                        catatanProsesperm: p.catatanProsesperm,
                        userId: p.user.id,
                        isAlert: p.isAlert,
                      );
                  context.read<ProsespermohonanBloc>().add(
                    ResetValidationError(),
                  );
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => AddProsespermohonanBottomSheet(
                      transpermohonanId: transpermohonanIdController.text,
                      existingData: request,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          if (transpermohonanIdController.text.isEmpty) {
            return;
          }
          context.read<ProsespermohonanBloc>().add(ResetValidationError());
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => AddProsespermohonanBottomSheet(
              transpermohonanId: transpermohonanIdController.text,
            ),
          );
        },
      ),
    );
  }

  Future<void> _cariPermohonan() async {
    final result = await showTranspermohonanBottomSheet(
      context,
      transpermohonanRepository,
    );

    if (result != null) {
      setState(() {
        transpermohonanIdController.text = result.id;
        _selectedTranspermohoan = result;
      });

      // ignore: use_build_context_synchronously
      context.read<ProsespermohonanBloc>().add(
        LoadProsespermohonan(
          transpermohonanId: result.id,
          isTranspermohonanId: true,
        ),
      );
    }
  }
}
