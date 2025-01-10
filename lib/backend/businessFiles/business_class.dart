
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
  int getCurrentNode() => currentNode;
  String getSaveName() => saveName;
  String getSaveID() => saveID;
  int getMaxStock() => stockMax;


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
    stockMax += amount;
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
    } else {
      print("Interest change is out of bounds.");
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
      print("Stock change is out of bounds.");
    }
  }

  // Edit disaster percentage with validation
  void editDisasterPercent(double amount) {
    if (amount != 0) {
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
