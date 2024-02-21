import 'package:e_klinik_dr_h_m_chalim/screens/screen_pasien_user/no_pasien.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_pasien_user/tentang_eklinik.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // Import paket lokalization
import 'package:e_klinik_dr_h_m_chalim/widgets/get/userStatus.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_pasien_user/checkup.dart';
import 'package:e_klinik_dr_h_m_chalim/provider/userfirestore.dart';
import 'package:e_klinik_dr_h_m_chalim/provider/usergoogle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_klinik_dr_h_m_chalim/widgets/get/useremail.dart';
import 'package:get/get.dart'; // Import GetX
  
class PasienUserWidget {
  String status = SimpanStatus.getStatus();

  PasienUserWidget() {
    initializeDateFormatting('id', null);
  }
}

Widget buildUser(BuildContext context) {
  final User? user = FirebaseAuth.instance.currentUser;
  if (user?.providerData[0]?.providerId == 'google.com') {
    return buildGoogleProfile(context);
  } else {
    return buildFirestoreProfile(context);
  }
}

Widget buildGoogleProfile(BuildContext context) {
  return FutureBuilder<DocumentSnapshot>(
    future: UserGoogle().getUserDataGoogle(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (!snapshot.hasData || !snapshot.data!.exists) {
        return Center(child: Text('User data not found.'));
      } else {
        var userData = snapshot.data!.data() as Map<String, dynamic>;
        return buildHomeUser(context, userData);
      }
    },
  );
}

Widget buildFirestoreProfile(BuildContext context) {
  return FutureBuilder<DocumentSnapshot>(
    future: UserFirestore().getUserData(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (!snapshot.hasData || !snapshot.data!.exists) {
        return Center(child: Text('User data not found.'));
      } else {
        var userData = snapshot.data!.data() as Map<String, dynamic>;
        return buildHomeUser(context, userData);
      }
    },
  );
}

String getGreeting() {
  DateTime now = DateTime.now();
  int hour = now.hour;

  if (hour >= 0 && hour < 10) {
    return 'Selamat Pagi!!';
  } else if (hour >= 10 && hour < 15) {
    return 'Selamat Siang!!';
  } else if (hour >= 15 && hour < 18) {
    return 'Selamat Sore!!';
  } else {
    return 'Selamat Malam!!';
  }
}

String reservasitime() {
  DateTime now = DateTime.now();
  int hour = now.hour;

  if (hour >= 0 && hour < 10) {
    return 'Pagi';
  } else if (hour >= 10 && hour < 15) {
    return 'Siang';
  } else if (hour >= 15 && hour < 18) {
    return 'Sore';
  } else {
    return 'Malam';
  }
}

String getFormattedDate() {
  DateTime now = DateTime.now();

  String formattedNow = DateFormat('EEEE , dd MMMM yyyy', 'id').format(now);

  return '$formattedNow';
}

