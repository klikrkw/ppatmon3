import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/auth/auth.dart';
import 'package:newklikrkw/blocs/transpermohonan/transpermohonan_bloc.dart';
import 'package:newklikrkw/blocs/transpermohonan/transpermohonan_event.dart';
import 'package:newklikrkw/blocs/transpermohonan/transpermohonan_state.dart';
import 'package:newklikrkw/models/transpermohonan.dart';
import 'package:newklikrkw/pages/transpermohonans/transpermohonan_menu_page.dart';
import 'package:newklikrkw/utils/common_utils.dart';

class TranspermohonanPage extends StatefulWidget {
  const TranspermohonanPage({super.key});

  @override
  State<TranspermohonanPage> createState() => _TranspermohonanPageState();
}

class _TranspermohonanPageState extends State<TranspermohonanPage> {
  final ScrollController _controller = ScrollController();
  final TextEditingController searchController = TextEditingController();
  int? _userId = 0;

  @override
  void initState() {
    super.initState();
    final currentState = context.read<AuthBloc>().state;
    if (currentState is Authenticated) {
      _userId = currentState.user.id;
    }
    context.read<TranspermohonanBloc>().add(FilterUserId(_userId));

    _controller.addListener(() {
      if (_controller.position.pixels >
          _controller.position.maxScrollExtent - 300) {
        context.read<TranspermohonanBloc>().add(LoadMoreTranspermohonan());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trans Permohonan')),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari NoDaftar, Pelepas, Penerima',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();

                              context.read<TranspermohonanBloc>().add(
                                SearchTranspermohonan(''),
                              );
                              setState(() {});
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    context.read<TranspermohonanBloc>().add(
                      SearchTranspermohonan(value),
                    );

                    setState(() {});
                  },
                ),
                SizedBox(height: 12),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is Authenticated) {
                      return Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                FilterChip(
                                  avatar: const CircleAvatar(
                                    child: Icon(Icons.person, size: 16),
                                  ),
                                  label: const Text('All'),
                                  selected: _userId == null,
                                  showCheckmark: false,
                                  onSelected: (selected) {
                                    setState(() {
                                      _userId = null;
                                    });
                                    context.read<TranspermohonanBloc>().add(
                                      FilterUserId(null),
                                    );
                                  },
                                ),
                              ],
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
                                    context.read<TranspermohonanBloc>().add(
                                      FilterUserId(user.id),
                                    );
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
              ],
            ),
          ),
          BlocBuilder<TranspermohonanBloc, TranspermohonanState>(
            builder: (context, state) {
              return Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('Active'),
                    selected: state.active == true,
                    onSelected: (_) {
                      context.read<TranspermohonanBloc>().add(
                        FilterActiveChanged(true),
                      );
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Non Active'),
                    selected: state.active == false,
                    onSelected: (_) {
                      context.read<TranspermohonanBloc>().add(
                        FilterActiveChanged(false),
                      );
                    },
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 12),

          BlocBuilder<TranspermohonanBloc, TranspermohonanState>(
            builder: (context, state) {
              if (state.loading && state.items.isEmpty) {
                return Expanded(
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              return Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<TranspermohonanBloc>().add(
                      RefreshTranspermohonan(),
                    );
                  },
                  child: ListView.builder(
                    controller: _controller,
                    itemCount:
                        state.items.length + (state.hasReachedMax ? 0 : 1),
                    itemBuilder: (context, index) {
                      if (index >= state.items.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final item = state.items[index];

                      return Card(
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.noDaftar,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                item.tglDaftar,
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
                                    CommonUtils.truncate(item.namaPenerima, 28),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleSmall,
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
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    CommonUtils.truncate(item.letakObyek, 20),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    item.users.map((u) => u.name).join(', '),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              if (state is Authenticated) {
                                if (state.user.isAdmin == true) {
                                  return IconButton(
                                    color: item.active == true
                                        ? Colors.green
                                        : Colors.blueGrey,
                                    icon: (item.active == true)
                                        ? const Icon(Icons.check_box_outlined)
                                        : const Icon(
                                            Icons
                                                .check_box_outline_blank_rounded,
                                          ),
                                    onPressed: () =>
                                        showStatusBottomSheet(context, item),
                                  );
                                }
                                return Icon(
                                  item.active == true
                                      ? Icons.check_box_outlined
                                      : Icons.check_box_outline_blank_rounded,
                                  color: item.active == true
                                      ? Colors.green
                                      : Colors.blueGrey,
                                );
                              }
                              return Container();
                            },
                          ),
                          onTap: () {
                            context.read<TranspermohonanBloc>().add(
                              FilterQrCode(transpermohonanId: item.id),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TranspermohonanMenuPage(),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> showStatusBottomSheet(
    BuildContext context,
    Transpermohonan item,
  ) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.check_circle),
                  title: const Text('Active'),
                  onTap: () {
                    Navigator.pop(context);
                    context.read<TranspermohonanBloc>().add(
                      UpdateStatusTranspermohonan(id: item.id, active: true),
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.cancel),
                  title: const Text('Non Active'),
                  onTap: () {
                    Navigator.pop(context);

                    context.read<TranspermohonanBloc>().add(
                      UpdateStatusTranspermohonan(id: item.id, active: false),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
