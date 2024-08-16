import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';
import 'package:noteapp/services/chats/chat_services.dart';

class DisplayMessage extends StatefulWidget {
  const DisplayMessage({super.key, required this.receivername,
  required this.receiverId});
  
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
      stream: _chatServices.getMessages(widget.receiverId, FirebaseAuth.instance.currentUser!.uid),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
           print(snapshot.error);
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        // Filter messages
        final currentUserId = FirebaseAuth.instance.currentUser!.uid;
        final filteredMessages = snapshot.data!.docs.where((doc) {
          final receiverId = doc['receiverId'];
          final userId = doc['senderId'];
          return receiverId == widget.receiverId || userId == currentUserId;
        }).toList();

        // Show no messages available if no matching messages are found
        if (filteredMessages.isEmpty) {
          return const Center(child: Text("No messages available."));
        }

        // Scroll to the bottom on new messages
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });

        return ListView.builder(
          controller: _scrollController,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            QueryDocumentSnapshot qds = snapshot.data!.docs[index];
            Timestamp time = qds["timestamp"];
            DateTime dateTime = time.toDate();
            bool isNotCurrentUser = widget.receiverId == qds["receiverId"];
            String messageReceiver = qds["receiverId"];
            String messageContent = qds["message"];
            
            return Padding(
              padding: const EdgeInsets.fromLTRB(10,2,10,2),
              child: Align(
               alignment: isNotCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: widget.receiverId != messageReceiver
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal:12,vertical: 8 ),
                      decoration: BoxDecoration(
                        color: isNotCurrentUser ? HexColor(buttonBackground) : HexColor(search),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Wrap(
                        children:[IntrinsicWidth(
                          child: ConstrainedBox(constraints: BoxConstraints(
                             maxWidth: MediaQuery.of(context).size.width * 0.8,
                          ),
                          child: Text(
                            messageContent,
                            style: TextStyle(fontFamily: "Inter",color: isNotCurrentUser ? Colors.white :Colors.black,fontSize: 15),
                          ),),
                        ),
                        ]
                        )
                        )
                          ,const SizedBox(height:2),
                          Text(
                            "${dateTime.hour}:${dateTime.minute}",
                            style: TextStyle(
                              color: HexColor(noteColor),
                              fontSize: 12,),
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
}
