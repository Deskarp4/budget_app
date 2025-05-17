import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cost_control/gradients.dart';
import 'package:cost_control/widgets/tx_block.dart';
import 'package:cost_control/models/tx_model.dart';
import 'package:cost_control/controllers/tx_controller.dart';
import 'package:get/get.dart';
import 'package:cost_control/expense_categories.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TxController c = Get.find<TxController>();
  final _currency = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

  static const _incomeCategories = ['Salary', 'Other'];

  var expensesDict = <String, double>{};

  Future<void> _showAddSheet() async {
    final amountCtl = TextEditingController();
    String category = _incomeCategories.first;
    bool isIncome = true;
    DateTime selectedDate = DateTime.now();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          top: 24,
          left: 24,
          right: 24,
        ),
        child: StatefulBuilder(
          builder: (context, setModalState) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Operation',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(value: true, label: Text('Income')),
                        ButtonSegment(
                          value: false,
                          label: Text('Expense'),
                        ),
                      ],
                      selected: {isIncome},
                      onSelectionChanged: (s) => setModalState(() {
                        isIncome = s.first;
                        category =
                        isIncome ? _incomeCategories.first : expensesCategories.first;
                      }))
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Date',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) setModalState(() => selectedDate = picked);
                    },
                    child: Text(
                      DateFormat('dd.MM.yyyy').format(selectedDate),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                ),
                items: [
                  for (final c in (isIncome ? _incomeCategories : expensesCategories))
                    DropdownMenuItem(value: c, child: Text(c)),
                ],
                onChanged: (v) => setModalState(() => category = v!),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: amountCtl,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(labelText: 'Amount'),
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentGradient.colors.first,
                  ),
                  onPressed: () {
                    final value = double.tryParse(amountCtl.text);
                    if (value == null || value <= 0) return;
                    final signed = isIncome ? value : -value;
                    c.add(Tx(amount: signed, note: category, category: category, date: selectedDate));
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final now = DateTime.now();
      final sortedTxs = List<Tx>.from(c.txs)..sort((a, b) => b.date.compareTo(a.date));

      final monthTxs = c.txs.where((tx) => tx.date.year == now.year && tx.date.month == now.month);

      final totalIncome = monthTxs.where((tx) => tx.amount >= 0).fold(0.0, (sum, tx) => sum + tx.amount);

      final totalExpense = monthTxs.where((tx) => tx.amount < 0).fold(0.0, (sum, tx) => sum + tx.amount.abs());


      final items = <dynamic>[];
      String? lastKey;
      final dateNow = DateTime(now.year, now.month, now.day);
      for (final tx in sortedTxs) {
        final dateTx = DateTime(tx.date.year, tx.date.month, tx.date.day);
        final daysDiff = dateNow.difference(dateTx).inDays;
        String key;
        if (daysDiff == 0) {
          key = 'Recent';
        } else if (daysDiff == 1) {
          key = 'Yesterday';
        } else {
          key = DateFormat('dd.MM').format(tx.date);
        }
        if (key != lastKey) {
          items.add(key);
          lastKey = key;
        }
        items.add(tx);
      }

      final screenHeight = MediaQuery.of(context).size.height;
      const rowSize = 78.0;
      const headerRowSize = 48.0;
      const listPadding = 32.0;

      final headerCount = items.where((e) => e is String).length;
      final txCount = items.where((e) => e is Tx).length;

      final contentHeight = headerCount * headerRowSize + txCount * rowSize + listPadding + 54;

      final double neededFraction = (contentHeight / screenHeight).clamp(0.60, 0.95);

      return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(gradient: paleGradient),
          child: Stack(
            children: [
              Container(
                alignment: Alignment.center,
                height: 365,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 32),
                            Text(
                              DateFormat.MMMM('en').format(DateTime.now()),
                              style: TextStyle(
                                fontSize: 36,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: Text(
                                _currency.format(c.balance),
                                style: const TextStyle(
                                  fontSize: 56,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Text(
                              'Current Balance',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xffe3e3e3),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 160,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 6,
                                offset: Offset(2, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 18, top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _currency.format(totalIncome),
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.trending_up_outlined,
                                      color: Colors.green,
                                    ),
                                    SizedBox(width: 7),
                                    Text(
                                      "Income",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Container(
                          width: 160,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 6,
                                offset: Offset(2, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 18, top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _currency.format(totalExpense),
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.trending_down_outlined,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 7),
                                    Text(
                                      "Expense",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        SizedBox(
                          width: 52,
                          height: 52,
                          child: Material(
                            color: Colors.white,
                            shape: const CircleBorder(),
                            elevation: 3,
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: _showAddSheet,
                              child: ShaderMask(
                                shaderCallback: (r) => accentGradient.createShader(r),
                                blendMode: BlendMode.srcIn,
                                child: const Icon(Icons.add, size: 24),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              DraggableScrollableSheet(
                initialChildSize: 0.60,
                minChildSize: 0.60,
                maxChildSize: neededFraction,
                builder: (context, scrollController) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(26),
                            topRight: Radius.circular(26),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          controller: scrollController,
                          shrinkWrap: false,
                          padding: const EdgeInsets.all(16),
                          itemCount: items.length,
                          itemBuilder: (context, i) {
                            final entry = items[i];
                            if (entry is String) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 16, bottom: 8, left: 12),
                                child: Text(
                                  entry,
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                                ),
                              );
                            } else if (entry is Tx) {
                              return Dismissible(
                                key: ValueKey(entry.hashCode),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: const Icon(Icons.delete, color: Colors.white),
                                ),
                                confirmDismiss: (_) async {
                                  return await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Delete transaction?'),
                                      content: const Text('This operation will be removed permanently.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx, false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx, true),
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  ) ??
                                      false;
                                },
                                onDismissed: (_) {
                                  c.txs.remove(entry);
                                },
                                child: TxBlock(tx: entry, fmt: _currency),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
