import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX

void main() {
  runApp(MaterialApp(
    home: DetailResep(),
  ));
}

class DetailResep extends StatelessWidget {
  final List<String> dataList = [];
  int jumlahsubtotal = 0; // Total subtotal dari semua item

  @override
  Widget build(BuildContext context) {
    final List<String> incomingDataList = Get.arguments;

    Set<String> uniqueData = Set(); // Using a Set to store unique items

    Map<String, int> idObatToTotalQuantity = {};
    Map<String, int> idObatToTotalSubtotal = {};

    jumlahsubtotal = 0; // Reset jumlahsubtotal sebelum memproses setiap item

    for (var data in incomingDataList) {
      List<String> splitData = data.split(',');
      String idObat = splitData[0];
      String namaObat = splitData[1];
      int harga = int.tryParse(splitData[2]) ?? 0;
      int quantity = int.tryParse(splitData[3]) ?? 0;
      int subtotal = int.tryParse(splitData[4]) ?? 0;
      jumlahsubtotal += subtotal; // Tambahkan subtotal item ke jumlahsubtotal

      String uniqueItem = '$idObat,$namaObat,$quantity,$harga,$subtotal';
      uniqueData.add(uniqueItem); // Add each unique item to the set
    }

    dataList.clear(); // Clear the dataList
    dataList.addAll(uniqueData); // Add unique items back to the dataList
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
                Get.offNamed('/listdataoba2t');
              },
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: 40.0,
                  ),
                  child: Text(
                    'Detail Resep',
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
      body: Container(
        constraints: BoxConstraints(maxHeight: 400),
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(255, 75, 75, 75)),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nama Pasien',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Yoga Prayoga',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Tanggal',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '02/22/23',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: dataList.map((item) {
                      List<String> splitData = item.split(',');
                      return buildListDataItem(
                        splitData[1], // Nama Obat
                        int.parse(splitData[2]), // Quantity
                        int.parse(splitData[3]), // Harga
                        int.parse(splitData[4]), // Subtotal
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    'Rp.$jumlahsubtotal',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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

  Widget buildListDataItem(
    String namaObat,
    int quantity,
    int harga,
    int subtotal,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: const Color.fromARGB(255, 58, 58, 58))),
      ),
      padding: EdgeInsets.symmetric(vertical: 19),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            namaObat,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            quantity.toString(),
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            harga.toString(),
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            subtotal.toString(),
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
