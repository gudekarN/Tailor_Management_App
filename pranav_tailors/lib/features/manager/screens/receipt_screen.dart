// ════════════════════════════════════════════════════════════════════════════
//  receipt_screen.dart
//  Pranav Ladies Tailors — Receipt List Screen (Manager)
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:intl/intl.dart';
import 'package:pranav_tailors/core/theme/app_theme.dart';

// ── Dummy data model ──────────────────────────────────────────────────────────

enum ReceiptStatus { pending, complete, overdue }

class _Receipt {
  const _Receipt({
    required this.number,
    required this.customer,
    required this.date,
    required this.totalAmount,
    required this.deliveryDate,
    required this.status,
    required this.generatedBy,
  });

  final String number;
  final String customer;
  final String date;
  final int totalAmount;
  final String deliveryDate;
  final ReceiptStatus status;
  final String generatedBy;
}

const _kReceipts = [
  _Receipt(number: 'RCP-001', customer: 'Priya Sharma',   date: '08 Jun 2026', totalAmount: 1250, deliveryDate: '12 Jun 2026', status: ReceiptStatus.pending,  generatedBy: 'Manager'),
  _Receipt(number: 'EMP-001', customer: 'Meena Patil',    date: '07 Jun 2026', totalAmount: 1400, deliveryDate: '11 Jun 2026', status: ReceiptStatus.pending,  generatedBy: 'Sunita'),
  _Receipt(number: 'EMP-002', customer: 'Rekha Joshi',    date: '06 Jun 2026', totalAmount: 2200, deliveryDate: '10 Jun 2026', status: ReceiptStatus.pending,  generatedBy: 'Sunita'),
  _Receipt(number: 'RCP-002', customer: 'Sunita Desai',   date: '05 Jun 2026', totalAmount:  850, deliveryDate: '09 Jun 2026', status: ReceiptStatus.complete, generatedBy: 'Manager'),
  _Receipt(number: 'EMP-003', customer: 'Kavita Rane',    date: '04 Jun 2026', totalAmount:  950, deliveryDate: '08 Jun 2026', status: ReceiptStatus.pending,  generatedBy: 'Kaveri'),
  _Receipt(number: 'RCP-003', customer: 'Rekha Joshi',    date: '01 Jun 2026', totalAmount: 2100, deliveryDate: '07 Jun 2026', status: ReceiptStatus.complete, generatedBy: 'Manager'),
  _Receipt(number: 'EMP-004', customer: 'Priya Sharma',   date: '30 May 2026', totalAmount: 1200, deliveryDate: '04 Jun 2026', status: ReceiptStatus.complete, generatedBy: 'Sunita'),
  _Receipt(number: 'EMP-005', customer: 'Pooja Nair',     date: '28 May 2026', totalAmount: 1800, deliveryDate: '02 Jun 2026', status: ReceiptStatus.complete, generatedBy: 'Kaveri'),
  _Receipt(number: 'RCP-004', customer: 'Anita Kulkarni', date: '22 May 2026', totalAmount:  350, deliveryDate: '26 May 2026', status: ReceiptStatus.complete, generatedBy: 'Manager'),
  _Receipt(number: 'EMP-006', customer: 'Nisha Borkar',   date: '18 May 2026', totalAmount: 1650, deliveryDate: '23 May 2026', status: ReceiptStatus.complete, generatedBy: 'Sunita'),
  _Receipt(number: 'RCP-005', customer: 'Lata Sawant',    date: '12 May 2026', totalAmount: 3200, deliveryDate: '18 May 2026', status: ReceiptStatus.overdue,  generatedBy: 'Manager'),
  _Receipt(number: 'EMP-007', customer: 'Kavita Rane',    date: '04 May 2026', totalAmount:  600, deliveryDate: '08 May 2026', status: ReceiptStatus.overdue,  generatedBy: 'Kaveri'),
];

// ── Screen ────────────────────────────────────────────────────────────────────

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  final _searchCtrl = TextEditingController();
  List<_Receipt> _filtered = _kReceipts;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(() {
      final q = _searchCtrl.text.trim().toLowerCase();
      setState(() {
        if (q.isEmpty) {
          _filtered = _kReceipts;
        } else {
          _filtered = _kReceipts
              .where((r) =>
                  r.customer.toLowerCase().contains(q) ||
                  r.number.toLowerCase().contains(q))
              .toList();
        }
      });
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.topbarStart, AppColors.topbarEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          'Receipts',
          style: TextStyle(fontFamily: 'Poppins', 
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: AppColors.primaryDark,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              controller: _searchCtrl,
              style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search by name or receipt #...',
                hintStyle: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 14, color: Colors.white.withValues(alpha: 0.60)),
                prefixIcon: Icon(Icons.search_rounded,
                    color: Colors.white.withValues(alpha: 0.80)),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          // List
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Text('No receipts found',
                        style: TextStyle(fontFamily: 'Poppins', 
                            color: AppColors.textHint, fontSize: 14)))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => GestureDetector(
                      onTap: () => context.push(
                        '/manager/receipt/receipt-view',
                        extra: _filtered[i].generatedBy,
                      ),
                      child: _ReceiptCard(receipt: _filtered[i]),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/manager/home/receipt-form'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.receipt_long_rounded),
        label: Text(
          'New Receipt',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

// ── Card Widget ───────────────────────────────────────────────────────────────

class _ReceiptCard extends StatelessWidget {
  const _ReceiptCard({required this.receipt});
  final _Receipt receipt;

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    String badgeText;
    switch (receipt.status) {
      case ReceiptStatus.pending:
        badgeColor = AppColors.urgent;
        badgeText = 'Pending';
        break;
      case ReceiptStatus.complete:
        badgeColor = AppColors.success;
        badgeText = 'Complete';
        break;
      case ReceiptStatus.overdue:
        badgeColor = AppColors.error;
        badgeText = 'Overdue';
        break;
    }

    final currencyFmt = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppShadows.subtle,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Number + Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                receipt.number,
                style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: badgeColor.withValues(alpha: 0.50)),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(fontFamily: 'Poppins', 
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: badgeColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Customer + Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  receipt.customer,
                  style: TextStyle(fontFamily: 'Poppins', 
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                currencyFmt.format(receipt.totalAmount),
                style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 12),
          // Dates
          Row(
            children: [
              Icon(Icons.calendar_today_rounded,
                  size: 14, color: AppColors.textHint),
              const SizedBox(width: 6),
              Text(
                'Date: ${receipt.date}',
                style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 12, color: AppColors.textSecondary),
              ),
              const Spacer(),
              Icon(Icons.local_shipping_rounded,
                  size: 14, color: AppColors.textHint),
              const SizedBox(width: 6),
              Text(
                'Due: ${receipt.deliveryDate}',
                style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Generated By
          Row(
            children: [
              Icon(Icons.person_outline_rounded,
                  size: 14, color: AppColors.textHint),
              const SizedBox(width: 6),
              Text(
                'By: ',
                style: TextStyle(fontFamily: 'Poppins',
                    fontSize: 12, color: AppColors.textSecondary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: receipt.generatedBy == 'Manager'
                      ? AppColors.primary.withValues(alpha: 0.12)
                      : AppColors.secondary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: receipt.generatedBy == 'Manager'
                        ? AppColors.primary.withValues(alpha: 0.35)
                        : AppColors.secondary.withValues(alpha: 0.40),
                  ),
                ),
                child: Text(
                  receipt.generatedBy,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: receipt.generatedBy == 'Manager'
                        ? AppColors.primary
                        : AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