Widget buildHomeUser(BuildContext context, Map<String, dynamic> userData) {
  String greeting = getGreeting();
  return Material(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'halo, $greeting\n${userData['nama'] ?? "Belum diset"}!',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 78, 127, 167)),
                      ),
                      Container(),
                    ],
                  ),
                 Positioned(
                      top: -11.0,
                      right: -10.0,
                      child: GestureDetector(
                        onTap: () {
                          // Tindakan yang ingin Anda lakukan ketika gambar diklik
                          Get.offNamed('/kunjungan');
                        },
                        child: Image(
                          image: AssetImage('assets/icon/reply.png'),
                          height: 70,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7.0),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 65, 122, 172),
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ), // changes the position of the shadow
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 1.0, vertical: 9),
                                  child: Text(
                                    'Pemeriksaan di Klinik',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white),
                                  ),
                                ),
                                Text(
                                  'Tidak ada reservasi',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                                Text(
                                  '-',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                                Text(
                                  '-',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                                Text(
                                  '-',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    'Total Antrian: -',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white),
                                  ),
                                ),
                                   SizedBox(height: 25),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 28.0,
                          ),
                          child: Container(
                            width: 120,
                            height: 145,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 182, 215, 243),
                              borderRadius: BorderRadius.circular(
                                  15.0), // Sesuaikan angka sesuai kebutuhan
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Nomor Antrian',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Kamu',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '-',
                                  style: TextStyle(
                                      fontSize: 40,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // New section for "Menunggu" and "Selesai" below the existing box
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 17),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Menunggu',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color.fromARGB(255, 78, 127, 167),
                        ),
                      ),
                      Text(
                        'antrian sekarang',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 78, 127, 167),
                        ),
                      ),
                      Text(
                        '-',
                        style: TextStyle(
                          fontSize: 35,
                          color: Color.fromARGB(255, 78, 127, 167),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // Image in the middle
                  Container(
                    width: 4,
                    height: 50,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/icon/garis.png'), // Replace with your image asset
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Selesai',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color.fromARGB(255, 78, 127, 167),
                        ),
                      ),
                      Text(
                        'antrian selesai',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 78, 127, 167),
                        ),
                      ),
                      Text(
                        '-',
                        style: TextStyle(
                          fontSize: 35,
                          color: Color.fromARGB(255, 78, 127, 167),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // New section for "Layanan" and three side-by-side containers
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Layanan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color.fromARGB(255, 78, 127, 167),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Container 1
                      GestureDetector(
                        onTap: () async {
                          final User? user = FirebaseAuth.instance.currentUser;
                          if (user?.providerData[0]?.providerId ==
                              'google.com') {
                            final userSnapshot = await FirebaseFirestore
                                .instance
                                .collection('eklinik')
                                .where('email', isEqualTo: user!.email)
                                .get();

                            if (userSnapshot.docs.isNotEmpty) {
                              // Pindah ke
                              final status_janji = userData['status_janji'];
                              final status = userData['status'];

                              print(status_janji);
                              if (status_janji == 'belum_janji' ||
                                  status == 'user') {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CheckupPage()),
                                );
                              } else if (status_janji == 'sedang_janji' ||
                                  status == 'pasien') {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NoPasien()),
                                );
                              }
                            } else {
                              print('data email kosong');
                            }
                          } else {
                            String email = SimpanEmail.getEmail();

                            final userSnapshot = await FirebaseFirestore
                                .instance
                                .collection('eklinik')
                                .where('email', isEqualTo: email)
                                .get();

                            if (userSnapshot.docs.isNotEmpty) {
                              // Pindah ke
                              final status_janji = userData['status_janji'];
                              print(status_janji);
                              if (status_janji == 'belum_janji') {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CheckupPage()),
                                );
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NoPasien()),
                                );
                              }
                            } else {
                              print('data email kosong');
                            }
                          }
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 70, // Set your desired width
                              height: 70, // Set your desired height
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Color.fromARGB(255, 78, 127, 167),
                                  width: 2,
                                ),
                              ),
                              child: Image.asset(
                                'assets/icon/health-check.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            Text(
                              'Checkup\n',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 78, 127, 167),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Container 2
                      GestureDetector(
                        onTap: () {
                          // Handle onTap for Container 2
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 70, // Set your desired width
                              height: 70, // Set your desired height
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Color.fromARGB(255, 78, 127, 167),
                                  width: 2,
                                ),
                              ),
                              child: Image.asset(
                                'assets/icon/health-report.png', // Replace with your image asset
                                fit: BoxFit.contain,
                              ),
                            ),
                            Text(
                              'Rekam\n Medis',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 78, 127, 167),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Container 3
                      GestureDetector(
                        onTap: () {
                          // Handle onTap for Container 3
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TentangEklinik()),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 70, // Set your desired width
                              height: 70, // Set your desired height
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Color.fromARGB(255, 78, 127, 167),
                                  width: 2,
                                ),
                              ),
                              child: Image.asset(
                                'assets/icon/health-home.png', // Replace with your image asset
                                fit: BoxFit.contain,
                              ),
                            ),
                            Text(
                              'Tentang\n  Klinik',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 78, 127, 167),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // New section for "Rekomendasi Artikel" and three side-by-side containers
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rekomendasi Artikel',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color.fromARGB(255, 78, 127, 167),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Use SingleChildScrollView with horizontal scroll
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // Container 1
                        buildArticleContainer(
                            'Tips agar terhindar dari\npenyakit di usia tua!!',
                            'Di era modern ini, kesehatan bukan\nsekadar absensi penyakit, melainkan\ninvestasi dalam kualitas hidup yang\nberkelanjutan.',
                            'assets/icon/artikel1.png'),

                        // Container 2
                        buildArticleContainer('Artikel 2',
                            'Deskripsi Artikel 2', 'assets/icon/artikel2.png'),

                        // Container 3
                        buildArticleContainer('Artikel 3',
                            'Deskripsi Artikel 3', 'assets/icon/artikel2.png'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildArticleContainer(
    String title, String description, String imagePath) {
  return GestureDetector(
    onTap: () {
      // Handle onTap for Container
    },
    child: Stack(
      children: [
        // Container untuk bayangan
        Container(
          width: 250,
          height: 120,
          margin: EdgeInsets.all(5), // Add some spacing between containers
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 48, 116, 155).withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 10,
                offset: Offset(0, 3), // Sesuaikan offset sesuai kebutuhan
              ),
            ],
          ),
        ),

        // Container utama
        Container(
          width: 250,
          height: 120,
          margin:
              EdgeInsets.only(right: 20), // Add some spacing between containers
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white, // Warna latar belakang container utama
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 11.0),
                child: Container(
                  width: 80,
                  height: 80,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 22.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 78, 127, 167),
                      ),
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    // Additional text or widgets can be added here
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
