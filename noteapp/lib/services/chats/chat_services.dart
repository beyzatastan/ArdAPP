import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:noteapp/messageModel.dart';

class ChatServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Kullanıcıları almak için stream
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection('Users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  //send message
  Future<void> sendMessage(String receiverId, message) async {
    final String currentUserId = _auth.currentUser!.uid;
    final String? currentUserEmail = _auth.currentUser!.email;
    final Timestamp timestamp = Timestamp.now();

//creaate new message
    Messagemodel newMessage = Messagemodel(
        senderId: currentUserId,
        senderEmail: currentUserEmail!,
        receiverId: receiverId,
        message: message,
        timestamp: timestamp);
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");
    await _firestore
        .collection("Chat_Rooms")
        .doc(chatRoomId)
        .collection("Messages")
        .add(newMessage.toMap());
  }
  //get message

  Stream<QuerySnapshot> getMessages(String userId, otheUserId) {
    List<String> ids = [userId, otheUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firestore
        .collection("Chat_Rooms")
        .doc(chatRoomId)
        .collection("Messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
