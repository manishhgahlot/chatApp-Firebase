import 'package:chatapp/modules/auth/controller/profile_input_controller.dart';
import 'package:chatapp/utils/app_colour.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileInputScreen extends StatelessWidget {
  const ProfileInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileController(),
      child: Consumer<ProfileController>(
        builder: (context, controller, child) {
          controller.clearController();
          return Scaffold(
            appBar: AppBar(
                backgroundColor: AppColors.primaryColor,
                title: Text('Setup Profile',
                    style: TextStyle(
                      color: AppColors.backgroundColor,
                    ))),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: controller.nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: controller.bioController,
                    decoration: InputDecoration(labelText: 'Bio'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      controller.saveProfile(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonColor,
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 80),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Save Profile",
                      style: TextStyle(
                        color: AppColors.buttonTextColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
