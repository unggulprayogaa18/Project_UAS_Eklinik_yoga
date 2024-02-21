import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_klinik_dr_h_m_chalim/provider/collection.dart';

class GetDataController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<Map<String, dynamic>> eklinikDataList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    // Load data when the controller is initialized
    fetchData();
    super.onInit();
  }

  Future<void> fetchData() async {
    try {
      isLoading(true);

      // Fetch specific fields ('nik', 'nama', and others) from Firestore
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection(Database.getCollection()).get();

      // Clear previous data
      eklinikDataList.clear();

      // Add fetched data to the list
      querySnapshot.docs.forEach((doc) {
        var data = {
          'nik': doc['nik'],
          'nama': doc['nama'],
          // Add more fields as needed
        };
        eklinikDataList.add(data);
      });

      print('Data loaded successfully.');
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }
}
