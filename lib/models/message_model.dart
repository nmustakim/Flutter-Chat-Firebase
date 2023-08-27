import 'package:cloud_firestore/cloud_firestore.dart';

class Message {

  final String senderId;
  final  String senderEmail;
  final String receiverId;
  final  String message;
  final Timestamp timeStamp;

  Message({required this.senderId, required this.senderEmail, required this.receiverId, required this.message, required this.timeStamp});

Map <String, dynamic> messageToMap(){
  return {
    'senderId':senderId,
    'senderEmail':senderEmail,
    'receiverId': receiverId,
    'message': message,
    'timeStamp': timeStamp
  };
}

  static Message fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'],
      senderEmail: map['senderEmail'],
      receiverId: map['receiverId'],
      message: map['message'],
      timeStamp: map['timeStamp'],
    );
  }




}