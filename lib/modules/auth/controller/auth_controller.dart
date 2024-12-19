import 'package:chatapp/modules/auth/screens/profile_input_screen.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:chatapp/modules/chat/screens/users_list.dart';

class LoginController with ChangeNotifier {
  final AuthService _authService = AuthService();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isLogin = true;

  bool get isLoading => _isLoading;
  bool get isLogin => _isLogin;

  void toggleAuthMode() {
    _isLogin = !_isLogin;
    notifyListeners();
  }

  init() {
    clearController();
  }

  Future<void> authenticate(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError(context, "Please fill in both email and password.");
      return;
    }

    _setLoading(true);

    try {
      if (_isLogin) {
        final user = await _authService.login(email, password);
        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => UserListScreen(
                currentUserId: user.uid,
              ),
            ),
          );
        } else {
          _showError(context, "Login failed. Please try again.");
        }
      } else {
        final user = await _authService.signUp(email, password);
        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ProfileInputScreen()),
          );
        } else {
          _showError(context, "Signup failed. Please try again.");
        }
      }
    } on Exception catch (e) {
      _showError(context, "$e");
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  clearController() {
    emailController.clear();
    passwordController.clear();
  }
}
