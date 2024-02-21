import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_klinik_dr_h_m_chalim/widgets/komponen_bar/menubar.dart';
import 'package:e_klinik_dr_h_m_chalim/widgets/get/userStatus.dart';
import 'package:e_klinik_dr_h_m_chalim/widgets/pasien/home/pasienhome.dart';
import 'package:e_klinik_dr_h_m_chalim/widgets/pasien/home/userhome.dart';
import 'dart:async';
import 'package:e_klinik_dr_h_m_chalim/provider/collection.dart';

class HomePagePasien extends StatefulWidget {
  @override
  _HomePagePasienState createState() => _HomePagePasienState();
}

class _HomePagePasienState extends State<HomePagePasien> {
  int _selectedIndex = 0;
  String status = SimpanStatus.getStatus();
  bool _isLoading = false; // Untuk mengontrol status loading refresh
  Timer? _timer; // Timer untuk melakukan refresh halaman

//   @override
//   void initState() {
//     super.initState();
//     getDataFromFirestore(); // Panggil fungsi untuk mengambil data dari Firestore
//     // Mulai timer untuk refresh halaman setiap menit
//     _timer = Timer.periodic(Duration(minutes: 1), (Timer timer) {
//       getDataFromFirestore();
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     // Hentikan timer saat widget di dispose
//     _timer?.cancel();
//   }

//   // Fungsi untuk mengambil data dari Firestore
//   void getDataFromFirestore() async {
//     // Mendapatkan referensi ke koleksi 'eklinik'
//     CollectionReference eklinik =
//         FirebaseFirestore.instance.collection(Database.getCollection());

//     // Mendapatkan data dari koleksi 'eklinik'
//     QuerySnapshot querySnapshot = await eklinik.get();

//     // Loop melalui dokumen-dokumen dalam koleksi 'eklinik'
//     querySnapshot.docs.forEach((doc) {
//       // Dapatkan data dari setiap dokumen dengan pengecekan null
//       Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

//       // Pastikan data tidak null dan memiliki tipe yang sesuai
//       if (data != null) {
//         // Tambahkan pengecekan null sebelum mengakses properti
//         String? jamMasuk = data['jam_antrian'];
//         String? jamBerakhir = data['jam_berakhir'];

//         print('cek : $jamMasuk');
//         print('cek : $jamBerakhir');
//         // Lakukan sesuatu dengan data yang diperoleh, misalnya membandingkan dengan waktu saat ini
//         // dan melakukan refresh halaman jika waktu cocok
//         // Pastikan untuk menyesuaikan logika sesuai dengan kebutuhan Anda
//         // Contoh sederhana: cek waktu masuk, jika sama dengan waktu saat ini, refresh halaman
//         String currentTime = getCurrentTime();
//         if (jamMasuk == currentTime || jamBerakhir == currentTime) {
//           // Lakukan refresh halaman jika waktu saat ini cocok dengan jam antrian atau jam berakhir
//           refreshPage();
//         }
//       }
//     });
//   }

// // Fungsi untuk melakukan refresh halaman
//   void refreshPage() {
//     print(
//         'Halaman diperbarui'); // Cetak pesan untuk menandai bahwa halaman diperbarui
//     setState(() {
//       _isLoading = true; // Set status loading refresh menjadi true
//     });
//     // Tunggu beberapa saat agar UI bisa merespons dengan benar
//     Future.delayed(Duration(milliseconds: 500), () {
//       setState(() {
//         _isLoading = false; // Set status loading refresh menjadi false
//       });
//     });
//   }

//   // Fungsi untuk mendapatkan waktu saat ini
//   String getCurrentTime() {
//     // Gunakan pustaka Dart untuk mendapatkan waktu saat ini
//     DateTime now = DateTime.now();
//     // Format waktu menjadi format yang sesuai, misalnya 'HH:mm'
//     String formattedTime =
//         '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
//     return formattedTime;
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _isLoading // Tampilkan indikator loading jika sedang loading refresh
              ? Center(child: CircularProgressIndicator())
              : (status == 'pasien'
                  ? PasienHomeWidget().buildPasien(context)
                  : buildUser(context)),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
