import 'package:cloud_firestore/cloud_firestore.dart';

class Messagemodel {
  final String senderId;
  final String  senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;

  Messagemodel({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    required this.timestamp
  });

  //map e cevir 
  Map<String,dynamic> toMap(){
    return {
      "senderId":senderId,
      "senderEmail":senderEmail,
      "receiverId":receiverId,
      "message":message,
      "timestamp":timestamp
    };
  }

}class NoteModel {
  final String userId;
  final String userName;
  final String noteTitle;
  final String noteDescription;
  final Timestamp timestamp;

  NoteModel({
    required this.userId,
    required this.userName,
    required this.noteTitle,
    required this.noteDescription,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "userName": userName,
      "noteTitle": noteTitle,
      "noteDescription": noteDescription,
      "timestamp": timestamp,
    };
  }
}
