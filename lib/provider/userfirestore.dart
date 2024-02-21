import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_klinik_dr_h_m_chalim/widgets/get/useremail.dart';
import 'package:e_klinik_dr_h_m_chalim/provider/collection.dart';
 class UserFirestore {
   
  Future<DocumentSnapshot> getUserData() async {
    String email = SimpanEmail.getEmail();

    return FirebaseFirestore.instance
        .collection(Database.getCollection())
        .where('email', isEqualTo: email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs[0];
      } else {
        throw 'User data not found in Firestore.';
      }
    });
  }

 }
 