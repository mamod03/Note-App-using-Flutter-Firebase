import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/auth/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_3/auth/signup.dart';
import 'package:flutter_application_3/categories/add.dart';
import 'package:flutter_application_3/filter.dart';
import 'package:flutter_application_3/homepage.dart';
import 'package:flutter_application_3/maps.dart';
import 'package:flutter_application_3/test.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("bakckck ===================");
  print(message.notification!.title);
  print(message.data);
  print(message.notification!.body);
  print("bakckck ===================");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid
      ? await Firebase.initializeApp(
          // name: "test",
          options: const FirebaseOptions(
              apiKey: "AIzaSyC0CL1Ndy8sAiD2GHvg-WkdihjayX72MMc",
              appId: "1:751054054953:android:547b2781703372dd63de38",
              messagingSenderId: "751054054953",
              projectId: "test-d1180",
              storageBucket: 'test-d1180.appspot.com'))
      : await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });

    super.initState();
  }

  final primaryColor = const Color.fromARGB(255, 255, 183, 0);
  final blu = const Color.fromARGB(255, 0, 55, 255);
  final re = const Color.fromARGB(255, 255, 0, 0);
  final gre = const Color.fromARGB(255, 0, 255, 51);
  final gry = const Color.fromARGB(255, 255, 255, 255);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            appBarTheme: AppBarTheme(
                backgroundColor: gry,
                titleTextStyle: const TextStyle(
                    color: Colors.orange,
                    fontSize: 17,
                    fontWeight: FontWeight.bold)),
            iconTheme: const IconThemeData(color: Colors.orange)),
        title: 'Flutter',
        debugShowCheckedModeBanner: false,
        routes: {
          "signup": (context) => const SignUp(),
          "login": (context) => const Login(),
          "homepage": (context) => homePage(),
          "addCategory": (context) => const AddCategory(),
          "FilterPage": (context) => const FilterUser()
        },
        home: (FirebaseAuth.instance.currentUser != null &&
                FirebaseAuth.instance.currentUser!.emailVerified)
            ? homePage()
            : const Login());
// mapui()
// test()
    // // FilterUser()
  }
}
