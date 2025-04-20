import 'package:bmi_firebase/data/bmi_record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addBmiRecord(BmiRecord record) async {
    await _firestore.collection('bmiRecords').add(record.toMap());
  }

  Stream<List<BmiRecord>> getBmiRecords(String userId) {
    return _firestore
        .collection('bmiRecords')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => BmiRecord.fromMap(doc.data(), doc.id))
        .toList());
  }

  Future<void> deleteBmiRecord(String id) async {
    await _firestore.collection('bmiRecords').doc(id).delete();
  }
}