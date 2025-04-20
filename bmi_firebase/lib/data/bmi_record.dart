import 'package:cloud_firestore/cloud_firestore.dart';

class BmiRecord {
  final String? id;
  final String userId;
  final double weight;
  final double height;
  final double bmi;
  final String category;
  final DateTime date;

  BmiRecord({
    this.id,
    required this.userId,
    required this.weight,
    required this.height,
    required this.bmi,
    required this.category,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'weight': weight,
      'height': height,
      'bmi': bmi,
      'category': category,
      'date': Timestamp.fromDate(date),
    };
  }

  factory BmiRecord.fromMap(Map<String, dynamic> map, String id) {
    return BmiRecord(
      id: id,
      userId: map['userId'],
      weight: map['weight'].toDouble(),
      height: map['height'].toDouble(),
      bmi: map['bmi'].toDouble(),
      category: map['category'],
      date: (map['date'] as Timestamp).toDate(),
    );
  }
}