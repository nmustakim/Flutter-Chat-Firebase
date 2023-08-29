import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_firebase/models/message_model.dart';

class ChatService {final _auth = FirebaseAuth.instance;

final _storage = FirebaseStorage.instance;
final _fireStore = FirebaseFirestore.instance;

Future<void> sendMessage(
    String receiverId,
    String message,
    {File? file}
    ) async {
  final uid = _auth.currentUser!.uid;
  final email = _auth.currentUser!.email;
  final timestamp = Timestamp.now();

  Message newMessage = Message(
    senderId: uid,
    senderEmail: email!,
    receiverId: receiverId,
    message: message,
    timeStamp: timestamp,
  );

  if (file != null) {

    final storageRef = _storage.ref().child('chat_files/$uid/${timestamp.seconds}${timestamp.nanoseconds}');
    final uploadTask = storageRef.putFile(file);
    await uploadTask.whenComplete(() => null);

    final downloadURL = await storageRef.getDownloadURL();
    newMessage.fileURL = downloadURL;
  }

  List<String> ids = [uid, receiverId];
  ids.sort();
  String chatRoomId = ids.join('_');

  await _fireStore
      .collection('chat_rooms')
      .doc(chatRoomId)
      .collection('messages')
      .add(newMessage.messageToMap());
  }

  Stream <QuerySnapshot> getMessages(String oneUserId,anotherUserId){
    List <String> ids = [oneUserId,anotherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');
   return _fireStore.collection('chat_rooms').doc(chatRoomId).collection('messages').orderBy('timeStamp',descending: false).snapshots();
  }

}
