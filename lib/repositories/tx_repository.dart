import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cost_control/models/tx_model.dart';
import 'package:flutter/foundation.dart';

class TxRepository {
  TxRepository(String uid) : _uid = uid {
    debugPrint('TxRepository CREATED  →  uid=$_uid');
  }
  final String _uid;

  CollectionReference<Map<String, dynamic>> get _col =>
      FirebaseFirestore.instance
          .collection('Users')
          .doc(_uid)
          .collection('transactions');

  Future<void> addTx(Tx tx) => _col.add(tx.toJson());

  Stream<List<Tx>> watchTx() => _col
      .orderBy('date', descending: true)
      .snapshots()
      .map((q) => q.docs.map((d) => Tx.fromJson(d.data())).toList());
}
