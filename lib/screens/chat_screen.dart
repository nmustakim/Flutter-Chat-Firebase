import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_firebase/screens/full_image.dart';
import 'package:flutter_chat_firebase/screens/profile.dart';
import 'package:flutter_chat_firebase/services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../models/message_model.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final String id;
  final String email;
  final String username;
  final String image;

  const ChatScreen({
    required this.name,
    required this.id,
    Key? key,
    required this.image,required this.username, required this.email,
  }) : super(key: key);

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      await _chatService.sendMessage(
        widget.id,
        messageText,
      );
      _messageController.clear();
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
  void _sendFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      await _chatService.sendMessage(
        widget.id,
        '',
        file: file,
      );
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        title: Text(widget.name),
        centerTitle: true,
        actions: [
          Row(
            children: [
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileScreen(name: widget.name, email: widget.email, image: widget.image, username: widget.username)));
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    widget.image,
                  ),
                ),
              ),
              const SizedBox(
                width: 24,
              )
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              height: 689,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Expanded(child: _buildMessageList()),
                  _buildMessageInput(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
        widget.id,
        _auth.currentUser!.uid,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final messages = snapshot.data!.docs;
        return ListView.builder(
          controller: _scrollController,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final messageData = messages[index].data() as Map<String, dynamic>;
            final message = Message.fromMap(messageData);
            return _buildMessageItem(message);
          },
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            maxLines: 2,
            controller: _messageController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        Column(
          children: [
            IconButton(
              onPressed: _sendMessage,
              icon: const Icon(Icons.send),
            ),
            IconButton(
              onPressed: _sendFile,
              icon: const Icon(Icons.attach_file),
            ),
          ],
        )

      ],
    );
  }

  Widget _buildMessageItem(Message message) {
    final isCurrentUser = message.senderId == _auth.currentUser!.uid;
    final bgColor = isCurrentUser ? Colors.blue : Colors.grey[300];
    final textColor = isCurrentUser ? Colors.white : Colors.black;
    final borderRadius = BorderRadius.only(
      topLeft: Radius.circular(isCurrentUser ? 20 : 0),
      topRight: Radius.circular(isCurrentUser ? 0 : 20),
      bottomLeft: const Radius.circular(20),
      bottomRight: const Radius.circular(20),
    );
    return Column(
      crossAxisAlignment:
          isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: borderRadius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isCurrentUser)
                Text(
                  widget.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              const SizedBox(height: 4),

              if (message.fileURL != null)
                InkWell(
                  onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>FullScreenImage(imageUrl: message.fileURL!))),
                  child: Image.network(
                    message.fileURL!,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  message.message,
                  style: TextStyle(color: textColor),
                ),
              const SizedBox(height: 4),
              Text(
                _formatTimestamp(message.timeStamp),
                style: TextStyle(fontSize: 12, color: textColor),
              ),
            ],
          ),
        )
      ],
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    final formattedTime = DateFormat.jm().format(dateTime);
    return formattedTime;
  }
}
