import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final fireStore = FirebaseFirestore.instance;
Reference get firbaseStorage => FirebaseStorage.instance.ref();

//final userRef = fireStore.collection('books');
final booksCollection = fireStore.collection('books');
DocumentReference booksRef({
  required String id,
  required String questionID,
  //Here we create subcollection based on main collection
  //
}) =>
    booksCollection.doc(id).collection('books').doc(questionID);