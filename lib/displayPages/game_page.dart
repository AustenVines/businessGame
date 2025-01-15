
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:businessGameApp/displayPages/start_up_page.dart';
import 'package:businessGameApp/services/firestore.dart';
import 'package:flutter/material.dart';
import '../backend/businessFiles/business_class.dart';
import '../backend/csv_ripper.dart';
import '../backend/nodeFiles/node.dart';

FirestoreService firestoreService = FirestoreService();
BusinessGame playersBusiness = BusinessGame(0,0,0,25,0,0);

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return GamePageState();
  }
}

class GamePageState extends State<GamePage> {
  final audioPlayer = AudioPlayer();

  late Node? currentNode = box.get(0);
  late int iD;
  late int optionA;
  late int optionB;
  late int optionC;
  String displayForQuestion = "";
  String displayForAnswer1 = "";
  String displayForAnswer2 = "";
  String displayForAnswer3 = "";
  int? costOfOptionA;
  int? costOfOptionB;
  int? costOfOptionC;
  String money = "";
  String interest = "";
  String stock = "";
  String maxStock = "";
  String disasterPercent = "";
  String imageA = "";
  String imageB = "";
  String imageC = "";
  int nodeID = playersBusiness.getCurrentNode();
  String showSaleAmount = "";
  bool saleBool = false;
  bool isVisible = true;
  bool canPress = true;
  bool isButtonAVisible = true;
  bool isButtonBVisible = true;
  bool isButtonCVisible = true;
  String changeInMoneyA = "";
  String changeInMoneyB = "";
  String changeInMoneyC = "";
  String changeInStockA = "";
  String changeInStockB = "";
  String changeInStockC = "";
  String changeInInterestA = "";
  String changeInInterestB = "";
  String changeInInterestC = "";


  @override

