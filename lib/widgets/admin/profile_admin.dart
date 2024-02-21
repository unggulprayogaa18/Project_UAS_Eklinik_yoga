import 'package:e_klinik_dr_h_m_chalim/screens/screen_admin/home_admin.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_klinik_dr_h_m_chalim/provider/userfirestore.dart';
import 'package:e_klinik_dr_h_m_chalim/provider/collection.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:firebase_auth/firebase_auth.dart';

class WidgetsProfileAdmin {
  Widget buildProfile(BuildContext context) {
    return buildFirestoreProfile(context);
  }

  Widget buildFirestoreProfile(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: UserFirestore().getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text('User data not found.'));
        } else {
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          return profiledata(context, userData);
        }
      },
    );
  }

  Widget profiledata(BuildContext context, Map<String, dynamic> userData) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 30.0), // Add vertical padding
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
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
                        'Profile admin',
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
      body: profile(context, userData),
    );
  }

  Widget profile(BuildContext context, userData) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: CircleAvatar(
                  radius: 60,
                  // Your avatar image goes here
                ),
              ),
              buildProfileTile(
                  Icons.person, 'Name', '${userData['nama'] ?? "Belum diset"}'),
              buildProfileTile(Icons.email, 'Email',
                  '${userData['email'] ?? "Belum diset"}'),
              buildProfileTile(Icons.phone, 'Phone',
                  '${userData['no_telpon'] ?? "Belum diset"}'),
              buildProfileTile(Icons.man, 'Gender',
                  '${userData['jenis_kelamin'] ?? "Belum diset"}'),
              buildProfileTile(Icons.location_on, 'Address',
                  '${userData['alamat'] ?? "Belum diset"}'),
              SizedBox(height: 20),
              buildButton(
                'Edit Profile',
                Colors.white,
                const Color.fromARGB(255, 15, 77, 128),
                const Color.fromARGB(255, 13, 52, 83),
              ),
              SizedBox(height: 10),
              buildButton('Logout', const Color.fromARGB(255, 40, 84, 121), Colors.white, const Color.fromARGB(255, 14, 66, 109)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color.fromARGB(255, 36, 98, 148), // Set icon color to blue
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
          fontSize: 13,
          color: const Color.fromARGB(255, 13, 99, 170), // Set text color to blue
        ),
      ),
      subtitle: Text(
        value,
        style: TextStyle(),
      ),
    );
  }

  Widget buildButton(
      String text, Color bgColor, Color textColor, Color borderColor) {
    return Container(
      width: 300,
      height: 40,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: TextButton(
        onPressed: () async {
          // Handle button click
          if (text == 'Edit Profile') {
            // Handle edit profile
            await Get.toNamed('/load');

            Get.offNamed('/editprofileadmin');
          } else if (text == 'Logout') {
            // Handle logout
            await Get.toNamed('/load');
            await FirebaseAuth.instance.signOut();

            Get.offNamed('/');
          }
        },
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
