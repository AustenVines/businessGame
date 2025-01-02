
import 'package:businessGameApp/backend/businessFiles/business_interactions.dart';
import 'package:businessGameApp/displayPages/start_up_page.dart';
import 'package:businessGameApp/services/firestore.dart';
import 'package:flutter/material.dart';
import '../backend/businessFiles/business_class.dart';
import '../backend/csv_ripper.dart';
import '../backend/nodeFiles/node.dart';
FirestoreService firestoreService = FirestoreService();
BusinessGame playersBusiness = BusinessGame(0, 0, 0, 0, 0);
Play loadedGame = Play();

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return GamePageState();
  }
}

class GamePageState extends State<GamePage> {
  late Node? currentNode = box.get(0);
  late int iD;
  late int optionA;
  late int optionB;
  late int optionC;
  String displayForQuestion = "";
  String displayForAnswer1 = "";
  String displayForAnswer2 = "";
  String displayForAnswer3 = "";
  late int? costOfOptionA = currentNode?.costOfOptionA;
  late int? costOfOptionB = currentNode?.costOfOptionB;
  late int? costOfOptionC = currentNode?.costOfOptionC;
  String money = "";
  String interest = "";
  String stock = "";
  String disasterPercent = "";
  int nodeID = loadedGame.getNode(playersBusiness);


  @override

  void initState() {
    super.initState();

    updateValues();

    WidgetsBinding.instance.addPostFrameCallback((_) {
    });
  }

  void updateValues() async{
    await loadedGame.load(playersBusiness, selectedSave);

    setState(()  {
      money = loadedGame.getMoney(playersBusiness).toString();
      interest = loadedGame.getInterest(playersBusiness).toString();
      stock = loadedGame.getStock(playersBusiness).toString();
      disasterPercent = loadedGame.getDisaster(playersBusiness).toString();
      nodeID = loadedGame.getNode(playersBusiness);

      Node? current = box.get(nodeID);
      if(current != null) {
        iD = current.iD;
        optionA = current.optionA;
        optionB = current.optionB;
        optionC = current.optionC;
        displayForQuestion = current.displayText;
        displayForAnswer1 = current.answerA;
        displayForAnswer2 = current.answerB;
        displayForAnswer3 = current.answerC;
        costOfOptionA = current.costOfOptionA;
        costOfOptionB = current.costOfOptionB;
        costOfOptionC = current.costOfOptionC;
      }

    });
  }
  void buttonHandler(int option) {
    setState(() {
      Node? nodeOption;
      int? amountOfMoney = 0;
      int? amountOfStock = 0;
      double? amountOfInterest = 0;
      double? amountOfDisaster = 0;
      int? newNodeId = 0;
      if (option == 1) {
        nodeOption = box.get(optionA);
        amountOfMoney = box.get(0)?.costOfOptionA;
        amountOfStock = 3;
        amountOfInterest = 3;
        newNodeId = optionA;
      } else if (option == 2) {
        nodeOption = box.get(optionB);
        amountOfMoney = box.get(0)?.costOfOptionB;
        amountOfStock = 2;
        amountOfInterest = 2;
        newNodeId = optionB;
      } else {
        nodeOption = box.get(optionC);
        amountOfMoney = box.get(0)?.costOfOptionC;
        amountOfStock = 1;
        amountOfInterest = 1;
        newNodeId = optionB;
      }
      loadedGame.setCurrentNode(playersBusiness, newNodeId);
      loadedGame.decreaseMoney(playersBusiness, amountOfMoney!);
      loadedGame.editInterest(playersBusiness, amountOfInterest);
      loadedGame.editStock(playersBusiness, amountOfStock);
      loadedGame.editDisaster(playersBusiness, amountOfDisaster);
      money = loadedGame.getMoney(playersBusiness).toString();
      interest = loadedGame.getInterest(playersBusiness).toString();
      stock = loadedGame.getStock(playersBusiness).toString();
      disasterPercent = loadedGame.getDisaster(playersBusiness).toString();
      nodeID = loadedGame.getNode(playersBusiness);

      loadedGame.saleMaker(playersBusiness);
      if (nodeOption != null) {
        iD = nodeOption.iD;
        optionA = nodeOption.optionA;
        optionB = nodeOption.optionB;
        optionC = nodeOption.optionC;
        displayForQuestion = nodeOption.displayText;
        displayForAnswer1 = nodeOption.answerA;
        displayForAnswer2 = nodeOption.answerB;
        displayForAnswer3 = nodeOption.answerC;
        costOfOptionA = nodeOption.costOfOptionA;
        costOfOptionB = nodeOption.costOfOptionB;
        costOfOptionC = nodeOption.costOfOptionC;

      }
    });
  }

