import 'package:flutter/material.dart';
import 'package:newklikrkw/widgets/home/feature_grid.dart';

class FeatureGridPermohonan extends StatelessWidget {
  final List<HomeFeature> features;

  const FeatureGridPermohonan({super.key, required this.features});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: features.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 18,
        mainAxisSpacing: 22,
        childAspectRatio: .78,
      ),
      itemBuilder: (_, index) {
        final item = features[index];

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
