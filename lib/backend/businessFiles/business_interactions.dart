
import 'dart:math';
import 'package:businessGameApp/backend/businessFiles/business_class.dart';
import '../../services/firestore.dart';

class Play{

  Future<void> load(BusinessGame business, String docID) async{
    FirestoreService firestoreService = FirestoreService();

    if (docID == ""){
      business.setMoney(50000);
    }else{

      var save = await firestoreService.getSave(docID);
      int money = save['businessMoney'];
      int stock = save['businessStock'];
      double interest = save['businessInterest'];
      double disaster = save['disasterPercent'];
      int currentNode = save['currentNode'];
      String saveName = save['saveName'];
      business.setMoney(money);
      business.setStock(stock);
      business.setInterest(interest);
      business.setDisaster(disaster);
      business.setNode(currentNode);
      business.setSaveName(saveName);
    }

  }
  String getSaveID(BusinessGame business){
    return business.getSaveID();
  }
  int getMoney(BusinessGame business){
    return business.getMoney();
  }
  int getStock(BusinessGame business){
    return business.getStock();
  }
  double getInterest(BusinessGame business){
    return business.getInterest();
  }
  double getDisaster(BusinessGame business){
    return business.getDisaster();
  }
  int getNode(BusinessGame business){
    return business.getCurrentNode();
  }
  String getSaveName(BusinessGame business){
    return business.getSaveName();
  }
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

  Future<void> saleMaker(BusinessGame business)async {
    endGame(business);
    Random saleSize = Random();
    // print(saleSize.nextInt(50000));
    int saleAmount = saleSize.nextInt(30000);
    int chanceOfSale = saleSize.nextInt(100);
    if(chanceOfSale <= business.interest && business.stock > 0){
      business.increaseMoney(saleAmount);
    }
    else{

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

