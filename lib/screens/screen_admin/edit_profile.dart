import 'package:e_klinik_dr_h_m_chalim/screens/screen_admin/home_admin.dart';
import 'package:flutter/material.dart';
import 'package:e_klinik_dr_h_m_chalim/provider/collection.dart';
import 'package:e_klinik_dr_h_m_chalim/widgets/get/useremail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileAdminScreen extends StatefulWidget {
  @override
  _EditProfileAdminScreenState createState() => _EditProfileAdminScreenState();
}

class _EditProfileAdminScreenState extends State<EditProfileAdminScreen> {
  String nomerRekamMedis = '';
  String alamat = '';
  String jenis_kelamin = '';
  String no_telpon = '';
  String nama = '';

  @override
  void initState() {
    super.initState();
    ambil_data();
  }

  Future<void> ambil_data() async {
    String email2 = SimpanEmail.getEmail();

    try {
      QuerySnapshot eklinikSnapshot = await FirebaseFirestore.instance
          .collection(Database.getCollection())
          .where('email', isEqualTo: email2)
          .get();

      if (eklinikSnapshot.docs.isNotEmpty) {
        setState(() {
          alamat = eklinikSnapshot.docs[0]['alamat'] ?? '';
          no_telpon = eklinikSnapshot.docs[0]['no_telpon'] ?? '';
          nama = eklinikSnapshot.docs[0]['nama'] ?? '';
          jenis_kelamin = eklinikSnapshot.docs[0]['jenis_kelamin'] ?? '';

          nomerRekamMedis = eklinikSnapshot.docs[0]['nomerRekamMedis'] ?? '';
          ;
        });
      }
    } catch (error) {
      // Handle error
      print(error);
    }
  }

  Future<void> simpan_data() async {
    String email2 = SimpanEmail.getEmail();

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('eklinik')
          .where('email', isEqualTo: email2)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.update({
          'nama': nama,
          'no_telpon': no_telpon,
          'alamat': alamat,
          'jenis_kelamin': jenis_kelamin,
        });

        // Tampilkan snackbar atau pesan sukses disini jika perlu
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data berhasil disimpan')),
        );
      } else {
        // Tampilkan snackbar atau pesan error jika perlu
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dokumen tidak ditemukan')),
        );
      }
    } catch (error) {
      // Handle error
      print(error);
      // Tampilkan snackbar atau pesan error jika perlu
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print(jenis_kelamin);
    print(nama);

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
                  MaterialPageRoute(builder: (context) => HomePageAdmin()),
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
                    'Edit Profile',
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
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            // Avatar Foto
            CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
            SizedBox(height: 20),

            // Nama
            TextFormField(
              initialValue: nama,
              onChanged: (value) {
                setState(() {
                  nama = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Nama',
                hintText: '$nama',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Nomor Telepon
            TextFormField(
              initialValue: no_telpon,
              onChanged: (value) {
                setState(() {
                  no_telpon = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Nomor Telepon',
                hintText: '$no_telpon',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Jenis Kelamin
            TextFormField(
              initialValue: jenis_kelamin,
              onChanged: (value) {
                setState(() {
                  jenis_kelamin = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Jenis Kelamin',
                hintText: '$jenis_kelamin',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Alamat
            TextFormField(
              initialValue: alamat,
              onChanged: (value) {
                setState(() {
                  alamat = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Alamat',
                hintText: '$alamat',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Tombol Simpan
            ElevatedButton(
              onPressed: () {
                // Tambahkan logika untuk menyimpan data
                simpan_data();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50),
                primary: const Color.fromARGB(255, 39, 106, 161),
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
