import 'package:base_application/displayPages/gamePage.dart';
import 'package:base_application/services/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
FirestoreService firestoreService = FirestoreService();

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
      body:
          Column(
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
          child: const Text("Play")),
          SizedBox(

            height: 200,
            width: 200,
            child: StreamBuilder<QuerySnapshot>(
                stream: firestoreService.getSavesStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData){
                    List savesList = snapshot.data!.docs;
                    return ListView.builder(
                        itemCount: savesList.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document = savesList[index];
                          String docID = document.id;

                          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                          String saveName = data['history'];

                          return ListTile(
                            title: Text(saveName),
                          );
                        });

                  }
                  else{
                    return const Text("no saves");
                  }
                }),
          )
        ]),

        ],
      ),
    );
  }
}
