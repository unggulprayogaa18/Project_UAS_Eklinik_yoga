import 'package:e_klinik_dr_h_m_chalim/screens/screen_doctor/data_pasien.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_doctor/detail_pasien.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_doctor/profile_doctor.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // Import paket lokalization
import 'package:e_klinik_dr_h_m_chalim/widgets/get/userStatus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_klinik_dr_h_m_chalim/provider/userfirestore.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_pasien_user/no_pasien.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:e_klinik_dr_h_m_chalim/provider/collection.dart';

class DoctorHomeWidget {
  final EklinikService eklinikService = EklinikService();

  String status = SimpanStatus.getStatus();

  DoctorHomeWidget() {
    initializeDateFormatting('id', null);
  }

  Widget buildDoctor(BuildContext context) {
    return buildFirestoreProfile(context);
  }
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
        return buildAdmin(context, userData);
      }
    },
  );
}

String getGreeting() {
  DateTime now = DateTime.now();
  int hour = now.hour;

  if (hour >= 0 && hour < 10) {
    return 'Selamat Pagi';
  } else if (hour >= 10 && hour < 15) {
    return 'Selamat Siang';
  } else if (hour >= 15 && hour < 18) {
    return 'Selamat Sore';
  } else {
    return 'Selamat Malam';
  }
}

late String reservasiTime;

Future<String> nomer_antrian_terakhir() async {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd').format(now);

  try {
    QuerySnapshot eklinikSnapshot = await FirebaseFirestore.instance
        .collection(Database.getCollection())
        .where('status_janji', isEqualTo: 'sedang_janji')
        .where('tanggalReservasi', isEqualTo: formattedDate)
        .get();

    if (eklinikSnapshot.docs.isNotEmpty) {
      int no_antrian_terakhir = eklinikSnapshot.docs.last['nomer_antrian'];
      return no_antrian_terakhir.toString();
    } else {
      return '0';
    }
  } catch (e) {
    print('Error: $e');
    return '0';
  }
}

String getFormattedDate() {
  DateTime now = DateTime.now();

  String formattedNow = DateFormat('EEEE , dd MMMM yyyy', 'id').format(now);

  return '$formattedNow';
}

Stream<String> countStatusAntrianMenungguWITHjam() async* {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd').format(now);
  try {
    // Use Firestore snapshot listeners to listen for real-time updates
    await for (QuerySnapshot eklinikSnapshot in FirebaseFirestore.instance
        .collection(Database.getCollection())
        .where('status_janji', isEqualTo: 'sedang_janji')
        .where('tanggalReservasi', isEqualTo: formattedDate)
        .snapshots()) {
      List<String> nomorAntrianList = [];

      for (QueryDocumentSnapshot doc in eklinikSnapshot.docs) {
        final userData = doc.data() as Map<String, dynamic>;

        String? jamBerakhir = userData['jam_berakhir'];
        String? jamAntrian = userData['jam_antrian'];

        if (jamBerakhir != null && jamAntrian != null) {
          DateTime now = DateTime.now();
          String currentTimeString = DateFormat.Hm().format(now.toLocal());

          if (currentTimeString.compareTo(jamAntrian) >= 0 &&
              currentTimeString.compareTo(jamBerakhir) <= 0) {
            var nomorAntrian = userData['nomer_antrian'];
            nomorAntrianList.add(nomorAntrian.toString());
          }
        }
      }

      if (nomorAntrianList.isNotEmpty) {
        yield nomorAntrianList.first;
      } else {
        yield "";
      }
    }
  } catch (e) {
    print('Error nomer antrian tidak muncul untuk jam sekarang: $e');
    yield "";
  }
}

Future<int> countStatusAntrianSelesai() async {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd').format(now);
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Database.getCollection())
        .where('status_antrian', isEqualTo: 'selesai')
        .where('tanggalReservasi', isEqualTo: formattedDate)
        .get();

    return querySnapshot.size;
  } catch (e) {
    print('Error counting status antrian: $e');
    return 0;
  }
}

Future<int> countStatusAntrianMenunggu() async {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd').format(now);
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Database.getCollection())
        .where('status_antrian', isEqualTo: 'menunggu')
        .where('tanggalReservasi', isEqualTo: formattedDate)
        .get();

    return querySnapshot.size;
  } catch (e) {
    print('Error counting status antrian: $e');
    return 0;
  }
}

Future<int> totalantrian() async {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd').format(now);
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(Database.getCollection())
        .where('status_janji', isEqualTo: 'sedang_janji')
        .where('tanggalReservasi', isEqualTo: formattedDate)
        .get();

    return querySnapshot.size;
  } catch (e) {
    print('Error counting status antrian: $e');
    return 0;
  }
}

