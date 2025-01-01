import 'package:businessGameApp/displayPages/game_page.dart';
import 'package:businessGameApp/services/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String selectedSave = "";
FirestoreService firestoreService = FirestoreService();

class StartupPage extends StatefulWidget {
  const StartupPage({super.key});

  @override
  State<StartupPage> createState() => StartupPageState();
}

class StartupPageState extends State<StartupPage> {
  final TextEditingController textController = TextEditingController();
  String displaySelectedSave = "Previous save (click save you want to load)";

  void grabSave(String docID) async {
    var save = await firestoreService.getSave(docID) as DocumentSnapshot;
    setState(() {
      if (displaySelectedSave == save['saveName']){
        displaySelectedSave = "Previous save (click save you want to load)";
      }else{
        displaySelectedSave = save['saveName'];
      }

    });
  }

  void holdSave(String docID) {
    if (selectedSave == docID){
      selectedSave = "";
    }else{
      selectedSave = docID;
    }


  }

  void editSave(String docID) {
    showDialog(context: context,
        builder: (context) =>
            AlertDialog(
              content: TextField(
                controller: textController,
              ),
              actions: [
                ElevatedButton(onPressed: () {
                  firestoreService.updateSave(docID, textController.text);

                  textController.clear();

                  Navigator.pop(context);
                }, child: const Text("Save"))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Text("Zero to Millions")],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  selectedSave = "";
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GamePage()),
                  );
                },
                child: const Text("New Game"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const GamePage()));
                },
                child: Text("Continue with $displaySelectedSave"),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: StreamBuilder<QuerySnapshot>(
                  stream: firestoreService.getSavesStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Error loading saves"),
                      );
                    }
                    if (snapshot.hasData) {
                      List<DocumentSnapshot> savesList = snapshot.data!.docs;

                      // Check if the list is empty
                      if (savesList.isEmpty) {
                        return const Center(
                          child: Text("No saves"),
                        );
                      }

                      // Display the list of saves
                      return ListView.builder(
                        itemCount: savesList.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot document = savesList[index];
                          String docID = document.id;

                          Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                          String saveName = data['saveName'];

                          return ListTile(
                            title: Text(saveName),
                            subtitle: Text(
                              "Saved on: ${DateFormat('yyyy-MM-dd HH:mm')
                                  .format(
                                  (data['timestamp'] as Timestamp).toDate())}",
                            ),
                            onTap: () {
                              grabSave(docID);
                              holdSave(docID);
                            },
                            trailing: IconButton(
                              onPressed: () => editSave(docID),
                              icon: const Icon(Icons.settings),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Text("No saves"),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
