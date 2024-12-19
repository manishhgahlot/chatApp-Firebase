import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatapp/services/chat_service.dart';
import 'package:intl/intl.dart';

class ChatProvider extends ChangeNotifier {
  final String chatId;
  final String senderId;
  final String receiverId;

  final ChatService _chatService = ChatService();
  final TextEditingController messageController = TextEditingController();

  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = true;

  List<Map<String, dynamic>> get messages => _messages;
  bool get isLoading => _isLoading;

  ChatProvider({
    required this.chatId,
    required this.senderId,
    required this.receiverId,
  });

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return '';
    }
    final format = DateFormat('h:mm a');
    return format.format(timestamp.toDate());
  }

  void fetchMessages() {
    _chatService.getMessages(chatId).listen((newMessages) {
      _messages = newMessages;
      _isLoading = false;
      notifyListeners();
    });
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isNotEmpty) {
      _chatService.sendMessage(
        chatId: chatId,
        senderId: senderId,
        receiverId: receiverId,
        text: text,
      );
      messageController.clear();
    }
  }

  clearController() {
    messageController.clear();
  }
}
