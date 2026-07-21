import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/kasbon/kasbon_bloc.dart';
import 'package:newklikrkw/pages/transaksis/kasbons/add_kasbon_page.dart';

class KasbonFormPage extends StatelessWidget {
  const KasbonFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<KasbonBloc, KasbonState>(
        builder: (context, state) {
          if (state is KasbonNew) {
            return AddKasbonPage();
          } else if (state is KasbonEdit) {
            final kasbon = state.kasbon;
            return Column(children: [Text('Form Edit : $kasbon ')]);
          }
          return Column(children: [const Text('Form Other')]);
        },
      ),
    );
  }
}
