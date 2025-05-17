import 'dart:async';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BudgetController extends GetxController {
  final RxMap<String, double> budgets = <String, double>{}.obs;

  late final String _uid;
  late final CollectionReference _budgetsCol;
  StreamSubscription<QuerySnapshot>? _sub;

  @override
  void onInit() {
    super.onInit();
    final user = FirebaseAuth.instance.currentUser;
    print('BudgetController onInit: ${hashCode}');
    if (user == null) {
      throw Exception('User must be signed in');
    }

    _uid = user.uid;
    _budgetsCol = FirebaseFirestore.instance
        .collection('Users')
        .doc(_uid)
        .collection('budgets');

    _subscribeToBudgets();
  }

  void _subscribeToBudgets() {
    _sub = _budgetsCol
        .snapshots(includeMetadataChanges: true)
        .listen((snap) {
      if (snap.metadata.hasPendingWrites) {
        print('[BUDGET_CONTROLLER] Waiting for server confirmation...');
        return;
      }

      final Map<String, double> m = {};
      for (final doc in snap.docs) {
        final data = doc.data() as Map<String, dynamic>;
        m[doc.id] = (data['limit'] as num).toDouble();
      }

      print('[BUDGET_CONTROLLER] Synced from server: $m');
      budgets
        ..clear()
        ..addAll(m);
    });
  }

  Future<void> setBudget(String category, double amount) async {
    await _budgetsCol.doc(category).set({'limit': amount});
    budgets[category] = amount;
    print('[BUDGET_CONTROLLER] Added/Updated budget: $category = $amount');
  }


  Future<void> deleteBudget(String category) async {
    await _budgetsCol.doc(category).delete();
    budgets.remove(category);
    print('[BUDGET_CONTROLLER] Deleted budget: $category');
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
