import 'businessClass.dart';
import 'dart:math';

class Play{

  editMoney(Business business, int amount){
    business.editMoney(amount);
  }

  editStock(Business business, int amount){
    business.editStock(amount);
  }

  editInterest(Business business, int amount){
    business.editIntrest(amount);
  }
  editDisasterPercent(Business business, int amount){
    business.editDisasterPercent(amount);
  }

  saleMaker(Business business){
    endGame(business);
    Random saleSize = Random();
    // print(saleSize.nextInt(50000));
    int saleAmount = saleSize.nextInt(30000);
    int chanceOfSale = saleSize.nextInt(100);
    if(chanceOfSale <= business.interest && business.stock > 0){
      print("sale");
      business.editMoney(saleAmount);
    }
    else{
      print("no sale");
    }
  }
  endGame(Business business){
    if(business.money <= 0){
      print("end game");
    }
    else{
    }
  }
}


