import 'package:get/get.dart';
import 'package:cost_control/models/tx_model.dart';
import 'package:cost_control/repositories/tx_repository.dart';

class TxController extends GetxController {
  late final TxRepository _repo;

  final RxList<Tx> txs = <Tx>[].obs;
  final RxMap<String, double> expensesByCategory = <String, double>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _repo = Get.find<TxRepository>();

    txs.bindStream(_repo.watchTx());

    ever<List<Tx>>(txs, (_) => _recalcExpenses());


    _recalcExpenses();
  }

  void add(Tx tx) => _repo.addTx(tx);

  double get balance => txs.fold(0.0, (s, t) => s + t.amount);

  void _recalcExpenses() {
    final now = DateTime.now();
    final Map<String, double> m = {};

    for (final tx in txs) {
      if (tx.amount >= 0) continue;
      if (tx.date.year != now.year || tx.date.month != now.month) continue;

      m.update(tx.category, (v) => v + tx.amount.abs(),
          ifAbsent: () => tx.amount.abs());

      print('Расходы пересчитаны: $expensesByCategory');
    }

    expensesByCategory
      ..clear()
      ..addAll(m);
  }
}
