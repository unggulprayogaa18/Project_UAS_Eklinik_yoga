import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_klinik_dr_h_m_chalim/widgets/get/useremail.dart';
import 'package:e_klinik_dr_h_m_chalim/provider/collection.dart';
import 'package:flutter/material.dart';

class CheckupController extends GetxController {
  RxString email = RxString('');
  int antriannomer = 0;

  void setEmail(String newEmail) {
    email.value = newEmail;
  }

  Future<void> updateEklinikData(
    String nama,
    String nomerRekamMedis,
    String alamat,
    String tanggalReservasi,
    String penjamin,
  ) async {
    try {
      DateTime now = DateTime.now();
      DateTime jam_berakhir;
      DateTime startTime;
      DateTime endTime;

      if (now.weekday >= 1 && now.weekday <= 5) {
        startTime = DateTime(now.year, now.month, now.day, 8, 0);
        endTime = DateTime(now.year, now.month, now.day, 20, 0);
        print('senin dan jumaat');
      } else {
        startTime = DateTime(now.year, now.month, now.day, 9, 0);
        endTime = DateTime(now.year, now.month, now.day, 20, 0);
        print('sabtu dan minggu');
      }
      // Mendapatkan jam sekarang dalam format yang diinginkan
      DateTime nowTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(now.toLocal().toString().substring(11, 13)),
        int.parse(now.toLocal().toString().substring(14, 16)),
      );
      if (now.isBefore(startTime) || now.isAfter(endTime)) {
        Get.defaultDialog(
          title: 'Sukses',
          content: Text(
              'Pendaftaran hanya dapat dilakukan antara jam 8 pagi hingga 8 malam'),
          confirm: TextButton(
            onPressed: () {
              // Tutup dialog saat tombol ditekan
              Get.back();
            },
            child: Text('OK'),
          ),
        );
      } else {
        // Menentukan jam berakhir berdasarkan jam sekarang + 1 jam
        DateTime tambahSatuJam = now.add(Duration(hours: 1));
        jam_berakhir = tambahSatuJam;

        // Membuat referensi user saat ini
        User? user = FirebaseAuth.instance.currentUser;
        String emailuser = SimpanEmail.getEmail();

        // Fungsi untuk melakukan pengecekan dan update data pada koleksi e-klinik
        Future<void> updateEklinikDataCommon(
            QuerySnapshot eklinikSnapshot) async {
          for (QueryDocumentSnapshot document in eklinikSnapshot.docs) {
            DocumentReference eklinikRef = document.reference;

            // Mengatur slot waktu yang tersedia dengan memeriksa jika sudah ada pendaftar pada jam tersebut
            DateTime availableSlotStart = jam_berakhir;
            DateTime availableSlotEnd =
                availableSlotStart.add(Duration(hours: 1));

            QuerySnapshot existingEntryStart = await FirebaseFirestore.instance
                .collection(Database.getCollection())
                .where('jam_antrian',
                    isGreaterThanOrEqualTo: availableSlotStart
                        .toLocal()
                        .toString()
                        .substring(11, 16))
                .get();

            QuerySnapshot existingEntryEnd = await FirebaseFirestore.instance
                .collection(Database.getCollection())
                .where('jam_berakhir',
                    isLessThanOrEqualTo:
                        availableSlotEnd.toLocal().toString().substring(11, 16))
                .get();

            // Menggabungkan dua hasil query menjadi satu list dokumen
            Set<DocumentSnapshot> existingEntries = Set<DocumentSnapshot>.from([
              ...existingEntryStart.docs,
              ...existingEntryEnd.docs,
            ]);

            if (existingEntries.isNotEmpty) {
              // Jika sudah ada pendaftar pada jam tersebut, atur slot waktu berikutnya
              availableSlotStart = availableSlotEnd;
              availableSlotEnd = availableSlotStart.add(Duration(hours: 1));
            }

            // Mendapatkan tanggal sekarang dalam format yang diinginkan
            String date =
                "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

            // Data yang akan diperbarui pada koleksi e-klinik
            Map<String, dynamic> dataToUpdate = {
              'jam_berakhir':
                  availableSlotEnd.toLocal().toString().substring(11, 16),
              'jam_antrian':
                  availableSlotStart.toLocal().toString().substring(11, 16),
              'nomer_antrian': await buildNomerAntrian(tanggalReservasi),
              'nomerRekamMedis': nomerRekamMedis,
              'tanggalReservasi': tanggalReservasi,
              'penjamin': penjamin,
              'status': 'pasien',
              'status_antrian': 'menunggu',
              'status_janji': 'sedang_janji',
              'tanggal_daftar': date, // Tanggal sekarang
            };

            // Memperbarui data pada koleksi e-klinik
            await eklinikRef.update(dataToUpdate);

            Get.defaultDialog(
              title: 'Sukses',
              content: Text('Data berhasil disimpan silahkan login kembali'),
              confirm: TextButton(
                onPressed: () {
                  // Tutup dialog saat tombol ditekan
                  Get.back();
                },
                child: Text('OK'),
              ),
            );

            break;
          }
        }

        if (user?.providerData[0]?.providerId == 'google.com') {
          // Jika user belum login, gunakan email yang tersimpan
          // Jika tidak ada email yang tersimpan, gunakan email dari user yang login
          QuerySnapshot eklinikSnapshot = await FirebaseFirestore.instance
              .collection(Database.getCollection())
              .where('email', isEqualTo: user!.email)
              .get();

          await updateEklinikDataCommon(eklinikSnapshot);
        } else {
          QuerySnapshot eklinikSnapshot = await FirebaseFirestore.instance
              .collection(Database.getCollection())
              .where('email', isEqualTo: emailuser)
              .get();

          await updateEklinikDataCommon(eklinikSnapshot);
        }
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<int> buildNomerAntrian(String tanggalReservasi) async {
    final User? user = FirebaseAuth.instance.currentUser;

    QuerySnapshot eklinikSnapshot;
    if (user?.providerData[0]?.providerId == 'google.com') {
      eklinikSnapshot = await FirebaseFirestore.instance
          .collection(Database.getCollection())
          .get();
    } else {
      eklinikSnapshot = await FirebaseFirestore.instance
          .collection(Database.getCollection())
          .get();
    }

    int nomerAntrian;

    if (eklinikSnapshot.docs.isEmpty) {
      // Jika tidak ada data, nomor antrian dimulai dari 1
      nomerAntrian = 1;
    } else {
      List<int> existingNomerAntrianList = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> document
          in eklinikSnapshot.docs
              .cast<QueryDocumentSnapshot<Map<String, dynamic>>>()) {
        Map<String, dynamic>? data = document.data();
        if (data != null &&
            data.containsKey('nomer_antrian') &&
            data['tanggalReservasi'] == tanggalReservasi) {
          existingNomerAntrianList.add(data['nomer_antrian']);
        }
      }

      if (existingNomerAntrianList.isEmpty) {
        // Jika tidak ada nomor antrian pada tanggal reservasi tertentu, nomor antrian dimulai dari 1
        nomerAntrian = 1;
      } else {
        // Jika ada nomor antrian pada tanggal reservasi tertentu, cari nomor antrian yang belum digunakan secara berurutan
        int maxNomerAntrian = existingNomerAntrianList
            .reduce((value, element) => value > element ? value : element);
        nomerAntrian = maxNomerAntrian + 1;
      }
    }

    return nomerAntrian;
  }
}
