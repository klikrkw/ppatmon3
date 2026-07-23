import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/auth/auth.dart';
import 'package:newklikrkw/blocs/kasbon/kasbon_bloc.dart';
import 'package:newklikrkw/models/db_option.dart';
import 'package:newklikrkw/models/kasbon.dart';
import 'package:newklikrkw/pages/transaksis/kasbons/edit_kasbon_page.dart';
import 'package:newklikrkw/routes.dart';
import 'package:newklikrkw/services/kasbon_service.dart';
import 'package:newklikrkw/services/user_service.dart';
import 'package:newklikrkw/utils/utils.dart';

class KasbonListPage extends StatefulWidget {
  const KasbonListPage({super.key});

  @override
  State<KasbonListPage> createState() => _KasbonListPageState();
}

class _KasbonListPageState extends State<KasbonListPage> {
  final ScrollController _scrollController = ScrollController();
  final List<Kasbon> _kasbonList = [];
  final _kasbonService = KasbonService();
  final _userService = UserService();

  int _currentPage = 1;
  bool _isLoading = false;
  bool _isStatusOptLoading = false;
  bool _isUserOptLoading = false;

  bool _hasMore = true;
  String? _selectedStatus = 'wait_approval';
  String? _selectedUser = '';

  final List<DbOption> _statusKasbonOptions = []; // List<Map<String, dynamic>>
  final List<DbOption> _userOptions = []; // List<Map<String, dynamic>>

  @override
  void initState() {
    super.initState();
    // _fetchKasbon();
    _fetchKasbonOptions();
    _fetchUserOptions();
    _scrollController.addListener(_onScroll);
    final authState = context.read<AuthBloc>().state;
    final user = authState is Authenticated ? authState.user : null;
    if (user!.isAdmin == false) {
      setState(() {
        _selectedUser = user.id.toString();
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await _fetchKasbon();
      } catch (_) {}
    });
  }

  Future<void> _onStatusChanged(String? value) async {
    setState(() {
      _selectedStatus = _statusKasbonOptions.isNotEmpty
          ? _statusKasbonOptions
                .firstWhere((element) => element.value == value)
                .value
          : 'semua';
      _currentPage = 1;
      _hasMore = true;
      _kasbonList.clear();
    });

    await _fetchKasbon();
  }

  Future<void> _onUserChanged(String? value) async {
    setState(() {
      _selectedUser = _userOptions.isNotEmpty
          ? _userOptions.firstWhere((element) => element.value == value).value
          : '';
      _currentPage = 1;
      _hasMore = true;
      _kasbonList.clear();
    });

    await _fetchKasbon();
  }

