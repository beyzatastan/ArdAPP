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


    final ChatRef = FirebaseFirestore.instance.collection("Chats").doc(chatRoomId);
        await ChatRef.set({
        "createdAt": Timestamp.now(),
        "senderId":FirebaseAuth.instance.currentUser!.uid,
        "receierId":receiverId
        
      });

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
Stream<List<Map<String, dynamic>>> getUsersWithLastMessagesStream(String currentUserId) {
  return _firestore.collection("Chats").snapshots().asyncMap((chatRoomsSnapshot) async {
    List<Map<String, dynamic>> usersWithMessages = [];

    print("Chat rooms snapshot: ${chatRoomsSnapshot.docs.length} documents found.");

    if (chatRoomsSnapshot.docs.isEmpty) {
      print("No chat rooms found.");
      return usersWithMessages;
    }

    for (var chatRoomDoc in chatRoomsSnapshot.docs) {
      String chatRoomId = chatRoomDoc.id;
      List<String> ids = chatRoomId.split("_");

      if (ids.contains(currentUserId)) {
        print("Processing chat room ID: $chatRoomId");
        
        Map<String, dynamic> userData = {};

        // Other user ID
        String otherUserId = ids.firstWhere((id) => id != currentUserId);
        DocumentSnapshot otherUserDoc = await _firestore.collection('Users').doc(otherUserId).get();

        if (otherUserDoc.exists) {
          userData['id'] = otherUserId;
          userData['name'] = otherUserDoc.get('name') ?? 'Unknown';
          userData['picture'] = otherUserDoc.get('picture') ?? '';
        } else {
          userData['id'] = otherUserId;
          userData['name'] = 'Unknown';
          userData['picture'] = '';
        }

        // Fetch the last message from the Messages collection
        QuerySnapshot messagesSnapshot = await _firestore
            .collection('Chats')
            .doc(chatRoomId)
            .collection('Messages')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        if (messagesSnapshot.docs.isNotEmpty) {
          DocumentSnapshot lastMessageDoc = messagesSnapshot.docs.first;
          Map<String, dynamic> lastMessageData = lastMessageDoc.data() as Map<String, dynamic>;
          userData['message'] = lastMessageData['message'] ?? 'No message';
          userData['timestamp'] = (lastMessageData['timestamp'] as Timestamp?);
      
        } else {
          userData['message'] = 'No message';
        }

        usersWithMessages.add(userData);
      }
    }

    print("Users with messages: $usersWithMessages");
    return usersWithMessages;
  }).handleError((error) {
    print("Error fetching data: $error");
    return []; // Hata durumunda boş liste döndür
  });
}

Stream<List<Map<String, dynamic>>> getGroupsWithChatHistory(String currentUserId) {
  return _firestore.collection('Group_Chats').snapshots().asyncMap((snapshot) async {
    List<Map<String, dynamic>> groups = [];

    for (var groupDoc in snapshot.docs) {
      String groupId = groupDoc.id;
      Map<String, dynamic> groupData = groupDoc.data() ;

      // Kurucu kimliğini kontrol edelim
      String founderId = groupData['founder'];

      if (founderId == currentUserId) {
        // Kullanıcı kurucu ise grubu ekle
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
      } else {
        // Kullanıcı kurucu değilse, üyelik durumunu kontrol edelim
        DocumentSnapshot memberDoc = await _firestore
            .collection('Group_Chats')
            .doc(groupId)
            .collection('Members')
            .doc(currentUserId)
            .get();

        if (memberDoc.exists) {
          QuerySnapshot membersSnapshot = await _firestore
              .collection('Group_Chats')
              .doc(groupId)
              .collection('Members')
              .get();

          List<Map<String, dynamic>> members = membersSnapshot.docs.map((memberDoc) {
            return memberDoc.data() as Map<String, dynamic>;
          }).toList();

        
        }

      }

         QuerySnapshot messagesSnapshot = await _firestore
            .collection('Group_Chats')
            .doc(groupId)
            .collection('Messages')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        if (messagesSnapshot.docs.isNotEmpty) {
          DocumentSnapshot lastMessageDoc = messagesSnapshot.docs.first;
          Map<String, dynamic> lastMessageData = lastMessageDoc.data() as Map<String, dynamic>;
          groupData['message'] = lastMessageData['message'] ?? 'No message';
          groupData['timestamp'] = (lastMessageData['timestamp'] as Timestamp?);
      
        } else {
          groupData['message'] = 'No message';
          groupData['timestamp'] = (groupData["createdAt"]);
        }
    }

    print(groups);
    return groups;
  }).handleError((error) {
    print("Error fetching data: $error");
    return []; // Hata durumunda boş liste döndür
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