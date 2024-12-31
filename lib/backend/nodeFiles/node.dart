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

  Node(this.iD, this.optionA, this.optionB, this.optionC, this.displayText, this.answerA, this.answerB, this.answerC, this.costOfOptionA, this.costOfOptionB, this.costOfOptionC);

}