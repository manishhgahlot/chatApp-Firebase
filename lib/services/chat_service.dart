import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String text,
  }) async {
    final messageData = {
      'chatId': chatId,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': text,
      'timestamp': FieldValue.serverTimestamp(), // Ensure timestamp is set
      'type': 'text',
      'fileUrl': null,
      'status': 'Sent', // Default status
    };

    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(messageData);
  }

  Future<void> updateMessageStatus({
    required String chatId,
    required String messageId,
    required String status,
  }) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({
      'status': status,
    });
  }

  Stream<List<Map<String, dynamic>>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .handleError((error) {
      print("Error fetching messages: $error");
    }).map((snapshot) => snapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
            .toList());
  }
}
