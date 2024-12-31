import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{

  static final ref  = FirebaseFirestore.instance.collection('gameSaves');
  //create save onto database
  Future<void> addSave(String name, int node, int money, int stock, double interest, double disasterPercent){
    return ref.add({
      'saveName': name,
      'timestamp': Timestamp.now(),
      'current node': node,
      'businessMoney': money,
      'businessStock': stock,
      'businessInterest': interest,
      'disasterPercent': disasterPercent,

    });// /////////////////////////// will be a list or dictionary not a string
  }
  //read to saves database
  Stream<QuerySnapshot> getSavesStream() {
    final savesStream = ref.orderBy('timestamp', descending: true).snapshots();
    return savesStream;
  }
  Future<DocumentSnapshot<Map<String, dynamic>>> getSave(String docID){
    final currentSave = ref.doc(docID).get();
    return currentSave;
  }
  //update a save on database
  Future<void> updateSave(String docID, String newName) {
    return ref.doc(docID).update({
      'saveName': newName,
    });
  }

  //delete saves on database
}