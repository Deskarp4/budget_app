import 'package:flutter/material.dart';
import 'package:cost_control/widgets/expense_pie_widget.dart';
import 'package:get/get.dart';
import 'package:cost_control/controllers/tx_controller.dart';
import 'package:cost_control/gradients.dart';
import 'package:cost_control/expense_categories.dart';
import 'package:cost_control/controllers/budget_controller.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});
  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  late final TxController _tx;
  late final BudgetController _budget;

  @override
  void initState() {
    super.initState();
    _tx = Get.find<TxController>();
    _budget = Get.find<BudgetController>();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final minHeight = screenHeight * 0.4;

    return Scaffold(
      body: Obx(() {
        final data = Map<String, double>.from(_tx.expensesByCategory);
        final budgets = _budget.budgets;

        return Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(gradient: paleGradient),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    ConstrainedBox(
                      constraints: BoxConstraints(minHeight: minHeight),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Monthly Expenses',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 12),
                            ExpensePie(data: data),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ConstrainedBox(
                      constraints: BoxConstraints(minHeight: minHeight),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Monthly Budgets',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            Obx(() {
                              if (_budget.budgets.isEmpty) {
                                return const Center(child: Text('No budgets yet'));
                              }
                              final entries = _budget.budgets.entries.toList();
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: entries.length,
                                itemBuilder: (context, index) {
                                  final entry = entries[index];
                                  return _BudgetBar(
                                    category: entry.key,
                                    spent: data[entry.key] ?? 0,
                                    limit: entry.value,
                                    onDelete: () => _budget.deleteBudget(entry.key),
                                  );
                                },
                              );
                            }),
                            const SizedBox(height: 8),
                            Center(
                              child: ElevatedButton(
                                onPressed: () => _showAddBudgetSheet(context),
                                child: const Icon(Icons.add),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Future<void> _showAddBudgetSheet(BuildContext ctx) async {
    String category = expensesCategories.first;
    final amountCtl = TextEditingController();

    await showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Add budget',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: category,
              items: [
                for (var c in expensesCategories)
                  DropdownMenuItem(value: c, child: Text(c))
              ],
              onChanged: (v) => category = v!,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountCtl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Monthly limit'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 46,
              child: ElevatedButton(
                onPressed: () {
                  final v = double.tryParse(amountCtl.text);
                  if (v == null || v <= 0) return;
                  _budget.setBudget(category, v).then((_) => Get.back());
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BudgetBar extends StatelessWidget {
  final String category;
  final double spent, limit;
  final VoidCallback onDelete;
  const _BudgetBar({
    required this.category,
    required this.spent,
    required this.limit,
    required this.onDelete,
  });
  @override
  Widget build(BuildContext c) {
    final p = (spent / limit).clamp(0.0, 1.0);
    final over = spent > limit;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(child: Text(category[0])),
        title: Text('$category (\$${limit.toStringAsFixed(0)})'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: p,
              color: over ? Colors.red : Theme.of(c).colorScheme.primary,
            ),
            const SizedBox(height: 4),
            Text(
              '\$${spent.toStringAsFixed(0)} / \$${limit.toStringAsFixed(0)}',
              style: TextStyle(color: over ? Colors.red : null),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
