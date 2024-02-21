import 'package:e_klinik_dr_h_m_chalim/screens/screen_admin/home_admin.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:e_klinik_dr_h_m_chalim/provider/collection.dart';

class ListDataPage extends StatefulWidget {
  @override
  _ListDataPageState createState() => _ListDataPageState();
}

class _ListDataPageState extends State<ListDataPage> {
  late TextEditingController _searchController;
  late List<QueryDocumentSnapshot> _searchResult = [];
  late List<QueryDocumentSnapshot> _allDocuments = []; // Tambahkan variabel ini untuk menyimpan semua dokumen

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
    _fetchData(); // Panggil fungsi untuk mengambil data dari Firestore
  }

  Future<void> _fetchData() async {
    // Ambil data dari Firestore dan simpan dalam variabel _allDocuments
    QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection(Database.getCollection())
      .where('status', whereIn: ['pasien', 'user'])
      .get();
    setState(() {
      _allDocuments = snapshot.docs;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String searchText = _searchController.text.toLowerCase();
    setState(() {
      _searchResult = searchText.isEmpty
          ? [] // Jika tidak ada teks pencarian, kosongkan hasil pencarian
          : _allDocuments.where((document) {
              // Filter dokumen berdasarkan teks pencarian
              String title = document['nama'].toString().toLowerCase();
              return title.contains(searchText);
            }).toList();
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
                    'List data registrasi',
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
      body: Column(
        children: [
          // Search input
          buildSearchInput(),
          SizedBox(height: 16),
          // Build article containers from search result
          buildArticleContainers(_searchResult.isNotEmpty ? _searchResult : _allDocuments),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 62, 134, 194),
        onPressed: () async {
          Get.offNamed('/load');
          await Future.delayed(Duration(seconds: 2));
          Get.offNamed('/tambahPasien');
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Set border radius here
          side: BorderSide(
              color: Color.fromARGB(
                  255, 68, 143, 194)), // Optional: Set border color
        ),
        child: Icon(Icons.add, color: const Color.fromARGB(255, 255, 255, 255)),
      ),
    );
  }

  Widget buildSearchInput() {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: Colors.blue,
          ),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController, // Hubungkan TextField dengan TextEditingController
              decoration: InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildArticleContainers(List<QueryDocumentSnapshot> documents) {
    return Expanded(
      child: ListView.builder(
        itemCount: documents.length,
        itemBuilder: (context, index) {
          DocumentSnapshot document = documents[index];
          return buildArticleContainer(
            document['nama'],
            document['nomerRekamMedis'],
            document['jenis_kelamin'],
          );
        },
      ),
    );
  }

  Widget buildArticleContainer(
    String title,
    String subtitle,
    String jenisKelamin,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 145, 191, 218),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 78, 127, 167),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 78, 127, 167),
                    ),
                  ),
                  Text(
                    jenisKelamin,
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 78, 127, 167),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
