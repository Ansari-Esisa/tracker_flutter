import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser?.uid ?? (throw Exception('User not authenticated'));

  CollectionReference _userCollection(String path) {
    return _db.collection('users').doc(_uid).collection(path);
  }

  // Generic CRUD
  Future<void> addDocument(String collectionPath, Map<String, dynamic> data) {
    return _userCollection(collectionPath).add(data);
  }

  Future<void> updateDocument(String collectionPath, String docId, Map<String, dynamic> data) {
    return _userCollection(collectionPath).doc(docId).update(data);
  }

  Future<void> deleteDocument(String collectionPath, String docId) {
    return _userCollection(collectionPath).doc(docId).delete();
  }

  Stream<QuerySnapshot> streamCollection(String collectionPath) {
    return _userCollection(collectionPath).snapshots();
  }

  Future<QuerySnapshot> getCollection(String collectionPath) {
    return _userCollection(collectionPath).get();
  }

  // Specific for Driver info (root document)
  Future<void> setDriverInfo(Map<String, dynamic> data) {
    return _db.collection('users').doc(_uid).set(data, SetOptions(merge: true));
  }

  Stream<DocumentSnapshot> streamDriverInfo() {
    return _db.collection('users').doc(_uid).snapshots();
  }
}
