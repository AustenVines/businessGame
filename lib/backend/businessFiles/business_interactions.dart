
import 'dart:math';
import 'package:businessGameApp/backend/businessFiles/business_class.dart';
import '../../services/firestore.dart';

class Play{

  Future<void> load(BusinessGame business, String docID) async{
    FirestoreService firestoreService = FirestoreService();

    if (docID == ""){
      business.setMoney(00000);
      business.setInterest(0);// temp

    }else{

      var save = await firestoreService.getSave(docID);
      int money = save['businessMoney'];
      int stock = save['businessStock'];
      double interest = save['businessInterest'];
      double disaster = save['disasterPercent'];
      int currentNode = save['currentNode'];
      String saveName = save['saveName'];
      int stockMax = save['maxStock'];
      business.setMoney(money);
      business.setStock(stock);
      business.setInterest(interest);
      business.setDisaster(disaster);
      business.setNode(currentNode);
      business.setSaveName(saveName);
      business.setMaxStock(stockMax);

    }

  }
  String getSaveID(BusinessGame business) => business.getSaveID();
  int getMoney(BusinessGame business) => business.getMoney();
  int getStock(BusinessGame business) => business.getStock();
  double getInterest(BusinessGame business) => business.getInterest();
  double getDisaster(BusinessGame business) => business.getDisaster();
  int getNode(BusinessGame business) => business.getCurrentNode();
  int getMaxStock(BusinessGame business) => business.getMaxStock();
  String getSaveName(BusinessGame business) => business.getSaveName();

  void setSaveName(BusinessGame business, name){
    business.setSaveName(name);
  }
  Future<void> setCurrentNode(BusinessGame business, int node)async {
    business.currentNode = node;
  }

  Future<void> decreaseMoney(BusinessGame business, int amount)async {
    business.decreaseMoney(amount);
  }
  Future<void> increaseMoney(BusinessGame business, int amount)async {
    business.increaseMoney(amount);
  }
  Future<void> editInterest(BusinessGame business, double amount)async {
    business.editInterest(amount);
  }
  Future<void> editStock(BusinessGame business, int amount)async {
    business.editStock(amount);
  }
  Future<void> editDisaster(BusinessGame business, double amount)async {
    business.editDisasterPercent(amount);
  }

  int decitionMade(BusinessGame business) {
    endGame(business);
    disasterChance(business);
    Random saleSize = Random();
    // print(saleSize.nextInt(50000));
    int amount = saleSize.nextInt(30000);
    int saleAmount = 0;
    int chanceOfSale = saleSize.nextInt(100);
    if(chanceOfSale <= business.interest && business.stock > 0){
      business.increaseMoney(amount);
      saleAmount = amount;
      return saleAmount;
    }
    else{
      return saleAmount;
    }

  }

  void disasterChance(BusinessGame business){
    Random size = Random();
    int disasterSize = size.nextInt(100);
    if(business.disasterPercent > disasterSize){
      print("disaster");
    }
  }

  void endGame(BusinessGame business){
    if(business.money <= 0){
      // print("end game");
    }
    else{
    }
  }
}

