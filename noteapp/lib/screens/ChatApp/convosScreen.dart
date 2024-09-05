import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noteapp/extensions/colors.dart';
import 'package:noteapp/screens/ChatApp/chatScreen.dart';
import 'package:noteapp/utils/services/chats/chat_services.dart';
import 'package:noteapp/utils/services/chats/display_message.dart';
import 'package:noteapp/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

class Convosscreen extends StatefulWidget {
  const Convosscreen(
      {super.key, required this.receiverName, required this.receiverId});
  final String receiverName;
  final String receiverId;

  @override
  State<Convosscreen> createState() => _ConvosscreenState();
}

class _ConvosscreenState extends State<Convosscreen> {
  final TextEditingController messageCont = TextEditingController();
  final ChatServices _chatServices = ChatServices();

  File? _mediaFile; 
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(backgroundColor),
      appBar: AppBar(
        leading: backButton(context, Chatscreen()),
        backgroundColor: HexColor(backgroundColor),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Text(
                widget.receiverName,
                style: const TextStyle(
                    fontFamily: "Inter", fontSize: 25, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: DisplayMessage(
                receivername: widget.receiverName,
                receiverId: widget.receiverId),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Row(
              children: [
                IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      size: 26,
                      color: HexColor(buttonBackground),
                    ),
                    onPressed: () =>
                        _bottomMessageOptions(context, Chatscreen())),
                Expanded(
                    child: TextFormField(
                  controller: messageCont,
                  onSaved: (newValue) {
                    messageCont.text = newValue!;
                  },
                  style: const TextStyle(
                    fontFamily: "Inter",
                  ),
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Message...",
                    enabled: true,
                    contentPadding: const EdgeInsets.only(left: 15, bottom: 8),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: HexColor(buttonBackground),
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                  ),
                  validator: (value) {
                    return null;
                  },
                )),
                TextButton(
                    onPressed: sendMessage,
                    child: Text(
                      "Send",
                      style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: HexColor(buttonBackground)),
                    ))
              ],
            ),
          )
        ],
      )),
    );
  }

  void sendMessage() async {
    if (messageCont.text.isNotEmpty) {
      await _chatServices.sendMessage(widget.receiverId, messageCont.text);
      messageCont.clear();
    }
  }
Future<void> _pickMedia() async {
  final pickedFile = await _picker.pickMedia();
  if (pickedFile != null) {
    setState(() {
      _mediaFile = File(pickedFile.path);
      print("MEDIA FILE: " + _mediaFile!.path);
    });
    
    String? mediaUrl;
    if (_mediaFile != null) {
      var uuid = Uuid();  
      String uniqueFileName = uuid.v4();  

      String fileExtension = _mediaFile!.path.split('.').last;
      
      // Firebase Storage referansı
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('Media_Messages')
          .child('$uniqueFileName.$fileExtension');  // UUID ile dosya adı oluşturuluyor

      // Dosyayı yükle
      await storageRef.putFile(_mediaFile!);
      mediaUrl = await storageRef.getDownloadURL();
      print("MEDIA URL: " + mediaUrl);
    }
  }
}
  Future<void> _bottomMessageOptions(BuildContext context, dynamic item) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: HexColor(search),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return Container(
            height: 200,
            child: Column(
              children: [
                ListTile(
                  title: Center(
                    child: Text('Gallery',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: HexColor(buttonBackground))),
                  ),
                  onTap: () {
                    _pickMedia();
                  },
                ),
                ListTile(
                  title: Center(
                    child: Text('Audio',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: HexColor(buttonBackground))),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Center(
                    child: Text(
                      'Location',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: HexColor(buttonBackground)),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }
}
