import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // get collection on the database
  final CollectionReference database =
      FirebaseFirestore.instance.collection('database');

  // CREATE: add to database
  Future<void> store(String data) {
    return database.add({
      'data': data,
      'timestamp': Timestamp.now(),
    });
  }

  // READ: Read from the database
  Stream<QuerySnapshot> getDatabaseString() {
    final dataStream =
        database.orderBy('timestamp', descending: true).snapshots();

    return dataStream;
  }

  // UPDATE: Update data from database
  Future<void> update(String docId, String textData) {
    return database.doc(docId).update({
      'data': textData,
      'timestamp': Timestamp.now(),
    });
  }

  // DELETE: Delete data from database
  Future<void> delete(String docId) {
    return database.doc(docId).delete();
  }
}
