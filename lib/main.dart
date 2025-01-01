import 'package:businessGameApp/backend/csv_ripper.dart';
import 'package:businessGameApp/displayPages/start_up_page.dart';
import 'package:businessGameApp/firebase_options.dart';
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

