import 'package:e_klinik_dr_h_m_chalim/screens/screen_apoteker/home_apoteker.dart';
import 'package:e_klinik_dr_h_m_chalim/screens/screen_apoteker/list_resep_pasien.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart'; // Import GetX

class ListDataObat extends StatefulWidget {
  @override
  _ListDataObatState createState() => _ListDataObatState();
}

class _ListDataObatState extends State<ListDataObat> {
  Map<String, int> values = {}; // Store values for each item
  List<String> dataList = [];

  Future<void> updateStok(String idObat, int newStock) async {
    try {
      // Menggunakan metode where() untuk mencari dokumen dengan id_obat yang cocok
      var querySnapshot = await FirebaseFirestore.instance
          .collection('db_obat')
          .where('id_obat', isEqualTo: idObat)
          .get();

      // Memeriksa apakah dokumen ditemukan
      if (querySnapshot.docs.isNotEmpty) {
        // Mengambil referensi dokumen pertama yang cocok dengan id_obat
        var documentReference = querySnapshot.docs.first.reference;

        // Memperbarui nilai stok di dokumen tersebut
        await documentReference.update({'stock': newStock});
      } else {
        // Jika dokumen tidak ditemukan, cetak pesan kesalahan
        print('Document not found for ID: $idObat');
      }
    } catch (e) {
      // Menangani kesalahan ketika memperbarui stok
      print('Error updating stock: $e');
    }
  }

