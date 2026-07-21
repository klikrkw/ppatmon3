import 'dart:async';

import 'package:flutter/material.dart';

class HomeBannerSlider extends StatefulWidget {
  final List<HomeBannerItem>? items;

  const HomeBannerSlider({super.key, this.items});

  @override
  State<HomeBannerSlider> createState() => _HomeBannerSliderState();
}

class _HomeBannerSliderState extends State<HomeBannerSlider> {
  late final PageController _controller;

  late final List<HomeBannerItem> _items;

  int _currentIndex = 0;

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _controller = PageController();

    _items =
        widget.items ??
        [
          HomeBannerItem(
            title: "Kasbon Lebih Mudah",
            subtitle: "Kelola kasbon dan pengeluaran secara realtime.",
            color1: const Color(0xff1976D2),
            color2: const Color(0xff42A5F5),
            icon: Icons.account_balance_wallet,
          ),
          HomeBannerItem(
            title: "Monitoring Proses",
            subtitle: "Pantau seluruh proses permohonan dari satu dashboard.",
            color1: const Color(0xff26A69A),
            color2: const Color(0xff4DB6AC),
            icon: Icons.assignment,
          ),
          HomeBannerItem(
            title: "Posting Jurnal",
            subtitle: "Posting jurnal otomatis setelah transaksi selesai.",
            color1: const Color(0xff5E35B1),
            color2: const Color(0xff7E57C2),
            icon: Icons.receipt_long,
          ),
        ];

    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_controller.hasClients) return;

      final next = (_currentIndex + 1) % _items.length;

      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 145,
          child: PageView.builder(
            controller: _controller,
            itemCount: _items.length,
            onPageChanged: (i) {
              setState(() {
                _currentIndex = i;
              });
            },
            itemBuilder: (_, index) {
              final item = _items[index];

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: LinearGradient(colors: [item.color1, item.color2]),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            item.subtitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      radius: 34,
                      backgroundColor: Colors.white24,
                      child: Icon(item.icon, size: 38, color: Colors.white),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_items.length, (index) {
            final active = index == _currentIndex;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: active ? 22 : 8,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: active ? Colors.blue : Colors.grey.shade400,
              ),
            );
          }),
        ),
      ],
    );
  }
}

class HomeBannerItem {
  final String title;

  final String subtitle;

  final Color color1;

  final Color color2;

  final IconData icon;

  HomeBannerItem({
    required this.title,
    required this.subtitle,
    required this.color1,
    required this.color2,
    required this.icon,
  });
}
