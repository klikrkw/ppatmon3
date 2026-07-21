import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  final Function(int) onPageIndexChanged;

  const BottomNav({super.key, required this.onPageIndexChanged});

  @override
  State<BottomNav> createState() => BottomNavState();
}

class BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      animationDuration: const Duration(seconds: 1),
      selectedIndex: _selectedIndex,
      destinations: _navBarItems,
      onDestinationSelected: (int index) {
        // Handle navigation
        setState(() {
          widget.onPageIndexChanged(index);
          _selectedIndex = index;
        });
      },
    );
  }
}

const _navBarItems = [
  NavigationDestination(
    icon: Icon(Icons.home_outlined),
    selectedIcon: Icon(Icons.home_rounded),
    label: 'Home',
  ),
  NavigationDestination(
    icon: Icon(Icons.list_alt_outlined),
    selectedIcon: Icon(Icons.list_alt_rounded),
    label: 'Kegiatan',
  ),
  NavigationDestination(
    icon: Icon(Icons.info_outline),
    selectedIcon: Icon(Icons.info_rounded),
    label: 'Informasi',
  ),
  NavigationDestination(
    icon: Icon(Icons.person_outline_rounded),
    selectedIcon: Icon(Icons.person_rounded),
    label: 'Profile',
  ),
];
