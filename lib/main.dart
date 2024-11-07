import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCSBuBeK25gx50Au1YhJ_T8dnLT3F6x5j0",
      authDomain: "setting-13051.firebaseapp.com",
      projectId: "setting-13051",
      storageBucket: "setting-13051.firebasestorage.app",
      messagingSenderId: "230600441220",
      appId: "1:230600441220:web:6e84f669e2cb30859ab1d1",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tela de Login',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LoginScreen(),
    );
  }
}
