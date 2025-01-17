
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
  void playAudio(int number){
    String localSound = "assets/sounds/sale.mp3";
    String localSound1 = "assets/sounds/button.mp3";
    if(number == 0){
      audioPlayer.play(localSound, isLocal: true);
    }else if(number == 1){
      audioPlayer.play(localSound1, isLocal: true);
    }

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
        if(current.costOfOptionA < 0){
          changeInMoneyA = "£+${0-current.costOfOptionA}";
        }else{
          changeInMoneyA = "£-${current.costOfOptionA}";
        }
        if(current.costOfOptionB < 0){
          changeInMoneyB = "£+${0-current.costOfOptionB}";
        }else{
          changeInMoneyC = "£-${current.costOfOptionC}";
        }
        if(current.costOfOptionC < 0){
          changeInMoneyC = "£+${0-current.costOfOptionC}";
        }else{
          changeInMoneyC = "£-${current.costOfOptionC}";
        }
        if(current.stockOfOptionA > 100){
          changeInStockA = "+${current.stockOfOptionA - 100} Stock capacity";
        }else{
          changeInStockA = "+${current.stockOfOptionA} stock";
        }
        if(current.stockOfOptionB > 100){
          changeInStockB = "+${current.stockOfOptionB - 100} Stock capacity";
        }else{
          changeInStockB = "+${current.stockOfOptionB} stock";
        }
        if(current.stockOfOptionC > 100){
          changeInStockC = "+${current.stockOfOptionC - 100} Stock capacity";
        }else{
          changeInStockC = "+${current.stockOfOptionC} stock";
        }
        changeInInterestA = "+${current.interestOfOptionA} interest";
        changeInInterestB = "+${current.interestOfOptionB} interest";
        changeInInterestC = "+${current.interestOfOptionC} interest";
        imageA = current.imageForOptionA;
        imageB = current.imageForOptionB;
        int imageCLength = current.imageForOptionC.length;
        imageC = current.imageForOptionC.substring(0,imageCLength -1);

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
      playAudio(0);
      setState(() {
        showSaleAmount = "£${sale.toString()}";
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
    playAudio(1);
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
            resetValues();
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
          if (playersBusiness.chanceToBeCaught() <= 50){
            nodeOption = box.get(17);
            newNodeId = 17;
            resetValues();
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

      if(playersBusiness.winGame() == true){
        nodeOption = box.get(20);
        newNodeId = 20;
        nodeID = 20;
        resetValues();
      }
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

        if(nodeOption.costOfOptionA < 0){
          changeInMoneyA = "£+${0-nodeOption.costOfOptionA}";
        }else{
          changeInMoneyA = "£-${nodeOption.costOfOptionA}";
        }
        if(nodeOption.costOfOptionB < 0){
          changeInMoneyB = "£+${0-nodeOption.costOfOptionB}";
        }else{
          changeInMoneyC = "£-${nodeOption.costOfOptionC}";
        }
        if(nodeOption.costOfOptionC < 0){
          changeInMoneyC = "£+${0-nodeOption.costOfOptionC}";
        }else{
          changeInMoneyC = "£-${nodeOption.costOfOptionC}";
        }
        if(nodeOption.stockOfOptionA > 100){
          changeInStockA = "+${nodeOption.stockOfOptionA - 100} Stock capacity";
        }else{
          changeInStockA = "+${nodeOption.stockOfOptionA} stock";
        }
        if(nodeOption.stockOfOptionB > 100){
          changeInStockB = "+${nodeOption.stockOfOptionB - 100} Stock capacity";
        }else{
          changeInStockB = "+${nodeOption.stockOfOptionB} stock";
        }
        if(nodeOption.stockOfOptionC > 100){
          changeInStockC = "+${nodeOption.stockOfOptionC - 100} Stock capacity";
        }else{
          changeInStockC = "+${nodeOption.stockOfOptionC} stock";
        }

        changeInInterestA = "+${nodeOption.interestOfOptionA} interest";
        changeInInterestB = "+${nodeOption.interestOfOptionB} interest";
        changeInInterestC = "+${nodeOption.interestOfOptionC} interest";
        imageA = nodeOption.imageForOptionA;
        imageB = nodeOption.imageForOptionB;
        int imageCLength = nodeOption.imageForOptionC.length;
        imageC = nodeOption.imageForOptionC.substring(0,imageCLength -1);
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
                  }, child: const Text("Save", style: TextStyle(fontSize: 15)))
                ],
              ));
    }else{
      firestoreService.updateSave(selectedSave, playersBusiness.getCurrentNode(), playersBusiness.getMoney(), playersBusiness.getStock(),
          playersBusiness.getMaxStock(), playersBusiness.getInterest(), playersBusiness.getDisaster());
    }
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    double textSize = height/40;
    return Scaffold(
        body: Stack(
            children: [
              Container(
                width: width,
                height: height,
                child: const DecoratedBox(decoration: BoxDecoration(
        image: DecorationImage(opacity: 0.2,
          image: AssetImage("assets/images/background.jpeg"),
      fit: BoxFit.cover,
    ),
    )),),
              Align(alignment: const Alignment(0.0, -0.2),
                  child: Container(
                    width: width,
                    height: height,
                    child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                // color: Colors.purple,
                            width: width,
                            height: height/6,
                            child: Align(alignment: const Alignment(0, 1),
                            child: Text(displayForQuestion , style: TextStyle(fontSize: textSize)),)

                          )],),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              color: Colors.blue,
                              width: width/4,
                              height: height/5,
                              child: Column(children: [
                                Text(displayForAnswer1, style: TextStyle(fontSize: textSize)),
                                MaterialButton(
                                  onPressed: canPress ? () async {await buttonHandler(1);
                                  disableButton();} : null,
                                  color: const Color(0xff3a21d9),
                                  elevation: 0,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),//
                                  child: Text("Option A", style: TextStyle(fontSize: textSize)),
                                ),
                                Text(changeInMoneyA, style: TextStyle(fontSize: textSize)),
                                Text(changeInStockA, style: TextStyle(fontSize: textSize)),
                                Text(changeInInterestA, style: TextStyle(fontSize: textSize))
                              ]
                              ),
                            ),
                            isButtonBVisible ?
                            Container(
                              color: Colors.blue,
                              width: width/4,
                              height: height/5,
                              child: Column(children: [
                                Text(displayForAnswer2, style: TextStyle(fontSize: textSize)),
                                MaterialButton(
                                  onPressed:canPress ? () async {await buttonHandler(2);
                                  disableButton();} : null,
                                  color: const Color(0xff3a21d9),
                                  elevation: 0,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),//
                                  child: Text("Option B", style: TextStyle(fontSize: textSize)),
                                ),
                                Text(changeInMoneyB, style: TextStyle(fontSize: textSize)),
                                Text(changeInStockB, style: TextStyle(fontSize: textSize)),
                                Text(changeInInterestB, style: TextStyle(fontSize: textSize))
                              ]
                              ),
                            ) : Container(),
                            isButtonCVisible ?
                            Container(
                              color: Colors.blue,
                              width: width/4,
                              height: height/5,
                              child: Column(children: [
                                Text(displayForAnswer3, style: TextStyle(fontSize: textSize)),
                                MaterialButton(
                                  onPressed: canPress ? () async {await buttonHandler(3);
                                  disableButton();} : null,
                                  color: const Color(0xff3a21d9),
                                  elevation: 0,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),//
                                  child: Text("Option C", style: TextStyle(fontSize: textSize)),
                                ),
                                Text(changeInMoneyC, style: TextStyle(fontSize: textSize)),
                                Text(changeInStockC, style: TextStyle(fontSize: textSize)),
                                Text(changeInInterestC, style: TextStyle(fontSize: textSize))
                              ]
                              ),
                            ) : Container(),
                          ],),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              color: Colors.purple,
                              width: width/4,
                              height: width/4,

                              child:DecoratedBox(decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage(imageA),
                              fit: BoxFit.cover,
                              ),
                              ),
                              )
                            ),
                            isButtonBVisible ?
                            Container(
                              color: Colors.purple,
                                width: width/4,
                                height: width/4,
                                child:DecoratedBox(decoration: BoxDecoration(
                                  image: DecorationImage(image: AssetImage(imageB),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                )
                            ) : Container(),
                            isButtonCVisible ?
                            Container(
                              color: Colors.purple,
                                width: width/4,
                                height: width/4,
                                child:DecoratedBox(decoration: BoxDecoration(
                                  image: DecorationImage(image: AssetImage(imageC),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                )
                            ) : Container(),
                          ],),
                      ],
                    ),
                  )
              ),
              Align(
                alignment: const Alignment(0, -0.99),
                child: Container(
                  width: width,
                  height: height/10,
                  // color: Colors.green,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            // color: Colors.cyanAccent,
                            child: Text("Money £$money", style: TextStyle(fontSize: textSize)),

                          ),
                          Container(
                            // color: Colors.cyanAccent,
                            child: Column(children: [
                              Text("Stock: $stock"),
                              Text("Maximum stock: $maxStock", style: TextStyle(fontSize: textSize)),
                            ],)
                          ),
                          Container(
                            // color: Colors.cyanAccent,
                            child: Text("Interest: $interest", style: TextStyle(fontSize: textSize)),
                          ),
                          Container(
                            // color: Colors.cyanAccent,
                            child: PopupMenuButton(
                              child: Text("Menu", style: TextStyle(fontSize: textSize)),


                              itemBuilder: (BuildContext context) => [
                                PopupMenuItem(child: TextButton(onPressed: (){saveGame();}, child: Text("Save Game", style: TextStyle(fontSize: textSize)))),
                                PopupMenuItem(child: TextButton(onPressed: (){
                                  Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => const StartupPage()),
                                );}, child: Text("Quit game", style: TextStyle(fontSize: textSize)))),
                              ],
                            )
                          ),
                        ],)
                    ],
                  ),
                ),
              ),
              Align(
                  alignment: const Alignment(-0.9, 0.45),
                  child: Container(
                    // color: Colors.grey,
                    width: width/20,
                    height: height/2,
                    child: AnimatedOpacity(opacity: isVisible ? 1.0 : 0.0, duration: const Duration(seconds: 2),
                      child: AnimatedAlign(alignment: saleBool ? Alignment.topCenter : Alignment.bottomCenter,
                        curve: Curves.linearToEaseOut,
                        duration: const Duration(seconds: 3),
                        child: Text(showSaleAmount, style: TextStyle(fontSize: textSize)),),
                    ),
                  ))
            ]
        )
    );

  }
}
