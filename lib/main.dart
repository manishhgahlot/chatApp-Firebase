import 'package:chatapp/firebase_options.dart';
import 'package:chatapp/modules/auth/controller/auth_controller.dart';
import 'package:chatapp/modules/auth/controller/profile_input_controller.dart';
import 'package:chatapp/modules/auth/screens/login_screen.dart';
import 'package:chatapp/modules/chat/screens/users_list.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: true);
  bool isLoggedIn = await AuthService().isLoggedIn();
  String? userId = isLoggedIn ? await AuthService().getUserId() : "";
  runApp(MyApp(isLoggedIn: isLoggedIn, userId: userId ?? ""));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String userId;

  const MyApp({required this.isLoggedIn, required this.userId});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginController()),
        ChangeNotifierProvider(create: (context) => ProfileController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home:
            isLoggedIn ? UserListScreen(currentUserId: userId) : LoginScreen(),
      ),
    );
  }
}
