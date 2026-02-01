import 'package:cloud_firestore/cloud_firestore.dart';

class Crudop {
  final CollectionReference _movieCollection = FirebaseFirestore.instance
      .collection('movie');

  //create
  Future<void> addMovieFirebase(String name, type, ratings) async {
    await _movieCollection.add({
      'name': name,
      'type': type,
      'ratings': ratings,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateMovie(
    String docId,
    String name,
    String type,
    String ratings,
  ) async {
    return await _movieCollection.doc(docId).update({
      'name': name,
      'type': type,
      'ratings': ratings,
    });
  }

  //read
  Stream<QuerySnapshot> get movieStream {
    return _movieCollection.orderBy('timestamp', descending: true).snapshots();
  }

  //delete
  Future<void> delete(docId) async {
    await _movieCollection.doc(docId).delete();
  }
}
