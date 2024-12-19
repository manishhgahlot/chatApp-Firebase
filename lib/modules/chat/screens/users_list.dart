import 'dart:developer';

import 'package:chatapp/modules/chat/controller/user_list_controller.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:chatapp/utils/app_colour.dart';
import 'package:chatapp/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat_screen.dart';

class UserListScreen extends StatelessWidget {
  final String currentUserId;

  const UserListScreen({Key? key, required this.currentUserId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserListProvider(currentUserId: currentUserId),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: const Text(
            'Users',
            style: TextStyle(
              color: AppColors.backgroundColor,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => AuthService().logout(context),
                child: const Icon(
                  Icons.logout,
                  color: AppColors.backgroundColor,
                ),
              ),
            ),
          ],
        ),
        body: Consumer<UserListProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.users.isEmpty) {
              return const Center(child: Text('No users found.'));
            }

            return ListView.builder(
              itemCount: provider.users.length,
              itemBuilder: (context, index) {
                final user = provider.users[index];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0.5,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: user['profilePicture'].isNotEmpty
                          ? NetworkImage(user['profilePicture'])
                          : null,
                      child: user['profilePicture'].isEmpty
                          ? Text(
                              user['name'].substring(0, 1).toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            )
                          : null,
                      backgroundColor: AppColors.primaryColor,
                    ),
                    title: Text(
                      user['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(user['email']),
                    trailing:
                        const Icon(Icons.chat, color: AppColors.primaryColor),
                    onTap: () {
                      final chatId =
                          ChatUtils.generateChatId(currentUserId, user.id);
                      log(chatId);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            chatId: chatId,
                            senderId: currentUserId,
                            receiverId: user.id,
                            receiverName: user['name'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
