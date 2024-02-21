import 'package:e_klinik_dr_h_m_chalim/screens/screen_admin/home_admin.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_apoteker/home_apoteker.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_doctor/home_doctor.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_pasien_user/home_pasien.dart';
import 'package:e_klinik_dr_h_m_chalim/widgets/get/userStatus.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'daftar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_klinik_dr_h_m_chalim/widgets/get/useremail.dart';
import 'package:e_klinik_dr_h_m_chalim/provider/collection.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await googleSignIn.signOut();
    } catch (e) {
      // Handle errors as needed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor:
              Colors.blue, // Ganti dengan warna latar belakang yang diinginkan
          content: Text(
            'Error during sign out: $e',
            style: TextStyle(
              color: Colors.white, // Ganti dengan warna font yang diinginkan
            ),
          ),
        ),
      );
    }
  }

  Future<User?> signInWithGoogle() async {
    try {
      await signOut();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount == null) {
        // User cancelled the sign-in process
        return null;
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User? user = authResult.user;

      if (user != null) {
        // Check if the user is already registered in your Firestore collection

        final userSnapshot = await FirebaseFirestore.instance
            .collection(Database.getCollection())
            .where('email', isEqualTo: user.email)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          // User is registered, proceed with login
          final userData = userSnapshot.docs[0].data() as Map<String, dynamic>;
          final status = userData['status'];
          SimpanStatus.simpan(status);

          if (status == 'user') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePagePasien()),
            );
          } else if (status == 'admin') {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Tidak bisa login'),
                  content: Text(
                      'maaf anda terdaftar sebagai admin\nsilahkan login manual sesuai akun resmi anda'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          } else if (status == 'doctor') {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Tidak bisa login'),
                  content: Text(
                      'maaf anda terdaftar sebagai Doctor\nsilahkan login manual sesuai akun resmi anda'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          } else if (status == 'apoteker') {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Tidak bisa login'),
                  content: Text(
                      'maaf anda terdaftar sebagai apoteker\nsilahkan login manual sesuai akun resmi anda'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          } else if (status == 'pasien') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePagePasien()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors
                    .blue, // Ganti dengan warna latar belakang yang diinginkan
                content: Text(
                  'Login failed. User is not a valid user.',
                  style: TextStyle(
                    color:
                        Colors.white, // Ganti dengan warna font yang diinginkan
                  ),
                ),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors
                  .blue, // Ganti dengan warna latar belakang yang diinginkan
              content: Text(
                'Login failed. User not registered.',
                style: TextStyle(
                  color:
                      Colors.white, // Ganti dengan warna font yang diinginkan
                ),
              ),
            ),
          );
        }

        return user;
      }
    } catch (e) {
      print('Error during Google login: $e');
      // Handle errors as needed
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content:
                Text('Terjadi kesalahan selama proses login dengan Google.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 79),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 94, 148, 199),
                  ),
                ),
                CircleAvatar(
                  radius: 105,
                  backgroundImage: AssetImage(
                    'assets/icon/Dr1.png',
                  ),
                ),
                SizedBox(height: 20),
                buildTextField('Email', _emailController),
                SizedBox(height: 10),
                buildPasswordField('Password', _passwordController),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DaftarPage()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    child: Align(
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          text: 'Belum punya akun? Silahkan Daftar',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: ' disini',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    signIn();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 46, 79, 105),
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ).copyWith(
                    minimumSize: MaterialStateProperty.all(Size(350, 50)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text('Sign in'),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () async {
                    // Tindakan yang dilakukan ketika tombol "Sign in with Google" ditekan
                    signInWithGoogle();
                  },
                  icon: Image.asset(
                    'assets/icon/Google.png',
                    height: 24,
                    width: 24,
                  ),
                  label: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text('Sign in with Google'),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    minimumSize: Size(350, 50),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color.fromARGB(255, 51, 92, 116),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 102, 177, 238),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: controller,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter your $label',
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPasswordField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color.fromARGB(255, 51, 92, 116),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 102, 177, 238),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: controller,
              obscureText: !_isPasswordVisible,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Create $label',
                hintStyle: TextStyle(color: Colors.white),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  child: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.white,
                  ),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> signIn() async {
    try {
      final email = _emailController.text;
      final password = _passwordController.text;

      // Check if the email exists in Firestore
      final userSnapshot = await FirebaseFirestore.instance
          .collection(Database.getCollection())
          .where('email', isEqualTo: email)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        final userData = userSnapshot.docs[0].data() as Map<String, dynamic>;

        // Get the user's password from Firestore
        final storedPassword = userData['password'];

        // Validate the password
        if (storedPassword == password) {
          // Password is correct, proceed with login
          if (userData.containsKey('status')) {
            final status = userData['status'];
            final email = userData['email'];
            SimpanEmail.simpan(email);
            SimpanStatus.simpan(status);
            if (status == 'user') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePagePasien()),
              );
            } else if (status == 'admin') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePageAdmin()),
              );
            } else if (status == 'doctor') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePageDokter()),
              );
            } else if (status == 'pasien') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePagePasien()),
              );
            } else if (status == 'apoteker') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeApoteker()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Login failed. User is not a valid user.'),
                ),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors
                    .blue, // Ganti dengan warna latar belakang yang diinginkan
                content: Text(
                  'Login failed. Status not found in user data.',
                  style: TextStyle(
                    color:
                        Colors.white, // Ganti dengan warna font yang diinginkan
                  ),
                ),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors
                  .blue, // Ganti dengan warna latar belakang yang diinginkan
              content: Text(
                'Login failed. Incorrect password.',
                style: TextStyle(
                  color:
                      Colors.white, // Ganti dengan warna font yang diinginkan
                ),
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors
                .blue, // Ganti dengan warna latar belakang yang diinginkan
            content: Text(
              'Login failed. User not found.',
              style: TextStyle(
                color: Colors.white, // Ganti dengan warna font yang diinginkan
              ),
            ),
          ),
        );
      }
    } catch (e) {
      print('Error during login: $e');
      // Handle errors as needed
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Terjadi kesalahan selama proses login.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
