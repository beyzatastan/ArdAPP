import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:noteapp/utils/models/messageModel.dart';

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
Future<void> sendMessage(String receiverId, message) async {
    final String currentUserId = _auth.currentUser!.uid;
    final String? currentUserEmail = _auth.currentUser!.email;
    final Timestamp timestamp = Timestamp.now();

    // Belgeye receiverId eklemek için yapılandırılmış bir Map oluştur
  Map<String, dynamic> receiverData = {
    'receiverId': receiverId,
    'timestamp': timestamp, // Opsiyonel, belgenin oluşturulma zamanını tutmak isteyebilirsiniz
  };

  // Receivers koleksiyonuna veri ekleme
  await _firestore.collection("Receivers").doc(receiverId).set(receiverData);

  
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
        .collection("Chats")
        .doc(chatRoomId)
        .collection("Messages")
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userId, otheUserId) {
    List<String> ids = [userId, otheUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firestore
        .collection("Chats")
        .doc(chatRoomId)
        .collection("Messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

 Stream<List<Map<String, dynamic>>> getUsersWithChatHistory() {
  return _firestore.collection('Receivers').snapshots().asyncMap((snapshot) async {
    // Kullanıcı ID'lerini toplama
    List<String> userIds = snapshot.docs.map((doc) {
      return doc['receiverId'] as String; // receiverId'yi döndür
    }).toList();

    // Kullanıcı bilgilerini almak için bir liste oluştur
    List<Map<String, dynamic>> users = [];

    // Kullanıcı ID'lerini kullanarak `Users` koleksiyonundan bilgileri al
    for (String userId in userIds) {
      DocumentSnapshot userDoc = await _firestore.collection('Users').doc(userId).get();
      if (userDoc.exists) {
        users.add(userDoc.data() as Map<String, dynamic>);
      }
    }

    return users;
  });
}
Future<String> getLastMessage(String chatId) async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection("Chats")
        .doc(chatId)
        .collection("Messages")
        .orderBy("timestamp", descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.data()['message'] ?? 'No message';
    } else {
      return 'No message';
    }
  } catch (e) {
    print("Error getting last message: $e");
    return 'Error';
  }
}

}