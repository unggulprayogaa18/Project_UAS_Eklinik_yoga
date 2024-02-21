import 'package:e_klinik_dr_h_m_chalim/screens/screen_pasien_user/home_pasien.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_klinik_dr_h_m_chalim/controllers/pasien/chekcup_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:e_klinik_dr_h_m_chalim/provider/collection.dart';
import 'package:e_klinik_dr_h_m_chalim/widgets/get/useremail.dart';

class CheckupPage extends StatefulWidget {
  const CheckupPage({Key? key}) : super(key: key);

  @override
  _CheckupPageState createState() => _CheckupPageState();
}

class _CheckupPageState extends State<CheckupPage> {
  String nama = ''; // Inisialisasi variabel nama
  String nomerRekamMedis = ''; // Inisialisasi variabel nomerRekamMedis
  String alamat = ''; // Inisialisasi variabel alamat
  RxString email = RxString('');
  String email2 = SimpanEmail.getEmail();
  int refreshCount = 0;
  void setEmail(String newEmail) {
    email.value = newEmail;
  }

  @override
  void initState() {
    super.initState();
    ambil_data();
  }

  Future<void> ambil_data() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user?.providerData[0]?.providerId == 'google.com') {
      try {
        QuerySnapshot eklinikSnapshot = await FirebaseFirestore.instance
            .collection(Database.getCollection())
            .where('email', isEqualTo: user!.email)
            .get();

        if (eklinikSnapshot.docs.isNotEmpty) {
          // Mengambil data dari eklinikSnapshot dan mengatur state
          setState(() {
            nama = eklinikSnapshot.docs[0]['nama'] ?? '';
            nomerRekamMedis = eklinikSnapshot.docs[0]['nomerRekamMedis'] ?? '';
            alamat = eklinikSnapshot.docs[0]['alamat'] ?? '';
          });

          // Set nilai controller
          namaController.text = nama;
          nomerRekamMedisController.text = nomerRekamMedis;
          alamatController.text = alamat;
        } else {
          print('Dokumen tidak ditemukan');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Data tidak ditemukan.'),
          ));
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Terjadi kesalahan dalam mengambil data: $e'),
        ));
      }
    } else {
      try {
        QuerySnapshot eklinikSnapshot = await FirebaseFirestore.instance
            .collection(Database.getCollection())
            .where('email', isEqualTo: email2)
            .get();

        if (eklinikSnapshot.docs.isNotEmpty) {
          // Mengambil data dari eklinikSnapshot dan mengatur state
          setState(() {
            nama = eklinikSnapshot.docs[0]['nama'] ?? '';
            nomerRekamMedis = eklinikSnapshot.docs[0]['nomerRekamMedis'] ?? '';
            alamat = eklinikSnapshot.docs[0]['alamat'] ?? '';
          });

          // Set nilai controller
          namaController.text = nama;
          nomerRekamMedisController.text = nomerRekamMedis;
          alamatController.text = alamat;
        } else {
          print('Dokumen tidak ditemukan');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Data tidak ditemukan.'),
          ));
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Terjadi kesalahan dalam mengambil data: $e'),
        ));
      }
    }
  }

  DateTime _selectedDate = DateTime.now();
  String _selectedPenjamin = 'penjamin';
  final CheckupController checkupController = Get.put(CheckupController());
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nomerRekamMedisController =
      TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController tanggalReservasiController =
      TextEditingController();

  Future<void> _selectPenjamin(BuildContext context) async {
    final String picked = await showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 200.0,
          child: Column(
            children: [
              ListTile(
                title: Text('Bpjs'),
                onTap: () {
                  Navigator.pop(context, 'Bpjs');
                },
              ),
              ListTile(
                title: Text('ktp'),
                onTap: () {
                  Navigator.pop(context, 'ktp');
                },
              ),
            ],
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedPenjamin = picked;
      });
    }
  }

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
                    right: 40.0,
                  ),
                  child: Text(
                    'Checkup',
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
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 30),
                  child: Center(
                    child: Text(
                        'Cek kembali kelengkapan data anda sebelum melakukan reservasi',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 69, 128, 177),
                        )),
                  ),
                ),
                SizedBox(height: 20),
                _buildTextField('Nama Lengkap', '$nama ', namaController),
                SizedBox(height: 20),
                _buildTextField('Nomer Rekam Medis', '$nomerRekamMedis',
                    nomerRekamMedisController,
                    isReadOnly: true),
                SizedBox(height: 20),
                _buildTextField('Alamat', '$alamat', alamatController),
                SizedBox(height: 20),
                _buildDatePickerField(
                    'Tanggal reservasi', tanggalReservasiController),
                SizedBox(height: 20),
                _buildPenjaminField('penjamin'),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      // Access the values using text editing controllers
                      String nama = namaController.text;
                      print(nama);
                      String nomerRekamMedis = nomerRekamMedisController.text;
                      String alamat = alamatController.text;
                      String tanggalReservasi = tanggalReservasiController
                              .text.isEmpty
                          ? DateTime.now().toLocal().toString().split(' ')[0]
                          : tanggalReservasiController.text;
                      String penjamin = _selectedPenjamin;

                      if (nama.isEmpty || alamat.isEmpty) {
                        // Lakukan sesuatu jika nama atau alamat kosong
                        print("Nama dan alamat harus diisi!");
                      } else {
                        // Check if Penjamin is selected
                        if (penjamin == 'penjamin') {
                          // Show an alert or take any other action to inform the user
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Error'),
                                content:
                                    Text('Please select a value for Penjamin.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                          return;
                        }

                        // Trigger the update when the "Submit" button is clicked
                        checkupController.updateEklinikData(
                          nama,
                          nomerRekamMedis,
                          alamat,
                          tanggalReservasi,
                          penjamin,
                        );
                      }
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

  _buildTextField(String label, String hint, TextEditingController controller,
      {bool isReadOnly = false}) {
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
          readOnly: label == 'Nomer Rekam Medis' ? true : isReadOnly,
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

  Widget _buildDatePickerField(String label, TextEditingController controller) {
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
            // You can add a date picker here and update the controller's text
            showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime(2101),
            ).then((value) {
              if (value != null) {
                setState(() {
                  _selectedDate = value;
                  controller.text =
                      _selectedDate.toLocal().toString().split(' ')[0];
                });
              }
            });
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

  Widget _buildPenjaminField(String label) {
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
            _selectPenjamin(context);
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
                      _selectedPenjamin,
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
}
