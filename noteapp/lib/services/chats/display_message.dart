import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';

class DisplayMessage extends StatefulWidget {
  const DisplayMessage({super.key, required this.receivername,
  required this.receiverId});
  
  final String receivername;
  final String receiverId;

  @override
  State<DisplayMessage> createState() => _DisplayMessageState();
}
class _DisplayMessageState extends State<DisplayMessage> {

  late final Stream<QuerySnapshot> _messageStream ;

  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    
     _messageStream = FirebaseFirestore.instance
      .collection('Users')
      .doc(currentUserId)
      .collection('Messages')
      .orderBy('time')
      .snapshots();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _messageStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
           print(snapshot.error);
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No messages available."));
        }
        //ekranın son mesaja açılması 
         WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });

        return ListView.builder(
          controller: _scrollController,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            QueryDocumentSnapshot qds = snapshot.data!.docs[index];
            if(widget.receiverId == qds["receiverId"]){

            }
            Timestamp time = qds["time"];
            DateTime dateTime = time.toDate();
            bool isNotCurrentUser = widget.receivername == qds["receiverName"];
            String messageReceiver = qds["receiverName"];
            String messageContent = qds["message"];
            
            return Padding(
              padding: const EdgeInsets.fromLTRB(10,2,10,2),
              child: Align(
               alignment: isNotCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: widget.receivername != messageReceiver
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
