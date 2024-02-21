import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_klinik_dr_h_m_chalim/provider/collection.dart';

 class UserGoogle {
   
 Future<DocumentSnapshot> getUserDataGoogle() async {
    final User? user = FirebaseAuth.instance.currentUser;
    print('nama user : $user');
    return FirebaseFirestore.instance
        .collection(Database.getCollection())
        .where('email', isEqualTo: user!.email)
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
 