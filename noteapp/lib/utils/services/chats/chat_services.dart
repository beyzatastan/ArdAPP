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
        timestamp: timestamp,
        messageType: "Text");
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
    List<String> userIds = snapshot.docs.map((doc) {
      return doc['receiverId'] as String;
    }).toList();

    List<Map<String, dynamic>> users = [];


    for (String userId in userIds) {
      DocumentSnapshot userDoc = await _firestore.collection('Users').doc(userId).get();
      if (userDoc.exists) {
        users.add(userDoc.data() as Map<String, dynamic>);
      }
    }

    return users;
  });
}
Stream<List<Map<String, dynamic>>> getGroupsWithChatHistory() {
  return _firestore.collection('Group_Chats').snapshots().asyncMap((snapshot) async {
    List<String> groupIds = snapshot.docs.map((doc) => doc.id).toList();
    List<Map<String, dynamic>> groups = [];

    for (String groupId in groupIds) {
      DocumentSnapshot groupDoc = await _firestore.collection('Group_Chats').doc(groupId).get();
      if (groupDoc.exists) {
        Map<String, dynamic> groupData = groupDoc.data() as Map<String, dynamic>;

        QuerySnapshot membersSnapshot = await _firestore
            .collection('Group_Chats')
            .doc(groupId)
            .collection('Members')
            .get();

        List<Map<String, dynamic>> members = membersSnapshot.docs.map((memberDoc) {
          return memberDoc.data() as Map<String, dynamic>;
        }).toList();

        groups.add({
          'groupId': groupId,
          'groupData': groupData,
          'members': members,
        });
      }
    }
    print(groups);  // Debug: Print the groups data to check
    return groups;
  });
}

Future<String?> getgroupLastMessage(String chatId) async {
  try {
    QuerySnapshot messagesSnapshot = await _firestore
        .collection('Group_Chats')
        .doc(chatId)
        .collection('Messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (messagesSnapshot.docs.isNotEmpty) {
      var lastMessage = messagesSnapshot.docs.first.data() as Map<String, dynamic>;
      return lastMessage['text'] as String?;
    }
    return null;
  } catch (e) {
    print("Error fetching last message: $e");
    return null;
  }
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
/*
Future<void> createGroupChat(String groupName) async{
 final user = _auth.currentUser;
 if(user==null){
  throw Exception("try login");
 }
 final now = DateTime.now();
 final id =now.toString();
 final selectedMembers = ref.read(selectedGroupMembersProvider);

 final chatRooms = ChatRooms{
  id:id,chatr
 }
}
List<String> _memberIds(User user,List<AppUser?> selectedMembers){
  List<String> ids=[user.uid];
  for(var member in selectedMembers){
    if(member != null && !ids.contains(member.uid)){
      ids.add(member.uid);
    }
  }
  return{...ids}.toList();
}
Future<void> addChatRoomMember(ChatRoom chatroom,AppUser appuser) async{
  
} */
}