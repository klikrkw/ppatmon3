import 'package:flutter/material.dart';

class FeatureGrid extends StatelessWidget {
  final List<HomeFeature>? features;

  const FeatureGrid({super.key, this.features});

  @override
  Widget build(BuildContext context) {
    final items = features ?? _defaultFeatures;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 18,
        mainAxisSpacing: 22,
        childAspectRatio: .78,
      ),
      itemBuilder: (_, index) {
        final item = items[index];

        return InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: item.onTap,
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 74,
                    height: 74,
                    decoration: BoxDecoration(
                      color: item.color.withValues(alpha: .10),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(item.icon, size: 36, color: item.color),
                  ),

                  if (item.badge > 0)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Text(
                          item.badge > 99 ? "99+" : item.badge.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 10),

              Text(
                item.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class HomeFeature {
  final String title;

  final IconData icon;

  final Color color;

  final int badge;

  final VoidCallback? onTap;

  const HomeFeature({
    required this.title,
    required this.icon,
    required this.color,
    this.badge = 0,
    this.onTap,
  });
}

final List<HomeFeature> _defaultFeatures = [
  HomeFeature(
    title: "Permohonan",
    icon: Icons.person_outlined,
    color: Colors.green,
    badge: 2,
    onTap: () {},
  ),
  HomeFeature(
    title: "Pengeluaran",
    icon: Icons.payments_outlined,
    color: Colors.blue,
  ),
  HomeFeature(
    title: "Proses",
    icon: Icons.assignment_outlined,
    color: Colors.orange,
    badge: 5,
  ),
  HomeFeature(
    title: "Biaya",
    icon: Icons.receipt_long_outlined,
    color: Colors.red,
  ),
  HomeFeature(
    title: "Post Jurnal",
    icon: Icons.book_outlined,
    color: Colors.indigo,
  ),
  HomeFeature(
    title: "Arsip",
    icon: Icons.folder_open_outlined,
    color: Colors.teal,
  ),
  HomeFeature(
    title: "Laporan",
    icon: Icons.bar_chart_outlined,
    color: Colors.deepPurple,
  ),
  HomeFeature(
    title: "Pengaturan",
    icon: Icons.settings_outlined,
    color: Colors.grey,
  ),
];
