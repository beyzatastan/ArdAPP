import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';

Widget backButton(BuildContext context, Widget screen) {
  return IconButton(
    icon: const Icon(Icons.arrow_back_ios),
    onPressed: () {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => screen),
        (Route<dynamic> route) => false,
      );
    },
  );
}
Widget optionsButton({
  required String name,
  required IconData icon,
  required BuildContext context,
  required Widget screen,
}) {
  return ElevatedButton(
    onPressed: () {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => screen),
        (Route<dynamic> route) => false,
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: HexColor(buttonBackground),
      foregroundColor: HexColor(buttoncolor),
      minimumSize: const Size(200, 170),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 60,
        ),
        const SizedBox(height: 20), // Space between icon and text
        Text(
          name,
          style: const TextStyle(fontFamily: "Inter", fontSize: 30),
        ),
      ],
    ),
  );
}
Widget textField(TextEditingController controller,
   String hintText,){
  return TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: hintText,
                      hintStyle: TextStyle(color: HexColor(noteColor)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: HexColor(noteColor), width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor(buttonBackground)))));
               
}

Widget textFieldFull(TextEditingController controller){
  return TextField(
                  controller: controller,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintStyle: TextStyle(color: HexColor(noteColor)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: HexColor(noteColor), width: 1)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: HexColor(buttonBackground)))));
               
}Widget searchField(Function(String) func,String hinttext) {
  return TextField(
    decoration: InputDecoration(
      fillColor: Colors.white,
      filled: true,
      hintText: hinttext,
      contentPadding: const EdgeInsets.only(left: 15, bottom: 8),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: HexColor(noteColor),
          width: 1.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.grey.withOpacity(0.5),
          width: 1,
        ),
      ),
    ),
    onChanged: (value) {
      func(value); 
    },
  );
}

/*
  Widget _buildGroupList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _chatServices.getGroupsWithChatHistory(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 50,
                  color: Colors.grey,
                ),
                const SizedBox(height: 10),
                const Text(
                  "No groups found",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: const Text(
                    "You can create a new group by using the add button",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
final groups = snapshot.data!;
return ListView(
  children: groups.map<Widget>((groupData) {
    // groupData'ya erişim sağlayan doğru anahtarları kullanın
    final groupInfo = groupData['groupData'] as Map<String, dynamic>;
    final groupPicture = groupInfo['groupPicture'] ?? '';
    final groupName = groupInfo['groupName'] ?? 'No Name';
    final groupDesc = groupInfo['groupDesc'] ?? 'No Description';

    return ListTile(
      leading: groupPicture.isNotEmpty
          ? SizedBox(
              width: 50, // Genişliği sınırlayın
              height: 50, // Yüksekliği sınırlayın
              child:ClipOval(
                child: Image.network(
                groupPicture,
                fit: BoxFit.cover, // Resmi kutuya sığdırmak için
                errorBuilder: (context, error, stackTrace) {
                  // Resim yüklenirken hata varsa burada göster
                  return Icon(Icons.error);
                },
              ),
              )
            )
          : Icon(Icons.group),
      title: Text(groupName,style: TextStyle(fontFamily: "Inter"),),
      subtitle: Text(groupDesc),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Groupconvoscreen(
              groupId: groupData['groupId'],
              groupName: groupName,
              members: (groupData['members'] as List<Map<String, dynamic>>)
                  .map((member) => member['memberId'] as String)
                  .toList(),
            ),
          ),
        );
      },
    );
  }).toList(),
);


      },
    );
  }

//build a list of users except current user
  Widget _buildUserList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _chatServices.getUsersWithChatHistory(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: (MainAxisAlignment.center),
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 50,
                  color: Colors.grey,
                ),
                const SizedBox(height: 10),
                const Text(
                  "No users found",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: const Text(
                    "You can start a new conversation by using the add button",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        final users = snapshot.data!;
        return ListView(
          children: users.map<Widget>((userData) {
            if (userData["email"] != getCurrentUser()!.email) {
              List<String> ids = [getCurrentUser()!.uid, userData["id"]];
              ids.sort();
              String chatRoomId = ids.join("_");
              return FutureBuilder<String>(
                future: _chatServices.getLastMessage(chatRoomId),
                builder: (context, messageSnapshot) {
                  if (!messageSnapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return UserTile(
                    text: userData["name"],
                    profile: userData["picture"],
                    chatId: chatRoomId,
                    receiverId: userData["id"],
                    lastMessage: messageSnapshot.data!,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Convosscreen(
                            receiverName: userData["name"],
                            receiverId: userData["id"],
                          ),
                        ),
                      );
                    },
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
*/