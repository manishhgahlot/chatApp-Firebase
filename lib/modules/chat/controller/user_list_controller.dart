import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserListProvider extends ChangeNotifier {
  final String currentUserId;
  List<DocumentSnapshot> _users = [];
  bool _isLoading = false;

  UserListProvider({required this.currentUserId}) {
    fetchUsers();
  }

  List<DocumentSnapshot> get users => _users;
  bool get isLoading => _isLoading;

  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('users').get();
      _users = snapshot.docs.where((doc) => doc.id != currentUserId).toList();
    } catch (e) {
      debugPrint("Error fetching users: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
