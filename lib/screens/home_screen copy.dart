import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/auth/auth.dart';
import 'package:newklikrkw/screens/dashboard_screen.dart';
import 'package:newklikrkw/screens/laporan_screen.dart';
import 'package:newklikrkw/screens/profile_screen.dart';
import 'package:newklikrkw/screens/transaksi_screen.dart';
import 'package:newklikrkw/widgets/bottom_nav.dart';
import 'package:newklikrkw/widgets/toggle_theme_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedScreenIndex = 0;
  final List<Widget> widgetOptions = const [
    DashboardScreen(),
    TransaksiScreen(),
    LaporanScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-PPAT'),
        actions: [
          ToggleThemeButton(),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
            },
          ),
        ],
      ),
      body: widgetOptions.elementAt(_selectedScreenIndex),
      bottomNavigationBar: BottomNav(
        onPageIndexChanged: (index) => setState(() {
          _selectedScreenIndex = index;
        }),
      ),
    );
  }
}
