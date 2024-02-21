import 'package:e_klinik_dr_h_m_chalim/screens/screen_doctor/home_doctor.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_klinik_dr_h_m_chalim/widgets/get/nomerRekamMedis.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:e_klinik_dr_h_m_chalim/provider/collection.dart';


class DetailPasien extends StatelessWidget {
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
                      MaterialPageRoute(builder: (context) => HomePageDokter()),
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
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(Database.getCollection())
              .where('nomerRekamMedis',
                  isEqualTo: NomerRekamMedis.getnomerRekamMedis())
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return Text('No data found');
            }
            var data =
                snapshot.data!.docs.first.data() as Map<String, dynamic>?;

            if (data == null) {
              return Text('No data found');
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  // Your avatar image goes here
                ),
                SizedBox(height: 10),
                Text(
                  'NAMA PASIEN TERFAFTAR',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: Color.fromARGB(255, 69, 128, 177),
                    fontSize: 14.0,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  data['nama'] ?? 'No name',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 69, 128, 177),
                    fontSize: 12.0,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 300,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 29, 96, 151),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.offNamed('/RekamMedisDC');

                      // Handle button1 click
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors
                          .transparent, // Set the button color as transparent
                      elevation: 0, // Remove button elevation
                    ),
                    child: Text(
                      'Lihat rekam medis',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 300,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 132, 193, 243),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle button2 click
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      elevation: 0,
                    ),
                    child: Text(
                      'Lihat imunisasi',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 300,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Colors.blue), // Set the border color to blue
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle button3 click
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      elevation: 0,
                    ),
                    child: Text(
                      'Lihat E-Resep',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
                buildProfileTile(
                    Icons.person, 'Name', data['nama'] ?? 'No name'),
                buildProfileTile(
                    Icons.email, 'Email', data['email'] ?? 'No email'),
                buildProfileTile(
                    Icons.phone, 'Phone', data['no_telpon'] ?? 'No no telpon'),
                buildProfileTile(
                    Icons.man, 'Gender', data['jenis_kelamin'] ?? 'No name'),
                buildProfileTile(
                    Icons.location_on, data['alamat'] ?? 'No name', 'Bandung'),
                SizedBox(height: 10),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildProfileTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.blue, // Set icon color to blue
        ),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: Colors.blue, // Set text color to blue
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            // Add style for subtitle text
            fontSize: 16,
            color:
                Colors.black, // You can adjust the color based on your design
          ),
        ),
      ),
    );
  }
}
