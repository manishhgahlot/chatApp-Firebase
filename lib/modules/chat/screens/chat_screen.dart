import 'package:chatapp/modules/chat/controller/chat_controller.dart';
import 'package:chatapp/utils/app_colour.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatelessWidget {
  final String chatId;
  final String senderId;
  final String receiverId;
  final String receiverName;

  const ChatScreen({
    Key? key,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.receiverName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatProvider(
        chatId: chatId,
        senderId: senderId,
        receiverId: receiverId,
      )..fetchMessages(),
      child: Scaffold(
        appBar: AppBar(
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: AppColors.backgroundColor,
              ),
            ),
            backgroundColor: AppColors.primaryColor,
            title: Text(
              receiverName,
              style: TextStyle(color: AppColors.backgroundColor),
            )),
        body: Column(
          children: [
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, provider, child) {
                  provider.clearController();
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    reverse: true,
                    itemCount: provider.messages.length,
                    itemBuilder: (context, index) {
                      final message = provider.messages[index];
                      final isMe = message['senderId'] == senderId;

                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 10),
                          decoration: BoxDecoration(
                            color: isMe
                                ? AppColors.primaryColor.withOpacity(0.3)
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.5,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message['message'] ?? '',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Row(
                                children: [
                                  isMe
                                      ? Text(
                                          message['status'] ?? 'Sent',
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 12,
                                            color: message['status'] == 'Sent'
                                                ? AppColors.buttonColor
                                                : (message['status'] ==
                                                        'Delivered'
                                                    ? Colors.blue
                                                    : Colors.green),
                                          ),
                                        )
                                      : SizedBox.shrink(),
                                  isMe ? SizedBox(width: 6) : SizedBox.shrink(),
                                  Text(
                                    provider
                                        .formatTimestamp(message['timestamp']),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Consumer<ChatProvider>(
                builder: (context, provider, child) {
                  return Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.attach_file),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Coming soon! Unavailable due to Firebase cloud storage premium plans.'),
                            ),
                          );
                        },
                      ),
                      Expanded(
                        child: TextField(
                          controller: provider.messageController,
                          decoration: InputDecoration(
                            hintText: 'Type a message',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: provider.sendMessage,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
