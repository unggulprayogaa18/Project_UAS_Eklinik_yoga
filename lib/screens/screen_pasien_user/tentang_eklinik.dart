import 'package:e_klinik_dr_h_m_chalim/screens/screen_pasien_user/home_pasien.dart';
import 'package:e_klinik_dr_h_m_chalim/widgets/map/mymap.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class TentangEklinik extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color myColor = Color(0xFF4682A9);
    Color buttonColor = Colors.white;
    Color buttonBorderColor = Colors.blue;
    Color buttonFontColor = Colors.blue;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
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
                      'Tentang eklinik',
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
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Clinic',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40.0,
                      color: myColor,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Center Information',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40.0,
                      color: myColor,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Dr. H.M. Chalim, Spa (Spesialis Anak) adalah seorang dokter dengan rating 4.5 dari para pengunjung. "Dokter spesialis anak yang cukup terkenal di kota marmer." Mungkin Anda juga tertarik untuk mencoba mengunjungi tempat ini.',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: myColor,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                Center(
                  child: Image(
                    image: AssetImage('assets/icon2/Frame.png'),
                    width: 460,
                    height: 260,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Jadwal Praktik:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: myColor,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Senin - Jumat : 08.00 - 20.00 WIB\nSabtu - Jum’at : 09.00 - 20.00 WIB',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: myColor,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'alamat : ',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: myColor,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Image(
                        image: AssetImage('assets/icon2/map.png'),
                        width: 160,
                        height: 260,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 30.0),
                            child: Column(
                              children: [
                                Text(
                                  'Jl. Ki Mangun Sarkoro No.57, Dusun\n Talun, Beji, Kec. Boyolangu, Kabupaten\n Tulungagung, Jawa Timur 66233',
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    color: myColor,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                                SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    // Action when button is pressed
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MapScreen (
                                      )
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      side:
                                          BorderSide(color: buttonBorderColor),
                                    ),
                                    primary: buttonColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10.0),
                                    child: Text(
                                      'Dapatkan arah',
                                      style: TextStyle(
                                        color: buttonFontColor,
                                      ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
