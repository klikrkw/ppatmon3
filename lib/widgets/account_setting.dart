import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newklikrkw/blocs/auth/auth.dart';
import 'package:newklikrkw/models/user_model.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({super.key});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is Authenticated) {
          return Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: ListView(
              children: [
                _buildHeader(context, isDark, state.user),
                const Divider(),
                _buildSection(
                  context,
                  title: 'Security',
                  isDark: isDark,
                  children: [
                    _buildSettingTile(
                      context,
                      icon: Icons.lock_outline,
                      title: 'Change Password',
                      subtitle: 'Last changed 30 days ago',
                      isDark: isDark,
                      onTap: () {},
                    ),
                    _buildSettingTile(
                      context,
                      icon: Icons.security,
                      title: 'Two-Factor Authentication',
                      subtitle: 'Enabled',
                      isDark: isDark,
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Enabled',
                          style: TextStyle(color: Colors.green, fontSize: 12),
                        ),
                      ),
                      onTap: () {},
                    ),
                    _buildSettingTile(
                      context,
                      icon: Icons.key,
                      title: 'Active Sessions',
                      subtitle: '2 devices',
                      isDark: isDark,
                      onTap: () {},
                    ),
                  ],
                ),
                _buildSection(
                  context,
                  title: 'Danger Zone',
                  isDark: isDark,
                  children: [
                    _buildSettingTile(
                      context,
                      icon: Icons.logout,
                      title: 'Sign Out',
                      subtitle: 'Sign out from all devices',
                      isDark: isDark,
                      onTap: () {
                        context.read<AuthBloc>().add(LogoutRequested());
                      },
                    ),
                    _buildSettingTile(
                      context,
                      icon: Icons.delete_forever,
                      title: 'Delete Account',
                      subtitle: 'Permanently delete your account',
                      isDark: isDark,
                      textColor: Colors.red,
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, UserModel user) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue,
            child: Icon(Icons.person, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.email,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white54 : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required bool isDark,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: title == 'Danger Zone'
                  ? Colors.red
                  : (isDark ? Colors.white54 : Colors.grey[600]),
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required bool isDark,
    Color? textColor,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: (textColor ?? Colors.blue).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: textColor ?? Colors.blue),
      ),
      title: Text(title, style: TextStyle(color: textColor)),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                color: isDark ? Colors.white54 : Colors.grey[600],
                fontSize: 12,
              ),
            )
          : null,
      trailing:
          trailing ??
          Icon(
            Icons.chevron_right,
            color: isDark ? Colors.white30 : Colors.grey[400],
          ),
      onTap: onTap,
    );
  }
}
