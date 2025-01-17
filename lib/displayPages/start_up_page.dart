
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

  @override
  void initState() {
    super.initState();
    // Reset selectedSave whenever the page is loaded
    selectedSave = "";
  }

  void grabSave(String docID) async {
    try {
      var save = await firestoreService.getSave(docID) as DocumentSnapshot;
      setState(() {
        if (displaySelectedSave == save['saveName']) {
          displaySelectedSave = "Previous save (click save you want to load)";
        } else {
          displaySelectedSave = save['saveName'];
        }
      });
    } catch (e) {
      // Handle exception and log the error
      print("Error fetching save: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch save")),
      );
    }
  }

  void holdSave(String docID) {
    try {
      if (selectedSave == docID) {
        selectedSave = "";
      } else {
        selectedSave = docID;
      }
    } catch (e) {
      // Handle exception and log the error
      print("Error holding save: $e");
    }
  }

  void editSave(String docID) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              try {
                await firestoreService.updateSaveName(docID, textController.text);
                textController.clear();
                Navigator.pop(context);
              } catch (e) {
                print("Error updating save name: $e");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Failed to update save name")),
                );
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    double textSize = height/40;
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Stack(children: [
        Container(
          width: width,
          height: height,
          child: const DecoratedBox(decoration: BoxDecoration(
            image: DecorationImage(opacity: 0.2,
              image: AssetImage("assets/images/background.jpeg"),
              fit: BoxFit.cover,
            ),
          )),),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [

            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Text("Zero to Millions", style: TextStyle(fontSize: 100),)],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.lightBlue),
                  onPressed: () {
                    selectedSave = "";
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GamePage()),
                    );
                  },
                  child: Text("New Game"),
                ),
                TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.lightBlue),
                  onPressed: () {
                    if (selectedSave != "") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const GamePage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("No save selected", style: TextStyle(fontSize: textSize))),
                      );
                    }
                  },
                  child: Text("Continue with $displaySelectedSave", style: TextStyle(fontSize: textSize)),
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
                        return Center(
                          child: Text("Error loading saves", style: TextStyle(fontSize: textSize)),
                        );
                      }
                      if (snapshot.hasData) {
                        List<DocumentSnapshot> savesList = snapshot.data!.docs;

                        if (savesList.isEmpty) {
                          return Center(
                            child: Text("No saves", style: TextStyle(fontSize: textSize)),
                          );
                        }

                        return ListView.builder(
                          itemCount: savesList.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot document = savesList[index];
                            String docID = document.id;

                            try {
                              Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;
                              String saveName = data['saveName'];

                              return ListTile(
                                title: Text(saveName),
                                subtitle: Text(
                                  "Saved on: ${DateFormat('yyyy-MM-dd HH:mm').format((data['timestamp'] as Timestamp).toDate())}",
                                ),
                                onTap: () {
                                  grabSave(docID);
                                  holdSave(docID);
                                },
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () => editSave(docID),
                                      icon: const Icon(Icons.settings),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        try {
                                          selectedSave = "";
                                          await firestoreService.deleteSave(docID);
                                        } catch (e) {
                                          print("Error deleting save: $e");
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                                content: Text(
                                                    "Failed to delete save")),
                                          );
                                        }
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              );
                            } catch (e) {
                              print("Error processing document: $e");
                              return const ListTile(
                                title: Text("Error loading save"),
                              );
                            }
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
      ],)
    );
  }
}

