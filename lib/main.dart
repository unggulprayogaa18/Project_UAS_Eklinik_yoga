import 'package:e_klinik_dr_h_m_chalim/login.dart';
import 'package:e_klinik_dr_h_m_chalim/provider/reset_pasientouser.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_admin/edit_profile.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_admin/jadwal_checkup.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_admin/list_data_registrasi.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_admin/tambah_pasien.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_admin/teller_page.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_apoteker/Rekam_medis_pasien.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_apoteker/detail_resep.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_apoteker/edit_data_obat.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_apoteker/edit_profile.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_apoteker/home_apoteker.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_apoteker/list_apoteker.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_apoteker/list_data_obat.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_apoteker/tambah_data_obat.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_doctor/detail_pasien.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_doctor/edit_profile.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_doctor/edit_rekam_medis.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_doctor/tambah_rekam_medis.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_doctor/home_doctor.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_doctor/rekam_medis_pasien.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_pasien_user/checkup.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_pasien_user/home_pasien.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_pasien_user/kartu_berobat.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_pasien_user/kunjungan.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_pasien_user/no_pasien.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_pasien_user/profile_user_pasien.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_pasien_user/rekam_medis.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_pasien_user/edit_profile.dart';

import 'package:e_klinik_dr_h_m_chalim/widgets/animation/load.dart';
import 'package:e_klinik_dr_h_m_chalim/widgets/splash_succes/berhasil.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Ganti MaterialApp dengan GetMaterialApp
      initialBinding: BindingsBuilder(() {
        Get.lazyPut<ResetController>(() => ResetController());
      }),
      getPages: [
        GetPage(name: '/', page: () => LoginPage()),
        GetPage(name: '/checkup', page: () => CheckupPage()),
        GetPage(name: '/load', page: () => LoadAnimation()),
        GetPage(name: '/nopasien', page: () => NoPasien()),
        GetPage(name: '/RekamMedis', page: () => RekamMedis()),
        GetPage(name: '/profile', page: () => ProfileUserPasien()),
        GetPage(name: '/kartu', page: () => KartuPasien()),
        GetPage(name: '/homepasien', page: () => HomePagePasien()),
        GetPage(name: '/adminadataregistrasi', page: () => ListDataPage()),
        GetPage(name: '/jadwalcheckup', page: () => JadwalCheckupPage()),
        GetPage(name: '/tambahPasien', page: () => TambahPasien()),
        GetPage(name: '/splash', page: () => SplashBerhasil()),
        GetPage(name: '/RekamMedisDC', page: () => RekamMedisPasienDoctor()),
        GetPage(name: '/DetailPasien', page: () => DetailPasien()),
        GetPage(name: '/homeDoctor', page: () => HomePageDokter()),
        GetPage(
            name: '/DetailRekamMEdisPasien', page: () => DetailRekamMedis()),
        GetPage(name: '/editRekamMedis', page: () => EditRekamMedis()),
        GetPage(name: '/TampilRekamMedis', page: () => TampilRekamMedis()),
        GetPage(name: '/homeApoteker', page: () => HomeApoteker()),
        GetPage(name: '/listdataoba2t', page: () => ListDataObat()),
        GetPage(name: '/detailResep', page: () => DetailResep()),
        GetPage(name: '/editprofileuser', page: () => EditProfileScreen()),
        GetPage(name: '/kunjungan', page: () => KunjunganSreen()),
        GetPage(
            name: '/editprofileadmin', page: () => EditProfileAdminScreen()),
        GetPage(
            name: '/editprofileApoteker',
            page: () => EditProfileApotekerScreen()),
        GetPage(
            name: '/editprofileDoctor', page: () => EditProfileDoctorScreen()),
        GetPage(name: '/teller_page', page: () => TellerPage()),
        GetPage(name: '/TambahDataObat', page: () => TambahDataObat()),
        GetPage(name: '/editDataObat', page: () => EditObat()),
        GetPage(name: '/Listapoteker', page: () => ListApoteker()),
      ],
      initialRoute: '/',
    );
  }
}
