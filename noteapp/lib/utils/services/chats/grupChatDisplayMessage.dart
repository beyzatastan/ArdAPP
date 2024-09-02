import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';
import 'package:noteapp/utils/services/chats/groupChatServices.dart';
import 'package:url_launcher/url_launcher.dart';

class GroupDisplayMessage extends StatefulWidget {
  final List<String> members;
  final String groupId;

  const GroupDisplayMessage({
    super.key,
    required this.members,
    required this.groupId,
  });

  @override
  State<StatefulWidget> createState() => _DisplayMessageState();
}

class _DisplayMessageState extends State<GroupDisplayMessage> {
  final Groupchatservices groupchatservices = Groupchatservices();
  final ScrollController _scrollController = ScrollController();

   @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: groupchatservices.getGroupMessages(widget.groupId),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final currentUserId = FirebaseAuth.instance.currentUser!.uid;
        final filteredMessages = snapshot.data!.docs.where((doc) {
          final senderId = doc['senderId'];

          // Mesajın göndericisi grup üyelerinden biri mi kontrol edin
          return widget.members.contains(senderId);
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
            final qds = filteredMessages[index];
            final Timestamp time = qds["timestamp"];
            final DateTime dateTime = time.toDate();
            final bool isCurrentUser = qds["senderId"] == currentUserId;
            final String messageContent = qds["message"];

            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
              child: Align(
                alignment: isCurrentUser
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: isCurrentUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isCurrentUser
                            ? HexColor(buttonBackground)
                            : HexColor(search),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _buildMessageWidget(messageContent, isCurrentUser),
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

  Widget _buildMessageWidget(String message, bool isNotCurrentUser) {
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

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
