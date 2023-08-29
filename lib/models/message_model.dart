import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timeStamp;
  String? fileURL;
  String? fileName;

  Message({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    required this.timeStamp,
    this.fileURL,
    this.fileName,
  });

  Map<String, dynamic> messageToMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'message': message,
      'timeStamp': timeStamp,
      'fileURL': fileURL,
      'fileName': fileName,
    };
  }

  static Message fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'],
      senderEmail: map['senderEmail'],
      receiverId: map['receiverId'],
      message: map['message'],
      timeStamp: map['timeStamp'],
      fileURL: map['fileURL'],
      fileName: map['fileName'],
    );
  }
}
