import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:newklikrkw/pages/transaksis/biaya_perm.dart';
import 'package:newklikrkw/routes.dart';

class TransaksiScreen extends StatelessWidget {
  const TransaksiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Kegiatan')),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: ListView(
            children: [
              _SingleSection(
                title: "Permohonan",
                children: [
                  _CustomListTile(
                    title: "Transpermohonan",
                    icon: CupertinoIcons.person_2_fill,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        MyRoute.transpermohonanList.name,
                      );
                    },
                  ),
                  _CustomListTile(
                    title: "Lokasi Berkas",
                    icon: CupertinoIcons.location,
                    onTap: () {
                      Navigator.pushNamed(context, MyRoute.lokasiberkas.name);
                    },
                  ),
                ],
              ),
              _SingleSection(
                title: "Proses Permohonan",
                children: [
                  _CustomListTile(
                    title: "By Permohonan ",
                    icon: CupertinoIcons.person,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        MyRoute.prosespermohonan.name,
                      );
                    },
                  ),
                  _CustomListTile(
                    title: "By Proses",
                    icon: CupertinoIcons.gear,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        MyRoute.prosespermohonanList.name,
                      );
                    },
                  ),
                ],
              ),

              _SingleSection(
                title: "Keuangan",
                children: [
                  _CustomListTile(
                    title: "Kasbon",
                    icon: CupertinoIcons.device_phone_portrait,
                    onTap: () {
                      Navigator.pushNamed(context, MyRoute.kasbonList.name);
                    },
                  ),
                  _CustomListTile(
                    title: "Biaya Permohonan",
                    icon: CupertinoIcons.device_phone_portrait,
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => const BiayapermPage(),
                      //   ),
                      // );
                      Navigator.pushNamed(context, MyRoute.biayaperm.name);
                    },
                  ),
                  _CustomListTile(
                    title: "Pengeluaran Biaya",
                    icon: CupertinoIcons.money_pound,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        MyRoute.keluarbiayaList.name,
                      );
                    },
                  ),
                  _CustomListTile(
                    title: "Pengeluaran Biaya Perm",
                    icon: CupertinoIcons.money_dollar,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        MyRoute.keluarbiayapermuserList.name,
                      );
                    },
                  ),
                  _CustomListTile(
                    title: "Posting Jurnal",
                    icon: CupertinoIcons.money_dollar,
                    onTap: () {
                      Navigator.pushNamed(context, MyRoute.postingjurnals.name);
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
