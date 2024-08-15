import 'package:cloud_firestore/cloud_firestore.dart';


class ChatServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  // Kullanıcıları almak için stream
  Stream<List<Map<String, dynamic>>> getUsersStream() {

    return _firestore.collection('Users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return doc.data(); 
      }).toList();
    });
  }
}
