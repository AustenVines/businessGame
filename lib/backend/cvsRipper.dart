
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'nodeFiles/node.dart';
late Box<Node> box;
Future<Box> nodeCreate() async {

  await Hive.initFlutter(); //HIVE SETUP
  Hive.registerAdapter(NodeAdapter());
  box = await Hive.openBox<Node>('basic_map');


  String csv = "csvFile.csv"; //path to csv file asset
  String fileData = await rootBundle.loadString(csv);
  print(fileData);


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
        costOfOptionC);
    // decisionMap.add(node);
    int key = int.parse(itemInRow[0]);
    box.put(key, node);
  }
  return box;
}