import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart'; // Pastikan file ini di-import
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:e_klinik_dr_h_m_chalim/provider/collection.dart';

class DaftarPage extends StatefulWidget {
  const DaftarPage({Key? key}) : super(key: key);

  @override
  _DaftarPageState createState() => _DaftarPageState();
}

class _DaftarPageState extends State<DaftarPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isPasswordVisible = false;
  DateTime _selectedDate = DateTime.now();
  String _selectedGender = 'Pilih Jenis Kelamin';

  TextEditingController _nikController = TextEditingController();
  TextEditingController _namaController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String> _generateNewId() async {
    QuerySnapshot idUserSnapshot = await _firestore
        .collection(Database.getCollection())
        .where('id_user', isEqualTo: 'id001')
        .get();

    if (idUserSnapshot.docs.isNotEmpty) {
      // Jika ID sudah ada, cari ID yang belum terpakai dan kembalikan
      int suffix = 1;
      String newId = 'id001';

      while (true) {
        newId = 'id' + suffix.toString().padLeft(3, '0');
        QuerySnapshot existingIdSnapshot = await _firestore
            .collection(Database.getCollection())
            .where('id_user', isEqualTo: newId)
            .get();

        if (existingIdSnapshot.docs.isEmpty) {
          // ID belum terpakai
          break;
        }

        suffix++;
      }

      return newId;
    } else {
      // Jika ID belum ada, langsung gunakan 'id001'
      return 'id001';
    }
  }

  Future<String> _generateNomerRekamMedis() async {
    QuerySnapshot idUserSnapshot = await _firestore
        .collection(Database.getCollection())
        .where('nomerRekamMedis', isEqualTo: 'Kmts.pa.001')
        .get();

    if (idUserSnapshot.docs.isNotEmpty) {
      // Jika ID sudah ada, cari ID yang belum terpakai dan kembalikan
      int suffix = 1;
      String rekam_medis = 'Kmts.pa.001';

      while (true) {
        rekam_medis = 'Kmts.pa.' + suffix.toString().padLeft(3, '0');
        QuerySnapshot existingIdSnapshot = await _firestore
            .collection(Database.getCollection())
            .where('nomerRekamMedis', isEqualTo: rekam_medis)
            .get();

        if (existingIdSnapshot.docs.isEmpty) {
          // ID belum terpakai
          break;
        }

        suffix++;
      }

      return rekam_medis;
    } else {
      // Jika ID belum ada, langsung gunakan 'id001'
      return 'Kmts.pa.001';
    }
  }

  Future<void> _sendRegistrationData() async {
    await googleSignIn.signOut();
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }

      // Validasi email dan password (contoh: minimal 6 karakter)
      if (_emailController.text.isEmpty ||
          _passwordController.text.length < 6) {
        print('Email or password is not valid.');
        return;
      }

      try {
        final GoogleSignInAccount? googleSignInAccount =
            await googleSignIn.signIn();

        if (googleSignInAccount != null) {
          // Periksa apakah alamat email Google sesuai dengan alamat email dari _emailController
          if (googleSignInAccount.email == _emailController.text) {
            // Alamat email sesuai, lanjutkan dengan proses masuk atau tindakan lainnya
            GoogleSignInAuthentication googleSignInAuthentication =
                await googleSignInAccount.authentication;
            AuthCredential googleAuthCredential = GoogleAuthProvider.credential(
              accessToken: googleSignInAuthentication.accessToken,
              idToken: googleSignInAuthentication.idToken,
            );

            // Sign in with Google credentials
            UserCredential googleUserCredential =
                await _auth.signInWithCredential(googleAuthCredential);

            if (googleUserCredential.user != null) {
              // Check if user with the same email already exists
              QuerySnapshot existingUserSnapshot = await _firestore
                  .collection(Database.getCollection())
                  .where('email', isEqualTo: googleUserCredential.user!.email)
                  .get();

              if (existingUserSnapshot.docs.isNotEmpty) {
                // User with the same email already exists, handle it (show an error, etc.)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Akun email sudah terdaftar'),
                  ),
                );
                print('User with the same email already exists.');
                return;
              } else {
                String newId = await _generateNewId();
                String rekam_medis = await _generateNomerRekamMedis();
                await _firestore
                    .collection(Database.getCollection())
                    .doc('user: ${_namaController.text}')
                    .set({
                  'id_user': newId,
                  'nik': _nikController.text,
                  'nama': _namaController.text,
                  'tanggal_lahir':
                      _selectedDate.toLocal().toString().split(' ')[0],
                  'jenis_kelamin': _selectedGender,
                  'alamat': _alamatController.text,
                  'no_telpon': '0',
                  'password': _passwordController.text,
                  'email': googleUserCredential.user!.email,
                  'status': 'user',
                  'nomerRekamMedis': rekam_medis,
                  'status_janji': 'belum_janji',
                });

                // Pindah ke SplashBerhasil dan tunggu 2 detik sebelum pindah ke login.php
                Get.offNamed('/splash');

                await Future.delayed(Duration(seconds: 2));
                Get.offNamed('/');
                print('User registered successfully.');
              }
            }
            // Check if the user signed in with Google
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Akun email sesuai.'),
              ),
            );
          } else {
            // Alamat email tidak sesuai, cetak pesan kesalahan
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Akun email tidak sesuai.'),
              ),
            );
            return;
          }
        }
      } catch (googleSignInError) {
        print('Error signing in with Google: $googleSignInError');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Widget _buildTextField(
      String label, String hint, TextEditingController controller) {
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
        TextField(
          controller: controller,
          style: TextStyle(color: Color.fromARGB(113, 3, 3, 3)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Color.fromARGB(113, 3, 3, 3)),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerField(String label) {
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
        InkWell(
          onTap: () async {
            // Action when the date field is clicked
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );

            if (picked != null && picked != _selectedDate) {
              setState(() {
                _selectedDate = picked;
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 102, 177, 238),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate.toLocal().toString().split(' ')[0],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Icon(Icons.calendar_today, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderPickerField(String label) {
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
        InkWell(
          onTap: () {
            // Action when the gender field is clicked
            _selectGender(context);
          },
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 102, 177, 238),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedGender,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller) {
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: TextField(
              controller: controller,
              obscureText: !_isPasswordVisible,
              style: TextStyle(color: Color.fromARGB(113, 3, 3, 3)),
              decoration: InputDecoration(
                hintText: 'Masukkan Password',
                hintStyle: TextStyle(color: const Color.fromARGB(113, 3, 3, 3)),
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
                    color: Color.fromARGB(255, 75, 146, 204),
                  ),
                ),
                border: InputBorder.none,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectGender(BuildContext context) async {
    final int pickedIndex = await showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 200.0,
          child: Column(
            children: [
              ListTile(
                title: Text('Pilih Jenis Kelamin'),
                onTap: () {
                  Navigator.pop(
                      context, 0); // User selected title, return index 0
                },
              ),
              ListTile(
                title: Text('Laki-laki'),
                onTap: () {
                  Navigator.pop(
                      context, 1); // User selected index 1 (Laki-laki)
                },
              ),
              ListTile(
                title: Text('Perempuan'),
                onTap: () {
                  Navigator.pop(
                      context, 2); // User selected index 2 (Perempuan)
                },
              ),
            ],
          ),
        );
      },
    );

    if (pickedIndex != null && pickedIndex > 0) {
      setState(() {
        // Set the selected gender based on the pickedIndex
        _selectedGender = pickedIndex == 1 ? 'Laki-laki' : 'Perempuan';
      });
    }
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
                  'Registrasi',
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
                      'assets/icon/Dr1.png'), // Replace with your image path
                ),
                SizedBox(height: 20),
                // Form field for NIK
                _buildTextField('Nik', 'Masukkan NIK', _nikController),
                SizedBox(height: 20),
                // Form field for Nama
                _buildTextField('Nama', 'Masukkan Nama', _namaController),
                SizedBox(height: 20),
                // Form field for Tanggal Lahir
                _buildDatePickerField('Tanggal lahir'),
                SizedBox(height: 20),
                // Form field for Jenis Kelamin
                _buildGenderPickerField('Jenis Kelamin'),
                SizedBox(height: 20),
                // Form field for Alamat
                _buildTextField('Alamat', 'Masukkan Alamat', _alamatController),
                SizedBox(height: 20),
                // Form field for Email
                _buildTextField(
                    'Email google', 'Masukkan Email', _emailController),
                SizedBox(height: 20),
                // Form field for Password
                _buildPasswordField('Password', _passwordController),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      // Action when the "Submit" button is clicked
                      _sendRegistrationData();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 46, 79, 105),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      minimumSize: Size(350, 50),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text('Submit'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
