import 'dart:convert';

import 'package:base_application/displayPages/game_page.dart';
import 'package:base_application/services/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
FirestoreService firestoreService = FirestoreService();

class StartupPage extends StatefulWidget {
  const StartupPage({super.key});

  @override
  State<StartupPage> createState() => StartupPageState();
}

class StartupPageState extends State<StartupPage> {
  final TextEditingController textController = TextEditingController();
  String displaySelectedSave = "Previous save (click save you want to load)";

  void grabSave (String docID) async{
     var start = await firestoreService.getSave(docID)as DocumentSnapshot;
     setState(() {
       displaySelectedSave = start['saveName'];
     });

  }
  void holdSave(String docID){
    print("the docID =  $docID");
  }

  void editSave(String docID){
    showDialog(context: context,
    builder: (context) => AlertDialog(
      content: TextField(
        controller: textController,
      ),
      actions: [
        ElevatedButton(onPressed: () {
          firestoreService.updateSave(docID, textController.text);

          textController.clear();

          Navigator.pop(context);}, child: const Text("Save"))
      ],
    ));
  }

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
          child: const Text("New Game")),

          TextButton(onPressed: () {}, child:
          Text("Continue with $displaySelectedSave"))

        ]),Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                              String saveName = data['saveName'];

                              return ListTile(
                                title: Text(saveName),
                                subtitle: Text("Saved on: ${DateFormat('yyyy-MM-dd HH:mm').format((data['timestamp'] as Timestamp).toDate())}",),
                                onTap: () => grabSave(docID),
                                trailing: IconButton(
                                onPressed: () => editSave(docID),
                                icon: const Icon(Icons.settings),
                              ));
                            });

                      }
                      else{
                        return const Text("no saves");
                      }
                    }),
              )

            ],
          )

        ],
      ),
    );
  }
}
