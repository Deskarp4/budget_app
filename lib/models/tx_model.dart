import 'package:cloud_firestore/cloud_firestore.dart';

class Tx {
  final double amount;
  final String note;
  final String category;
  final DateTime date;

  Tx({
    required this.amount,
    required this.note,
    required this.category,
    required this.date,
  });

  toJson() {
    return {
      'amount': amount,
      'note': note,
      'category': category,
      'date': date,
    };
  }
  factory Tx.fromJson(Map<String, dynamic> json) => Tx(
    amount : (json['amount'] as num).toDouble(),
    note : json['note'] as String,
    category : json['category'] as String,
    date : (json['date'] as Timestamp).toDate(),
  );
}
