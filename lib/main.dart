import 'package:base_application/backend/cvsRipper.dart';
import 'package:base_application/displayPages/startUpPage.dart';
import 'package:base_application/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  await nodeCreate();
  runApp(const MaterialApp(
    home: StartupPage(),
  ));
}

