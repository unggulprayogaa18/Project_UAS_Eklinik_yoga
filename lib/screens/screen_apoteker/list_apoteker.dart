import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ListApoteker extends StatelessWidget {
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
                // Navigasi menggunakan GetX
                Get.offAllNamed('/homeApoteker');
              },
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: 40.0,
                  ),
                  child: Text(
                    'List Data Obat',
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('db_obat').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data found'));
          } else {
            List<Widget> listItems = [];
            snapshot.data!.docs.forEach((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              listItems.add(buildGridItem(
                '${data['id_obat'] ?? ''}',
                '${data['nama_obat'] ?? ''}',
                'Kategori : ${data['kategori'] ?? ''} ',
                'Stok     : ${data['stok'] ?? ''}',
                'Rp. ${data['harga'] ?? ''} /btl',
                context,
              ));
            });
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: listItems,
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 69, 128, 177),
        onPressed: () {
          // Navigasi menggunakan GetX
          Get.offNamed('/TambahDataObat');
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget buildGridItem(
    String id_obat,
    String namaobat,
    String kategori,
    String stock,
    String harga,
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.blue, // Set the border color to blue
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
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  namaobat,
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
                padding: const EdgeInsets.only(right: 20.0),
                child: Text(
                  id_obat,
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
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              kategori,
              style: TextStyle(
                color: Color.fromARGB(255, 77, 147, 194),
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              stock,
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
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  harga,
                  style: TextStyle(
                    color: Color.fromARGB(255, 77, 147, 194),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Row(
                  children: [
                    Container(
                      height: 35,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.edit, color: Colors.white),
                        onPressed: () {
                          // Navigasi menggunakan GetX dan mengirimkan ID obat
                          Get.toNamed('/editDataObat', arguments: id_obat);
                        },
                      ),
                    ),
                    SizedBox(width: 8), // Add some space between the buttons
                    Container(
                      height: 35,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.delete, color: Colors.white),
                        onPressed: () {
                          // Add your onPressed logic for the delete button here
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
