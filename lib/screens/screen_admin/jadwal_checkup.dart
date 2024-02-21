import 'package:e_klinik_dr_h_m_chalim/screens/screen_admin/home_admin.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:e_klinik_dr_h_m_chalim/provider/collection.dart';
import 'package:intl/intl.dart';

class JadwalCheckupPage extends StatelessWidget {
  Stream<String> cekstatusantrianWITHjam(String nomerRekamMedis) async* {
    try {
      // Use Firestore snapshot listeners to listen for real-time updates
      await for (QuerySnapshot eklinikSnapshot in FirebaseFirestore.instance
          .collection(Database.getCollection())
          .where('nomerRekamMedis',
              isEqualTo: nomerRekamMedis) // Filter by nomerRekamMedis
          .snapshots()) {
        List<String> status_antrianList = [];

        for (QueryDocumentSnapshot doc in eklinikSnapshot.docs) {
          final userData = doc.data() as Map<String, dynamic>;

          String? jamBerakhir = userData['jam_berakhir'];
          String? jamAntrian = userData['jam_antrian'];

          if (jamBerakhir != null && jamAntrian != null) {
            DateTime now = DateTime.now();
            String currentTimeString = DateFormat.Hm().format(now.toLocal());

            if (currentTimeString.compareTo(jamAntrian) >= 0 &&
                currentTimeString.compareTo(jamBerakhir) <= 0) {
              var status_antrian = 'masuk';
              status_antrianList.add(status_antrian.toString());
            }
          }
        }

        if (status_antrianList.isNotEmpty) {
          yield status_antrianList.first.padLeft(2, '0');
        } else {
          await for (QuerySnapshot eklinikSnapshot in FirebaseFirestore.instance
              .collection(Database.getCollection())
              .where('nomerRekamMedis',
                  isEqualTo: nomerRekamMedis) // Filter by nomerRekamMedis
              .snapshots()) {
            List<String> status_antrianList2 = [];

            for (QueryDocumentSnapshot doc in eklinikSnapshot.docs) {
              final userData = doc.data() as Map<String, dynamic>;

              var status_antrian3 = userData['status_antrian'];
              status_antrianList2.add(status_antrian3.toString());
            }

            if (status_antrianList2.isNotEmpty) {
              yield status_antrianList2.first.padLeft(2, '0');
            } else {
              yield "status_antrian";
            }
          }
        }
      }
    } catch (e) {
      print('Error status_antrian tidak muncul untuk jam sekarang: $e');
      yield "";
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: AppBar(
            elevation: 0,
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            shape: Border(
              top: BorderSide(
                color: Color.fromARGB(55, 116, 115, 115),
                width: 2.0,
              ),
              bottom: BorderSide(
                color: Color.fromARGB(55, 116, 115, 115),
                width: 2.0,
              ),
            ),
            flexibleSpace: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Color.fromARGB(255, 69, 128, 177),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePageAdmin()),
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
                        'Jadwal Hari Ini',
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
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(Database.getCollection())
                    .where('status_janji', isEqualTo: 'sedang_janji')
                    .where('tanggalReservasi', isEqualTo: formattedDate)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    List<QueryDocumentSnapshot<Map<String, dynamic>>>
                        documents =
                        (snapshot.data! as QuerySnapshot<Map<String, dynamic>>)
                            .docs;

                    if (documents.isEmpty) {
                      return Center(
                        child: Text('No data available'),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        var data = documents[index].data();
                        String nomorAntrianString = '';
                        if (data['nomer_antrian'] != null) {
                          String nomorAntrian =
                              data['nomer_antrian'].toString();
                          if (nomorAntrian.length == 1) {
                            nomorAntrianString = 'No.000$nomorAntrian';
                          } else if (nomorAntrian.length == 2) {
                            nomorAntrianString = 'No.00$nomorAntrian';
                          } else if (nomorAntrian.length == 3) {
                            nomorAntrianString = 'No.0$nomorAntrian';
                          }
                        } else {
                          nomorAntrianString = 'No.null';
                        }
                        return StreamBuilder<String>(
                          stream: cekstatusantrianWITHjam(
                              data['nomerRekamMedis'] ?? ''),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              String status_antrian = snapshot.data ??
                                  data['status_antrian'] ??
                                  'null';
                              // Periksa apakah status_antrian null atau tidak
                              // Jika tidak null, gunakan status_antrian
                              return buildGridItem(
                                nomorAntrianString,
                                '${data['nama'] ?? 'null'}',
                                'Reservasi : ${_formatDate(DateTime.parse(data['tanggalReservasi'] ?? 'null'))} | ${data['jam_antrian'] ?? 'null'}',
                                'Daftar       : ${_formatDate(DateTime.parse(data['tanggalReservasi'] ?? 'null'))}',
                                '${data['nomerRekamMedis'] ?? 'null'}',
                                status_antrian.padLeft(
                                    2, '0'), // Gunakan status_antrian
                                context,
                              );
                              // Jika null, gunakan nilai default dari data['status_antrian']
                            }
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 0, 65, 243),
        onPressed: () async {
          Get.offNamed('/teller_page');
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Set border radius here
          side: BorderSide(
            color: Color.fromARGB(
                255, 255, 255, 255), // Optional: Set border color
          ),
        ),
        child: Icon(Icons.notifications,
            color: const Color.fromARGB(255, 255, 255, 255)),
      ),
    );
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) {
      return 'Tanggal tidak valid';
    } else {
      try {
        String month;
        switch (dateTime.month) {
          case 1:
            month = 'Januari';
            break;
          case 2:
            month = 'Februari';
            break;
          case 3:
            month = 'Maret';
            break;
          case 4:
            month = 'April';
            break;
          case 5:
            month = 'Mei';
            break;
          case 6:
            month = 'Juni';
            break;
          case 7:
            month = 'Juli';
            break;
          case 8:
            month = 'Agustus';
            break;
          case 9:
            month = 'September';
            break;
          case 10:
            month = 'Oktober';
            break;
          case 11:
            month = 'November';
            break;
          case 12:
            month = 'Desember';
            break;
          default:
            month = '';
        }
        return '${dateTime.day} $month ${dateTime.year}';
      } catch (e) {
        print('Error formatting date: $e');
        return 'Tanggal tidak valid';
      }
    }
  }

  Widget buildGridItem(
    String noantrian,
    String namaPasien,
    String waktuReservasi,
    String tanggalDaftar,
    String no_pasien,
    String status,
    BuildContext context,
  ) {
    Color statusColor;
    if (status.toLowerCase() == 'selesai') {
      statusColor = Colors.green;
    } else if (status.toLowerCase() == 'masuk') {
      statusColor = Colors.amber;
    } else {
      statusColor = Colors.red;
    }

    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 69, 128, 177),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  namaPasien,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Poppins'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Text(
                  noantrian,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins'),
                ),
              ),
            ],
          ),
          Image.asset(
            'assets/icon2/garis.png',
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              waktuReservasi,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              tanggalDaftar,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins'),
            ),
          ),
          Image.asset(
            'assets/icon2/garis.png',
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  no_pasien,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Text(
                    status,
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
