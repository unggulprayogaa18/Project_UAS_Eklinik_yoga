import 'package:e_klinik_dr_h_m_chalim/screens/screen_pasien_user/tentang_eklinik.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // Import paket lokalization
import 'package:e_klinik_dr_h_m_chalim/widgets/get/userStatus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:e_klinik_dr_h_m_chalim/provider/usergoogle.dart';
// import 'package:e_klinik_dr_h_m_chalim/provider/userfirestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_klinik_dr_h_m_chalim/widgets/get/useremail.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_pasien_user/no_pasien.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:e_klinik_dr_h_m_chalim/provider/collection.dart';

class PasienHomeWidget {
  final EklinikService eklinikService = EklinikService();

  String status = SimpanStatus.getStatus();

  PasienHomeWidget() {
    initializeDateFormatting('id', null);
  }

  Widget buildPasien(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user?.providerData[0]?.providerId == 'google.com') {
      return buildGoogleProfile(context);
    } else {
      return buildFirestoreProfile(context);
    }
  }

  Widget buildFirestoreProfile(BuildContext context) {
    String email = SimpanEmail.getEmail();
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection(Database.getCollection())
          .where('email', isEqualTo: email)
          .snapshots()
          .map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs[0];
        } else {
          throw 'User data not found in Firestore.';
        }
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text('User data not found.'));
        } else {
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          return buildHomePasien(context, userData);
        }
      },
    );
  }

  Widget buildGoogleProfile(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    print('nama user : $user');
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection(Database.getCollection())
          .where('email', isEqualTo: user!.email)
          .snapshots()
          .map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs[0];
        } else {
          throw 'User data not found in Firestore.';
        }
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text('User data not found.'));
        } else {
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          return buildHomePasien(context, userData);
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

  late String reservasiTime;

  Stream<String> reservasitimeStream() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 1)); // Menunggu satu detik
      final User? user = FirebaseAuth.instance.currentUser;
      String email = SimpanEmail.getEmail();
      String jam = '';

      if (user?.providerData[0]?.providerId == 'google.com') {
        QuerySnapshot eklinikSnapshot = await FirebaseFirestore.instance
            .collection(Database.getCollection())
            .where('email', isEqualTo: user!.email)
            .get();
        final userData = eklinikSnapshot.docs[0].data() as Map<String, dynamic>;
        jam = userData['jam_antrian'] ?? '';
      } else {
        QuerySnapshot eklinikSnapshot = await FirebaseFirestore.instance
            .collection(Database.getCollection())
            .where('email', isEqualTo: email)
            .get();
        final userData = eklinikSnapshot.docs[0].data() as Map<String, dynamic>;
        jam = userData['jam_antrian'] ?? '';
      }

      // Pindahkan pengecekan jam dari database ke sini
      DateTime now = DateTime.now();
      int currentHour = now.hour;

      // Handle jika jam_antrian tidak dalam format yang sesuai
      if (jam.isEmpty || !jam.contains(':')) {
        yield 'Tidak Diketahui';
      }

      // Ubah jam dari string ke integer
      int jamAntrian = int.tryParse(jam.split(':')[0]) ?? 0;

      if (jamAntrian >= 0 && jamAntrian < 10) {
        yield 'Pagi';
      } else if (jamAntrian >= 10 && jamAntrian < 15) {
        yield 'Siang';
      } else if (jamAntrian >= 15 && jamAntrian < 18) {
        yield 'Sore';
      } else {
        yield 'Malam';
      }
    }
  }

  Stream<Map<String, dynamic>> tanggalreservasi() async* {
    final User? user = FirebaseAuth.instance.currentUser;
    String email = SimpanEmail.getEmail();
    String tanggalReservasi = ''; // Original string representation
    String tanggal = ''; // New string representation in DateTime format

    try {
      if (user?.providerData[0]?.providerId == 'google.com') {
        QuerySnapshot eklinikSnapshot = await FirebaseFirestore.instance
            .collection(Database.getCollection())
            .where('email', isEqualTo: user!.email!)
            .get();
        if (eklinikSnapshot.docs.isNotEmpty) {
          final userData =
              eklinikSnapshot.docs[0].data() as Map<String, dynamic>;
          tanggalReservasi = userData['tanggalReservasi'];
          DateTime parsedDate =
              DateFormat('yyyy-MM-dd').parse(tanggalReservasi);
          tanggal = DateFormat('EEEE , dd MMMM yyyy', 'id').format(parsedDate);
          print('Tanggal reservasi saya: $tanggal');
        } else {
          print('Data eklinik tidak ditemukan');
        }
      } else {
        QuerySnapshot eklinikSnapshot = await FirebaseFirestore.instance
            .collection(Database.getCollection())
            .where('email', isEqualTo: email)
            .get();
        if (eklinikSnapshot.docs.isNotEmpty) {
          final userData =
              eklinikSnapshot.docs[0].data() as Map<String, dynamic>;
          tanggalReservasi = userData['tanggalReservasi'];
          DateTime parsedDate =
              DateFormat('yyyy-MM-dd').parse(tanggalReservasi);
          tanggal = DateFormat('EEEE , dd MMMM yyyy', 'id').format(parsedDate);
          print('Tanggal reservasi saya: $tanggal');
        } else {
          print('Data eklinik tidak ditemukan');
        }
      }
    } catch (e) {
      print('Error: $e');
    }

    // Yield both 'tanggalReservasi' and 'tanggal'
    yield {'tanggalReservasi': tanggalReservasi, 'tanggal': tanggal};
  }

  Stream<String> countStatusAntrianMenungguWITHjam() async* {
    try {
      // Use Firestore snapshot listeners to listen for real-time updates
      await for (QuerySnapshot eklinikSnapshot in FirebaseFirestore.instance
          .collection(Database.getCollection())
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

  Stream<int> countStatusAntrianMenunggu() async* {
    try {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd').format(now);

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(Database.getCollection())
          .where('status_antrian', isEqualTo: 'menunggu')
          .where('tanggalReservasi', isEqualTo: formattedDate)
          .get();

      yield querySnapshot.size;
    } catch (e) {
      print('Error counting status antrian: $e');
      yield 0;
    }
  }

  Stream<int> countAntrianSelesai() async* {
    try {
      QuerySnapshot eklinikSnapshot = await FirebaseFirestore.instance
          .collection(Database.getCollection())
          .get();

      int count = 0;

      for (QueryDocumentSnapshot doc in eklinikSnapshot.docs) {
        final userData = doc.data() as Map<String, dynamic>;
        String status_antrian = userData['status_antrian'];

        if (status_antrian == 'selesai') {
          count++;
        }
      }

      print('Jumlah antrian selesai: $count');
      yield count;
    } catch (e) {
      print('Error menghitung jumlah antrian selesai: $e');
      yield 0;
    }
  }

  Stream<int> countStatusAntrianSelesai() async* {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(Database.getCollection())
          .where('status_antrian', isEqualTo: 'selesai')
          .get();

      yield querySnapshot.size;
    } catch (e) {
      print('Error counting status antrian: $e');
      yield 0;
    }
  }

  Stream<Map<String, int>> no_antrian_saya() async* {
    final User? user = FirebaseAuth.instance.currentUser;
    String email = SimpanEmail.getEmail();
    int no_saya = 0;

    try {
      if (user?.providerData[0]?.providerId == 'google.com') {
        QuerySnapshot eklinikSnapshot = await FirebaseFirestore.instance
            .collection(Database.getCollection())
            .where('email', isEqualTo: user!.email!)
            .get();
        if (eklinikSnapshot.docs.isNotEmpty) {
          final userData =
              eklinikSnapshot.docs[0].data() as Map<String, dynamic>;
          no_saya = userData['nomer_antrian'] ?? 0;
          print('Nomor antrian saya: $no_saya');
        } else {
          print('Data eklinik tidak ditemukan');
        }
      } else {
        QuerySnapshot eklinikSnapshot = await FirebaseFirestore.instance
            .collection(Database.getCollection())
            .where('email', isEqualTo: email)
            .get();
        if (eklinikSnapshot.docs.isNotEmpty) {
          final userData =
              eklinikSnapshot.docs[0].data() as Map<String, dynamic>;
          no_saya = userData['nomer_antrian'] ?? 0;
          print('Nomor antrian saya: $no_saya');
        } else {
          print('Data eklinik tidak ditemukan');
        }
      }
    } catch (e) {
      print('Error: $e');
    }

    yield {'nomor_antrian': no_saya};
  }

  Widget buildHomePasien(BuildContext context, Map<String, dynamic> userData) {
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
                            color: Color.fromARGB(255, 78, 127, 167),
                          ),
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
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
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
                      ),
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
                                  SizedBox(height: 7),
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
                                  StreamBuilder<String>(
                                    stream: reservasitimeStream(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else {
                                        String reservasiTime =
                                            snapshot.data ?? 'Tidak Diketahui';
                                        return Text(
                                          'Reservasi $reservasiTime',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  StreamBuilder<Map<String, dynamic>>(
                                    stream: tanggalreservasi(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        String? tanggal = snapshot.data?[
                                            'tanggal']; // Access 'tanggal' key
                                        return Text(
                                          tanggal ?? 'Tanggal not available',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  Text(
                                    'Estimasi Waktu Diperiksa',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                  Text(
                                    '${userData['jam_antrian']} - ${userData['jam_berakhir']} WIB',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
                                  SizedBox(height: 5),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: StreamBuilder<int>(
                                      stream: countStatusAntrianMenunggu(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else {
                                          int totalAntrian = snapshot.data ?? 0;
                                          return Text(
                                            'Total Antrian: $totalAntrian',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 28.0, bottom: 10),
                            child: Container(
                              width: 120,
                              height: 145,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 182, 215, 243),
                                borderRadius: BorderRadius.circular(15.0),
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
                                  StreamBuilder<Map<String, int>>(
                                    stream: no_antrian_saya(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        Map<String, int>? result =
                                            snapshot.data;
                                        int? no_saya = result?[
                                            'nomor_antrian']; // Accessing the 'nomor_antrian' from the map
                                        String formattedNoSaya =
                                            no_saya != null && no_saya < 10
                                                ? '0$no_saya'
                                                : '$no_saya';
                                        return Text(
                                          '$formattedNoSaya',
                                          style: TextStyle(
                                            fontSize: 40,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      }
                                    },
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25),
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
                            fontSize: 16,
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
                        SizedBox(height: 8),
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
                      ],
                    ),
                    Container(
                      width: 4,
                      height: 50,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/icon/garis.png'),
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
                            fontSize: 16,
                            color: Color.fromARGB(255, 78, 127, 167),
                          ),
                        ),
                        Text(
                          'antrian selesai',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 78, 127, 167),
                          ),
                        ),
                        SizedBox(height: 8),
                        StreamBuilder<int>(
                          stream: countStatusAntrianSelesai(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              int totalAntrianSelesai = snapshot.data ?? 0;
                              String formattedTotalAntrianSelesai =
                                  totalAntrianSelesai
                                      .toString()
                                      .padLeft(2, '0');
                              return Text(
                                formattedTotalAntrianSelesai,
                                style: TextStyle(
                                  fontSize: 40,
                                  color: Color.fromARGB(255, 78, 127, 167),
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final User? user =
                                FirebaseAuth.instance.currentUser;
                            if (user?.providerData[0]?.providerId ==
                                'google.com') {
                              final userSnapshot = await FirebaseFirestore
                                  .instance
                                  .collection(Database.getCollection())
                                  .where('email', isEqualTo: user!.email)
                                  .get();

                              if (userSnapshot.docs.isNotEmpty) {
                                // Pindah ke
                                final status_janji = userData['status_janji'];
                                print(status_janji);
                                if (status_janji == 'belum_janji') {
                                  Get.offNamed('/load');
                                  await Future.delayed(Duration(seconds: 2));
                                  Get.offNamed('/checkup');
                                } else {
                                  Get.offNamed('/load');
                                  await Future.delayed(Duration(seconds: 2));
                                  Get.offNamed('/nopasien');
                                }
                              } else {
                                print('data email kosong');
                              }
                            } else {
                              String email = SimpanEmail.getEmail();

                              final userSnapshot = await FirebaseFirestore
                                  .instance
                                  .collection(Database.getCollection())
                                  .where('email', isEqualTo: email)
                                  .get();

                              if (userSnapshot.docs.isNotEmpty) {
                                // Pindah ke
                                final status_janji = userData['status_janji'];
                                print(status_janji);
                                if (status_janji == 'belum_janji') {
                                  Get.offNamed('/load');
                                  await Future.delayed(Duration(seconds: 2));
                                  Get.offNamed('/checkup');
                                } else {
                                  Get.offNamed('/load');
                                  await Future.delayed(Duration(seconds: 2));
                                  Get.offNamed('/nopasien');
                                }
                              } else {
                                print('data email kosong');
                              }
                            }
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 80,
                                height: 70,
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
                              SizedBox(height: 8),
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
                        GestureDetector(
                          onTap: () async {
                            // Handle onTap for Container 2
                            Get.offNamed('/load');
                            await Future.delayed(Duration(seconds: 2));
                            Get.offNamed('/RekamMedis');
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 80,
                                height: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Color.fromARGB(255, 78, 127, 167),
                                    width: 2,
                                  ),
                                ),
                                child: Image.asset(
                                  'assets/icon/health-report.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(height: 8),
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
                        GestureDetector(
                          onTap: () async {
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
                                width: 80,
                                height: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Color.fromARGB(255, 78, 127, 167),
                                    width: 2,
                                  ),
                                ),
                                child: Image.asset(
                                  'assets/icon/health-home.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(height: 8),
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
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          buildArticleContainer(
                              'Tips agar terhindar dari\npenyakit di usia tua!!',
                              'Di era modern ini, kesehatan bukan\nsekadar absensi penyakit, melainkan\ninvestasi dalam kualitas hidup yang\nberkelanjutan.',
                              'assets/icon/artikel1.png'),
                          buildArticleContainer(
                              'Artikel 2',
                              'Deskripsi Artikel 2',
                              'assets/icon/artikel2.png'),
                          buildArticleContainer(
                              'Artikel 3',
                              'Deskripsi Artikel 3',
                              'assets/icon/artikel2.png'),
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
            margin: EdgeInsets.only(
                right: 20), // Add some spacing between containers
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
}
