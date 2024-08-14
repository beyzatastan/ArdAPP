import 'package:cloud_firestore/cloud_firestore.dart';

class NoteServices {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;


  //get notes
Stream<List<Map<String, dynamic>>> getUsersStream() {
  return _firebaseFirestore.collection('Notes').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      return doc.data(); 
    }).toList();
  });
}
}