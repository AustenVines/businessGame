
class Business{

  int money = 100000; // as a starting point
  double interest = 0;
  double maxInterest = 100;
  double minInterest = 0;
  double stock = 0;
  double maxStock = 100;
  double minStock = 0;
  double disasterPercent = 0;

  int getMoney(){
    return money;
  }
  double getInterest(){
    return interest;
  }
  double getStock(){
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