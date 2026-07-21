import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/transpermohonan/transpermohonan_bloc.dart';
import 'package:newklikrkw/blocs/transpermohonan/transpermohonan_event.dart';
import 'package:newklikrkw/blocs/transpermohonan/transpermohonan_state.dart';
import 'package:newklikrkw/utils/utils.dart';

class CardTranspermohonanWidget extends StatefulWidget {
  final String? transpermohonanId;
  const CardTranspermohonanWidget({super.key, required this.transpermohonanId});

  @override
  State<CardTranspermohonanWidget> createState() =>
      _CardTranspermohonanWidgetState();
}

class _CardTranspermohonanWidgetState extends State<CardTranspermohonanWidget> {
  @override
  void didUpdateWidget(covariant CardTranspermohonanWidget oldWidget) {
    if (oldWidget.transpermohonanId != widget.transpermohonanId) {
      if (widget.transpermohonanId != null) {
        context.read<TranspermohonanBloc>().add(
          FilterTranspermohonanId(
            transpermohonanId: widget.transpermohonanId,
            isTranspermohonanId: true,
          ),
        );
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    debugPrint('init card transpermohonan widget');
    context.read<TranspermohonanBloc>().add(ResetItem());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TranspermohonanBloc, TranspermohonanState>(
      builder: (context, state) {
        if (state.item != null) {
          return Card(
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    state.item!.noDaftar,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    state.item!.tglDaftar,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        state.item!.namaPenerima,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Spacer(),
                      Text(
                        state.item!.jenisPermohonan,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        state.item!.alasHak,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const Spacer(),
                      Text(
                        CommonUtils.truncate(state.item!.letakObyek, 20),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        state.item!.namaPelepas,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Spacer(),
                      Text(
                        state.item!.users.map((u) => u.name).join(', '),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
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
}
