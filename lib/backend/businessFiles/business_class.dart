
import 'package:businessGameApp/displayPages/game_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/firestore.dart';

class Business{
  String save = "";
  int currentNode = 0;
  int money = 50000; // as a starting point
  double interest = 0;
  double maxInterest = 100;
  double minInterest = 0;
  int stock = 0;
  double maxStock = 100;
  double minStock = 0;
  double disasterPercent = 0;

  FirestoreService firestoreService = FirestoreService();

  void loadSave(String docID) async{

    var save = await firestoreService.getSave(docID) as DocumentSnapshot;
    print(save['businessMoney']);
    if(save['saveName'] == ""){
      print("nothing to load");
    }else{
      money = save['businessMoney'];
      currentNode = save['currentNode'];
    }
  }

  int getMoney(){
    return money;
  }
  double getInterest(){
    return interest;
  }
  int getStock(){
    return stock;
  }
  double getDisaster(){
    return disasterPercent;
  }
  void editMoney(int amount){
    if(amount != 0){
      money += amount;
    }
  }

  void editIntrest(int amount){
    if(amount + interest >= minInterest && amount + interest <= maxInterest){
      interest += amount;
    }
  }
  void editStock(int amount){
    if(amount + stock >= minStock && amount + stock <= maxStock){
      stock += amount;
    }
  }
  void editDisasterPercent(int amount) {
    if (amount + stock >= 0 && amount + stock <= 100) {
      stock += amount;
    }
  }
}