  void initState() {
    super.initState();
    updateValues();

    WidgetsBinding.instance.addPostFrameCallback((_) {
    });
  }
  void playAudio(){
    String audioPath = "assets/sounds/sale.mp3";
    audioPlayer.play(audioPath, isLocal: true);
  }
  void updateValues() async{

    await playersBusiness.load(selectedSave);

    setState(()  {
      isVisible = true;
      canPress = true;
      money = playersBusiness.getMoney().toString();
      interest = playersBusiness.getInterest().toString();
      stock = playersBusiness.getStock().toString();
      maxStock = playersBusiness.getMaxStock().toString();
      disasterPercent = playersBusiness.getDisaster().toString();
      nodeID = playersBusiness.getCurrentNode();

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

    toggleButtonsVisibility();
  }
  void resetAnimation() {
    setState(() {
      saleBool = false;
      isVisible = true;
      showSaleAmount = "";
    });
  }

  Future<void> sales()async {
    int sale = playersBusiness.decisionMade();
    if (sale != 0){
      playAudio();
      setState(() {
        showSaleAmount = sale.toString();
        saleBool = true;
        isVisible = false;
      });
      await Future.delayed(const Duration(seconds: 2));
      resetAnimation();
    }
    playersBusiness.disasterChance();
  }

  void disableButton(){
    setState(() {
      canPress = false;
    });
    Timer(
        const Duration(seconds: 1), () => setState(() {
      canPress = true;
    })
    );
  }

  void resetValues(){
    playersBusiness.reset();
    money = playersBusiness.getMoney().toString();
    interest = playersBusiness.getInterest().toString();
    stock = playersBusiness.getStock().toString();
    maxStock = playersBusiness.getMaxStock().toString();
    disasterPercent = playersBusiness.getDisaster().toString();

  }

  Future<void> buttonHandler(int option) async{
    setState(()  {
      Node? nodeOption;
      int? amountOfMoney = 0;
      int? amountOfStock = 0;
      double? amountOfInterest = 0;
      double? amountOfDisaster = 0;
      int? newNodeId;
      if (option == 1) {
        newNodeId = optionA;
        nodeOption = box.get(optionA);
        amountOfMoney = box.get(nodeID)?.costOfOptionA;
        amountOfStock = box.get(nodeID)?.stockOfOptionA;
        amountOfInterest = box.get(nodeID)?.interestOfOptionA as double?;
        amountOfDisaster = box.get(nodeID)?.disasterOfOptionA as double?;
        if (box.get(nodeID)!.answerA.toLowerCase().contains("stolen")){
          if (playersBusiness.chanceToBeCaught() <= 50){
            nodeOption = box.get(17);
            nodeID = 17;
          }
        }

      } else if (option == 2) {
        newNodeId = optionB;
        nodeOption = box.get(optionB);
        amountOfMoney = box.get(nodeID)?.costOfOptionB;
        amountOfStock = box.get(nodeID)?.stockOfOptionB;
        amountOfInterest = box.get(nodeID)?.interestOfOptionB as double?;
        amountOfDisaster = box.get(nodeID)?.disasterOfOptionB as double?;
        if (box.get(nodeID)!.answerB.toLowerCase().contains("stolen")){
          if (playersBusiness.chanceToBeCaught() <= 50){
            nodeOption = box.get(17);
            nodeID = 17;
          }
        }

      } else {
        newNodeId = optionC;
        nodeOption = box.get(optionC);
        amountOfMoney = box.get(nodeID)?.costOfOptionC;
        amountOfStock = box.get(nodeID)?.stockOfOptionC;
        amountOfInterest = box.get(nodeID)?.interestOfOptionC as double?;
        amountOfDisaster = box.get(nodeID)?.disasterOfOptionC as double?;
        if (box.get(nodeID)!.answerC.toLowerCase().contains("stolen")){
          if (playersBusiness.chanceToBeCaught() <= 100){
            nodeOption = box.get(17);
            newNodeId = 17;
          }
        }
      }

      playersBusiness.setNode(newNodeId);
      playersBusiness.decreaseMoney(amountOfMoney!);
      playersBusiness.editInterest(amountOfInterest!);
      playersBusiness.editStock(amountOfStock!);
      playersBusiness.editDisasterPercent(amountOfDisaster!);

      sales();

      money = playersBusiness.getMoney().toString();
      interest = playersBusiness.getInterest().toString();
      stock = playersBusiness.getStock().toString();
      maxStock = playersBusiness.getMaxStock().toString();
      disasterPercent = playersBusiness.getDisaster().toString();
      nodeID = playersBusiness.getCurrentNode();

      if (playersBusiness.endGame() == true){
        nodeOption = box.get(18);
        newNodeId = 18;
        nodeID = 18;
        resetValues();
      }


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
        currentNode = nodeOption;
      }
    });
    toggleButtonsVisibility();
  }

  void toggleButtonsVisibility() {

    setState(() {
      int aVisible = box.get(nodeID)!.optionA;
      int bVisible = box.get(nodeID)!.optionB;
      int cVisible = box.get(nodeID)!.optionC;
      if(aVisible < 0){
        isButtonAVisible = false;
      }else{
        isButtonAVisible = true;
      }
      if(bVisible < 0){
        isButtonBVisible = false;
      }else{
        isButtonBVisible = true;
      }
      if (cVisible < 0){
        isButtonCVisible = false;
      }else{
        isButtonCVisible = true;
      }
    });
  }

  void saveGame(){
    if(selectedSave == ""){
      TextEditingController textController = TextEditingController();
      showDialog(context: context,
          builder: (context) =>
              AlertDialog(
                content: TextField(
                  controller: textController,
                ),
                actions: [
                  ElevatedButton(onPressed: () async {
                    firestoreService.addSave(textController.text, playersBusiness.getCurrentNode(), playersBusiness.getMoney(),
                        playersBusiness.getStock(),playersBusiness.getMaxStock(), playersBusiness.getInterest(), playersBusiness.getDisaster());
                    String? lastSaveId = await firestoreService.getLastSaveId();
                    textController.clear();
                    selectedSave = lastSaveId!;
                    Navigator.pop(context);
                  }, child: const Text("Save"))
                ],
              ));
    }else{
      firestoreService.updateSave(selectedSave, playersBusiness.getCurrentNode(), playersBusiness.getMoney(), playersBusiness.getStock(),
          playersBusiness.getMaxStock(), playersBusiness.getInterest(), playersBusiness.getDisaster());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
            children: [
              Align(alignment: const Alignment(0.0, -0.2),
                  child: Container(
                    width: 1000,
                    height: 600,
                    color: Colors.grey,
                    child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Container(color: Colors.grey,
                            child: Text(displayForQuestion),
                          )],),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              color: Colors.blue,
                              width: 100,
                              height: 100,
                              child: Column(children: [
                                Text(displayForAnswer1),
                                MaterialButton(
                                  onPressed: canPress ? () async {await buttonHandler(1);
                                  disableButton();} : null,
                                  color: const Color(0xff3a21d9),
                                  elevation: 0,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),//
                                  child: const Text("Option A"),
                                )
                              ]
                              ),
                            ),
                            isButtonBVisible ?
                            Container(
                              color: Colors.blue,
                              width: 100,
                              height: 100,
                              child: Column(children: [
                                Text(displayForAnswer2),
                                MaterialButton(
                                  onPressed:canPress ? () async {await buttonHandler(2);
                                  disableButton();} : null,
                                  color: const Color(0xff3a21d9),
                                  elevation: 0,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),//
                                  child: const Text("Option B"),
                                )
                              ]
                              ),
                            ) : Container(),
                            isButtonCVisible ?
                            Container(
                              color: Colors.blue,
                              width: 100,
                              height: 100,
                              child: Column(children: [
                                Text(displayForAnswer3),
                                MaterialButton(
                                  onPressed: canPress ? () async {await buttonHandler(3);
                                  disableButton();} : null,
                                  color: const Color(0xff3a21d9),
                                  elevation: 0,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),//
                                  child: const Text("Option C"),
                                )
                              ]
                              ),
                            ) : Container(),
                          ],),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              color: Colors.purple,
                              width: 100,
                              height: 300,
                              child: const DecoratedBox(decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage("assets/images/background.jpeg"),
                              fit: BoxFit.cover,
                              ),
                              ),
                              )
                            ),
                            Container(
                              color: Colors.purple,
                              width: 100,
                              height: 300,
                            ),
                            Container(
                              color: Colors.purple,
                              width: 100,
                              height: 300,
                            ),
                          ],),
                      ],
                    ),
                  )
              ),
              Align(
                alignment: const Alignment(0, -0.99),
                child: Container(
                  width: 1000,
                  height: 50,
                  color: Colors.green,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            color: Colors.cyanAccent,
                            child: Text("Money £$money"),

                          ),
                          Container(
                            color: Colors.cyanAccent,
                            child: Column(children: [
                              Text("Stock: $stock"),
                              Text("Maximum stock: $maxStock"),
                            ],)
                          ),
                          Container(
                            color: Colors.cyanAccent,
                            child: Text("Interest: $interest"),
                          ),
                          Container(
                            color: Colors.cyanAccent,
                            child: MenuItemButton(
                              onPressed: (){saveGame();},
                              child: const Text("Menu"),
                            ),
                          ),
                        ],)
                    ],
                  ),
                ),
              ),
              Align(
                  alignment: const Alignment(-0.9, 0.45),
                  child: Container(
                    color: Colors.red,
                    width: 60,
                    height: 400,
                    child: AnimatedOpacity(opacity: isVisible ? 1.0 : 0.0, duration: const Duration(seconds: 2),
                      child: AnimatedAlign(alignment: saleBool ? Alignment.topCenter : Alignment.bottomCenter,
                        curve: Curves.linearToEaseOut,
                        duration: const Duration(seconds: 3),
                        child: Text(showSaleAmount),),
                    ),
                  ))
            ]
        )
    );

  }
}



