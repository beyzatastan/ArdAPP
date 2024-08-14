import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DisplayMessage extends StatefulWidget {
  const DisplayMessage({super.key, required this.name});
  final String name;

  @override
  State<DisplayMessage> createState() => _DisplayMessageState();
}

class _DisplayMessageState extends State<DisplayMessage> {
  final Stream<QuerySnapshot> _messageStream = FirebaseFirestore.instance
      .collection("Message") // Koleksiyon adını kontrol edin
      .orderBy("time")
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _messageStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No messages available."));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            QueryDocumentSnapshot qds = snapshot.data!.docs[index];
            Timestamp time = qds["time"];
            DateTime dateTime = time.toDate();
            String messageSender = qds["name"];
            String messageContent = qds["message"];
            
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Column(
                crossAxisAlignment: widget.name == messageSender
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8, // Dinamik genişlik
                    child: ListTile(
                      title: Text(messageSender), // Kullanıcı adını göster
                      subtitle: Text(
                        messageContent,
                        softWrap: true,
                        style: const TextStyle(fontFamily: "Inter"),
                      ),
                    ),
                  ),
                  Text(
                    "${dateTime.hour}:${dateTime.minute}",
                    style: const TextStyle(fontSize: 12), // Zaman için stil
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
