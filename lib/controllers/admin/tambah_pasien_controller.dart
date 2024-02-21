import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:e_klinik_dr_h_m_chalim/provider/collection.dart';
import 'package:flutter/material.dart';

class TambahPasienController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxBool isLoading = false.obs;

  Future<String> _generateNewId() async {
    QuerySnapshot idUserSnapshot = await _firestore
        .collection(Database.getCollection())
        .where('id_user', isEqualTo: 'id001')
        .get();

    if (idUserSnapshot.docs.isNotEmpty) {
      // Jika ID sudah ada, cari ID yang belum terpakai dan kembalikan
      int suffix = 1;
      String newId = 'id001';

      while (true) {
        newId = 'id' + suffix.toString().padLeft(3, '0');
        QuerySnapshot existingIdSnapshot = await _firestore
            .collection(Database.getCollection())
            .where('id_user', isEqualTo: newId)
            .get();

        if (existingIdSnapshot.docs.isEmpty) {
          // ID belum terpakai
          break;
        }

        suffix++;
      }

      return newId;
    } else {
      // Jika ID belum ada, langsung gunakan 'id001'
      return 'id001';
    }
  }

  Future<String> _generateNomerRekamMedis() async {
    QuerySnapshot idUserSnapshot = await _firestore
        .collection(Database.getCollection())
        .where('nomerRekamMedis', isEqualTo: 'Kmts.pa.001')
        .get();

    if (idUserSnapshot.docs.isNotEmpty) {
      // Jika ID sudah ada, cari ID yang belum terpakai dan kembalikan
      int suffix = 1;
      String rekam_medis = 'Kmts.pa.001';

      while (true) {
        rekam_medis = 'Kmts.pa.' + suffix.toString().padLeft(3, '0');
        QuerySnapshot existingIdSnapshot = await _firestore
            .collection(Database.getCollection())
            .where('nomerRekamMedis', isEqualTo: rekam_medis)
            .get();

        if (existingIdSnapshot.docs.isEmpty) {
          // ID belum terpakai
          break;
        }

        suffix++;
      }

      return rekam_medis;
    } else {
      // Jika ID belum ada, langsung gunakan 'id001'
      return 'Kmts.pa.001';
    }
  }

  Future<void> sendRegistrationData({
    required String nama,
    required DateTime selectedDate,
    required String selectedGender,
    required String alamat,
    required String nomertelpon,
    required String email,
    required String password,
  }) async {
    try {
      isLoading(true);

      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }

      var registrationData = {
        'nama': nama,
        'tanggal_lahir': selectedDate.toLocal().toString().split(' ')[0],
        'jenis_kelamin': selectedGender,
        'alamat': alamat,
        'no_telpon': nomertelpon,
        'email': email,
        'password': password,
        'status': 'user',
        'status_janji': 'belum_janji',
      };

      // Validasi email dan password (contoh: minimal 6 karakter)
      if (email.isEmpty || password.length < 6) {
        print('Email or password is not valid.');
         Get.defaultDialog(
          title: 'Erorr',
          content: Text(
              'Email or password is not valid.'),
          confirm: TextButton(
            onPressed: () {
              // Tutup dialog saat tombol ditekan
              Get.back();
            },
            child: Text('OK'),
          ),
        );
        return;
      }

      // Cek apakah email sudah terdaftar
      final userSnapshot = await FirebaseFirestore.instance
          .collection(Database.getCollection())
          .where('email', isEqualTo: registrationData['email'])
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        print('Email is already registered.');
         Get.defaultDialog(
          title: 'Erorr',
          content: Text(
              'email sudah terdaftar'),
          confirm: TextButton(
            onPressed: () {
              // Tutup dialog saat tombol ditekan
              Get.back();
            },
            child: Text('OK'),
          ),
        );
        return;
      }

      // Register user using Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: registrationData['email'] ?? '',
        password: registrationData['password'] ?? '',
      );

      String newId = await _generateNewId();
      String rekam_medis = await _generateNomerRekamMedis();
      // Add user data to Firestore
      await _firestore
          .collection(Database.getCollection())
          .doc('user: ${nama}')
          .set({
        'nomerRekamMedis': rekam_medis,
        'id_user': newId,
        'nama': registrationData['nama'],
        'tanggal_lahir': registrationData['tanggal_lahir'],
        'jenis_kelamin': registrationData['jenis_kelamin'],
        'alamat': registrationData['alamat'],
        'no_telpon': registrationData['no_telpon'],
        'email': registrationData['email'],
        'password': registrationData['password'],
        'status': registrationData['status'],
        'status_janji': registrationData['status_janji'],
      });

      print('User registered successfully.');
      Get.offNamed('/adminadataregistrasi');
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false);
    }
  }
}
