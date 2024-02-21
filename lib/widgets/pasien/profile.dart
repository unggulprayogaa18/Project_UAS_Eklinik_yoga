import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_pasien_user/home_pasien.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:e_klinik_dr_h_m_chalim/provider/userfirestore.dart';
import 'package:e_klinik_dr_h_m_chalim/provider/usergoogle.dart';

class WidgetsUser {
  Widget buildProfile(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user?.providerData[0]?.providerId == 'google.com') {
      return buildGoogleProfile(context);
    } else {
      return buildFirestoreProfile(context);
    }
  }

  Widget buildGoogleProfile(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: UserGoogle().getUserDataGoogle(),
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
    final User? user = FirebaseAuth.instance.currentUser;

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
                    right: 50.0,
                  ),
                  child: Text(
                    'Profile',
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
        // Wrap with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : AssetImage('assets/icon2/acatar.png')
                            as ImageProvider<Object>,
                  ),
                ),
                buildProfileTile(Icons.person, 'Name',
                    '${userData['nama'] ?? "Belum diset"}'),
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
                  context,
                  'Edit Profile',
                  Colors.white,
                  const Color.fromARGB(255, 42, 76, 104),
                  const Color.fromARGB(255, 11, 67, 112),
                ),
                SizedBox(height: 10),
                buildButton(
                    context, 'Logout', const Color.fromARGB(255, 19, 67, 107), Colors.white, const Color.fromARGB(255, 20, 68, 107)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProfileTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(
        icon,
        color: Color.fromARGB(255, 45, 110, 163), // Set icon color to blue
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
          fontSize: 13,
          color: Color.fromARGB(255, 34, 89, 134), // Set text color to blue
        ),
      ),
      subtitle: Text(
        value,
        style: TextStyle(),
      ),
    );
  }

  Widget buildButton(BuildContext context, String text, Color bgColor,
      Color textColor, Color borderColor) {
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
            await Get.toNamed('/load');

            Get.offNamed('/editprofileuser');
            // Handle edit profile
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
