// ════════════════════════════════════════════════════════════════════════════
//  expense_tracker_screen.dart
//  Pranav Ladies Tailors — Expense Tracker (Manager)
// ════════════════════════════════════════════════════════════════════════════

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:pranav_tailors/core/theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════════════════
//  Data models
// ════════════════════════════════════════════════════════════════════════════

enum _ExpType { stitchBill, employeePayment }

class _Expense {
  const _Expense({
    required this.id,
    required this.type,
    required this.description,
    required this.amount,
    required this.date,
  });
  final int      id;
  final _ExpType type;
  final String   description;
  final double   amount;
  final DateTime date;
}

class _MonthData {
  const _MonthData(this.label, this.stitchBills, this.empPayments);
  final String label;
  final double stitchBills;
  final double empPayments;
}

// ════════════════════════════════════════════════════════════════════════════
//  Dummy data — last 6 months + current-month transactions
// ════════════════════════════════════════════════════════════════════════════

// Bar chart monthly aggregates (Jan – Jun 2026)
const _kMonthData = [
  _MonthData('Jan', 15200, 9500),
  _MonthData('Feb', 11800, 7800),
  _MonthData('Mar', 18600, 11200),
  _MonthData('Apr', 14200, 8900),
  _MonthData('May', 16800, 10400),
  _MonthData('Jun',  8400,  5630), // partial (current)
];

final _kTransactions = <_Expense>[
  _Expense(id:  1, type: _ExpType.stitchBill,     description: 'Customer Payment - Anita',  amount: 2500, date: DateTime(2026,6,11)),
  _Expense(id:  2, type: _ExpType.stitchBill,     description: 'Stitch Bill #1042',         amount: 1200, date: DateTime(2026,6,11)),
  _Expense(id:  3, type: _ExpType.employeePayment, description: 'Kaveri Shinde — top-up',    amount:   80, date: DateTime(2026,6,11)),
  _Expense(id:  4, type: _ExpType.employeePayment, description: 'Anita Kale — weekly pay',   amount:   50, date: DateTime(2026,6,9)),
  _Expense(id:  5, type: _ExpType.stitchBill,     description: 'Customer Payment - Pooja',  amount:  900, date: DateTime(2026,6,9)),
  _Expense(id:  6, type: _ExpType.employeePayment, description: 'Sunanda More — partial',    amount: 2000, date: DateTime(2026,6,8)),
  _Expense(id:  7, type: _ExpType.employeePayment, description: 'Rekha Jadhav — full pay',   amount:  200, date: DateTime(2026,6,7)),
  _Expense(id:  8, type: _ExpType.stitchBill,     description: 'Stitch Bill #1041',         amount: 1500, date: DateTime(2026,6,6)),
  _Expense(id:  9, type: _ExpType.employeePayment, description: 'Priya Kulkarni — May bal.', amount: 1800, date: DateTime(2026,6,5)),
  _Expense(id: 10, type: _ExpType.stitchBill,     description: 'Customer Payment - Deepa',  amount: 1100, date: DateTime(2026,6,4)),
  _Expense(id: 11, type: _ExpType.stitchBill,     description: 'Stitch Bill #1040',         amount:  850, date: DateTime(2026,6,2)),
  _Expense(id: 12, type: _ExpType.employeePayment, description: 'Kaveri Shinde — advance',   amount: 1500, date: DateTime(2026,6,1)),
  _Expense(id: 13, type: _ExpType.stitchBill,     description: 'Customer Payment - Lata',   amount: 1800, date: DateTime(2026,6,1)),
];

// ════════════════════════════════════════════════════════════════════════════
//  Screen
// ════════════════════════════════════════════════════════════════════════════

class ExpenseTrackerScreen extends StatefulWidget {
  const ExpenseTrackerScreen({super.key});
  @override
  State<ExpenseTrackerScreen> createState() => _ExpenseTrackerScreenState();
}

class _ExpenseTrackerScreenState extends State<ExpenseTrackerScreen> {
  int _filter = 0; // 0=All, 1=Stitch Bills, 2=Emp Payments
  final _amtFmt  = NumberFormat('#,##0');
  final _dateFmt = DateFormat('dd MMM');

  // Pre-compute this-month totals
  double get _monthEarnings =>
      _kTransactions.where((e) => e.type == _ExpType.stitchBill)
          .fold(0.0, (s, e) => s + e.amount);

  double get _monthExpenses =>
      _kTransactions.where((e) => e.type == _ExpType.employeePayment)
          .fold(0.0, (s, e) => s + e.amount);

  double get _monthNet => _monthEarnings - _monthExpenses;

