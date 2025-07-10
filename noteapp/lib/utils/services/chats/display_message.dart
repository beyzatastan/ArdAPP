import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';
import 'package:noteapp/utils/services/chats/chat_services.dart';
import 'package:url_launcher/url_launcher.dart';

class DisplayMessage extends StatefulWidget {
  const DisplayMessage(
      {super.key, required this.receivername, required this.receiverId,});

  final String receivername;
  final String receiverId;
  @override
  State<DisplayMessage> createState() => _DisplayMessageState();
}


class _DisplayMessageState extends State<DisplayMessage> {
  final ChatServices _chatServices = ChatServices();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _chatServices.getMessages(
          widget.receiverId, FirebaseAuth.instance.currentUser!.uid),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final currentUserId = FirebaseAuth.instance.currentUser!.uid;
        final filteredMessages = snapshot.data!.docs.where((doc) {
          final receiverId = doc['receiverId'];
          final senderId = doc['senderId'];
          return (receiverId == widget.receiverId &&
                  senderId == currentUserId) ||
              (senderId == widget.receiverId && receiverId == currentUserId);
        }).toList();

        if (filteredMessages.isEmpty) {
          return const Center(child: Text("No messages available."));
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });

        return ListView.builder(
          controller: _scrollController,
          itemCount: filteredMessages.length,
          itemBuilder: (context, index) {
            QueryDocumentSnapshot qds = filteredMessages[index];
            Timestamp time = qds["timestamp"];
            DateTime dateTime = time.toDate();
            bool isNotCurrentUser = qds["senderId"] == currentUserId;
            String messageContent = qds["message"];

            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
              child: Align(
                alignment: isNotCurrentUser
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: isNotCurrentUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isNotCurrentUser
                            ? HexColor(buttonBackground)
                            : HexColor(search),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _buildMessageWidget(messageContent,isNotCurrentUser),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${dateTime.hour}:${dateTime.minute}",
                      style: TextStyle(
                        color: HexColor(noteColor),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMessageWidget(String message,bool isNotCurrentUser) {
    // URL'leri tespit etmek için RegExp kullanımı
    final urlPattern = RegExp(
        r'(http|https):\/\/([\w.]+\/?)\S*',
        caseSensitive: false,
        multiLine: false);

    if (urlPattern.hasMatch(message)) {
      final match = urlPattern.firstMatch(message);
      final url = match?.group(0);

      return InkWell(
        onTap: () {
          if (url != null) {
            _launchURL(url);
          }
        },
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ), 
        ),
      );
    } else {
      return Text(
        message,
        style: TextStyle(
          fontFamily: "Inter",
          color: isNotCurrentUser 
                      ? Colors.white
                      : Colors.black,
          fontSize: 15,
        ),
      );
    }
  }

  // URL'yi tarayıcıda açma fonksiyonu
  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
