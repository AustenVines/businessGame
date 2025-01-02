import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{

  static final ref  = FirebaseFirestore.instance.collection('gameSaves');
  //create save onto database
  Future<void> addSave(String name, int node, int money, int stock, double interest, double disasterPercent){
    return ref.add({
      'saveName': name,
      'timestamp': Timestamp.now(),
      'currentNode': node,
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

  Future<String?> getLastSaveId() async {
    try {
      // Access the Firestore collection
      CollectionReference saves = FirebaseFirestore.instance.collection('gameSaves');

      // Query the collection, ordering by timestamp descending
      QuerySnapshot querySnapshot = await saves.orderBy('timestamp', descending: true).limit(1).get();

      // Check if any documents exist
      if (querySnapshot.docs.isNotEmpty) {
        // Return the document ID of the most recent save
        return querySnapshot.docs.first.id;
      } else {
        print("No saves found.");
        return null;
      }
    } catch (e) {
      print("Error fetching last save: $e");
      return null;
    }
  }
  //update a save on database
  Future<void> updateSaveName(String docID, String newName) {
    return ref.doc(docID).update({
      'saveName': newName,
    });
  }
  Future<void> updateSave(String docID, node, money, stock, interest, disasterPercent) {
    print("$docID, $node, $money, $stock, $interest, $disasterPercent");
    return ref.doc(docID).update({
      'timestamp': Timestamp.now(),
      'currentNode': node,
      'businessMoney': money,
      'businessStock': stock,
      'businessInterest': interest,
      'disasterPercent': disasterPercent,

    });
  }

  //delete saves on database

  Future<void> deleteSave(String docID){
    return ref.doc(docID).delete();
  }
}