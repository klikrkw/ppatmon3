import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newklikrkw/routes.dart';

class LaporanScreen extends StatelessWidget {
  const LaporanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: ListView(
            children: [
              _SingleSection(
                title: "Biaya Permohonan",
                children: [
                  _CustomListTile(
                    title: "Daftar Biaya Permohonan",
                    icon: CupertinoIcons.person,
                    onTap: () {
                      Navigator.pushNamed(context, MyRoute.biayapermList.name);
                    },
                  ),
                ],
              ),
              _SingleSection(
                title: "Keuangan",
                children: [
                  _CustomListTile(
                    title: "Pengeluaran Umum",
                    icon: Icons.account_balance_rounded,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        MyRoute.dkeluarbiayaByItem.name,
                      );
                    },
                  ),
                  _CustomListTile(
                    title: "Buku Besar",
                    icon: Icons.account_balance_rounded,
                    onTap: () {
                      Navigator.pushNamed(context, MyRoute.bukubesar.name);
                    },
                  ),
                  _CustomListTile(
                    title: "Neraca",
                    icon: Icons.balance_rounded,
                    onTap: () {
                      Navigator.pushNamed(context, MyRoute.neraca.name);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final Widget? trailing;
  const _CustomListTile({
    required this.title,
    required this.icon,
    this.onTap,
    // ignore: unused_element_parameter
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        title: Text(title),
        leading: Icon(icon),
        trailing: trailing ?? const Icon(CupertinoIcons.forward, size: 18),
        onTap: onTap,
      ),
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SingleSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title.toUpperCase(),
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontSize: 16),
          ),
        ),
        Container(
          width: double.infinity,
          color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
          child: Column(children: children),
        ),
      ],
    );
  }
}
