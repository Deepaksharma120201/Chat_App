import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:chat_app/widgets/my_drawer.dart';
import 'package:chat_app/widgets/user_tile.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // chat and auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
        title: const Text('Users'),
      ),
      drawer: const MyDrawer(),
      body: StreamBuilder(
        stream: _chatService.getUserStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something goes wrong!'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            children: snapshot.data!
                .map<Widget>(
                  (userData) => _buildUserListView(userData, context),
                )
                .toList(),
          );
        },
      ),
    );
  }

  Widget _buildUserListView(
    Map<String, dynamic> userData,
    BuildContext context,
  ) {
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTile(
        user: userData["email"],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                receiverEmail: userData["email"],
                receiverId: userData["uid"],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
