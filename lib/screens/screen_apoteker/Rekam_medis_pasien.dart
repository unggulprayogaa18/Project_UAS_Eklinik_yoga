import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_klinik_dr_h_m_chalim/widgets/get/nomerRekamMedis.dart';
import 'package:get/get.dart';
import 'package:e_klinik_dr_h_m_chalim/provider/collection.dart';

class TampilRekamMedis extends StatefulWidget {
  @override
  _TampilRekamMedisState createState() => _TampilRekamMedisState();
}

class _TampilRekamMedisState extends State<TampilRekamMedis> {
  String data = NomerRekamMedis.getnomerRekamMedis();
  List<TextEditingController> obatControllers = [];
  int obatControllerIndex = 0;
  TextEditingController keluhanController = TextEditingController();
  List<String> obats = [];
  List<Widget> resepObatTextFields = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            shape: Border(
              top: BorderSide(
                color: Color.fromARGB(36, 116, 115, 115),
                width: 2.0,
              ),
              bottom: BorderSide(
                color: Color.fromARGB(36, 116, 115, 115),
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
                    Get.offNamed('/homeapoteker');
                  },
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(right: 40.0),
                      child: Text(
                        'Detail Data Pasien',
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
          builder: (context, eklinikSnapshot) {
            if (eklinikSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!eklinikSnapshot.hasData ||
                eklinikSnapshot.data == null ||
                eklinikSnapshot.data!.docs.isEmpty) {
              return Center(child: Text('Data belum dibuat id pasien $data'));
            }

            var eklinikData = eklinikSnapshot.data!.docs.first.data()
                as Map<String, dynamic>?;

            if (eklinikData == null) {
              return Center(child: Text('Dokter belum membuat sesi'));
            }

            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Rekam_medis_pasien')
                  .where('nomerRekamMedis', isEqualTo: data)
                  .snapshots(),
              builder: (context, rekamMedisSnapshot) {
                if (rekamMedisSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!rekamMedisSnapshot.hasData ||
                    rekamMedisSnapshot.data == null ||
                    rekamMedisSnapshot.data!.docs.isEmpty) {
                  return Center(
                      child: Text(
                    'Dokter belum membuat sesi',
                    style: TextStyle(fontSize: 20),
                  ));
                }

                var rekamMedisData = rekamMedisSnapshot.data!.docs.first.data()
                    as Map<String, dynamic>?;

                if (rekamMedisData == null) {
                  return Center(
                      child: Text(
                    'Dokter belum membuat sesi',
                    style: TextStyle(fontSize: 20),
                  ));
                }

                // Clear the existing resepObatTextFields list before rebuilding it
                resepObatTextFields.clear();
                obats.clear();

                // Initialize obatControllers and obats from rekamMedisData
                obatControllers.clear();
                for (var obat in rekamMedisData['obat'] ?? []) {
                  obats.add(obat);
                  obatControllers.add(TextEditingController(text: obat));
                }

                // Iterate through each obat in the array and add a TextField for it
                for (var obat in obats) {
                  addTextField(obat);
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: CircleAvatar(
                              radius: 50,
                              // Your avatar image goes here
                            ),
                          ),
                          SizedBox(width: 30),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'No. Rekam Medis: ${eklinikData['nomerRekamMedis']}'),
                                Text('Nama Pasien: ${eklinikData['nama']}'),
                                Text(
                                    'Tgl. Lahir: ${eklinikData['tanggal_lahir']}'),
                                Text('Jenis Kelamin: Perempuan'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Container(
                        width: 400,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 29, 96, 151),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle button1 click
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.transparent,
                            elevation: 0,
                          ),
                          child: Text(
                            'Catatan pasien',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        child: Column(
                          children: [
                            Container(
                              height: 100,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                maxLines: null,
                                enabled: false,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(8),
                                  border: InputBorder.none,
                                  hintText: '${rekamMedisData['keluhan']}',
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              width: 400,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 29, 96, 151),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  addTextField('');
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent,
                                  elevation: 0,
                                ),
                                child: Text(
                                  'resep obat',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Column(
                              children: resepObatTextFields,
                            ),
                            SizedBox(height: 10),
                            Visibility(
                              child: Container(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.offNamed('/listdataoba2t');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Color.fromARGB(255, 46, 79, 105),
                                    onPrimary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ).copyWith(
                                    minimumSize: MaterialStateProperty.all(
                                        Size(350, 50)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text('Buat Obat'),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void addTextField(String obat) {
    TextEditingController newObatController = TextEditingController(text: obat);
    obatControllers.add(newObatController);
    obatControllerIndex++;

    resepObatTextFields.add(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: newObatController,
                maxLines: null,
                enabled: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  border: OutlineInputBorder(),
                  hintText: 'Type here...',
                ),
                onChanged: (value) {
                  // Update data obat saat nilai TextField berubah
                  obats[obatControllerIndex - 1] = value;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void removeTextField(int index) {
    setState(() {
      obatControllers.removeAt(index - 1);
      resepObatTextFields.removeAt(index - 1);
      obats.removeAt(index - 1);
      obatControllerIndex--;
    });
  }
}
