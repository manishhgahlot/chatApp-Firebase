import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/auth_service.dart';
import 'package:chatapp/modules/chat/screens/users_list.dart';

class ProfileController with ChangeNotifier {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  TextEditingController get nameController => _nameController;
  TextEditingController get bioController => _bioController;

  Future<void> saveProfile(BuildContext context) async {
    final name = _nameController.text.trim();
    final bio = _bioController.text.trim();
    final user = _authService.getCurrentUser();

    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
          'bio': bio,
          'email': user.email,
          'profilePicture': '',
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserListScreen(currentUserId: user.uid),
          ),
        );
      } catch (e) {
        _showError(context, "Error saving profile: $e");
      }
    } else {
      _showError(context, "User not found.");
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  clearController() {
    nameController.clear();
    bioController.clear();
  }
}
