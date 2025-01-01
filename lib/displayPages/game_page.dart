
import 'package:businessGameApp/backend/businessFiles/business_interactions.dart';
import 'package:businessGameApp/displayPages/start_up_page.dart';
import 'package:flutter/material.dart';
import '../backend/businessFiles/business_class.dart';
import '../backend/csv_ripper.dart';
import '../backend/nodeFiles/node.dart';

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
  int costOfOption = 0;
  late int? costOfOptionA = currentNode?.costOfOptionA;
  late int? costOfOptionB = currentNode?.costOfOptionB;
  late int? costOfOptionC = currentNode?.costOfOptionC;
  String money = loadedGame.getMoney(playersBusiness).toString();
  String interest = loadedGame.getInterest(playersBusiness).toString();
  String stock = loadedGame.getStock(playersBusiness).toString();
  String disasterPercent = loadedGame.getDisaster(playersBusiness).toString(); // temp

  @override
  void initState()  {
    super.initState();
    loadedGame.load(playersBusiness, selectedSave);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        Node? current = box.get(0);
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
    });
  }
  void buttonHandler(int option) {
    setState(() {
      Node? nodeOption;
      int? amountOfMoney = 0;
      int? amountOfStock = 0;
      double? amountOfInterest = 0;
      double? amountOfDistaster = 0;
      if (option == 1) {
        nodeOption = box.get(optionA);
        amountOfMoney = box.get(0)?.costOfOptionA;
        amountOfStock = 3;
        amountOfInterest = 3;
      } else if (option == 2) {
        nodeOption = box.get(optionB);
        amountOfMoney = box.get(0)?.costOfOptionB;
        amountOfStock = 2;
        amountOfInterest = 2;
      } else {
        nodeOption = box.get(optionC);
        amountOfMoney = box.get(0)?.costOfOptionC;
        amountOfStock = 1;
        amountOfInterest = 1;
      }
      loadedGame.decreaseMoney(playersBusiness, amountOfMoney!);
      loadedGame.editInterest(playersBusiness, amountOfInterest);
      loadedGame.editStock(playersBusiness, amountOfStock);
      loadedGame.editDisaster(playersBusiness, amountOfDistaster);


      loadedGame.saleMaker(playersBusiness);
      money = loadedGame.getMoney(playersBusiness).toString();
      interest = playersBusiness.getInterest().toString();
      stock = playersBusiness.getStock().toString();
      disasterPercent = playersBusiness.disasterPercent.toString();


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