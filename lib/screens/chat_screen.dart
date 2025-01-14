import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.receiverEmail,
    required this.receiverId,
  });

  final String receiverEmail;
  final String receiverId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  // chat and auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  // focusNode for textField focus
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // add listener to focus Node
    myFocusNode.addListener(
      () {
        if (myFocusNode.hasFocus) {
          Future.delayed(
            const Duration(microseconds: 400),
            () => scrollDown(),
          );
        }
      },
    );
    // wait a bit for listview
    Future.delayed(
      const Duration(microseconds: 400),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  //scroll Controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverId, _messageController.text);
      _messageController.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: AppBar(
          title: Text(
            widget.receiverEmail,
            style: const TextStyle(overflow: TextOverflow.ellipsis),
          ),
        ),
        body: Column(
          children: [
            Expanded(child: _buildMessageList()),
            _buildUserInput(),
          ],
        ),
      ),
    );
  }

  // Build message List
  Widget _buildMessageList() {
    String senderId = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessage(widget.receiverId, senderId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong!'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs
              .map<Widget>(
                (docs) => _buildMessageItemView(docs),
              )
              .toList(),
        );
      },
    );
  }

  // Build message Item View
  Widget _buildMessageItemView(DocumentSnapshot docs) {
    Map<String, dynamic> data = docs.data() as Map<String, dynamic>;

    // check currentUser and align msg accordingly
    bool isCurrentUser = data['senderId'] == _authService.getCurrentUser()!.uid;
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(
            message: data["message"],
            isCurrentUser: isCurrentUser,
          ),
        ],
      ),
    );
  }

  // user input field
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Send message...',
              ),
              controller: _messageController,
              focusNode: myFocusNode,
            ),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(Icons.send_rounded),
          ),
        ],
      ),
    );
  }
}