//     return Scaffold(
//         body:
//          DecoratedBox(decoration: const BoxDecoration(
//           image: DecorationImage(image: AssetImage("assets/images/background.jpeg"),
//             fit: BoxFit.cover,
//           ),
//         ),child: Column(
//           children: [
//             Row(
//
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//
//                 Text(displayForQuestion)
//               ],),Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [Column(
//                   children: [
//                     Text("Money: £${loadedGame.getMoney(playersBusiness).toString()}"),
//                     Text("interest percentage: $interest%"),
//                     Text("Stock level: $stock"),
//                     Text("disaster percentage: $disasterPercent%"),
//                     Text("optionDisplay1"),
//
//                     Text(displayForAnswer1),
//                     isButton1Visible ?
//                     MaterialButton(
//                       onPressed: () async {await buttonHandler(1);},//
//                       color: const Color(0xff3a21d9),
//                       elevation: 0,
//                       shape: const RoundedRectangleBorder(
//                         borderRadius: BorderRadius.zero,
//                       ),
//                       textColor: const Color(0xfffffdfd),
//                       height: 40,
//                       minWidth: 140,
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                       child: const Text(
//                         "option 1",
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w400,
//                           fontStyle: FontStyle.normal,
//                         ),
//                       ),
//                     )
//                         : Container(),
//                   ],
//                 ),
//                   Column(
//                     children: [
//                       Text("optionDisplay2"),
//                       Text(displayForAnswer2),
//                       isButton2Visible ?
//                       MaterialButton(
//                         onPressed: () async {await buttonHandler(2);}, // buttonHandler(2);
//                         color: const Color(0xff3a21d9),
//                         elevation: 0,
//                         shape: const RoundedRectangleBorder(
//                           borderRadius: BorderRadius.zero,
//                         ),
//                         textColor: const Color(0xfffffdfd),
//                         height: 40,
//                         minWidth: 140,
//                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                         child: const Text(
//                           "option 2",
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w400,
//                             fontStyle: FontStyle.normal,
//                           ),
//                         ),
//                       )
//                           : Container(),
//                     ],
//
//                   ),
//                   Column(
//                     children: [
//                       TextButton(onPressed: () {
//                         saveGame();
//                       }, child: const Text("Save Game")),
//                       Text("optionDisplay3"),
//                       Text(displayForAnswer3),
//                       isButton3Visible ?
//                       MaterialButton(
//                         onPressed: () async {await buttonHandler(3);}, // buttonHandler(3);
//                         color: const Color(0xff3a21d9),
//                         elevation: 0,
//                         shape: const RoundedRectangleBorder(
//                           borderRadius: BorderRadius.zero,
//                         ),
//                         textColor: const Color(0xfffffdfd),
//                         height: 40,
//                         minWidth: 140,
//                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                         child: const Text(
//                           "option 3",
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w400,
//                             fontStyle: FontStyle.normal,
//                           ),
//                         ),
//                       )
//                           : Container(),
//                     ],
//                   ),
//
//                 ]
//             ),
//             Container(
//               height: 25,
//               width: 10,
//               alignment: Alignment.bottomLeft,
//               padding: const EdgeInsets.all(40.0),
//               color: Colors.black,
//             )
//           ],
//          ),
//
//         ),
//
//
//
//     );
//
//   }
// }

