import 'package:hive/hive.dart';
part 'node.g.dart';

@HiveType(typeId: 0)
class Node{

  @HiveField(0)
  int iD;

  @HiveField(1)
  int optionA;

  @HiveField(2)
  int optionB;

  @HiveField(3)
  int optionC;

  @HiveField(4)
  String displayText;

  @HiveField(5)
  String answerA;

  @HiveField(6)
  String answerB;

  @HiveField(7)
  String answerC;

  @HiveField(8)
  int costOfOptionA;

  @HiveField(9)
  int costOfOptionB;

  @HiveField(10)
  int costOfOptionC;

  @HiveField(11)
  int stockOfOptionA;

  @HiveField(12)
  int stockOfOptionB;

  @HiveField(13)
  int stockOfOptionC;

  @HiveField(14)
  int interestOfOptionA;

  @HiveField(15)
  int interestOfOptionB;

  @HiveField(16)
  int interestOfOptionC;

  @HiveField(17)
  int disasterOfOptionA;

  @HiveField(18)
  int disasterOfOptionB;

  @HiveField(19)
  int disasterOfOptionC;

  @HiveField(20)
  String imageForOptionA;

  @HiveField(21)
  String imageForOptionB;

  @HiveField(22)
  String imageForOptionC;


  Node(this.iD, this.optionA, this.optionB, this.optionC, this.displayText, this.answerA, this.answerB, this.answerC,
      this.costOfOptionA, this.costOfOptionB, this.costOfOptionC, this.stockOfOptionA, this.stockOfOptionB, this.stockOfOptionC,
      this.interestOfOptionA, this.interestOfOptionB, this.interestOfOptionC, this.disasterOfOptionA, this.disasterOfOptionB, this.disasterOfOptionC,
      this.imageForOptionA, this.imageForOptionB, this.imageForOptionC);

}