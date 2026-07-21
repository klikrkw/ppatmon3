import 'package:newklikrkw/features/home/home_page.dart';
import 'package:newklikrkw/pages/biayaperms/biayaperm_list_page.dart';
import 'package:newklikrkw/pages/biayaperms/biayaperm_page.dart';
import 'package:newklikrkw/pages/dkeluarbiayas/dkeluarbiayas_by_item_page.dart';
import 'package:newklikrkw/pages/keluarbiayapermusers/keluarbiayapermuser_list_page.dart';
import 'package:newklikrkw/pages/keluarbiayas/keluarbiaya_list_page.dart';
import 'package:newklikrkw/pages/lapkeuangans/bukubesar_list_page.dart';
import 'package:newklikrkw/pages/lapkeuangans/neraca_page.dart';
import 'package:newklikrkw/pages/login_page.dart';
import 'package:newklikrkw/pages/lokasi_berkas_page.dart';
import 'package:newklikrkw/pages/postingjurnals/postingjurnal_list_page.dart';
import 'package:newklikrkw/pages/transaksis/kasbons/add_kasbon_page.dart';
import 'package:newklikrkw/pages/transaksis/kasbons/edit_kasbon_page.dart';
import 'package:newklikrkw/pages/transaksis/kasbons/kasbon_list_page.dart';
import 'package:newklikrkw/pages/transaksis/prosespermohonans/prosespermohonan_list_page.dart';
import 'package:newklikrkw/pages/transaksis/prosespermohonans/prosespermohonan_page.dart';
import 'package:newklikrkw/pages/transpermohonans/transpermohonan_page.dart';

enum MyRoute {
  login('/login'),
  home('/home'),
  kasbonList('/kasbonlist'),
  addKasbon('/addkasbon'),
  editKasbon('/editkasbon'),
  transpermohonanList('/transpermohonanlist'),
  editDKasbon('/editdkasbon'),
  prosespermohonan('/prosespermohonan'),
  prosespermohonanList('/prosespermohonanlist'),
  lokasiberkas('/lokasiberkas'),
  biayapermList('/biayapermlist'),
  dkeluarbiayaByItem('/dkeluarbiayabyitem'),
  keluarbiayaList('/keluarbiayalist'),
  postingjurnals('/postingjurnals'),
  keluarbiayapermuserList('/keluarbiayapermuserlist'),
  biayaperm('/biayaperm'),
  neraca('/neraca'),
  bukubesar('/bukubesar');

  final String name;
  const MyRoute(this.name);
}

final routes = {
  MyRoute.login.name: (context) => LoginPage(),
  MyRoute.home.name: (context) => const HomePage(),
  MyRoute.kasbonList.name: (context) => const KasbonListPage(),
  MyRoute.addKasbon.name: (context) => const AddKasbonPage(),
  MyRoute.editKasbon.name: (context) => const EditKasbonPage(),
  MyRoute.transpermohonanList.name: (context) => const TranspermohonanPage(),
  MyRoute.prosespermohonanList.name: (context) =>
      const ProsespermohonanListPage(),
  MyRoute.prosespermohonan.name: (context) => const ProsespermohonanPage(),
  MyRoute.lokasiberkas.name: (context) => const LokasiBerkasPage(),
  MyRoute.biayapermList.name: (context) => const BiayapermListPage(),
  MyRoute.biayaperm.name: (context) => const BiayapermPage(),
  MyRoute.keluarbiayaList.name: (context) => const KeluarbiayaListPage(),
  MyRoute.keluarbiayapermuserList.name: (context) =>
      const KeluarbiayapermuserListPage(),
  MyRoute.bukubesar.name: (context) => const BukubesarListPage(),
  MyRoute.neraca.name: (context) => const NeracaPage(),
  MyRoute.dkeluarbiayaByItem.name: (context) => const DkeluarbiayasByItemPage(),
  MyRoute.postingjurnals.name: (context) => const PostingjurnalListPage(),
};
