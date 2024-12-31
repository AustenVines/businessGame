import 'package:base_application/displayPages/gamePage.dart';
import 'package:flutter/material.dart';

class StartupPage extends StatefulWidget {
  const StartupPage({super.key});

  @override
  State<StartupPage> createState() => StartupPageState();
}

class StartupPageState extends State<StartupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
        children: [Text("Zero to Millions")]),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(onPressed: () {Navigator.push(context,
          MaterialPageRoute(builder: (context) => const GamePage()));},
          child: const Text("Play"))],),
        ],
      ),
    );
  }
}
