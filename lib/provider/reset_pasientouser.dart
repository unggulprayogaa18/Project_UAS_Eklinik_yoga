import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_klinik_dr_h_m_chalim/provider/collection.dart';

class ResetController extends GetxController {
  Future<void> updateEklinikData(int queueNumber) async {
    try {
      // Fetch the document with the given queueNumber
      QuerySnapshot eklinikSnapshot = await FirebaseFirestore.instance
          .collection(Database.getCollection())
          .where('nomer_antrian', isEqualTo: queueNumber)
          .get();

      // Check if there's any document found
      if (eklinikSnapshot.docs.isNotEmpty) {
        // Get the first document (assuming there's only one with the given queue number)
        QueryDocumentSnapshot document = eklinikSnapshot.docs.first;
        DocumentReference eklinikRef = document.reference;

        // Prepare data to update
        Map<String, dynamic> dataToUpdate = {
          'status': 'user',
          'status_antrian': 'selesai',
          'tanggal_jam_selesai': Timestamp.now(), // Use Firestore timestamp
          // Remove unnecessary fields
          // 'nomer_antrian': FieldValue.delete(),
          // 'jam_berakhir': FieldValue.delete(),
          // 'jam_antrian': FieldValue.delete(),
          // 'tanggalReservasi': FieldValue.delete(),
          // 'status_janji': FieldValue.delete(),
          'penjamin': FieldValue.delete(),
          // 'tanggal_daftar': FieldValue.delete(),
        };

        // Update the document
        await eklinikRef.update(dataToUpdate);

        print('Data berhasil direset');
      } else {
        print('Dokumen dengan nomer antrian $queueNumber tidak ditemukan');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}
