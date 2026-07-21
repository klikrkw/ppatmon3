import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/prosespermohonan/prosespermohonan_bloc.dart';
import 'package:newklikrkw/blocs/prosespermohonan/prosespermohonan_event.dart';
import 'package:newklikrkw/blocs/prosespermohonan/prosespermohonan_state.dart';
import 'package:newklikrkw/models/prosespermohonan.dart';
import 'package:newklikrkw/utils/dio.dart';

class ProsespermohonanListWidget extends StatefulWidget {
  final String? transpermohonanId;
  final bool enableSearch;
  final Function(Prosespermohonan prosespermohonan)? onTapItem;
  const ProsespermohonanListWidget({
    super.key,
    this.transpermohonanId,
    this.enableSearch = false,
    this.onTapItem,
  });

  @override
  State<ProsespermohonanListWidget> createState() =>
      _ProsespermohonanListWidgetState();
}

class _ProsespermohonanListWidgetState
    extends State<ProsespermohonanListWidget> {
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    context.read<ProsespermohonanBloc>().add(
      LoadProsespermohonan(
        transpermohonanId: widget.transpermohonanId,
        isTranspermohonanId: true,
      ),
    );

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;

    final currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll - 300) {
      context.read<ProsespermohonanBloc>().add(LoadMoreProsespermohonan());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildItem(BuildContext context, Prosespermohonan item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(item.itemprosesperm.namaItemprosesperm),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            item.statusprosesperms.isNotEmpty
                ? Text(item.statusprosesperms[0].updatedAt!)
                : Container(),
            Text(item.catatanProsesperm),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (item.statusprosesperms.isNotEmpty)
              GestureDetector(
                onTap: () {
                  widget.onTapItem!(item);
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      item.statusprosesperms.isNotEmpty
                          ? Chip(
                              avatar: item.statusprosesperms.isNotEmpty
                                  ? CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: NetworkImage(
                                        '$myBaseUrl${item.statusprosesperms[0].imageStatusprosesperm}',
                                      ),
                                    )
                                  : null,
                              label: Text(
                                item.statusprosesperms[0].namaStatusprosesperm,
                                style: const TextStyle(fontSize: 12),
                              ),
                            )
                          : Container(),
                    ],
                    // item.statusprosesperms
                    //     .map((status) {
                    //       return Chip(
                    //         avatar:
                    //             status
                    //                 .imageStatusprosesperm
                    //                 .isNotEmpty
                    //             ? CircleAvatar(
                    //                 radius: 10,
                    //                 backgroundColor:
                    //                     Colors.transparent,
                    //                 backgroundImage: NetworkImage(
                    //                   '$myBaseUrl${status.imageStatusprosesperm}',
                    //                 ),
                    //               )
                    //             : null,
                    //         label: Text(
                    //           status.namaStatusprosesperm,
                    //           style: const TextStyle(
                    //             fontSize: 12,
                    //           ),
                    //         ),
                    //       );
                    //     })
                    //     .toList()
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.enableSearch)
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Cari proses...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                context.read<ProsespermohonanBloc>().add(
                  SearchProsespermohonan(value),
                );
              },
            ),
          ),

        Expanded(
          child: BlocBuilder<ProsespermohonanBloc, ProsespermohonanState>(
            builder: (context, state) {
              if (state.loading && state.items.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.items.isEmpty) {
                return const Center(
                  child: Text('Belum ada data proses permohonan'),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ProsespermohonanBloc>().add(
                    LoadProsespermohonan(
                      transpermohonanId: widget.transpermohonanId,
                      query: state.query,
                      isTranspermohonanId: true,
                    ),
                  );
                },
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: state.items.length + (state.hasReachedMax ? 0 : 1),
                  itemBuilder: (context, index) {
                    if (index >= state.items.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final item = state.items[index];

                    return _buildItem(context, item);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
