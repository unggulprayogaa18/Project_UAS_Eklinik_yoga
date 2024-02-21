import 'package:e_klinik_dr_h_m_chalim/screens/screen_pasien_user/home_pasien.dart';
import 'package:flutter/material.dart';
import 'package:e_klinik_dr_h_m_chalim/provider/userfirestore.dart';
import 'package:e_klinik_dr_h_m_chalim/provider/usergoogle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_klinik_dr_h_m_chalim/provider/collection.dart';

class EklinikService {
  final CollectionReference eklinikCollection =
      FirebaseFirestore.instance.collection(Database.getCollection());

  Future<int> countStatusAntrianMenunggu() async {
    try {
      QuerySnapshot querySnapshot = await eklinikCollection
          .where('status_antrian', isEqualTo: 'menunggu')
          .get();

      return querySnapshot.size;
    } catch (e) {
      print('Error counting status antrian: $e');
      return 0;
    }
  }
}

class NoPasien extends StatelessWidget {
  final EklinikService eklinikService = EklinikService();

  Widget buildPasien(BuildContext context, int totalAntrianMenunggu) {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user?.providerData[0]?.providerId == 'google.com') {
      return buildProfile(
          context, UserGoogle().getUserDataGoogle(), totalAntrianMenunggu);
    } else {
      return buildProfile(
          context, UserFirestore().getUserData(), totalAntrianMenunggu);
    }
  }

  Widget buildProfile(BuildContext context,
      Future<DocumentSnapshot> userDataFuture, int totalAntrianMenunggu) {
    return FutureBuilder<DocumentSnapshot>(
      future: userDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text('User data not found.'));
        } else {
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          return halaman(context, userData, totalAntrianMenunggu);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<int>(
        future: eklinikService.countStatusAntrianMenunggu(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            int totalAntrianMenunggu = snapshot.data ?? 0;
            return buildPasien(context, totalAntrianMenunggu);
          }
        },
      ),
    );
  }

  Widget halaman(BuildContext context, Map<String, dynamic> userData,
      int totalAntrianMenunggu) {
    return Scaffold(
      // Ganti Scaffold dengan Material
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: Row(
                children: [
                  Text(
                    '\u2039',
                    style: TextStyle(
                      fontSize: 30,
                      color: Color.fromARGB(255, 69, 128, 177),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePagePasien()),
                );
              },
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: 40.0,
                  ),
                  child: Text(
                    'Checkup',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 69, 128, 177),
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 7.0),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            width: double.infinity,
            height: 340,
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
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 1.0, vertical: 9),
                              child: Text(
                                'Nomor Antrian Anda',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: Center(
                                child: Text(
                                  userData['status_antrian'] == 'selesai'
                                      ? '0'
                                      : (userData['nomer_antrian'] != null &&
                                              userData['nomer_antrian']
                                                      .toString()
                                                      .length ==
                                                  1)
                                          ? '0${userData['nomer_antrian']}'
                                          : userData['nomer_antrian']
                                              .toString(),
                                  style: TextStyle(
                                    fontSize: 130,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Center(
                                child: Text(
                                  'Total Antrian: $totalAntrianMenunggu orang',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Center(
                                child: Text(
                                  'Estimasi Waktu Diperiksa: ${userData['jam_antrian']} WIB',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                              ),
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
      ),
    );
  }
}