  void incrementValue(String idObat, int stok) {
    setState(() {
      int currentValue = values[idObat] ?? 0;
      if (currentValue < stok) {
        values[idObat] = currentValue + 1;
        // updateStok(idObat, stok - 1); // Kurangi stok di Firestore
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Stok untuk item ini telah mencapai batas.'),
          ),
        );
      }
    });
  }

  void decrementValue(String idObat, int stok) {
    setState(() {
      int currentValue = values[idObat] ?? 0;
      if (currentValue > 0) {
        values[idObat] = currentValue - 1;
        // updateStok(idObat, stok + 1); // Menambahkan stok di Firestore
      }
    });
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
                      color: Color.fromARGB(255, 78, 127, 167),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                // Navigasi kembali
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ListResepPasien()),
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
                    'Kunjungan',
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('db_obat').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data found'));
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(20.0),
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      String idObat = data['id_obat'] ?? '';
                      var harga = data['harga']; // Ambil harga dari data

                      // Validasi tipe data harga
                      if (harga is int) {
                        // Harga adalah integer, lanjutkan seperti biasa
                        int currentValue = values[idObat] ?? 0;
                        return buildGridItem(
                          idObat,
                          '${data['nama_obat'] ?? ''}',
                          'Kategori : ${data['kategori'] ?? ''} ',
                          'Stok         : ${data['stock'] ?? ''}',
                          'Rp. ${harga ?? ''} /btl', // Gunakan harga yang telah diambil dari data
                          currentValue,
                          context,
                          () => incrementValue(idObat, data['stock']),
                          () => decrementValue(idObat, data['stock']),
                        );
                      } else {
                        // Tangani kasus di mana harga bukan integer
                        return SizedBox(); // Misalnya, Anda dapat mengembalikan widget kosong atau widget yang sesuai dengan kasus tersebut
                      }
                    }).toList(),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.blue),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              color: Color.fromARGB(255, 77, 147, 194),
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          FutureBuilder<int>(
                            future: calculateTotal(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text(
                                  'Loading...', // Menampilkan pesan 'Loading...' selama Future sedang berjalan
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 77, 147, 194),
                                    fontSize: 18,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                  ),
                                );
                              } else {
                                if (snapshot.hasError) {
                                  return Text(
                                    'Error: ${snapshot.error}', // Menampilkan pesan error jika terjadi kesalahan
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 77, 147, 194),
                                      fontSize: 18,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  );
                                } else {
                                  return Text(
                                    'Rp. ${snapshot.data}',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 77, 147, 194),
                                      fontSize: 18,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              dataList
                                  .clear(); // Membersihkan dataList sebelum menambahkan data baru
                              await calculateTotal(); // Menghitung total sebelum navigasi

                              // Membuat ID acak untuk dokumen baru
                              String documentId = FirebaseFirestore.instance
                                  .collection('data_keluar')
                                  .doc()
                                  .id;

                              // Menyiapkan data yang akan disimpan
                              Map<String, dynamic> newData = {
                                'dataList': dataList,
                                'total': await calculateTotal(),
                                'timestamp': FieldValue
                                    .serverTimestamp(), // Menambahkan timestamp server
                              };

                              // Menyimpan data ke Firestore
                              await FirebaseFirestore.instance
                                  .collection('data_keluar')
                                  .doc(documentId)
                                  .set(newData);

                              // Panggil updateStok untuk setiap item yang ada di values
                              for (var entry in values.entries) {
                                String idObat = entry.key;
                                int stok = await getStockById(
                                    idObat); // Dapatkan stok saat ini
                                updateStok(
                                    idObat,
                                    stok -
                                        entry
                                            .value); // Kurangi stok di Firestore
                              }

                              Get.offNamed('/detailResep',
                                  arguments:
                                      dataList); // Navigasi ke halaman selanjutnya sambil mengirimkan dataList
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 46, 79, 105),
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ).copyWith(
                              minimumSize:
                                  MaterialStateProperty.all(Size(350, 50)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text('checkout'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget buildGridItem(
    String noantrian,
    String namaPasien,
    String waktuReservasi,
    String tanggalDaftar,
    String no_pasien,
    int value,
    BuildContext context,
    VoidCallback onIncrement,
    VoidCallback onDecrement,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.blue,
        ),
      ),
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  namaPasien,
                  style: TextStyle(
                    color: Color.fromARGB(255, 77, 147, 194),
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 45),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Text(
                  noantrian,
                  style: TextStyle(
                    color: Color.fromARGB(255, 77, 147, 194),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  waktuReservasi,
                  style: TextStyle(
                    color: Color.fromARGB(255, 77, 147, 194),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
                child: Container(
                  padding: EdgeInsets.all(1.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: onIncrement,
                        child: Icon(Icons.add, size: 15.0),
                      ),
                      Text(
                        '$value',
                        style: TextStyle(fontSize: 13.0),
                      ),
                      ElevatedButton(
                        onPressed: onDecrement,
                        child: Icon(Icons.remove, size: 15.0),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              tanggalDaftar,
              style: TextStyle(
                color: Color.fromARGB(255, 77, 147, 194),
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Image.asset(
            'assets/icon2/Line36.png',
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  no_pasien,
                  style: TextStyle(
                    color: Color.fromARGB(255, 77, 147, 194),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<int> calculateTotal() async {
    int total = 0;
    Map<String, int> idObatToTotalQuantity = {};
    Map<String, int> idObatToTotalSubtotal = {};

    for (var entry in values.entries) {
      String idObat = entry.key;
      int quantity = entry.value;
      int harga = await getHargaById(idObat);
      int subtotal = quantity * harga;
      total += subtotal;

      // Menyimpan jumlah dan subtotal untuk setiap ID obat
      if (idObatToTotalQuantity.containsKey(idObat)) {
        idObatToTotalQuantity[idObat] =
            (idObatToTotalQuantity[idObat] ?? 0) + quantity;
        idObatToTotalSubtotal[idObat] =
            (idObatToTotalSubtotal[idObat] ?? 0) + subtotal;
      } else {
        idObatToTotalQuantity[idObat] = quantity;
        idObatToTotalSubtotal[idObat] = subtotal;
      }
    }

    // Membersihkan dataList sebelum menambahkan data baru
    dataList.clear();

    // Filter data dan sum quantities dan subtotals
    for (var idObat in idObatToTotalQuantity.keys) {
      String namaObat = await getNamaObatById(idObat);
      int quantity = idObatToTotalQuantity[idObat]!;
      int harga = await getHargaById(idObat);
      int subtotal = idObatToTotalSubtotal[idObat]!;

      // Menambahkan data yang sudah difilter ke dataList
      String newData = '$idObat,$namaObat,$quantity,$harga,$subtotal';
      dataList.add(newData);
    }

    return total;
  }

  Future<int> getHargaById(String idObat) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('db_obat')
          .where('id_obat', isEqualTo: idObat)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Jika dokumen ditemukan, ambil harga dari dokumen pertama
        var harga = querySnapshot.docs.first.data()['harga'] ?? 0;
        return harga;
      } else {
        // Jika dokumen tidak ditemukan, kembalikan harga default
        return 0;
      }
    } catch (e) {
      // Tangani kesalahan jika terjadi
      print('Error fetching harga: $e');
      return 0; // Kembalikan harga default jika terjadi kesalahan
    }
  }

  Future<String> getNamaObatById(String idObat) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('db_obat')
          .where('id_obat', isEqualTo: idObat)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Jika dokumen ditemukan, ambil nama obat dari dokumen pertama
        var namaObat = querySnapshot.docs.first.data()['nama_obat'] ?? '';
        return namaObat;
      } else {
        // Jika dokumen tidak ditemukan, kembalikan string kosong
        return '';
      }
    } catch (e) {
      // Tangani kesalahan jika terjadi
      print('Error fetching nama obat: $e');
      return ''; // Kembalikan string kosong jika terjadi kesalahan
    }
  }
  Future<int> getStockById(String idObat) async {
  try {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('db_obat')
        .where('id_obat', isEqualTo: idObat)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Jika dokumen ditemukan, ambil stok dari dokumen pertama
      var stock = querySnapshot.docs.first.data()['stock'] ?? 0;
      return stock;
    } else {
      // Jika dokumen tidak ditemukan, kembalikan stok default
      return 0;
    }
  } catch (e) {
    // Tangani kesalahan jika terjadi
    print('Error fetching stock: $e');
    return 0; // Kembalikan stok default jika terjadi kesalahan
  }
}

}