Widget buildAdmin(BuildContext context, Map<String, dynamic> userData) {
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'halo, $greeting\nDokter ${userData['nama']}!',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 78, 127, 167)),
                        ),
                      ),
                      Container(),
                    ],
                  ),
                  Positioned(
                    top: -11.0,
                    right: 8.0,
                    child: Image(
                      image: AssetImage('assets/icon2/nature.png'),
                      height: 70,
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
                height: 140,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 65, 122, 172),
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Nomor Antrian\n      Terakhir',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          FutureBuilder<String>(
                            future: nomer_antrian_terakhir(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                // Ambil nomor antrian dari snapshot
                                String nomorAntrian = snapshot.data!;

                                // Jika nomor antrian hanya satu digit, tambahkan nol di depannya
                                if (nomorAntrian.length == 1) {
                                  nomorAntrian = '0$nomorAntrian';
                                } else if (nomorAntrian.startsWith('0')) {
                                  // Jika nomor antrian lebih dari satu digit dan dimulai dengan nol, hilangkan nol pertamanya
                                  nomorAntrian = nomorAntrian.substring(1);
                                }

                                return Text(
                                  nomorAntrian,
                                  style: TextStyle(
                                    fontSize: 40,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }
                            },
                          ),
                          FutureBuilder<int>(
                            future: totalantrian(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator(); // Menampilkan indikator loading selama data diambil dari Firestore
                              } else {
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return Text(
                                    'Total Antrian: ${snapshot.data}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 2,
                      height: 70,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/icon/garis.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Belum',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          FutureBuilder<int>(
                            future: countStatusAntrianMenunggu(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                int countAntrianMenunggu = snapshot.data ?? 0;

                                // Tambahkan nol di depan jika hanya satu digit, atau hilangkan nol jika lebih dari satu digit
                                String formattedCountAntrianMenunggu =
                                    countAntrianMenunggu < 10
                                        ? '0$countAntrianMenunggu'
                                        : '$countAntrianMenunggu';

                                return Text(
                                  formattedCountAntrianMenunggu,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: Colors.white,
                                  ),
                                );
                              }
                            },
                          ),
                          Text(
                            'Selesai',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          FutureBuilder<int>(
                            future: countStatusAntrianSelesai(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                int countAntrianSelesai = snapshot.data ?? 0;

                                // Tambahkan nol di depan jika hanya satu digit, atau hilangkan nol jika lebih dari satu digit
                                String formattedCountAntrianSelesai =
                                    countAntrianSelesai < 10
                                        ? '0$countAntrianSelesai'
                                        : '$countAntrianSelesai';

                                return Text(
                                  formattedCountAntrianSelesai,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: Colors.white,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // New section for "Menunggu" and "Selesai" below the existing box
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Antrian Sesi Sore',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Color.fromARGB(255, 78, 127, 167),
                        ),
                      ),
                      Text(
                        'Pasien Klinik ',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 78, 127, 167),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StreamBuilder<String>(
                        stream: countStatusAntrianMenungguWITHjam(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            String nomorAntrian = snapshot.data ?? "";
                            return Text(
                              ' ${nomorAntrian.padLeft(2, '0')}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                                color: Color.fromARGB(255, 78, 127, 167),
                              ),
                            );
                          }
                        },
                      ),
                      Text(
                        'pasien menunggu',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 78, 127, 167),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // New section for "Layanan" and three side-by-side containers
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Data User',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color.fromARGB(255, 78, 127, 167),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Container 1
                      Padding(
                        padding: const EdgeInsets.only(right: 40.0),
                        child: GestureDetector(
                          onTap: () {
                            // Handle onTap for Container 1
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DataPasienPage()),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 80, // Set your desired width
                                height: 70, // Set your desired height
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Color.fromARGB(255, 78, 127, 167),
                                    width: 2,
                                  ),
                                ),
                                child: Image.asset(
                                  'assets/icon2/hospital-bed.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '    Data\nregistrasi',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 78, 127, 167),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Container 2
                      Padding(
                        padding: const EdgeInsets.only(right: 40.0),
                        child: GestureDetector(
                          onTap: () {
                            // Handle onTap for Container 2
                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => DetailPasien()),
                            // );
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 80, // Set your desired width
                                height: 70, // Set your desired height
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Color.fromARGB(255, 78, 127, 167),
                                    width: 2,
                                  ),
                                ),
                                child: Image.asset(
                                  'assets/icon2/unauthorized-person.png', // Replace with your image asset
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Data\nAdmin',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 78, 127, 167),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Container 3
                      GestureDetector(
                        onTap: () {
                          // Handle onTap for Container 3
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileDoctor()),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 80, // Set your desired width
                              height: 70, // Set your desired height
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Color.fromARGB(255, 78, 127, 167),
                                  width: 2,
                                ),
                              ),
                              child: Image.asset(
                                'assets/icon2/doctor.png', // Replace with your image asset
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Profile\nDoctor',
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
          ],
        ),
      ),
    ),
  );
}

Widget buildArticleContainer(String title, String subtitle, String imagePath) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 15.0),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 145, 191, 218),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), // Adjust the radius as needed
                bottomLeft: Radius.circular(8), // Adjust the radius as needed
              ),
            ),
            child: Center(
              child: Image.asset(
                'assets/icon2/Vector.png',
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 78, 127, 167),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(255, 78, 127, 167),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
