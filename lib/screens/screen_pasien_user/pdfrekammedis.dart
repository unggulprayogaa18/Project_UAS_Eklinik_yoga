import 'package:e_klinik_dr_h_m_chalim/screens/screen_pasien_user/home_pasien.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_klinik_dr_h_m_chalim/widgets/get/useremail.dart';

class PdfScreen extends StatelessWidget {
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
                image: AssetImage('assets/icon2/pdf.png'),
                width: 160, // Sesuaikan dengan ukuran yang Anda inginkan
                height: 160,
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
