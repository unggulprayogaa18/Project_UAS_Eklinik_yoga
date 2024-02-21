import 'package:e_klinik_dr_h_m_chalim/screens/screen_admin/home_admin.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_apoteker/home_apoteker.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_doctor/home_doctor.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:e_klinik_dr_h_m_chalim/provider/collection.dart';
import 'package:e_klinik_dr_h_m_chalim/widgets/get/nomerRekamMedis.dart';

class ListResepPasien extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                      MaterialPageRoute(builder: (context) => HomeApoteker()),
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
              FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection(Database.getCollection())
                    .where('status_janji', isEqualTo: 'sedang_janji')
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.hasData) {
                      List<QueryDocumentSnapshot<Map<String, dynamic>>>
                          documents = [];
                      if (snapshot.hasData) {
                        documents = (snapshot.data!.docs as List<
                            QueryDocumentSnapshot<Map<String, dynamic>>>);
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          var data = documents[index].data();
                          int nomorAntrian = index + 1;
                          String nomorAntrianString = nomorAntrian
                              .toString()
                              .padLeft(4,
                                  '0'); // Menambahkan angka 0 di depan nomor antrian jika panjangnya kurang dari 4 digit
                          return buildGridItem(
                            'No.$nomorAntrianString',
                            '${data['nama'] ?? 'null'}',
                            'Reservasi : ${_formatDate(DateTime.parse(data['tanggalReservasi'] ?? 'null'))} | ${data['jam_antrian'] ?? 'null'}',
                            'Daftar       : ${_formatDate(DateTime.parse(data['tanggalReservasi'] ?? 'null'))}',
                            '${data['nomerRekamMedis'] ?? 'null'}',
                            '${data['status_antrian'] ?? 'null'}',
                            context,
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text('No data available'),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
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
    } else if (status.toLowerCase() == 'check') {
      statusColor = Colors.amber;
    } else {
      statusColor = Colors.red;
    }

    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman DetailPasien dengan mengirim nomerRekamMedis
        NomerRekamMedis.simpannomerRekamMedis(no_pasien);
        print(no_pasien);

        Get.offNamed('/TampilRekamMedis');
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => DetailPasien(),
        //   ),
        // );
      },
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 69, 128, 177),
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.symmetric(horizontal : 16.0, vertical: 10),
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
                        fontWeight: FontWeight.w800,
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
                      fontWeight: FontWeight.w500,
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
      ),
    );
  }
}
