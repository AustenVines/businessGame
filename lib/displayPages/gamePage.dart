import 'package:flutter/material.dart';
import '../backend/businessFiles/businessClass.dart';
import '../backend/businessFiles/businessInteractions.dart';
import '../backend/cvsRipper.dart';
import '../backend/nodeFiles/node.dart';
import 'package:base_application/services/firestore.dart';

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
  String money = businessName.getMoney().toString();
  String interest = businessName.getInterest().toString();
  String stock = businessName.getStock().toString();
  String distasterPercent = businessName.getDisaster().toString(); // temp


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        Node? current = box.get(0);
        if (current != null) {
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

  void buttonHandler(int option) {
    setState(() {
      Node? nodeOption;
      int? amountOfMoney = 0;
      int? amountOfStock = 0;
      int? amountOfInterest = 0;
      int? amountOfDisaster = 0;
      if (option == 1) {
        nodeOption = box.get(optionA);
        amountOfMoney = box
            .get(0)
            ?.costOfOptionA;
        amountOfStock = 30;
        amountOfInterest = 30;
      } else if (option == 2) {
        nodeOption = box.get(optionB);
        amountOfMoney = box
            .get(0)
            ?.costOfOptionB;
        amountOfStock = 20;
        amountOfInterest = 20;
      } else {
        nodeOption = box.get(optionC);
        amountOfMoney = box
            .get(0)
            ?.costOfOptionC;
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
      distasterPercent = businessName.disasterPercent.toString();


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

  void toggleButtonsVisibility() {
    // for buttons once question is asked before
    setState(() {
      isButton1Visible = !isButton1Visible;
      isButton2Visible = !isButton2Visible;
      isButton3Visible = !isButton3Visible;
    });
  }


  void save(){
    print("saving");
    FirestoreService firestoreService = FirestoreService();
    firestoreService.addSave("second save");
    print("saved");

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
                    Text("disaster percentage: $distasterPercent%"),
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