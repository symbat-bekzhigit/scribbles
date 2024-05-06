import "package:flutter/material.dart";
import "package:messaging_app/components/my_drawer.dart";
import "package:messaging_app/components/user_title.dart";
import "package:messaging_app/pages/chat_page.dart";
import "package:messaging_app/services/auth/auth_service.dart";
import "package:messaging_app/services/chat/chat_service.dart";

class ChatHomePage extends StatelessWidget {
  ChatHomePage({super.key});

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scribbles"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0
        ),
      drawer: const MyDrawer(),
      body: _buildUserList()
    );
  }

  // build a list of users except for the current logged in user
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          return const Text("Error");
        }

        // loading..
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        // return list view
        return ListView(
          children: snapshot.data!
          .map<Widget>((userData) => _buildUserListItem(userData, context))
          .toList(),
        ); // ListView
      },
    ); // StreamBuilder
  }

  // build individual list tile for user
  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    if (userData["email"] != _authService.getCurrentUser()!.email) { 
      return UserTile(
        text: userData["email"],
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData["email"], receiverID: userData["uid"],
              ),
            ),
          );
        }
      );
    }else{
      return Container();
    }
  }
}