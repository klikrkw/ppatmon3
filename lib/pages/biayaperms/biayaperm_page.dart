import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/auth/auth.dart';
import 'package:newklikrkw/blocs/transpermohonan/transpermohonan_bloc.dart';
import 'package:newklikrkw/blocs/transpermohonan/transpermohonan_state.dart';
import 'package:newklikrkw/models/transpermohonan.dart';
import 'package:newklikrkw/repositories/transpermohonan_repository.dart';
import 'package:newklikrkw/services/trans_permohonan_service.dart';
import 'package:newklikrkw/widgets/biayaperm_list_widget.dart';
import 'package:newklikrkw/widgets/dialogs/add_edit_biayaperm_dialog.dart';
import 'package:newklikrkw/widgets/trans_permohonan_bottom_sheet.dart';
import 'package:newklikrkw/widgets/transpermohonans/card_transpermohonan_widget.dart';

class BiayapermPage extends StatefulWidget {
  final Transpermohonan? transpermohonan;
  const BiayapermPage({super.key, this.transpermohonan});

  @override
  State<BiayapermPage> createState() => _BiayapermPageState();
}

class _BiayapermPageState extends State<BiayapermPage> {
  final transpermohonanIdController = TextEditingController();
  late final TranspermohonanRepository transpermohonanRepository;
  final _transpermohonanService = TranspermohonanService();
  late String? _selectedTranspermohonanId;
  @override
  void initState() {
    super.initState();
    _selectedTranspermohonanId = '';
    transpermohonanRepository = TranspermohonanRepository(
      _transpermohonanService,
    );
    if (widget.transpermohonan != null) {
      setState(() {
        _selectedTranspermohonanId = widget.transpermohonan!.id;
      });
      transpermohonanIdController.text = widget.transpermohonan!.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final user = authState is Authenticated ? authState.user : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Biaya Permohonan')),
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
            CardTranspermohonanWidget(
              transpermohonanId: _selectedTranspermohonanId,
            ),
            Expanded(
              child: BiayapermListWidget(
                transpermohonanId: _selectedTranspermohonanId,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          BlocBuilder<TranspermohonanBloc, TranspermohonanState>(
            builder: (context, state) {
              if (state.item == null) return const SizedBox.shrink();
              if (user!.isAdmin == false) return const SizedBox.shrink();
              return FloatingActionButton(
                onPressed: () async {
                  await AddEditBiayapermDialog.show(
                    context,
                    transpermohonanId: state.item!.id,
                  );
                },
                child: const Icon(Icons.add),
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
        _selectedTranspermohonanId = result.id;
      });
      transpermohonanIdController.text = result.id;
    }
  }
}
