import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String username;

  final int notificationCount;

  final VoidCallback? onNotificationTap;

  final VoidCallback? onHelpTap;

  const HomeHeader({
    super.key,
    required this.username,
    this.notificationCount = 0,
    this.onNotificationTap,
    this.onHelpTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Logo
        Container(
          width: 60,
          height: 38,
          alignment: Alignment.center,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "E-PPAT",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
              SizedBox(height: 2),
              Text(
                "Monitoring",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        /// Greeting
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Selamat Pagi,",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              // const SizedBox(height: 4),
              Text(
                username,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        /// Notification
        Stack(
          clipBehavior: Clip.none,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(28),
              onTap: onNotificationTap,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: .18),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),

            if (notificationCount > 0)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Text(
                    notificationCount > 99 ? "99+" : "$notificationCount",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(width: 10),

        /// Help
        InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onHelpTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: .18),
              borderRadius: BorderRadius.circular(28),
            ),
            child: const Row(
              children: [
                Icon(Icons.support_agent, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  "Help",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
