import 'package:flutter/material.dart';
import 'package:cost_control/models/tx_model.dart';
import 'package:intl/intl.dart';

class TxBlock extends StatelessWidget {
  const TxBlock({required this.tx, required this.fmt});

  final Tx tx;
  final NumberFormat fmt;

  @override
  Widget build(BuildContext context) {
    final isIncome = tx.amount >= 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isIncome ? Colors.green.shade600 : Colors.red.shade600,
              ),
              child: Icon(
                isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                size: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                tx.note,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              (isIncome ? '+' : '-') + fmt.format(tx.amount.abs()),
              style: TextStyle(
                color: isIncome ? Colors.green.shade700 : Colors.red.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}