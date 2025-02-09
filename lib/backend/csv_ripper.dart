
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'nodeFiles/node.dart';
late Box<Node> box;
Future<Box> nodeCreate() async {

  await Hive.initFlutter(); //HIVE SETUP
  Hive.registerAdapter(NodeAdapter());
  box = await Hive.openBox<Node>('basic_map');


  String csv = "currentCsvFile1.csv"; //path to csv file asset
  String fileData = await rootBundle.loadString(csv);

  List <String> rows = fileData.split("\n");
  for (int i = 0; i < rows.length; i++) {
    String row = rows[i];
    List <String> itemInRow = row.split(",");
    int lineID = int.parse(itemInRow[0]);
    int optionA = int.parse(itemInRow[1]);
    int optionB = int.parse(itemInRow[2]);
    int optionC = int.parse(itemInRow[3]);
    String displayText = itemInRow[4];
    String answerA = itemInRow[5];
    String answerB = itemInRow[6];
    String answerC = itemInRow[7];
    int costOfOptionA = int.parse(itemInRow[8]);
    int costOfOptionB = int.parse(itemInRow[9]);
    int costOfOptionC = int.parse(itemInRow[10]);
    int stockOfOptionA = int.parse(itemInRow[11]);
    int stockOfOptionB = int.parse(itemInRow[12]);
    int stockOfOptionC = int.parse(itemInRow[13]);
    int interestOfOptionA = int.parse(itemInRow[14]);
    int interestOfOptionB = int.parse(itemInRow[15]);
    int interestOfOptionC = int.parse(itemInRow[16]);
    int disasterOfOptionA = int.parse(itemInRow[17]);
    int disasterOfOptionB = int.parse(itemInRow[18]);
    int disasterOfOptionC = int.parse(itemInRow[19]);
    String imageForOptionA = itemInRow[20];
    String imageForOptionB = itemInRow[21];
    String imageForOptionC = itemInRow[22];
    Node node = Node(
        lineID,
        optionA,
        optionB,
        optionC,
        displayText,
        answerA,
        answerB,
        answerC,
        costOfOptionA,
        costOfOptionB,
        costOfOptionC,
        stockOfOptionA,
        stockOfOptionB,
        stockOfOptionC,
        interestOfOptionA,
        interestOfOptionB,
        interestOfOptionC,
        disasterOfOptionA,
        disasterOfOptionB,
        disasterOfOptionC,
        imageForOptionA,
        imageForOptionB,
        imageForOptionC);
    // decisionMap.add(node);
    int key = int.parse(itemInRow[0]);
    box.put(key, node);
  }
  return box;

}