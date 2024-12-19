import 'package:chatapp/modules/auth/controller/auth_controller.dart';
import 'package:chatapp/utils/app_colour.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginController>(
      builder: (context, controller, child) {
        controller.clearController();
        return Scaffold(
          appBar: AppBar(
            title: Text(
              controller.isLogin ? 'Login' : 'Sign Up',
              style: TextStyle(color: AppColors.backgroundColor),
            ),
            backgroundColor: AppColors.primaryColor,
          ),
          body: controller.isLoading
              ? Center(child: CircularProgressIndicator())
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                            controller: controller.emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              filled: true,
                              fillColor: AppColors.textFieldColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          TextField(
                            controller: controller.passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              filled: true,
                              fillColor: AppColors.textFieldColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            obscureText: true,
                          ),
                          SizedBox(height: 24),

                          // Login/Signup Button
                          ElevatedButton(
                            onPressed: () {
                              controller.authenticate(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.buttonColor,
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 100),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              controller.isLogin ? 'Login' : 'Sign Up',
                              style: TextStyle(
                                color: AppColors.buttonTextColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              controller.toggleAuthMode();
                            },
                            child: Text(
                              controller.isLogin
                                  ? 'Don\'t have an account? Sign Up'
                                  : 'Already have an account? Login',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
