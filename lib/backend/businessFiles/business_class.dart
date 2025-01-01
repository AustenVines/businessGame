
class BusinessGame {
  int currentNode;
  int money;
  double interest;
  int stock;
  double disasterPercent = 0;

   BusinessGame(this.currentNode, this.money, this.stock, this.interest, this.disasterPercent);

  @override
  String toString(){
    String business = "current node: $currentNode and money: $money";
    return business;
  }

  // Getters
  int getMoney() => money;
  double getInterest() => interest;
  int getStock() => stock;
  double getDisaster() => disasterPercent;

  // Setters
  void setMoney(int amount) {
    if (amount != 0) {
      money = amount;
    }
  }

  // Edit interest with validation
  void editInterest(double amount) {
    if (amount + interest >= 0 && amount + interest <= 100) {
      interest += amount;
    } else {
      print("Interest change is out of bounds.");
    }
  }

  // Edit stock with validation
  void editStock(int amount) {
    if (amount + stock >= 0 && amount + stock <= 100) {
      stock += amount;
    } else {
      print("Stock change is out of bounds.");
    }
  }

  // Edit disaster percentage with validation
  void editDisasterPercent(double amount) {
    if (amount + disasterPercent >= 0 && amount + disasterPercent <= 100) {
      disasterPercent += amount;
    } else {
      print("Disaster percentage change is out of bounds.");
    }
  }
  void decreaseMoney(int amount){
    money = money - amount;
  }
  void increaseMoney(int amount){
    money += amount;
  }
}
