import 'package:chat_app_flutter_firebase/screens/change_pass.dart';
import 'package:chat_app_flutter_firebase/screens/myprofile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'chatscreen.dart';

class ChatListScreen extends StatelessWidget {
  final String currentUserId;

  ChatListScreen({super.key, required this.currentUserId});

 

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        backgroundColor: Colors.teal,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'changePassword') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangePasswordScreen()),
                );
              } else if (value == 'myProfile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyProfileScreen(
                        userId: FirebaseAuth.instance.currentUser!.uid),
                  ),
                );
              } else if (value == 'logout') {
                _logout(context);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'changePassword',
                child: Row(
                  children: const [
                    Icon(Icons.lock, color: Colors.teal),
                    SizedBox(width: 8),
                    Text("Change Password"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'myProfile',
                child: Row(
                  children: const [
                    Icon(Icons.person, color: Colors.teal),
                    SizedBox(width: 8),
                    Text("My Profile"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: const [
                    Icon(Icons.logout, color: Colors.teal),
                    SizedBox(width: 8),
                    Text("Logout"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No users found.'));
          }

          final users = snapshot.data!.docs
              .where((doc) => doc['uid'] != currentUserId)
              .toList();

          if (users.isEmpty) {
            return const Center(child: Text('No other users found.'));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    user['profileImage'] ?? 'https://via.placeholder.com/150',
                  ),
                ),
                title: Text(user['name'] ?? 'Unknown'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        currentUserId: currentUserId,
                        receiverId: user['uid'],
                        receiverName: user['name'] ?? 'Unknown',
                        receiverImage: user['profileImage'] ?? '',
                      ),


                      
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