  bool isButton1Visible = true;
  bool isButton2Visible = true;
  bool isButton3Visible = true;

  void toggleButtonsVisibility() {// for buttons once question is asked before
    setState(() {
      isButton1Visible = !isButton1Visible;
      isButton2Visible = !isButton2Visible;
      isButton3Visible = !isButton3Visible;
    });
  }

  void saveGame(){
    print("save name = ${loadedGame.getSaveName(playersBusiness)}");
    if(loadedGame.getSaveName(playersBusiness) == ""){
      TextEditingController textController = TextEditingController();
      showDialog(context: context,
          builder: (context) =>
              AlertDialog(
                content: TextField(
                  controller: textController,
                ),
                actions: [
                  ElevatedButton(onPressed: () async {
                    firestoreService.addSave(textController.text, loadedGame.getNode(playersBusiness), loadedGame.getMoney(playersBusiness),
                        loadedGame.getStock(playersBusiness), loadedGame.getInterest(playersBusiness), loadedGame.getDisaster(playersBusiness));
                    String? lastSaveId = await firestoreService.getLastSaveId();
                    loadedGame.setSaveName(playersBusiness, lastSaveId);
                    textController.clear();
                    selectedSave = lastSaveId!;
                    Navigator.pop(context);
                  }, child: const Text("Save"))
                ],
              ));
      print("object");

    }else{
      print("update save");
      firestoreService.updateSave(selectedSave, loadedGame.getNode(playersBusiness), loadedGame.getMoney(playersBusiness), loadedGame.getStock(playersBusiness),
          loadedGame.getInterest(playersBusiness), loadedGame.getDisaster(playersBusiness));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff3e87c5),
        body:
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(displayForQuestion)
              ],),Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Column(
                  children: [
                    Text("Money: £$money"),
                    Text("interest percentage: $interest%"),
                    Text("Stock level: $stock"),
                    Text("disaster percentage: $disasterPercent%"),
                    Text("optionDisplay1"),
                    Text(displayForAnswer1),
                    isButton1Visible ?
                    MaterialButton(
                      onPressed: () {buttonHandler(1);},//
                      color: const Color(0xff3a21d9),
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      textColor: const Color(0xfffffdfd),
                      height: 40,
                      minWidth: 140,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: const Text(
                        "option 1",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    )
                        : Container(),
                  ],
                ),
                  Column(
                    children: [
                      Text("optionDisplay2"),
                      Text(displayForAnswer2),
                      isButton2Visible ?
                      MaterialButton(
                        onPressed: () {buttonHandler(2);}, // buttonHandler(2);
                        color: const Color(0xff3a21d9),
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        textColor: const Color(0xfffffdfd),
                        height: 40,
                        minWidth: 140,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: const Text(
                          "option 2",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      )
                          : Container(),
                    ],
                  ),
                  Column(
                    children: [
                      TextButton(onPressed: () {
                        saveGame();
                      }, child: const Text("Save Game")),
                      Text("optionDisplay3"),
                      Text(displayForAnswer3),
                      isButton3Visible ?
                      MaterialButton(
                        onPressed: () {buttonHandler(3);}, // buttonHandler(3);
                        color: const Color(0xff3a21d9),
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        textColor: const Color(0xfffffdfd),
                        height: 40,
                        minWidth: 140,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: const Text(
                          "option 3",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      )
                          : Container(),
                    ],
                  ),
                ]
            ),
          ],)
    );

  }
}