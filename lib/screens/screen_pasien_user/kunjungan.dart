import 'package:e_klinik_dr_h_m_chalim/screens/screen_pasien_user/home_pasien.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_klinik_dr_h_m_chalim/provider/collection.dart';
import 'package:e_klinik_dr_h_m_chalim/widgets/get/useremail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class KunjunganSreen extends StatefulWidget {
  @override
  _KunjunganSreenState createState() => _KunjunganSreenState();
}

class _KunjunganSreenState extends State<KunjunganSreen>
    with SingleTickerProviderStateMixin {
  String nomerRekamMedis = '';

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 12, vsync: this);
    ambil_data(); // Buat TabController dengan 12 tab
  }

  Future<void> ambil_data() async {
    String email2 = SimpanEmail.getEmail();
    final User? user = FirebaseAuth.instance.currentUser;
    if (user?.providerData[0]?.providerId == 'google.com') {
      try {
        QuerySnapshot eklinikSnapshot = await FirebaseFirestore.instance
            .collection(Database.getCollection())
            .where('email', isEqualTo: user!.email)
            .get();

        if (eklinikSnapshot.docs.isNotEmpty) {
          setState(() {
            nomerRekamMedis = eklinikSnapshot.docs[0]['nomerRekamMedis'] ?? '';
          });
        }
      } catch (error) {
        // Handle error
        print(error);
      }
    } else {
      try {
        QuerySnapshot eklinikSnapshot = await FirebaseFirestore.instance
            .collection(Database.getCollection())
            .where('email', isEqualTo: email2)
            .get();

        if (eklinikSnapshot.docs.isNotEmpty) {
          setState(() {
            nomerRekamMedis = eklinikSnapshot.docs[0]['nomerRekamMedis'] ?? '';
          });
        }
      } catch (error) {
        // Handle error
        print(error);
      }
    }
  }

  // Fungsi untuk mengubah format tanggal
  String formatDate(DateTime date) {
    // Buat formatter untuk hari, tanggal, dan bulan
    DateFormat dayFormat = DateFormat('EEEE');
    DateFormat dateFormat = DateFormat('dd MMMM yyyy');

    // Format tanggal menggunakan formatter yang telah dibuat
    String formattedDate =
        '${dayFormat.format(date)}, ${dateFormat.format(date)}';

    return formattedDate;
  }

  String _getMonthName(DateTime date) {
    switch (date.month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                  // Navigasi kembali
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
                      'Kunjungan',
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
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 60),
              // Avatar Foto
              Image(
                image: AssetImage('assets/icon2/kit.png'),
                width: 160, // Sesuaikan dengan ukuran yang Anda inginkan
                height: 160,
              ),
              SizedBox(height: 50),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
                    boxShadow: [
                      // Tambahkan box shadow di sudut top kiri dan kanan
                      BoxShadow(
                        color: Color.fromARGB(28, 41, 41, 41).withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(-3, 3), // Offset untuk sudut top kiri
                      ),
                      BoxShadow(
                        color: Color.fromARGB(70, 39, 38, 38).withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(3, 3), // Offset untuk sudut top kanan
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          labelColor: Colors.white,
                          indicator: BoxDecoration(
                            color: Colors.transparent,
                            border: Border(
                              bottom: BorderSide(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                width: 2.0,
                              ),
                            ),
                          ),
                          tabs: [
                            for (int i = 1; i <= 12; i++)
                              Tab(
                                child: Text(
                                  _getMonthName(DateTime(2024, i)),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            for (int i = 1; i <= 12; i++)
                              _buildMonthContent(DateTime(2024, i)),
                          ],
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
    );
  }

  Widget _buildMonthContent(DateTime monthDate) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Rekam_medis_pasien')
                    .where('nomerRekamMedis', isEqualTo: nomerRekamMedis)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData ||
                      snapshot.data == null ||
                      snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No data found'));
                  }
                  var dataList = snapshot.data!.docs
                      .map((doc) => doc.data() as Map<String, dynamic>)
                      .toList();
                  return SingleChildScrollView(
                    child: Column(
                      children: dataList.map((Map<String, dynamic> data) {
                        dynamic tanggalMedis = data['tanggal_medis'];
                        if (tanggalMedis is Timestamp) {
                          DateTime tanggalMedisDate = tanggalMedis.toDate();
                          if (tanggalMedisDate.month == monthDate.month) {
                            String formattedDate = formatDate(tanggalMedisDate);
                            print(formattedDate);
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0.0, vertical: 0),
                              child: buildGridItem(
                                'assets/icon2/shc.png',
                                'Kunjungan',
                                '$formattedDate',
                                '${data['jam'] ?? ''}',
                                context,
                              ),
                            );
                          }
                        } else if (tanggalMedis is String) {
                          // Jika tanggal_medis adalah String, konversi ke DateTime
                          DateTime tanggalMedisDate =
                              DateTime.parse(tanggalMedis);
                          if (tanggalMedisDate.month == monthDate.month) {
                            String formattedDate = formatDate(tanggalMedisDate);
                            print(formattedDate);
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0.0, vertical: 0),
                              child: buildGridItem(
                                'assets/icon2/shc.png',
                                'Kunjungan',
                                '$formattedDate',
                                '${data['jam'] ?? ''}',
                                context,
                              ),
                            );
                          }
                        }
                        return SizedBox(); // Jika tidak sesuai, kembalikan SizedBox
                      }).toList(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGridItem(String imagePath, String title, String date, String jam,
      BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(0, 255, 255, 255),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset(
            imagePath,
            width: 40,
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 13.0,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  date,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 11.0,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              '$jam WIB',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Poppins',
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(KunjunganSreen());
}
