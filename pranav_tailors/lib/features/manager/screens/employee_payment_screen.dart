// ════════════════════════════════════════════════════════════════════════════
//  employee_payment_screen.dart
//  Pranav Ladies Tailors — Employee Payment Management
//  Two screens in one file:
//    EmployeePaymentScreen  — list of all employees with balance summary
//    _PaymentDetailScreen   — one employee's payment history + add payment
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:pranav_tailors/core/theme/app_theme.dart';
import 'package:pranav_tailors/features/manager/screens/employees_screen.dart'
    show Employee, EmpPayment, buildDummyEmployees;

// ════════════════════════════════════════════════════════════════════════════
//  Root list screen
// ════════════════════════════════════════════════════════════════════════════

class EmployeePaymentScreen extends StatefulWidget {
  /// When non-null, jumps straight to that employee's detail screen.
  const EmployeePaymentScreen({super.key, this.employee});
  final Employee? employee;

  @override
  State<EmployeePaymentScreen> createState() => _EmployeePaymentScreenState();
}

class _EmployeePaymentScreenState extends State<EmployeePaymentScreen> {
  late final List<Employee> _employees;
  final _fmt     = NumberFormat('#,##0.00');
  final _dateFmt = DateFormat('dd MMM yyyy');

  @override
  void initState() {
    super.initState();
    _employees = buildDummyEmployees();
  }

  @override
  Widget build(BuildContext context) {
    // If opened for a specific employee, render detail directly.
    if (widget.employee != null) {
      return _PaymentDetailScreen(employee: widget.employee!);
    }
    return _buildListScreen(context);
  }

  // ── Aggregate stats ────────────────────────────────────────────────────────
  double get _totalEarned =>
      _employees.fold(0.0, (s, e) => s + e.totalEarned);
  double get _totalPaid =>
      _employees.fold(0.0, (s, e) => s + e.totalPaid);
  double get _totalDue => _employees.fold(
      0.0, (s, e) => s + e.balance.clamp(0.0, double.infinity));

