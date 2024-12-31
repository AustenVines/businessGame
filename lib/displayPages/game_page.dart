import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../backend/businessFiles/business_class.dart';
import '../backend/businessFiles/business_interactions.dart';
import '../backend/csv_ripper.dart';
import '../backend/nodeFiles/node.dart';
import 'package:businessGameApp/services/firestore.dart';

Business businessName = Business();

Play active = Play();

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyFlutterState();
  }
}


class MyFlutterState extends State<GamePage> {


  late Node? currentNode = box.get(0);
  late int iD;
  late int optionA;
  late int optionB;
  late int optionC;
  String displayForQuestion = "";
  String displayForAnswer1 = "";
  String displayForAnswer2 = "";
  String displayForAnswer3 = "";
  int costOfOption = 0;
  late int? costOfOptionA = currentNode?.costOfOptionA;
  late int? costOfOptionB = currentNode?.costOfOptionB;
  late int? costOfOptionC = currentNode?.costOfOptionC;
  String money = 0.toString();
  String interest = businessName.getInterest().toString();
  String stock = businessName.getStock().toString();
  String disasterPercent = businessName.getDisaster().toString(); // temp

  @override
  void initState() {
    loadGame();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        Node? current = box.get(0);
        if (current != null) {
          businessName.currentNode = current.iD;
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
    });
  }
  void loadGame() async{
    FirestoreService firestoreService = FirestoreService();
    if(businessName.save == ""){

    }else{
      var currentSave = await firestoreService.getSave(businessName.save)as DocumentSnapshot;

      setState(() {
        money = currentSave['businessMoney'].toString();
        businessName.money = currentSave['businessMoney'];
        stock = currentSave['businessStock'].toString();
        businessName.stock = currentSave['businessStock'];
        interest = currentSave['businessInterest'].toString();
        businessName.interest = currentSave['businessInterest'];
        disasterPercent = currentSave['disasterPercent'].toString();
        businessName.disasterPercent = currentSave['disasterPercent'];
      });

    }

  }
  void buttonHandler(int option) {
    print("money after stuff :${businessName.money}");

    setState(() {
      Node? nodeOption;
      int? amountOfMoney = 0;
      int? amountOfStock = 0;
      int? amountOfInterest = 0;
      int? amountOfDisaster = 0;
      if (option == 1) {
        nodeOption = box.get(optionA);
        amountOfMoney = box.get(0)?.costOfOptionA;
        amountOfStock = 30;
        amountOfInterest = 30;
      } else if (option == 2) {
        nodeOption = box.get(optionB);
        amountOfMoney = box.get(0)?.costOfOptionB;
        amountOfStock = 20;
        amountOfInterest = 20;
      } else {
        nodeOption = box.get(optionC);
        amountOfMoney = box.get(0)?.costOfOptionC;
        amountOfStock = 10;
        amountOfInterest = 10;
      }
      active.editMoney(businessName, -amountOfMoney!);
      active.editInterest(businessName, amountOfInterest);
      active.editStock(businessName, amountOfStock);
      active.editDisasterPercent(businessName, amountOfDisaster);

      active.saleMaker(businessName);
      money = businessName.getMoney().toString();
      interest = businessName.getInterest().toString();
      stock = businessName.getStock().toString();
      disasterPercent = businessName.disasterPercent.toString();

      if (nodeOption != null) {
        businessName.currentNode = nodeOption.iD;
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

  void toggleButtonsVisibility() {
    // for buttons once question is asked before
    setState(() {
      isButton1Visible = !isButton1Visible;
      isButton2Visible = !isButton2Visible;
      isButton3Visible = !isButton3Visible;
    });
  }
  void save(){
    TextEditingController textController = TextEditingController();
    FirestoreService firestoreService = FirestoreService();
    showDialog(context: context,
        builder: (context) => AlertDialog(
          content: TextField(
            controller: textController,
          ),
          actions: [
            ElevatedButton(onPressed: () {
              print("current node = ${businessName.currentNode}");

              firestoreService.addSave(textController.text, businessName.currentNode, businessName.money, businessName.stock, businessName.interest, businessName.disasterPercent);

              textController.clear();

              Navigator.pop(context);}, child: const Text("Save"))
          ],
        ));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue, //style
        body:
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(displayForQuestion)
              ],), Row(
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
                      onPressed: () {
                        buttonHandler(1);
                      },
                      //
                      color: const Color(0xff3a21d9),
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      textColor: const Color(0xfffffdfd),
                      height: 40,
                      minWidth: 140,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
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
                        onPressed: () {
                          buttonHandler(2);
                        },
                        // buttonHandler(2);
                        color: const Color(0xff3a21d9),
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        textColor: const Color(0xfffffdfd),
                        height: 40,
                        minWidth: 140,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
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
                        save();
                        }, child: const Text("save")),
                      Text("optionDisplay3"),
                      Text(displayForAnswer3),
                      isButton3Visible ?
                      MaterialButton(
                        onPressed: () {
                          buttonHandler(3);
                        },
                        // buttonHandler(3);
                        color: const Color(0xff3a21d9),
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        textColor: const Color(0xfffffdfd),
                        height: 40,
                        minWidth: 140,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: const Text(
                          "option 3",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ): Container()
                    ],
                  ),
                ]
            ),
          ],)
    );
  }
}