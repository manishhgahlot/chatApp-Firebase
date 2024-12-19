class ChatUtils {
  static String generateChatId(String userId1, String userId2) {
    List<String> userIds = [userId1, userId2]..sort();
    return userIds.join('_');
  }
}
