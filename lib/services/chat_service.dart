import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_firebase/models/message_model.dart';

class ChatService {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;

  Future<void> sendMessage(String receiverId, message) async {
    final uid = _auth.currentUser!.uid;
    final email = _auth.currentUser!.email;
    final timestamp = Timestamp.now();

    Message newMessage = Message(
        senderId: uid,
        senderEmail: email!,
        receiverId: receiverId,
        message: message,
        timeStamp: timestamp);
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
    print(_fireStore.collection('chat_rooms').doc(chatRoomId).collection('messages'));
    return _fireStore.collection('chat_rooms').doc(chatRoomId).collection('messages').orderBy('timeStamp',descending: false).snapshots();
  }

}
