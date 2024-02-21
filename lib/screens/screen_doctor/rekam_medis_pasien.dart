import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_klinik_dr_h_m_chalim/widgets/get/nomerRekamMedis.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:e_klinik_dr_h_m_chalim/provider/collection.dart';


class RekamMedisPasienDoctor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                      color: Color.fromARGB(255, 69, 128, 177),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Get.offNamed('/homeDoctor');
              },
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: 40.0,
                  ),
                  child: Text(
                    'Rekam Medis Pasien',
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Rekam_medis_pasien')
            .where('nomerRekamMedis',
                isEqualTo: NomerRekamMedis.getnomerRekamMedis())
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Rekam medis belum dibuat',style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(255, 156, 156, 156),
                    fontSize: 23.0,
                  ),));
          }
          var dataList = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
          return SingleChildScrollView(
            child: Column(
              children: dataList.map((Map<String, dynamic> data) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal : 20.0 , vertical: 10),
                  child: buildGridItem(
                    'assets/icon/heart-rate.png',
                    'Rekam medis  ${data['nama'] ?? ''}',
                    '${data['tanggal_medis'] ?? ''}',
                    context,
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Your onPressed logic here
          // For example, navigation to the add screen
          Get.offNamed('/DetailRekamMEdisPasien');
        },
        backgroundColor: const Color.fromARGB(255, 106, 159, 202),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // Adjust as needed
    );
  }

  Widget buildGridItem(
      String imagePath, String title, String date, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 10,
            offset: Offset(0, 3),
          ), // changes the position of the shadow
        ],
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
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(255, 69, 128, 177),
                    fontSize: 13.0,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  date,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 69, 128, 177),
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50.0),
            child: IconButton(
              icon: Row(
                children: [
                  Text(
                    '\u203A',
                    style: TextStyle(
                      fontSize: 30,
                      color: Color.fromARGB(255, 69, 128, 177),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Get.offNamed('/editRekamMedis');
              },
            ),
          ),
        ],
      ),
    );
  }
}
