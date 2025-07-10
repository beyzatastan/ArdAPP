import 'package:cloud_firestore/cloud_firestore.dart';

class Groupchatmodel {
  final String groupName;
  final String groupDesc;
  final List<Map<String, dynamic>> membersId;
  final Timestamp timestamp;
  final String founderId;
  final String founderEmail;

   Groupchatmodel(
      {
      required this.founderId,
      required this.founderEmail,
      required this.membersId,
      required this.groupDesc,
      required this.groupName,
      required this.timestamp});

  //map e cevir
  Map<String, dynamic> toMap() {
    return {
      "founderId": founderId,
      "founderEmail": founderEmail,
      "receiverMembers": membersId,
      "groupName":groupName,
      "groupDesc":groupDesc,
      "timestamp": timestamp,
    };
  }
}

class groupMessageModel {
  final String senderId;
  final String senderEmail;
  final String message;
  final Timestamp timestamp;
  final String messageType;

  groupMessageModel(
      {required this.messageType,
      required this.senderId,
      required this.senderEmail,
      required this.message,
      required this.timestamp});

  //map e cevir
  Map<String, dynamic> toMap() {
    return {
      "senderId": senderId,
      "senderEmail": senderEmail,
      "message": message,
      "timestamp": timestamp,
      "messageType": messageType
    };
  }
}
