
import 'dart:math';

import '../../services/firestore.dart';

class BusinessGame {
  String saveID = "";
  String saveName = "";
  int currentNode;
  int money;
  double interest;
  int stock;
  int stockMax;
  double disasterPercent = 0;

   BusinessGame(this.currentNode, this.money, this.stock, this.stockMax, this.interest, this.disasterPercent);

  // Getters
  int getMoney() => money;
  double getInterest() => interest;
  int getStock() => stock;
  double getDisaster() => disasterPercent;
  int getCurrentNode() => currentNode;
  String getSaveName() => saveName;
  String getSaveID() => saveID;
  int getMaxStock() => stockMax;

  Future<void> load(String docID) async{
    FirestoreService firestoreService = FirestoreService();

    if (docID == ""){
      setMoney(00000);
      setInterest(0);// temp

    }else{

      var save = await firestoreService.getSave(docID);
      int money = save['businessMoney'];
      int stock = save['businessStock'];
      double interest = save['businessInterest'];
      double disaster = save['disasterPercent'];
      int currentNode = save['currentNode'];
      String saveName = save['saveName'];
      int stockMax = save['maxStock'];
      setMoney(money);
      setStock(stock);
      setInterest(interest);
      setDisaster(disaster);
      setNode(currentNode);
      setSaveName(saveName);
      setMaxStock(stockMax);

    }

  }

  // Setters
  void setSaveID(String newSaveID){
    saveID = newSaveID;
  }
  void setMoney(int amount) {
    if (amount != 0) {
      money = amount;
    }
  }
  void setStock(int amount) {
    if (amount != 0) {
      stock = amount;
    }else if(amount > 100){
    }

  }
  void setMaxStock(int amount){
    stockMax = amount;
  }
  void setInterest(double amount) {
    if (amount != 0) {
      interest = amount;
    }
  }
  void setDisaster(double amount) {
    if (amount != 0) {
      disasterPercent = amount;
    }
  }
  void setNode(int node){
    currentNode = node;
  }
  void setSaveName(String name){
    saveName = name;
  }

  // Edit interest with validation
  void editInterest(double amount) {
    if (amount + interest >= 0 && amount + interest <= 100) {
      interest += amount;
    }
  }

  // Edit stock with validation
  void editStock(int amount) {
    if(amount > 100){
      switch (amount) {
        case (130):
          stockMax += 30;
        case 120:
          stockMax += 20;
        case 110:
          stockMax += 10;
        case 150:
          stockMax += 50;
        case 160:
          stockMax += 60;
      }
    }else if (amount + stock >= 0 && amount + stock <= stockMax) {
      stock += amount;
    } else if(amount + stock > stockMax){
      stock = stockMax;
    }else {
    }
  }
  void decreaseStock(int amount){
    stock -= amount;
  }
  // Edit disaster percentage with validation
  void editDisasterPercent(double amount) {
    if (amount != 0) {
      disasterPercent += amount;
    } else {
    }
  }
  void decreaseMoney(int amount){
    money = money - amount;
  }
  void increaseMoney(int amount){
    money += amount;
  }

  void reset(){
    money = 0;
    stockMax = 0;
    stock  = 0;
    interest = 0;
    disasterPercent = 0;
  }

  int decisionMade() {
    Random saleSize = Random();
    // print(saleSize.nextInt(50000));
    int amount = saleSize.nextInt(30000);
    int saleAmount = 0;
    int chanceOfSale = saleSize.nextInt(100);
    if(chanceOfSale <= interest && stock > 0){
      increaseMoney(amount);
      decreaseStock(1);
      saleAmount = amount;
      return saleAmount;
    }
    else{
      return saleAmount;
    }
  }

  void disasterChance(){
    Random size = Random();
    int disasterSize = size.nextInt(100);
    if(disasterPercent > disasterSize){
      // print("disaster");
    }
  }
  bool winGame(){
    if (money >= 1000000){
      return true;
    }
    else{
      return false;
    }
  }
  bool endGame(){
    if(money < 0){
      return true;
    }
    else{
      return false;
    }
  }

  int chanceToBeCaught(){
    Random number = Random();
    int chance = number.nextInt(100);
    return chance;
  }
}
