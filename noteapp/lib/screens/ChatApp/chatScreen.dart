import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';
import 'package:noteapp/screens/ChatApp/searchScreen.dart';
import 'package:noteapp/screens/login/optionScreen.dart';
import 'package:noteapp/utils/services/chats/chat_services.dart';
import 'package:noteapp/widgets/widgets.dart';
import 'package:rxdart/rxdart.dart';

class Chatscreen extends StatefulWidget {
  const Chatscreen({super.key});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  // Chat & Auth Services
  final ChatServices _chatServices = ChatServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(backgroundColor),
      appBar: AppBar(
        leading: backButton(context, Optionscreen()),
        backgroundColor: HexColor(backgroundColor),
        title: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Chats",
              style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Searchscreen(
                          usersStream: _chatServices.getUsersStream())));
                },
                color: HexColor(buttonBackground),
                icon: const Icon(
                  Icons.add_circle_outline_sharp,
                  size: 30,
                ),
              ),
            ]),
          )
        ],
      ),
      body: _buildCombinedList(),
    );
  }Widget _buildCombinedList() {
  return StreamBuilder<List<Map<String, dynamic>>>(
    stream: Rx.combineLatest2(
      _chatServices.getGroupsWithChatHistory(),
      _chatServices.getUsersWithChatHistory(),
      (List<Map<String, dynamic>> groups, List<Map<String, dynamic>> users) {
        List<Map<String, dynamic>> combinedList = [];

        combinedList.addAll(groups.map((group) {
          Timestamp timestamp = group['groupData']['createdAt'];
          return {
            'type': 'group',
            'data': group,
            'timestamp': timestamp.toDate()
          };
        }).toList());

        combinedList.addAll(users.map((user) {
          // Kullanıcılar için gerçek bir timestamp'e ihtiyaç var.
          // Örneğin, kullanıcıların en son mesajlarının zamanını kullanabilirsiniz.
          return {
            'type': 'user',
            'data': user,
            'timestamp': DateTime.now() // Burayı güncel bir timestamp ile değiştirmelisiniz.
          };
        }).toList());

        // Kullanıcıların timestamp'ını doğru bir değerle güncelleyiniz.
        // Burada varsayılan olarak güncel zamanı kullanmak yerine,
        // gerçek bir timestamp ile değiştirilmesi önerilir.

        combinedList.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
        return combinedList;
      }
    ),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text("Error: ${snapshot.error}");
      }
      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Center(child: Text("No data available"));
      }

      final combinedList = snapshot.data!;
      return ListView(
        children: combinedList.map<Widget>((item) {
          if (item['type'] == 'group') {
            final groupData = item['data'] as Map<String, dynamic>;
            final groupPicture = groupData['groupData']['groupPicture'] ?? '';
            final groupName = groupData['groupData']['groupName'] ?? 'No Name';
            final groupDesc = groupData['groupData']['groupDesc'] ?? 'No Description';

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  groupPicture.isNotEmpty
                      ? SizedBox(
                          width: 60,
                          height: 60,
                          child: ClipOval(
                            child: Image.network(
                              groupPicture,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.error);
                              },
                            ),
                          ),
                        )
                      : Icon(Icons.group, size: 50),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          groupName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          groupDesc,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 15
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (item['type'] == 'user') {
            final userData = item['data'] as Map<String, dynamic>;
            final chatRoomId = [getCurrentUser()!.uid, userData["id"]].join("_");
            return FutureBuilder<String>(
              future: _chatServices.getLastMessage(chatRoomId),
              builder: (context, messageSnapshot) {
                if (!messageSnapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Row(
                    children: [
                      userData["picture"] != null
                          ? SizedBox(
                              width: 60,
                              height: 60,
                              child: ClipOval(
                                child: Image.network(
                                  userData["picture"],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.error);
                                  },
                                ),
                              ),
                            )
                          : Icon(Icons.person, size: 50),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userData["name"],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              messageSnapshot.data!,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 15
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Container();
          }
        }).toList(),
      );
    },
  );
}
}