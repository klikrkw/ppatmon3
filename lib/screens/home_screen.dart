import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/auth/auth.dart';
import 'package:newklikrkw/blocs/transpermohonan/transpermohonan_bloc.dart';
import 'package:newklikrkw/blocs/transpermohonan/transpermohonan_event.dart';
import 'package:newklikrkw/pages/biayaperms/biayaperm_list_page.dart';
import 'package:newklikrkw/pages/lokasi_berkas_page.dart';
import 'package:newklikrkw/pages/qr_reader_page.dart';
import 'package:newklikrkw/pages/transaksis/prosespermohonans/prosespermohonan_page.dart';
import 'package:newklikrkw/pages/transpermohonans/transpermohonan_menu_page.dart';
import 'package:newklikrkw/pages/transpermohonans/transpermohonan_page.dart';
import 'package:newklikrkw/routes.dart';
import 'package:newklikrkw/screens/laporan_screen.dart';
import 'package:newklikrkw/screens/profile_screen.dart';
import 'package:newklikrkw/screens/transaksi_screen.dart';
import 'package:newklikrkw/widgets/feature_grid_permohonan.dart';
import 'package:newklikrkw/widgets/home/saldo_kasbon_card.dart';

import '../../blocs/home/home_bloc.dart';
import '../../blocs/home/home_event.dart';
import '../../blocs/home/home_state.dart';

import '../../widgets/home/home_header.dart';
import '../../widgets/home/quick_menu_grid.dart';
import '../../widgets/home/home_banner_slider.dart';
import '../../widgets/home/feature_search.dart';
import '../../widgets/home/home_bottom_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    final userState = context.read<AuthBloc>().state;
    if (userState is Authenticated) {
      final userId = userState.user.id;
      context.read<HomeBloc>().add(LoadHome(userId));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.loading && state.dashboard == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.error != null && state.dashboard == null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 80, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.error!, textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () {
                      context.read<HomeBloc>().add(const RefreshHome());
                    },
                    child: const Text("Muat Ulang"),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xffF5F7FB),

          bottomNavigationBar: HomeBottomNavigation(
            currentIndex: _currentIndex,
            onChanged: (index) async {
              setState(() {
                _currentIndex = index;
              });
            },
          ),

          body: IndexedStack(
            index: _currentIndex,
            children: [
              _buildHome(state),
              _buildKegiatan(),
              Container(),
              _buildLaporan(),
              _buildProfile(),
            ],
          ),
          floatingActionButtonLocation:
              // FloatingActionButtonLocation.centerDocked,
              const CustomFabLocation(offsetY: 12),

          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await _scanQrCode(context);
            },
            child: const Icon(Icons.qr_code_scanner),
          ),
        );
      },
    );
  }

  Widget _buildHome(HomeState state) => SafeArea(
    child: Stack(
      children: [
        Container(
          height: 260,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff1976D2), Color(0xff42A5F5)],
            ),
          ),
        ),

        RefreshIndicator(
          onRefresh: () async {
            context.read<HomeBloc>().add(const RefreshHome());
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomeHeader(
                        username: state.dashboard?.name ?? "",

                        notificationCount:
                            state.dashboard?.notificationCount ?? 0,

                        onNotificationTap: () {},

                        onHelpTap: () {},
                      ),

                      const SizedBox(height: 18),

                      SaldoKasbonCard(
                        saldo: state.dashboard?.saldoKasbon ?? 0,

                        visible: state.showSaldo,

                        onToggleVisibility: () {
                          context.read<HomeBloc>().add(const ToggleSaldo());
                        },

                        onTapSemuaKasbon: () {
                          Navigator.pushNamed(context, MyRoute.kasbonList.name);
                        },
                      ),

                      const SizedBox(height: 24),

                      QuickMenuGrid(
                        onKasbon: () {
                          Navigator.pushNamed(context, MyRoute.kasbonList.name);
                        },
                        onPengeluaran: () {
                          Navigator.pushNamed(
                            context,
                            MyRoute.keluarbiayaList.name,
                          );
                        },
                        onProses: () {
                          Navigator.pushNamed(
                            context,
                            MyRoute.prosespermohonanList.name,
                          );
                        },
                        onBiaya: () {
                          Navigator.pushNamed(context, MyRoute.biayaperm.name);
                        },
                      ),

                      const SizedBox(height: 24),

                      const HomeBannerSlider(),

                      const SizedBox(height: 24),

                      FeatureSearch(
                        controller: _searchController,

                        onChanged: (keyword) {},

                        onManageFeature: () {},
                      ),

                      const SizedBox(height: 24),

                      FeatureGridPermohonan(features: _buildFeatures(context)),

                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        if (state.loading && state.dashboard != null)
          const Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: LinearProgressIndicator(),
          ),
      ],
    ),
  );

  TransaksiScreen _buildKegiatan() {
    return TransaksiScreen();
  }

  LaporanScreen _buildLaporan() {
    return LaporanScreen();
  }

  ProfileScreen _buildProfile() {
    return ProfileScreen();
  }

  Future<void> _scanQrCode(BuildContext context) async {
    final String? result = await QrReaderPage.show(context);

    if (!context.mounted) return;

    if (result == null || result.isEmpty) {
      return;
    }

    context.read<TranspermohonanBloc>().add(
      FilterQrCode(transpermohonanId: result),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TranspermohonanMenuPage()),
    );
    // Reset state jika diperlukan
  }
}

class CustomFabLocation extends FloatingActionButtonLocation {
  final double offsetY;

  const CustomFabLocation({this.offsetY = 20});

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabX =
        (scaffoldGeometry.scaffoldSize.width -
            scaffoldGeometry.floatingActionButtonSize.width) /
        2;

    final double fabY =
        scaffoldGeometry.contentBottom -
        (scaffoldGeometry.floatingActionButtonSize.height / 2) +
        offsetY;

    return Offset(fabX, fabY);
  }
}

List<HomeFeature> _buildFeatures(BuildContext context) {
  return [
    HomeFeature(
      title: "Permohonan",
      icon: Icons.person_outlined,
      color: Colors.green,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TranspermohonanPage()),
        );
      },
    ),
    HomeFeature(
      title: "Proses",
      icon: Icons.assignment_outlined,
      color: Colors.orange,
      badge: 5,
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => ProsespermohonanPage()));
      },
    ),
    HomeFeature(
      title: "Biaya",
      icon: Icons.receipt_long_outlined,
      color: Colors.red,
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => BiayapermListPage()));
      },
    ),
    HomeFeature(
      title: "Lokasi",
      icon: Icons.pin_drop_outlined,
      color: Colors.blue,
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => LokasiBerkasPage()));
      },
    ),
  ];
}
