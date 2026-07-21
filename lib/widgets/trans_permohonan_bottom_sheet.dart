import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/auth/auth.dart';
import 'package:newklikrkw/models/transpermohonan.dart';
import 'package:newklikrkw/repositories/transpermohonan_repository.dart';
import 'package:newklikrkw/utils/common_utils.dart';

Future<Transpermohonan?> showTranspermohonanBottomSheet(
  BuildContext context,
  TranspermohonanRepository repository,
) {
  return showModalBottomSheet<Transpermohonan>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) {
      return _TranspermohonanSearchSheet(repository: repository);
    },
  );
}

class _TranspermohonanSearchSheet extends StatefulWidget {
  final TranspermohonanRepository repository;

  const _TranspermohonanSearchSheet({required this.repository});

  @override
  State<_TranspermohonanSearchSheet> createState() =>
      _TranspermohonanSearchSheetState();
}

class _TranspermohonanSearchSheetState
    extends State<_TranspermohonanSearchSheet> {
  final searchController = TextEditingController();

  List<Transpermohonan> items = [];

  bool loading = false;
  Timer? _debounce;
  int? _userId;

  Future<void> search(String keyword, int? userId) async {
    setState(() => loading = true);

    try {
      items = await widget.repository.search(keyword, userId);
    } finally {
      setState(() => loading = false);
    }
  }

  void onSearchChanged(String value) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      search(value, _userId!);
    });
  }

  @override
  void initState() {
    super.initState();
    final currentState = context.read<AuthBloc>().state;
    if (currentState is Authenticated) {
      _userId = currentState.user.id;
    }

    search('', _userId);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.50,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Cari Permohonan...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: onSearchChanged,
              ),

              const SizedBox(height: 10),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is Authenticated) {
                    return Container(
                      height: 60,
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          FilterChip(
                            avatar: const CircleAvatar(
                              child: Icon(Icons.person, size: 16),
                            ),
                            label: const Text("All"),
                            selected: _userId == 0,
                            showCheckmark: false,
                            onSelected: (selected) {
                              setState(() {
                                _userId = 0;
                              });
                              search(searchController.text, _userId);
                            },
                          ),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: state.users.map((user) {
                              return FilterChip(
                                avatar: const CircleAvatar(
                                  child: Icon(Icons.person, size: 16),
                                ),
                                label: Text(
                                  CommonUtils.truncate(user.name, 10),
                                ),
                                selected: _userId == user.id,
                                showCheckmark: false,
                                onSelected: (selected) {
                                  setState(() {
                                    _userId = user.id;
                                  });
                                  search(searchController.text, user.id);
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),

              const SizedBox(height: 10),

              Expanded(
                child: loading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];

                          return Card(
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item.noDaftar,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  Text(
                                    item.tglDaftar,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleSmall,
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        item.namaPenerima,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium,
                                      ),
                                      const Spacer(),
                                      Text(
                                        item.jenisPermohonan,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        item.alasHak,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                      const Spacer(),
                                      Text(
                                        CommonUtils.truncate(
                                          item.letakObyek,
                                          20,
                                        ),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        item.namaPelepas,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                      Spacer(),
                                      Text(
                                        item.users
                                            .map((u) => u.name)
                                            .join(', '),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.pop(context, item);
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