  List<_Expense> get _filtered => switch (_filter) {
        1 => _kTransactions.where((e) => e.type == _ExpType.stitchBill).toList(),
        2 => _kTransactions.where((e) => e.type == _ExpType.employeePayment).toList(),
        _ => _kTransactions,
      };

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: CustomScrollView(
        slivers: [
          // Summary card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: _buildSummaryCard(),
            ),
          ),
          // Chart card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: _buildChartCard(),
            ),
          ),
          // Filter row
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
              child: _buildFilterRow(),
            ),
          ),
          // Transactions header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 4),
              child: Row(
                children: [
                  Text('Transactions',
                      style: TextStyle(fontFamily: 'Poppins', 
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary)),
                  const Spacer(),
                  Text('${filtered.length} record${filtered.length == 1 ? '' : 's'}',
                      style: TextStyle(fontFamily: 'Poppins', 
                          fontSize: 12, color: AppColors.textHint)),
                ],
              ),
            ),
          ),
          // Transaction list
          filtered.isEmpty
              ? SliverFillRemaining(child: _buildEmpty())
              : SliverList.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildTransactionCard(filtered[i]),
                  ),
                ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
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
      title: Text('Expense Tracker',
          style: TextStyle(fontFamily: 'Poppins', 
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 12, top: 12, bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.20),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text('Jun 2026',
              style: TextStyle(fontFamily: 'Poppins', 
                  fontSize: 12, fontWeight: FontWeight.w600,
                  color: Colors.white)),
        ),
      ],
    );
  }

  // ── Summary card ──────────────────────────────────────────────────────────
  Widget _buildSummaryCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.topbarStart, AppColors.topbarEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.28),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.account_balance_wallet_rounded,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('This Month Overview',
                        style: TextStyle(fontFamily: 'Poppins', 
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70)),
                    Text('June 2026',
                        style: TextStyle(fontFamily: 'Poppins', 
                            fontSize: 11, color: Colors.white54)),
                  ],
                ),
              ],
            ),
          ),
          // Stats row
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.14),
              borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(18)),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: _SummaryStat(
                      label: 'Shop Earnings',
                      value: '₹${_amtFmt.format(_monthEarnings)}',
                      icon: Icons.trending_up_rounded,
                      color: const Color(0xFFA5D6A7),
                    ),
                  ),
                  VerticalDivider(
                      color: Colors.white.withValues(alpha: 0.20),
                      width: 1, thickness: 1),
                  Expanded(
                    child: _SummaryStat(
                      label: 'Employee Expenses',
                      value: '₹${_amtFmt.format(_monthExpenses)}',
                      icon: Icons.money_off_rounded,
                      color: const Color(0xFFFFCC80),
                    ),
                  ),
                  VerticalDivider(
                      color: Colors.white.withValues(alpha: 0.20),
                      width: 1, thickness: 1),
                  Expanded(
                    child: _SummaryStat(
                      label: 'Net Balance',
                      value: '₹${_amtFmt.format(_monthNet)}',
                      icon: Icons.account_balance_wallet_rounded,
                      color: Colors.white,
                      large: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Bar chart card ────────────────────────────────────────────────────────
  Widget _buildChartCard() {
    // Compute maxY for axis scale
    final allVals = _kMonthData
        .expand((m) => [m.stitchBills, m.empPayments]);
    final maxVal = allVals.reduce((a, b) => a > b ? a : b);
    final maxY   = ((maxVal / 5000).ceil() + 1) * 5000.0;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 10, 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + legend
          Row(
            children: [
              Text('6-Month Overview',
                  style: TextStyle(fontFamily: 'Poppins', 
                      fontSize: 13.5, fontWeight: FontWeight.w700)),
              const Spacer(),
              _LegendDot(color: AppColors.primary, label: 'Shop Earnings'),
              const SizedBox(width: 12),
              _LegendDot(color: AppColors.secondary, label: 'Employee Expenses'),
            ],
          ),
          const SizedBox(height: 16),
          // Chart
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) =>
                        AppColors.primaryDark.withValues(alpha: 0.92),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '₹${_amtFmt.format(rod.toY)}',
                        TextStyle(fontFamily: 'Poppins', 
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 11),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= _kMonthData.length) {
                          return const SizedBox.shrink();
                        }
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            _kMonthData[idx].label,
                            style: TextStyle(fontFamily: 'Poppins', 
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: idx == _kMonthData.length - 1
                                    ? AppColors.primary
                                    : AppColors.textSecondary),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 44,
                      interval: 5000,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const SizedBox.shrink();
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            '₹${(value / 1000).toStringAsFixed(0)}k',
                            style: TextStyle(fontFamily: 'Poppins', 
                                fontSize: 10, color: AppColors.textHint),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 5000,
                  getDrawingHorizontalLine: (_) => const FlLine(
                    color: AppColors.border,
                    strokeWidth: 0.8,
                  ),
                ),
                barGroups: List.generate(_kMonthData.length, (i) {
                  final d = _kMonthData[i];
                  final isCurrent = i == _kMonthData.length - 1;
                  return BarChartGroupData(
                    x: i,
                    barsSpace: 4,
                    barRods: [
                      BarChartRodData(
                        toY: d.stitchBills,
                        color: isCurrent
                            ? AppColors.primary
                            : AppColors.primary.withValues(alpha: 0.55),
                        width: 11,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4)),
                      ),
                      BarChartRodData(
                        toY: d.empPayments,
                        color: isCurrent
                            ? AppColors.secondary
                            : AppColors.secondary.withValues(alpha: 0.55),
                        width: 11,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4)),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          // Current month note
          const SizedBox(height: 8),
          Center(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.40),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('Bright bars = current month (partial)',
                  style: TextStyle(fontFamily: 'Poppins', 
                      fontSize: 10.5, color: AppColors.primary)),
            ),
          ),
        ],
      ),
    );
  }

  // ── Filter row ────────────────────────────────────────────────────────────
  Widget _buildFilterRow() {
    final stCount = _kTransactions
        .where((e) => e.type == _ExpType.stitchBill).length;
    final epCount = _kTransactions
        .where((e) => e.type == _ExpType.employeePayment).length;

    return Row(
      children: [
        _FilterPill(
          label: 'All',
          count: _kTransactions.length,
          active: _filter == 0,
          color: AppColors.primary,
          onTap: () => setState(() => _filter = 0),
        ),
        const SizedBox(width: 8),
        _FilterPill(
          label: 'Stitch Bills',
          count: stCount,
          active: _filter == 1,
          color: AppColors.primary,
          icon: Icons.content_cut_rounded,
          onTap: () => setState(() => _filter = 1),
        ),
        const SizedBox(width: 8),
        _FilterPill(
          label: 'Staff Pay',
          count: epCount,
          active: _filter == 2,
          color: AppColors.secondary,
          icon: Icons.people_rounded,
          onTap: () => setState(() => _filter = 2),
        ),
      ],
    );
  }

  // ── Transaction card ──────────────────────────────────────────────────────
  Widget _buildTransactionCard(_Expense exp) {
    final isStitch = exp.type == _ExpType.stitchBill;
    final color    = isStitch ? AppColors.primary : AppColors.secondary;
    final icon     = isStitch
        ? Icons.content_cut_rounded
        : Icons.person_rounded;
    final typeLabel = isStitch ? 'Stitch Bill' : 'Staff Payment';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // Icon circle
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            // Description + type + date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(exp.description,
                      style: TextStyle(fontFamily: 'Poppins', 
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(typeLabel,
                            style: TextStyle(fontFamily: 'Poppins', 
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: color)),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.calendar_today_rounded,
                          size: 11, color: AppColors.textHint),
                      const SizedBox(width: 3),
                      Text(_dateFmt.format(exp.date),
                          style: TextStyle(fontFamily: 'Poppins', 
                              fontSize: 11.5,
                              color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
            ),
            // Amount
            Text(isStitch ? '+₹${_amtFmt.format(exp.amount)}' : '−₹${_amtFmt.format(exp.amount)}',
                style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: isStitch ? AppColors.success : AppColors.error)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.receipt_long_rounded,
              size: 52,
              color: AppColors.textHint.withValues(alpha: 0.50)),
          const SizedBox(height: 10),
          Text('No expenses found',
              style: TextStyle(fontFamily: 'Poppins', 
                  fontSize: 14, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  Helper widgets
// ════════════════════════════════════════════════════════════════════════════

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.large = false,
  });
  final String   label;
  final String   value;
  final IconData icon;
  final Color    color;
  final bool     large;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: large ? 22 : 18),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(fontFamily: 'Poppins', 
                fontSize: large ? 16 : 13.5,
                fontWeight: FontWeight.w800,
                color: Colors.white)),
        Text(label,
            style: TextStyle(fontFamily: 'Poppins', 
                fontSize: 10, color: Colors.white60)),
      ],
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.count,
    required this.active,
    required this.color,
    required this.onTap,
    this.icon,
  });
  final String   label;
  final int      count;
  final bool     active;
  final Color    color;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
          decoration: BoxDecoration(
            color: active ? color : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: active ? color : AppColors.border),
            boxShadow: active
                ? [
                    BoxShadow(
                        color: color.withValues(alpha: 0.25),
                        blurRadius: 6,
                        offset: const Offset(0, 2))
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 13,
                    color: active ? Colors.white : color),
                const SizedBox(width: 5),
              ],
              Flexible(
                child: Text(label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontFamily: 'Poppins', 
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: active
                            ? Colors.white
                            : AppColors.textSecondary)),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: active
                      ? Colors.white.withValues(alpha: 0.25)
                      : AppColors.border,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('$count',
                    style: TextStyle(fontFamily: 'Poppins', 
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: active
                            ? Colors.white
                            : AppColors.textHint)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
  final Color  color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10, height: 10,
          decoration:
              BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 5),
        Text(label,
            style: TextStyle(fontFamily: 'Poppins', 
                fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}