  Widget _buildFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: DropdownButtonFormField<String>(
        initialValue: _selectedStatus ?? 'wait_approval',
        decoration: const InputDecoration(
          labelText: 'Filter Status',
          border: OutlineInputBorder(),
        ),
        items: _statusKasbonOptions.map((status) {
          return DropdownMenuItem(
            value: status.value,
            child: Text(status.label),
          );
        }).toList(),
        onChanged: _onStatusChanged,
      ),
    );
  }

  Widget _buildUserFilter() {
    final authState = context.watch<AuthBloc>().state;
    final user = authState is Authenticated ? authState.user : null;
    if (user!.isAdmin == false) return Container();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: _isUserOptLoading
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.amberAccent),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const CircularProgressIndicator(
                backgroundColor: Colors.amber,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
              ),
            )
          : DropdownButtonFormField<String>(
              initialValue: '',
              decoration: const InputDecoration(
                labelText: 'Filter User',
                border: OutlineInputBorder(),
              ),
              items: _userOptions.map((status) {
                return DropdownMenuItem(
                  value: status.value,
                  child: Text(status.label),
                );
              }).toList(),
              onChanged: _onUserChanged,
            ),
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    // Trigger ketika tersisa 300px dari bawah
    if (currentScroll >= (maxScroll - 300)) {
      _fetchKasbon();
    }
  }

  Future<void> _fetchKasbon() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });
    try {
      final result = await _kasbonService.list(
        keyword: '',
        statusKasbon: _selectedStatus,
        userId: _selectedUser,
        page: _currentPage,
        pageSize: 10,
      );

      final newData = result.data;

      setState(() {
        _kasbonList.addAll(newData);

        _hasMore = result.hasMore;

        if (newData.isNotEmpty) {
          _currentPage++;
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchKasbonOptions() async {
    setState(() {
      _isStatusOptLoading = true;
    });
    try {
      final result = await _kasbonService.getStatusKasbonOptions();

      setState(() {
        _statusKasbonOptions.addAll(result);
      });
    } catch (e) {
      debugPrint(e.toString());
      _isStatusOptLoading = false;
    } finally {
      setState(() {
        _isStatusOptLoading = false;
      });
    }
  }

  Future<void> _fetchUserOptions() async {
    setState(() {
      _isUserOptLoading = true;
    });
    try {
      final result = await _userService.getUserOptions();

      setState(() {
        _userOptions.addAll(result);
      });
    } catch (e) {
      _isUserOptLoading = false;
    } finally {
      setState(() {
        _isUserOptLoading = false;
      });
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _currentPage = 1;
      _hasMore = true;
      _kasbonList.clear();
    });

    await _fetchKasbon();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();

    super.dispose();
  }

  Widget _buildKasbonItem(Kasbon kasbon) {
    // final updatedAt = DateFormat(
    //   'dd MMM yyyy HH:mm',
    //   'id_ID',
    // ).format(DateTime.parse(kasbon.updatedAt));
    // final updatedAt = formatDateTimeIndo(
    //   tanggal: kasbon.updatedAt,
    //   format: 'dd MMM yyyy',
    // );
    final authState = context.watch<AuthBloc>().state;
    final user = authState is Authenticated ? authState.user : null;

    return BlocConsumer<KasbonBloc, KasbonState>(
      listener: (context, state) {
        if (state is KasbonRefreshList) {
          _refresh();
        }
      },
      builder: (context, state) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shadowColor: Theme.of(context).colorScheme.primary,
          elevation: 2,

          child: Column(
            children: [
              ListTile(
                titleAlignment: ListTileTitleAlignment.top,
                title: Row(
                  children: [
                    Text(
                      CommonUtils.truncate(kasbon.keperluan ?? "", 20),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${kasbon.id} ',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      formatDateTimeIndo(
                        tanggal: kasbon.updatedAt,
                        format: 'dd MMM yy',
                      ),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                subtitle: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Petugas ",
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        Spacer(),
                        Text(
                          kasbon.user?.name ?? "",
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        IconButton(
                          onPressed: () {
                            final contex = context;
                            contex.read<KasbonBloc>().add(EditKasbon(kasbon));
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditKasbonPage(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit, color: Colors.green),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    // Row(
                    //   children: [
                    //     Text(
                    //       "Jenis Kasbon ",
                    //       style: Theme.of(context).textTheme.titleSmall
                    //           ?.copyWith(
                    //             color: Theme.of(context).colorScheme.primary,
                    //           ),
                    //     ),
                    //     Spacer(),
                    //     Text(
                    //       kasbon.jenisKasbon,
                    //       style: Theme.of(context).textTheme.titleSmall
                    //           ?.copyWith(
                    //             color: Theme.of(context).colorScheme.primary,
                    //           ),
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          "Status ",
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        Spacer(),
                        Text(
                          kasbon.statusKasbon,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          "Instansi ",
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        Spacer(),
                        Text(
                          kasbon.instansi.namaInstansi,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8.0).copyWith(
                          bottomLeft: Radius.zero,
                          bottomRight: Radius.zero,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2, // Takes up 2/6 (33%) of the width
                            child: Text('Jumlah'),
                          ),
                          Expanded(
                            flex: 2, // Takes up 3/6 (50%) of the width
                            child: Text('Penggunaan'),
                          ),
                          Expanded(
                            flex: 2, // Takes up 1/6 (17%) of the width
                            child: Text('Sisa'),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(
                          8.0,
                        ).copyWith(topLeft: Radius.zero, topRight: Radius.zero),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2, // Takes up 2/6 (33%) of the width
                            child: Text(
                              '${formatRupiah(kasbon.jumlahKasbon)} ',
                            ),
                          ),
                          Expanded(
                            flex: 2, // Takes up 3/6 (50%) of the width
                            child: Text(
                              '${formatRupiah(kasbon.jumlahPenggunaan)} ',
                            ),
                          ),
                          Expanded(
                            flex: 2, // Takes up 1/6 (17%) of the width
                            child: Text(
                              '${formatRupiah(kasbon.sisaPenggunaan)} ',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
                onTap: () => user!.isAdmin == true
                    ? _showUpdateStatusBottomSheet(kasbon)
                    : null,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomLoader() {
    if (!_isLoading) return const SizedBox();
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildNoMoreData() {
    if (_hasMore || _kasbonList.isEmpty) {
      return const SizedBox();
    }

    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(child: Text('Tidak ada data lagi')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Kasbon')),
      body: Column(
        children: [
          _buildFilter(),
          _buildUserFilter(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: _kasbonList.length + 1,
                itemBuilder: (context, index) {
                  if (index < _kasbonList.length) {
                    return _buildKasbonItem(_kasbonList[index]);
                  }

                  return Column(
                    children: [_buildBottomLoader(), _buildNoMoreData()],
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                final user = state.user;
                context.read<KasbonBloc>().add(NewKasbon(userId: user.id));
                Navigator.pushNamed(context, MyRoute.addKasbon.name);
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Future<void> _showUpdateStatusBottomSheet(Kasbon kasbon) async {
    DbOption selectedStatus = _statusKasbonOptions.firstWhere(
      (element) => element.value == kasbon.statusKasbon,
    );

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        bool isSubmitting = false;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Update Status Kasbon',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(kasbon.id),
                  const SizedBox(height: 20),
                  _isStatusOptLoading
                      ? const LinearProgressIndicator()
                      : DropdownButtonFormField<String>(
                          initialValue: selectedStatus.value,
                          decoration: const InputDecoration(
                            labelText: 'Status Kasbon',
                            border: OutlineInputBorder(),
                          ),
                          items: _statusKasbonOptions.map((status) {
                            return DropdownMenuItem(
                              value: status.value,
                              child: Text(status.label),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setModalState(() {
                                selectedStatus = _statusKasbonOptions
                                    .firstWhere((s) => s.value == value);
                              });
                            }
                          },
                        ), // Use the names of the StatusKasbon enumconst SizedBox(height: 20),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSubmitting
                          ? null
                          : () async {
                              try {
                                setModalState(() {
                                  isSubmitting = true;
                                });

                                await _kasbonService.updateStatusKasbon(
                                  id: kasbon.id,
                                  statusKasbon: selectedStatus.value,
                                );

                                if (!mounted) {
                                  return;
                                }

                                Navigator.pop(context);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Status berhasil diperbarui'),
                                  ),
                                );

                                await _refresh();
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())),
                                );
                              } finally {
                                setModalState(() {
                                  isSubmitting = false;
                                });
                              }
                            },
                      child: isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(),
                            )
                          : const Text('Simpan'),
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
