import 'package:e_klinik_dr_h_m_chalim/screens/screen_pasien_user/home_pasien.dart';
import 'package:e_klinik_dr_h_m_chalim/widgets/get/userStatus.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:e_klinik_dr_h_m_chalim/provider/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_klinik_dr_h_m_chalim/widgets/get/useremail.dart';
import 'package:intl/intl.dart';

class KartuPasien extends StatelessWidget {
  String status = SimpanStatus.getStatus();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: status == 'pasien'
          ? buildPasien(context)
          : pasienTidakTerdafter(context),
    );
  }
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
        return pasienTerdafter(context, userData);
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
        return pasienTerdafter(context, userData);
      }
    },
  );
}

String calculateAge(DateTime birthDate) {
  DateTime currentDate = DateTime.now();
  int age = currentDate.year - birthDate.year;
  int month1 = currentDate.month;
  int month2 = birthDate.month;
  if (month2 > month1) {
    age--;
  } else if (month1 == month2) {
    int day1 = currentDate.day;
    int day2 = birthDate.day;
    if (day2 > day1) {
      age--;
    }
  }
  return age.toString();
}

Widget pasienTerdafter(BuildContext context, Map<String, dynamic> userData) {
  DateTime tanggalLahir =
      DateFormat('yyyy-MM-dd').parse(userData['tanggal_lahir']);
  final now = DateTime.now();
  print(tanggalLahir);
  // Menghitung umur berdasarkan tanggal lahir
  String umur = calculateAge(tanggalLahir);

  return Scaffold(
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
                    color: Color.fromARGB(255, 78, 127, 167),
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
                  right: 30.0,
                ),
                child: Text(
                  'kartu berobat',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(255, 78, 127, 167),
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 140),
        child: Column(
          children: [
            SizedBox(
              height: 270,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromARGB(34, 29, 30, 31),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0,
                          2), // Adjusted to have the shadow on bottom, left, and right
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      color: const Color.fromARGB(255, 149, 199, 240),
                      width: 400,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 13.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.circle,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Column(
                              children: [
                                Text(
                                  'PRAKTEK DOKTER UMUM DAN ANAK',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontSize: 8.0,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'dr.H.M.Chalim,Spa',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white,
                                    color: Colors.white,
                                    fontSize: 8.0,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Jl. mangun sarkoro no.57,Dusun Talun,Beji,Kec.Boyolangu,\nKabupaten Tulungagung, Jawa timur 66233',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white,
                                    color: Colors.white,
                                    fontSize: 5.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Container(
                                child: QrImageView(
                                  data:
                                      "namabarcode", // Replace with actual data
                                  version: QrVersions.auto,
                                  size: 200.0,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 2.0,
                      height: 0.0,
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        width: 380,
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 250.0),
                              child: Text(
                                '${userData['nomerRekamMedis'] ?? "Belum diset"}',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 78, 127, 167),
                                ),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                'Nama Lengkap   :   ${userData['nama'] ?? "Belum diset"}',
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 78, 127, 167),
                                ),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                'Umur                         :   $umur tahun ',
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 78, 127, 167),
                                ),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                'Jenis Kelamin     :   ${userData['jenis_kelamin'] ?? "Belum diset"}',
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 78, 127, 167),
                                ),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                'Alamat                    :   ${userData['alamat'] ?? "Belum diset"}',
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 78, 127, 167),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ketentuan:',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500, // Use w500 for medium weight
                      fontSize: 14.0,
                      color: Color.fromARGB(
                          255, 78, 127, 167), // Adjust the font size as needed
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '1. Tunjukan selalu kartu ketika berobat.',
                    style: TextStyle(
                      fontSize: 11.0,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 78, 127, 167),
                    ),
                  ),
                  Text(
                    '2. Kartu tidak boleh disalahgunakan.',
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 78, 127, 167),
                    ),
                  ),
                  Text(
                    '3. Apabila ada perubahan data bisa konsultasi ke klinik.',
                    style: TextStyle(
                      fontSize: 11.0,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 78, 127, 167),
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

int hitungUmur(DateTime tanggalLahir) {
  final now = DateTime.now();
  int umur = now.year - tanggalLahir.year;
  if (now.month < tanggalLahir.month ||
      (now.month == tanggalLahir.month && now.day < tanggalLahir.day)) {
    umur--;
  }
  return umur;
}

Widget pasienTidakTerdafter(BuildContext context) {
  return Scaffold(
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
                    color: Color.fromARGB(255, 78, 127, 167),
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
                  right: 30.0,
                ),
                child: Text(
                  'kartu berobat',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(255, 78, 127, 167),
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 140),
        child: Column(
          children: [
            SizedBox(
              height: 290,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromARGB(34, 29, 30, 31),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0,
                          2), // Adjusted to have the shadow on bottom, left, and right
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      color: const Color.fromARGB(255, 149, 199, 240),
                      width: 400,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 13.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.circle,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Column(
                              children: [
                                Text(
                                  'PRAKTEK DOKTER UMUM DAN ANAK',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontSize: 8.0,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'dr.H.M.Chalim,Spa',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white,
                                    color: Colors.white,
                                    fontSize: 8.0,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Jl. mangun sarkoro no.57,Dusun Talun,Beji,Kec.Boyolangu,\nKabupaten Tulungagung, Jawa timur 66233',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white,
                                    color: Colors.white,
                                    fontSize: 5.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Container(
                                child: QrImageView(
                                  data:
                                      "namabarcode", // Replace with actual data
                                  version: QrVersions.auto,
                                  size: 200.0,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 2.0,
                      height: 0.0,
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        width: 370,
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 300.0),
                              child: Text(
                                '.',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 78, 127, 167),
                                ),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                'Nama Lengkap   :   -',
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 78, 127, 167),
                                ),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                'Umur                         :   -',
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 78, 127, 167),
                                ),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                'Jenis Kelamin     :   -',
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 78, 127, 167),
                                ),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                'Alamat                    :   -',
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 78, 127, 167),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ketentuan:',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500, // Use w500 for medium weight
                      fontSize: 14.0,
                      color: Color.fromARGB(
                          255, 78, 127, 167), // Adjust the font size as needed
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '1. Tunjukan selalu kartu ketika berobat.',
                    style: TextStyle(
                      fontSize: 11.0,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 78, 127, 167),
                    ),
                  ),
                  Text(
                    '2. Kartu tidak boleh disalahgunakan.',
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 78, 127, 167),
                    ),
                  ),
                  Text(
                    '3. Apabila ada perubahan data bisa konsultasi ke klinik.',
                    style: TextStyle(
                      fontSize: 11.0,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 78, 127, 167),
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
