import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_apoteker/home_apoteker.dart';
import 'package:get/get.dart';

class TambahDataObat extends StatefulWidget {
  @override
  _TambahDataObatState createState() => _TambahDataObatState();
}

class _TambahDataObatState extends State<TambahDataObat> {
  TextEditingController namaController = TextEditingController();
  TextEditingController kategoriController = TextEditingController();
  TextEditingController hargaController = TextEditingController();
  TextEditingController stockController = TextEditingController();

  Future<String> _generateNewId() async {
    QuerySnapshot idUserSnapshot = await FirebaseFirestore.instance
        .collection('db_obat')
        .orderBy('id_obat', descending: true)
        .limit(1)
        .get();

    String? newId;
    if (idUserSnapshot.docs.isNotEmpty) {
      String lastId = idUserSnapshot.docs.first['id_obat'];
      int? lastSuffix = int.tryParse(lastId.substring(6));

      if (lastSuffix != null) {
        int nextSuffix = lastSuffix + 1;
        newId = 'aptk.A' + nextSuffix.toString().padLeft(3, '0');
      }
    } else {
      newId = 'aptk.A001';
    }

    return newId ??
        'aptk.A001'; // Default ID jika tidak ditemukan ID sebelumnya
  }

  Future<void> saveData() async {
    try {
      String newId = await _generateNewId();

      // Konversi harga dan stok ke tipe data int
      int harga = int.parse(hargaController.text);
      int stok = int.parse(stockController.text);

      await FirebaseFirestore.instance.collection('db_obat').add({
        'id_obat': newId,
        'nama_obat': namaController.text,
        'kategori': kategoriController.text,
        'harga': harga, // Simpan harga sebagai angka (number)
        'stok': stok, // Simpan stok sebagai angka (number)
      });

      namaController.clear();
      kategoriController.clear();
      hargaController.clear();
      stockController.clear();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Data obat berhasil disimpan.'),
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
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Terjadi kesalahan saat menyimpan data.'),
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
                Get.offNamed('/Listapoteker');
              },
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: 40.0,
                  ),
                  child: Text(
                    'Tambah data obat',
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
