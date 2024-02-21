import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_klinik_dr_h_m_chalim/widgets/get/nomerRekamMedis.dart';
import 'package:get/get.dart';
import 'package:e_klinik_dr_h_m_chalim/provider/collection.dart';
import 'package:intl/intl.dart';

class DetailRekamMedisController extends GetxController {
  final obatController = TextEditingController();
  final keluhanController = TextEditingController();

  List<TextEditingController> obatControllers = []; // Define obatControllers here

  void fetchDataAndSaveToFirestore(
      {required List<String> obats, required String keluhan}) async {
    try {
      final nomerRekamMedis = NomerRekamMedis.getnomerRekamMedis();

      if (nomerRekamMedis != null) {
        // Ambil data nama dari database berdasarkan nomer rekam medis
        QuerySnapshot eklinikSnapshot = await FirebaseFirestore.instance
            .collection(Database.getCollection())
            .where('nomerRekamMedis', isEqualTo: nomerRekamMedis)
            .get();

        if (eklinikSnapshot.docs.isNotEmpty) {
          // Ambil data nama dari dokumen pertama
          String nama = eklinikSnapshot.docs.first.get('nama');

          // Format tanggal saat ini sesuai dengan "yyyy-MM-dd"
          String tanggalMedis = DateTime.now().toString().substring(0, 10);

          // Format waktu saat ini sesuai dengan "HH:mm"
          String jam = DateFormat.Hm().format(DateTime.now());

          // Buat dokumen baru dengan data yang diberikan
          await FirebaseFirestore.instance
              .collection('Rekam_medis_pasien')
              .doc('rekam_medis : $nama')
              .set({
            'nomerRekamMedis': nomerRekamMedis,
            'obat': obats,
            'keluhan': keluhan,
            'nama': nama,
            'tanggal_medis': tanggalMedis,
            'jam': jam, // Tanggal medis sesuai format "yyyy-MM-dd"
          });

          // Bersihkan controller setelah data disimpan
          obatControllers.forEach((controller) => controller.clear());
          keluhanController.clear();

          // Tampilkan pesan sukses jika berhasil
          Get.snackbar(
            'Success',
            'Data berhasil disimpan',
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.snackbar(
            'Error',
            'Nama tidak ditemukan',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Nomor Rekam Medis tidak ditemukan',
          snackPosition: SnackPosition.BOTTOM,
        );
        return; // Kembalikan dari fungsi jika nomor rekam medis tidak ditemukan
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $error',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    // Pastikan untuk membersihkan controller saat tidak digunakan lagi
    obatController.dispose();
    keluhanController.dispose();
    super.onClose();
  }
}
