import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:noteapp/utils/models/groupChatModel.dart';

class Groupchatservices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
      final    List<Map<String,dynamic>> members = [];


Future<void> sendMessagetoGroup(String groupId, String message) async {
  final String currentUserId = _auth.currentUser!.uid;
  final String? currentUserEmail = _auth.currentUser!.email;
  final Timestamp timestamp = Timestamp.now();

 
  groupMessageModel newMessage = groupMessageModel(
    senderId: currentUserId,
    senderEmail: currentUserEmail!,
    message: message,
    timestamp: timestamp,
    messageType: "Text",
  );

  await _firestore
    .collection("Group_Chats")
    .doc(groupId)
    .collection("Messages")
    .add(newMessage.toMap());
}



 // Groupchatservices.dart
static Future<List<Map<String, dynamic>>> getMemberDetails(List<String> memberIds) async {
  final memberDetails = <Map<String, dynamic>>[];

  for (var id in memberIds) {
    final doc = await FirebaseFirestore.instance.collection('Users').doc(id).get();
    if (doc.exists) {
      memberDetails.add(doc.data() as Map<String, dynamic>);
    }
  }

  return memberDetails;
}
  // Kullanıcı bilgilerini alma
  Future<DocumentSnapshot> getUserInfo(String userId) async {
    return await _firestore.collection('Users').doc(userId).get();
  }

  Stream<QuerySnapshot> getGroupMessagesIfAuthorized(String groupId, String currentUserId) async* {
  DocumentSnapshot groupDoc = await _firestore.collection('Group_Chats').doc(groupId).get();

  if (groupDoc.exists) {
  
    String founderId = groupDoc['founder'];

    if (founderId == currentUserId) {
      yield* getGroupMessages(groupId);
    } else {
      DocumentSnapshot memberDoc = await _firestore
          .collection('Group_Chats')
          .doc(groupId)
          .collection('Members')
          .doc(currentUserId)
          .get();

      if (memberDoc.exists) {
        yield* getGroupMessages(groupId);
      } else {
        yield* Stream.error('You are not authorized to view messages in this group.');
      }
    }
  } else {
    yield* Stream.error('Group does not exist.');
  }
}

Stream<QuerySnapshot> getGroupMessages(String groupId) {
  return _firestore
      .collection('Group_Chats')
      .doc(groupId)
      .collection('Messages')
      .orderBy('timestamp', descending: false)
      .snapshots();
}

}