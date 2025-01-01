
import 'dart:math';

import 'package:businessGameApp/backend/businessFiles/business_class.dart';
import 'package:businessGameApp/displayPages/game_page.dart';

import '../../services/firestore.dart';

class Play{

  void load(BusinessGame business, String docID) async{
    FirestoreService firestoreService = FirestoreService();
    var save = await firestoreService.getSave(docID);
    int money = save['businessMoney'];
    int stock = save['businessStock'];
    double interest = save['businessInterest'];
    double disaster = save['disasterPercent'];
    int currentNode = save['currentNode'];
    business.setMoney(money);
    business.setStock(stock);
    business.setInterest(interest);
    business.setDisaster(disaster);
    business.setNode(currentNode);
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
    return business.currentNode;
  }

  void setCurrentNode(BusinessGame business, int node){
    business.currentNode = node;
  }

  void decreaseMoney(BusinessGame business, int amount){
    business.decreaseMoney(amount);
  }
  void increaseMoney(BusinessGame business, int amount){
    business.increaseMoney(amount);
  }
  void editInterest(BusinessGame business, double amount){
    business.editInterest(amount);
  }
  void editStock(BusinessGame business, int amount){
    business.editStock(amount);
  }
  void editDisaster(BusinessGame business, double amount){
    business.editDisasterPercent(amount);
  }

  void saleMaker(BusinessGame business){
    endGame(business);
    Random saleSize = Random();
    // print(saleSize.nextInt(50000));
    int saleAmount = saleSize.nextInt(30000);
    int chanceOfSale = saleSize.nextInt(100);
    if(chanceOfSale <= business.interest && business.stock > 0){
      saleAmount;
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

