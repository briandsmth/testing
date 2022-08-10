import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mini_app/method/auth_method.dart';
import 'package:mini_app/screens/add_task.dart';
import 'package:mini_app/screens/edit_task.dart';
import 'package:mini_app/screens/home.dart';
import 'package:mini_app/screens/login.dart';
import 'package:mini_app/widgets/buttomnav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "To Do App",
      theme: ThemeData(),
      routes: {
        '/login': (context) => LoginScreen(),
      },
      home: StreamBuilder(
        stream: AuthMethod().authChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            return ButtomBar();
          }

          return LoginScreen();
        },
      ),
    );
  }
}
