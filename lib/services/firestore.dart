import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{

  static final ref  = FirebaseFirestore.instance.collection('gameSaves');
  //create save onto database
  Future<void> addSave(String history){
    return ref.add({
      'history': history,
      'timestamp': Timestamp.now(),
    });// /////////////////////////// will be a list or dictionary not a string
  }
  //update a save on database
  //read to saves database
  Stream<QuerySnapshot> getSavesStream() {
    final savesStream = ref.orderBy('timestamp', descending: true).snapshots();
    return savesStream;
  }
  //delete saves on database
}