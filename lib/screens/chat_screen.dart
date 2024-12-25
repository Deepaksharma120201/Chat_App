import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/widgets/chat_messages.dart';
import 'package:chat_app/widgets/new_message.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void setUpNotification() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();

    final token = await fcm.getToken();
    print(token);
  }

  @override
  void initState() {
    super.initState();
    setUpNotification();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Chat Screen'),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).cardColor,
          body: const Column(
            children: [
              Expanded(
                child: ChatMessages(),
              ),
              NewMessage(),
            ],
          )),
    );
  }
}