  // ── List screen ────────────────────────────────────────────────────────────
  Widget _buildListScreen(BuildContext context) {
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
                end: Alignment.bottomRight),
          ),
        ),
        title: const Text('Employee Payments',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
      ),
      body: Column(
        children: [
          // ── Summary banner ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: _buildSummaryBanner(),
          ),
          const SizedBox(height: 20),

          // ── Section heading ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text('All Staff',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withValues(alpha: 0.50),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('${_employees.length} employees',
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600)),
                ),
                const Spacer(),
                if (_totalDue <= 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.successLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('All Settled ✓',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.success)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── Employee cards ─────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              itemCount: _employees.length,
              itemBuilder: (context, index) {
                final emp = _employees[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _EmployeePaymentCard(
                    emp: emp,
                    fmt: _fmt,
                    onTap: () => _openDetail(emp),
                    onAddPayment: () => _showAddPaymentSheet(emp),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryBanner() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [AppColors.topbarStart, AppColors.topbarEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.30),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
            child: Row(
              children: [
                Container(
                  width: 46, height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.payments_rounded,
                      color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Payment Overview',
                        style: TextStyle(fontFamily: 'Poppins', 
                            fontSize: 16, fontWeight: FontWeight.w700,
                            color: Colors.white)),
                    Text('${_employees.length} employees · ${_dateFmt.format(DateTime.now())}',
                        style: TextStyle(fontFamily: 'Poppins', 
                            fontSize: 11.5, color: Colors.white70)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.15),
              borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _BannerStat(
                  label: 'Total Earned',
                  value: '₹${_fmt.format(_totalEarned)}',
                  icon: Icons.trending_up_rounded,
                  color: const Color(0xFFA5D6A7),
                ),
                _Divider(),
                _BannerStat(
                  label: 'Total Paid',
                  value: '₹${_fmt.format(_totalPaid)}',
                  icon: Icons.check_circle_outline_rounded,
                  color: const Color(0xFF90CAF9),
                ),
                _Divider(),
                _BannerStat(
                  label: 'Total Due',
                  value: _totalDue <= 0
                      ? 'All Clear ✓'
                      : '₹${_fmt.format(_totalDue)}',
                  icon: _totalDue <= 0
                      ? Icons.done_all_rounded
                      : Icons.warning_amber_rounded,
                  color: _totalDue <= 0
                      ? const Color(0xFFA5D6A7)
                      : const Color(0xFFFFCC80),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openDetail(Employee emp) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => _PaymentDetailScreen(employee: emp)),
    ).then((_) => setState(() {}));
  }

  void _showAddPaymentSheet(Employee emp) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddPaymentSheet(
        employee: emp,
        onSave: (payment) => setState(() => emp.payments.add(payment)),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  Employee payment card (list item)
// ════════════════════════════════════════════════════════════════════════════

class _EmployeePaymentCard extends StatelessWidget {
  const _EmployeePaymentCard({
    required this.emp,
    required this.fmt,
    required this.onTap,
    required this.onAddPayment,
  });
  final Employee     emp;
  final NumberFormat fmt;
  final VoidCallback onTap;
  final VoidCallback onAddPayment;

  @override
  Widget build(BuildContext context) {
    final isPaidUp = emp.isPaidUp;
    final balanceColor = isPaidUp ? AppColors.success : AppColors.error;

    // Flutter cannot paint a non-uniform Border (different widths per side)
    // together with a borderRadius — it silently fails and the card renders
    // as a blank white box. Fix: use a uniform border + a separate left-accent
    // bar rendered via ClipRRect > Row so the rounded corners are preserved.
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: AppShadows.subtle,
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Left accent bar ──────────────────────────────────
                Container(width: 4, color: emp.color),

                // ── Card content ─────────────────────────────────────
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ── Header: avatar + name ──────────────────
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: emp.color.withValues(alpha: 0.14),
                              child: Text(emp.initials,
                                  style: TextStyle(fontFamily: 'Poppins',
                                      fontSize: 14, fontWeight: FontWeight.w800,
                                      color: emp.color)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(emp.name,
                                      style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textPrimary)),
                                  const SizedBox(height: 3),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 7, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: emp.color.withValues(alpha: 0.10),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(emp.role,
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 10.5,
                                                fontWeight: FontWeight.w600,
                                                color: emp.color)),
                                      ),
                                      const SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          '${emp.payments.length} payment'
                                          '${emp.payments.length == 1 ? '' : 's'}',
                                          style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 11.5,
                                              color: AppColors.textHint),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Balance badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: balanceColor.withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: balanceColor.withValues(alpha: 0.35)),
                              ),
                              child: Text(
                                isPaidUp
                                    ? 'Paid Up ✓'
                                    : '₹${fmt.format(emp.balance)} due',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: balanceColor),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),
                        const Divider(color: AppColors.border, height: 1),
                        const SizedBox(height: 12),

                        // ── Financials ─────────────────────────────
                        Row(
                          children: [
                            _MiniStat(
                              label: 'Total Earned',
                              value: '₹${fmt.format(emp.totalEarned)}',
                              color: AppColors.textPrimary,
                            ),
                            const SizedBox(width: 20),
                            _MiniStat(
                              label: 'Total Paid',
                              value: '₹${fmt.format(emp.totalPaid)}',
                              color: AppColors.success,
                            ),
                            const Spacer(),
                            _MiniStat(
                              label: 'Balance',
                              value: isPaidUp
                                  ? '₹0.00'
                                  : '₹${fmt.format(emp.balance)}',
                              color: balanceColor,
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // ── Add Payment quick button ───────────────
                        SizedBox(
                          width: double.infinity,
                          height: 38,
                          child: OutlinedButton.icon(
                            onPressed: onAddPayment,
                            icon: const Icon(Icons.add_rounded, size: 16),
                            label: const Text('Add Payment',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: BorderSide(
                                  color: AppColors.primary.withValues(alpha: 0.60)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  Payment detail screen (single employee)
// ════════════════════════════════════════════════════════════════════════════

class _PaymentDetailScreen extends StatefulWidget {
  const _PaymentDetailScreen({required this.employee});
  final Employee employee;

  @override
  State<_PaymentDetailScreen> createState() => _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends State<_PaymentDetailScreen> {
  final _fmt     = NumberFormat('#,##0.00');
  final _dateFmt = DateFormat('dd MMM yyyy');

  Employee get emp => widget.employee;

  void _showAddPaymentSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddPaymentSheet(
        employee: emp,
        onSave: (payment) => setState(() => emp.payments.add(payment)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final payments = [...emp.payments]..sort((a, b) => b.date.compareTo(a.date));
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
                end: Alignment.bottomRight),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Payments',
                style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 17, fontWeight: FontWeight.w600,
                    color: Colors.white)),
            Text(emp.name,
                style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 11.5, color: Colors.white70)),
          ],
        ),
      ),
      body: Column(
        children: [
          // ── Balance summary card ───────────────────────────────────────
          _buildSummaryCard(),

          // ── Add Payment button ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [AppColors.topbarStart, AppColors.topbarEnd]),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: _showAddPaymentSheet,
                  icon: const Icon(Icons.add_rounded,
                      color: Colors.white, size: 20),
                  label: Text('Add Payment',
                      style: TextStyle(fontFamily: 'Poppins', 
                          fontSize: 15, fontWeight: FontWeight.w700,
                          color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ),
          ),

          // ── Section header ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
            child: Row(
              children: [
                Text('Transaction History',
                    style: TextStyle(fontFamily: 'Poppins', 
                        fontSize: 14, fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const Spacer(),
                Text(
                  '${payments.length} record${payments.length == 1 ? '' : 's'}',
                  style: TextStyle(fontFamily: 'Poppins', 
                      fontSize: 12, color: AppColors.textHint),
                ),
              ],
            ),
          ),

          // ── Payment list ──────────────────────────────────────────────
          Expanded(
            child: payments.isEmpty
                ? _buildEmpty()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                    itemCount: payments.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 10),
                    itemBuilder: (_, i) => _PaymentTile(
                      payment: payments[i],
                      fmt: _fmt,
                      dateFmt: _dateFmt,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final isPaidUp = emp.isPaidUp;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [AppColors.topbarStart, AppColors.topbarEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.28),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white.withValues(alpha: 0.20),
                  child: Text(emp.initials,
                      style: TextStyle(fontFamily: 'Poppins', 
                          fontSize: 17, fontWeight: FontWeight.w800,
                          color: Colors.white)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(emp.name,
                          style: TextStyle(fontFamily: 'Poppins', 
                              fontSize: 15, fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      Text(
                        '${emp.role}  ·  ₹${emp.ratePerItem.toStringAsFixed(0)}/item',
                        style: TextStyle(fontFamily: 'Poppins', 
                            fontSize: 11.5, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                // Balance chip
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.30)),
                  ),
                  child: Text(
                    isPaidUp
                        ? 'Paid Up ✓'
                        : '₹${_fmt.format(emp.balance)} due',
                    style: TextStyle(fontFamily: 'Poppins', 
                        fontSize: 12, fontWeight: FontWeight.w700,
                        color: isPaidUp
                            ? const Color(0xFFA5D6A7)
                            : const Color(0xFFFFCC80)),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.15),
              borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(18)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _BannerStat(
                  label: 'Total Earned',
                  value: '₹${_fmt.format(emp.totalEarned)}',
                  icon: Icons.trending_up_rounded,
                  color: const Color(0xFFA5D6A7),
                ),
                _Divider(),
                _BannerStat(
                  label: 'Total Paid',
                  value: '₹${_fmt.format(emp.totalPaid)}',
                  icon: Icons.check_circle_outline_rounded,
                  color: const Color(0xFF90CAF9),
                ),
                _Divider(),
                _BannerStat(
                  label: 'Balance Due',
                  value: isPaidUp
                      ? 'Paid Up ✓'
                      : '₹${_fmt.format(emp.balance)}',
                  icon: isPaidUp
                      ? Icons.done_all_rounded
                      : Icons.warning_amber_rounded,
                  color: isPaidUp
                      ? const Color(0xFFA5D6A7)
                      : const Color(0xFFFFCC80),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.payments_outlined,
              size: 56,
              color: AppColors.textHint.withValues(alpha: 0.50)),
          const SizedBox(height: 12),
          Text('No payments recorded yet',
              style: TextStyle(fontFamily: 'Poppins', 
                  fontSize: 15, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text('Tap "Add Payment" above to record one',
              style: TextStyle(fontFamily: 'Poppins', 
                  fontSize: 12, color: AppColors.textHint)),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  Payment tile
// ════════════════════════════════════════════════════════════════════════════

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({
    required this.payment,
    required this.fmt,
    required this.dateFmt,
  });
  final EmpPayment   payment;
  final NumberFormat fmt;
  final DateFormat   dateFmt;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.subtle,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Row(
          children: [
            // Green rupee circle
            Container(
              width: 46, height: 46,
              decoration: const BoxDecoration(
                  color: AppColors.successLight, shape: BoxShape.circle),
              child: const Icon(Icons.currency_rupee_rounded,
                  color: AppColors.success, size: 22),
            ),
            const SizedBox(width: 14),
            // Amount + date + note
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '₹${fmt.format(payment.amount)}',
                    style: TextStyle(fontFamily: 'Poppins', 
                        fontSize: 18, fontWeight: FontWeight.w800,
                        color: AppColors.success),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded,
                          size: 12, color: AppColors.textHint),
                      const SizedBox(width: 4),
                      Text(dateFmt.format(payment.date),
                          style: TextStyle(fontFamily: 'Poppins', 
                              fontSize: 12, color: AppColors.textSecondary)),
                      if (payment.givenBy.isNotEmpty) ...[
                        const SizedBox(width: 10),
                        const Icon(Icons.person_rounded,
                            size: 12, color: AppColors.textHint),
                        const SizedBox(width: 3),
                        Text(payment.givenBy,
                            style: TextStyle(fontFamily: 'Poppins', 
                                fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ],
                  ),
                  // Note — only if present
                  if (payment.note != null &&
                      payment.note!.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.notes_rounded,
                            size: 12, color: AppColors.textHint),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(payment.note!,
                              style: TextStyle(fontFamily: 'Poppins', 
                                  fontSize: 11.5,
                                  color: AppColors.textSecondary,
                                  fontStyle: FontStyle.italic),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            // Paid badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.check_rounded,
                  size: 16, color: AppColors.success),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  Add Payment bottom sheet
// ════════════════════════════════════════════════════════════════════════════

class _AddPaymentSheet extends StatefulWidget {
  const _AddPaymentSheet({
    required this.employee,
    required this.onSave,
  });
  final Employee                employee;
  final ValueChanged<EmpPayment> onSave;

  @override
  State<_AddPaymentSheet> createState() => _AddPaymentSheetState();
}

class _AddPaymentSheetState extends State<_AddPaymentSheet> {
  final _amtCtrl  = TextEditingController();
  final _noteCtrl = TextEditingController();
  DateTime _date  = DateTime.now();
  final _dateFmt  = DateFormat('dd MMM yyyy');
  final _fmt      = NumberFormat('#,##0.00');

  @override
  void dispose() {
    _amtCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
              primary: AppColors.primary, onPrimary: Colors.white),
        ),
        child: child!,
      ),
    );
    if (d != null) setState(() => _date = d);
  }

  void _save() {
    final amount = double.tryParse(_amtCtrl.text.trim());
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Enter a valid amount',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 13)),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    widget.onSave(EmpPayment(
      id: DateTime.now().millisecondsSinceEpoch,
      date: _date,
      amount: amount,
      givenBy: 'Manager',
      note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom +
        MediaQuery.of(context).padding.bottom;
    final emp     = widget.employee;
    final balance = emp.balance;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 8, 20, 20 + bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Handle ────────────────────────────────────────────────
            Center(
              child: Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(top: 8, bottom: 16),
                decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(4)),
              ),
            ),

            // ── Header ────────────────────────────────────────────────
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: emp.color.withValues(alpha: 0.14),
                  child: Text(emp.initials,
                      style: TextStyle(fontFamily: 'Poppins', 
                          fontSize: 12, fontWeight: FontWeight.w800,
                          color: emp.color)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Add Payment — ${emp.name}',
                          style: TextStyle(fontFamily: 'Poppins', 
                              fontSize: 15, fontWeight: FontWeight.w700)),
                      Text(
                        emp.isPaidUp
                            ? 'No balance due — all paid up'
                            : 'Balance due: ₹${_fmt.format(balance)}',
                        style: TextStyle(fontFamily: 'Poppins', 
                            fontSize: 12.5,
                            color: emp.isPaidUp
                                ? AppColors.success
                                : AppColors.error,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Amount field ──────────────────────────────────────────
            _SheetLabel('Amount (₹)'),
            const SizedBox(height: 6),
            TextField(
              controller: _amtCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              style: TextStyle(fontFamily: 'Poppins', 
                  fontSize: 26, fontWeight: FontWeight.w800,
                  color: AppColors.primary),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 26, fontWeight: FontWeight.w800,
                    color: AppColors.textHint),
                prefixIcon: const Icon(Icons.currency_rupee_rounded,
                    color: AppColors.primary, size: 22),
                suffix: !emp.isPaidUp
                    ? GestureDetector(
                        onTap: () => setState(
                            () => _amtCtrl.text = balance.toStringAsFixed(0)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight.withValues(alpha: 0.50),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('Full ₹${balance.toStringAsFixed(0)}',
                              style: TextStyle(fontFamily: 'Poppins', 
                                  fontSize: 11, fontWeight: FontWeight.w700,
                                  color: AppColors.primary)),
                        ),
                      )
                    : null,
                filled: true,
                fillColor: AppColors.primaryLight.withValues(alpha: 0.08),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.border)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.border)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide:
                        const BorderSide(color: AppColors.primary, width: 2)),
              ),
            ),
            const SizedBox(height: 16),

            // ── Date picker ───────────────────────────────────────────
            _SheetLabel('Payment Date'),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.calendar_today_rounded,
                        size: 18, color: AppColors.primary),
                    const SizedBox(width: 10),
                    Text(_dateFmt.format(_date),
                        style: TextStyle(fontFamily: 'Poppins', 
                            fontSize: 14, fontWeight: FontWeight.w600,
                            color: AppColors.primary)),
                    const SizedBox(width: 8),
                    const Icon(Icons.edit_rounded,
                        size: 14, color: AppColors.textHint),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Note (optional) ───────────────────────────────────────
            _SheetLabel('Note (optional)'),
            const SizedBox(height: 6),
            TextField(
              controller: _noteCtrl,
              maxLines: 2,
              style: TextStyle(fontFamily: 'Poppins', fontSize: 13),
              decoration: InputDecoration(
                hintText: 'e.g. Weekly salary, advance, bonus…',
                hintStyle: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 13, color: AppColors.textHint),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(top: 12, left: 12, right: 8),
                  child: Icon(Icons.notes_rounded,
                      size: 18, color: AppColors.textHint),
                ),
                prefixIconConstraints: const BoxConstraints(),
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.border)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.border)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                        color: AppColors.primary, width: 1.8)),
              ),
            ),
            const SizedBox(height: 14),

            // ── Given by (auto) ───────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surface2,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.person_rounded,
                      size: 16, color: AppColors.textHint),
                  const SizedBox(width: 8),
                  Text('Given by: ',
                      style: TextStyle(fontFamily: 'Poppins', 
                          fontSize: 13, color: AppColors.textHint)),
                  Text('Manager',
                      style: TextStyle(fontFamily: 'Poppins', 
                          fontSize: 13, fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Confirm button ────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 52,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [AppColors.topbarStart, AppColors.topbarEnd]),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.check_circle_rounded,
                      size: 20, color: Colors.white),
                  label: Text('Confirm Payment',
                      style: TextStyle(fontFamily: 'Poppins', 
                          fontSize: 15, fontWeight: FontWeight.w700,
                          color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  Helper widgets
// ════════════════════════════════════════════════════════════════════════════

class _SheetLabel extends StatelessWidget {
  const _SheetLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(text,
      style: TextStyle(fontFamily: 'Poppins', 
          fontSize: 12.5, fontWeight: FontWeight.w600,
          color: AppColors.textSecondary));
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final String value;
  final Color  color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontFamily: 'Poppins', 
                fontSize: 10, color: AppColors.textHint,
                fontWeight: FontWeight.w500)),
        Text(value,
            style: TextStyle(fontFamily: 'Poppins', 
                fontSize: 13, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }
}

class _BannerStat extends StatelessWidget {
  const _BannerStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
  final String   label;
  final String   value;
  final IconData icon;
  final Color    color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 5),
        Text(value,
            style: TextStyle(fontFamily: 'Poppins', 
                fontSize: 14, fontWeight: FontWeight.w800,
                color: Colors.white)),
        Text(label,
            style: TextStyle(fontFamily: 'Poppins', fontSize: 10.5, color: Colors.white60)),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: 1,
        height: 40,
        color: Colors.white.withValues(alpha: 0.20),
      );
}
