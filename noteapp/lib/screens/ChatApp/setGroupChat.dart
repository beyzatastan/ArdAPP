import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noteapp/extensions/colors.dart';
import 'package:noteapp/screens/ChatApp/groupConvoScreen.dart';
import 'package:noteapp/utils/services/chats/groupChatServices.dart';
import 'package:noteapp/widgets/widgets.dart';

class Setgroupchat extends StatefulWidget {
  final List<Map<String, dynamic>> chatRoomMemberIds;
  const Setgroupchat({super.key, required this.chatRoomMemberIds});

  @override
  State<Setgroupchat> createState() => _SetgroupchatState();
}

class _SetgroupchatState extends State<Setgroupchat> {
  TextEditingController groupName = TextEditingController();
  TextEditingController groupDesc = TextEditingController();
    File? _imageFile; // Seçilen resim dosyası
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    groupName.dispose();
    groupDesc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(backgroundColor),
      appBar: AppBar(
        backgroundColor: HexColor(backgroundColor),
        title: Text(
          "Group Chat",
          style: TextStyle(
              fontFamily: "Inter", fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
          child: Column(
            children: [
              Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: HexColor(noteColor),
                    ),
                    child: _imageFile == null
                        ? IconButton(
                            onPressed: _pickImage,
                            icon: Icon(
                              Icons.add_a_photo,
                              color: Colors.white,
                              size: 40.0,
                            ),
                          )
                        : ClipOval(
                            child: Image.file(
                              _imageFile!,
                              fit: BoxFit.cover,
                              width: 130,
                              height: 130,
                            ),
                          ),
                  ),
                  SizedBox(height: 40,),
              textField(groupName, "Group Name..."),
              SizedBox(
                height: 20,
              ),
              textField(groupDesc, "Group Description"),
              SizedBox(
                height: 40,
              ),
              Text(
                "Members",
                style: TextStyle(fontFamily: "Inter", fontSize: 20),
              ),
              SizedBox(
                height: 30,
              ),
              if (widget.chatRoomMemberIds.isNotEmpty)
                Container(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.chatRoomMemberIds.length,
                    itemBuilder: (context, index) {
                      final member = widget.chatRoomMemberIds[index];
                      return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.black,
                                    backgroundImage:
                                        member["picture"] != null &&
                                                member["picture"].isNotEmpty
                                            ? NetworkImage(member["picture"])
                                            : const AssetImage(
                                                    'assets/images/1024.png')
                                                as ImageProvider,
                                                
                                    radius: 30,
                                  ),
                                  Positioned(
                                    top: -19,
                                    right: -18,
                                    child: IconButton(
                                      icon: Icon(Icons.close,
                                          size: 18,
                                          color: HexColor(buttonBackground)),
                                      onPressed: () {
                                        setState(() {
                                          widget.chatRoomMemberIds
                                              .remove(member);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                member["name"],
                                style: const TextStyle(
                                  fontFamily: "Inter",
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                            ],
                          )
                          ); 
                    },
                  ),
                ),
              if (widget.chatRoomMemberIds.isEmpty)
                Text(
                  "No member found!",
                  style: TextStyle(),
                ),
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () async {
                  final memberIds = widget.chatRoomMemberIds.map((member) => member['id'] as String).toList();
                  memberIds..add(FirebaseAuth.instance.currentUser!.uid);
                  print('Selected Member IDs: $memberIds');

                  final groupId = await createGroupFirebase(widget
                      .chatRoomMemberIds
                      .map((member) => member['id'] as String)
                      .toList());

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => Groupconvoscreen(
                        groupName: groupName.text,
                        members: memberIds,
                        groupId: groupId,
                        groupDesc: groupDesc.text,
                      ),
                    ),
                    (Route<dynamic> route) => false,
                    
                  );
                   print('Selected group IDs: $groupId');
                    print('Selected Member IDs: $memberIds');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: HexColor(buttonBackground),
                  foregroundColor: HexColor(buttoncolor),
                  minimumSize: const Size(227, 63),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  "Create Group",
                  style: TextStyle(fontFamily: "Inter", fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
 Future<String> createGroupFirebase(List<String> memberIds) async {
    final groupChatRef = FirebaseFirestore.instance.collection("Group_Chats").doc();
    final groupId = groupChatRef.id;

    try {
      final memberDetails = await Groupchatservices.getMemberDetails(memberIds);
String? profilePictureUrl;
      if (_imageFile != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_pictures')
            .child(groupId + '.jpg');

        await storageRef.putFile(_imageFile!);
        profilePictureUrl = await storageRef.getDownloadURL();
      }
      await groupChatRef.set({
        "createdAt": Timestamp.now(),
        "groupName":groupName.text,
        "groupId":groupId,
        "groupDesc":groupDesc.text,
        "groupPicture":profilePictureUrl,
        "founder":FirebaseAuth.instance.currentUser!.uid
        
      });

      for (var member in memberDetails) {
        await groupChatRef.collection("Members").doc(member['id']).set({
          "memberId": member['id'],
          "memberName": member["name"],
          "groupId":groupId
        });
      }

      return groupId;
    } catch (e) {
      print("Error creating group: $e");
      rethrow;
    }
  }
   Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }
}

