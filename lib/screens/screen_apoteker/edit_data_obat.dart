import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_apoteker/home_apoteker.dart';
import 'package:get/get.dart'; // Import GetX

class EditObat extends StatefulWidget {
  final String? idObat = Get.parameters['idObat'];

  @override
  _EditObatState createState() => _EditObatState();
}

class _EditObatState extends State<EditObat> {
  late TextEditingController namaController;
  late TextEditingController kategoriController;
  late TextEditingController hargaController;
  late TextEditingController stockController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    namaController = TextEditingController();
    kategoriController = TextEditingController();
    hargaController = TextEditingController();
    stockController = TextEditingController();

    // Load data obat based on idObat
    loadDataObat();
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    namaController.dispose();
    kategoriController.dispose();
    hargaController.dispose();
    stockController.dispose();
    super.dispose();
  }

  Future<void> loadDataObat() async {
    try {
      // Get the document reference of the obat based on idObat
      QuerySnapshot obatSnapshot = await FirebaseFirestore.instance
          .collection('db_obat')
          .where('id_obat', isEqualTo: widget.idObat)
          .get();

      // Check if the snapshot contains any data
      if (obatSnapshot.docs.isNotEmpty) {
        // Get the first document
        DocumentSnapshot obatDoc = obatSnapshot.docs.first;

        // Get the data from the document snapshot
        Map<String, dynamic>? obatData =
            obatDoc.data() as Map<String, dynamic>?;

        // Set the controller values with the retrieved data
        if (obatData != null) {
          namaController.text = obatData['nama_obat'] ?? '';
          kategoriController.text = obatData['kategori'] ?? '';
          hargaController.text = obatData['harga'] ?? '';
          stockController.text = obatData['stok'] ?? '';
        }
      } else {
        // Handle if no matching document is found
        print('No matching document found for idObat: ${widget.idObat}');
      }
    } catch (error) {
      // Handle errors
      print('Error loading data: $error');
    }
  }

  Future<void> saveData() async {
    try {
      // Update data obat berdasarkan idObat
      await FirebaseFirestore.instance
          .collection('db_obat')
          .where('id_obat', isEqualTo: widget.idObat)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          querySnapshot.docs.first.reference.update({
            'nama_obat': namaController.text,
            'kategori': kategoriController.text,
            'harga': hargaController.text,
            'stok': stockController.text,
          }).then((_) {
            // Tampilkan dialog sukses
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Success'),
                  content: Text('Data obat berhasil diupdate.'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          });
        } else {
          // Handle jika tidak ada dokumen yang sesuai
          print('No matching document found for idObat: ${widget.idObat}');
        }
      });
    } catch (error) {
      // Tampilkan dialog error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Terjadi kesalahan saat mengupdate data.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
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
                  Icon(
                    Icons.arrow_back_ios,
                    size: 30,
                    color: Color.fromARGB(255, 69, 128, 177),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: 40.0,
                  ),
                  child: Text(
                    'Edit data obat',
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
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nama obat'),
                  TextField(
                    controller: namaController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintText: 'Masukkan Nama Obat',
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Kategori Obat'),
                  TextField(
                    controller: kategoriController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintText: 'Masukkan Kategori Obat',
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Harga Obat'),
                  TextField(
                    controller: hargaController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintText: 'Masukkan Harga Obat',
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Stock Obat'),
                  TextField(
                    controller: stockController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintText: 'Masukkan Stock Obat',
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30),
              child: ElevatedButton(
                onPressed: saveData,
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Container(
                  width: double.infinity,
                  child: Center(
                    child: Text('Simpan'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
