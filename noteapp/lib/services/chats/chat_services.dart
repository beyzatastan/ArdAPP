import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:noteapp/models/message.dart';

class ChatServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Kullanıcıları almak için stream
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection('Users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return doc.data(); 
      }).toList();
    });
  }

  // Mesaj göndermek için fonksiyon
  Future<void> sendMessages(String receiverId, String message) async {
  final String currentUserId = _auth.currentUser!.uid;
  final String currentUserEmail = _auth.currentUser!.email!;
  final Timestamp timestamp = Timestamp.now();

  Message newMessage = Message(
    senderID: currentUserId, 
    senderName: currentUserEmail, 
    receiverID: receiverId, 
    message: message, 
    timestamp: timestamp
  );

  List<String> ids = [currentUserId, receiverId];
  ids.sort();
  String chatroomId = ids.join("_");

  try {
    // chat_rooms koleksiyonunda yeni bir belge oluştur
    await _firestore.collection("chat_rooms").doc(chatroomId).set({
      'lastMessage': message,
      'lastMessageTime': timestamp,
      'participants': [currentUserId, receiverId]
    }, SetOptions(merge: true));

    // Mesajı messages alt koleksiyonuna ekle
    await _firestore.collection("chat_rooms")
      .doc(chatroomId)
      .collection("messages")
      .add(newMessage.toMap());

    print("Message sent successfully");
  } catch (e) {
    print("Error sending message: $e");
  }
}

  // Mesajları getirmek için fonksiyon
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore.collection("chat_rooms")
      .doc(chatRoomId)
      .collection("messages")
      .orderBy("timestamp", descending: false)
      .snapshots();
  }
  
  Stream<List<Map<String, dynamic>>> getChatRoomsStream() {
  return _firestore.collection('chat_rooms').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      return doc.data() as Map<String, dynamic>;
    }).toList();
  });
}

}
