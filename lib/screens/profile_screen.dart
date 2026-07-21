import 'package:flutter/material.dart';
import 'package:newklikrkw/widgets/account_setting.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(16), child: AccountSettings());
  }
}
