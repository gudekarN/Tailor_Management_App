// ════════════════════════════════════════════════════════════════════════════
//  employee_my_payment_screen.dart
//  Pranav Ladies Tailors — Employee Personal Payment / Earnings Screen
//  Employee: Sunita  ·  Blush Rose + Gold theme
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:pranav_tailors/core/theme/app_theme.dart';

// ═════════════════════════════════════════════════════════════════════════════
//  Dummy data
// ═════════════════════════════════════════════════════════════════════════════

// ── Summary totals ────────────────────────────────────────────────────────────
const int _totalEarned   = 11050;
const int _totalReceived = 7400;
const int _balanceDue    = _totalEarned - _totalReceived; // 3650

// ── Week chart: last 7 days (Mon–Sun) in ₹ ───────────────────────────────────
const _kWeekBars = [
  (label: 'Mon', amount: 0.0),
  (label: 'Tue', amount: 1200.0),
  (label: 'Wed', amount: 0.0),
  (label: 'Thu', amount: 1800.0),
  (label: 'Fri', amount: 1650.0),
  (label: 'Sat', amount: 2200.0),
  (label: 'Sun', amount: 0.0),
];

// ── Month chart: last 4 weeks in ₹ ──────────────────────────────────────────
const _kMonthBars = [
  (label: 'W1', amount: 2900.0),
  (label: 'W2', amount: 1800.0),
  (label: 'W3', amount: 3250.0),
  (label: 'W4', amount: 3100.0),
];

// ── Payment history ───────────────────────────────────────────────────────────
class _HistoryEntry {
  const _HistoryEntry({
    required this.date,
    required this.description,
    required this.givenBy,
    required this.amount,
    this.isDeduction = false,
  });
  final String date;
  final String description;
  final String givenBy;
  final int    amount;
  final bool   isDeduction;
}

const _kHistory = [
  _HistoryEntry(
    date:        '12 Jun 2026',
    description: 'Weekly payment — Week of 9 Jun',
    givenBy:     'Pranav (Manager)',
    amount:      2500,
  ),
  _HistoryEntry(
    date:        '05 Jun 2026',
    description: 'Weekly payment — Week of 2 Jun',
    givenBy:     'Pranav (Manager)',
    amount:      2900,
  ),
  _HistoryEntry(
    date:        '29 May 2026',
    description: 'Weekly payment — Week of 26 May',
    givenBy:     'Pranav (Manager)',
    amount:      2000,
  ),
  _HistoryEntry(
    date:        '22 May 2026',
    description: 'Advance payment — May batch',
    givenBy:     'Pranav (Manager)',
    amount:      1500,
  ),
  _HistoryEntry(
    date:        '15 May 2026',
    description: 'Festival bonus deduction (absent)',
    givenBy:     'Pranav (Manager)',
    amount:      400,
    isDeduction: true,
  ),
  _HistoryEntry(
    date:        '08 May 2026',
    description: 'Weekly payment — Week of 5 May',
    givenBy:     'Pranav (Manager)',
    amount:      1800,
  ),
];

// ═════════════════════════════════════════════════════════════════════════════
//  Screen
// ═════════════════════════════════════════════════════════════════════════════

enum _ChartFilter { week, month }

class EmployeeMyPaymentScreen extends StatefulWidget {
  const EmployeeMyPaymentScreen({super.key});
  @override
  State<EmployeeMyPaymentScreen> createState() =>
      _EmployeeMyPaymentScreenState();
}

class _EmployeeMyPaymentScreenState extends State<EmployeeMyPaymentScreen> {
  _ChartFilter _filter = _ChartFilter.week;
  final _moneyFmt = NumberFormat('#,##0');

  // Bars for the active filter
  List<({String label, double amount})> get _activeBars =>
      _filter == _ChartFilter.week ? _kWeekBars : _kMonthBars;

  double get _maxY {
    final m = _activeBars.map((b) => b.amount).reduce((a, b) => a > b ? a : b);
    return (m * 1.28).ceilToDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Gradient header ──────────────────────────────────────────────
          _buildHeader(context),

          // ── Body padding ─────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Earnings chart ────────────────────────────────────────
                _buildChartCard(),
                const SizedBox(height: 24),

                // ── Payment history section ───────────────────────────────
                _buildSectionHeader(
                  'Payment History',
                  '${_kHistory.length} transactions',
                ),
                const SizedBox(height: 12),
                ..._kHistory.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _HistoryTile(entry: e, moneyFmt: _moneyFmt),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ── Gradient SliverAppBar ───────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 210,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.topbarStart, AppColors.topbarEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Employee name row
                  Row(
                    children: [
                      // Avatar
                      Container(
                        width: 46, height: 46,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryDark.withValues(alpha: 0.30),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text('S',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Sunita',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text('My Payments',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 10.5,
                                    color: Colors.white70)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Three summary tiles
                  Row(
                    children: [
                      _HeaderTile(
                        label: 'Total Earned',
                        value: '₹${_moneyFmt.format(_totalEarned)}',
                        icon: Icons.workspace_premium_rounded,
                        bgColor: Colors.white.withValues(alpha: 0.15),
                      ),
                      const SizedBox(width: 8),
                      _HeaderTile(
                        label: 'Received',
                        value: '₹${_moneyFmt.format(_totalReceived)}',
                        icon: Icons.payments_rounded,
                        bgColor: Colors.white.withValues(alpha: 0.15),
                      ),
                      const SizedBox(width: 8),
                      _HeaderTile(
                        label: 'Balance Due',
                        value: '₹${_moneyFmt.format(_balanceDue)}',
                        icon: Icons.account_balance_wallet_rounded,
                        bgColor: const Color(0xFFFF4081).withValues(alpha: 0.28),
                        valueColor: const Color(0xFFFFCDD2),
                        highlighted: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      title: const Text('My Payments',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.white)),
    );
  }

  // ── Earnings chart card ─────────────────────────────────────────────────────
  Widget _buildChartCard() {
    final isWeek = _filter == _ChartFilter.week;
    final topAmount = _activeBars.map((b) => b.amount).reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppShadows.card,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chart header row
          Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.bar_chart_rounded,
                    color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Earnings Overview',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary)),
                    Text(
                      isWeek
                          ? 'Daily earnings — this week'
                          : 'Weekly earnings — this month',
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: AppColors.textHint),
                    ),
                  ],
                ),
              ),
              // Week / Month toggle
              Container(
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.surface2,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _FilterBtn(
                      label: 'Week',
                      active: _filter == _ChartFilter.week,
                      onTap: () => setState(() => _filter = _ChartFilter.week),
                    ),
                    _FilterBtn(
                      label: 'Month',
                      active: _filter == _ChartFilter.month,
                      onTap: () => setState(() => _filter = _ChartFilter.month),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Bar chart
          SizedBox(
            height: 175,
            child: BarChart(
              BarChartData(
                maxY: _maxY,
                minY: 0,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: _maxY / 4,
                  getDrawingHorizontalLine: (_) => const FlLine(
                    color: AppColors.border,
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 48,
                      interval: _maxY / 4,
                      getTitlesWidget: (v, _) {
                        if (v == 0) return const SizedBox();
                        return Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text(
                            '₹${_moneyFmt.format(v.toInt())}',
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 8,
                                color: AppColors.textHint),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (v, _) {
                        final i = v.toInt();
                        if (i < 0 || i >= _activeBars.length) {
                          return const SizedBox();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            _activeBars[i].label,
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(_activeBars.length, (i) {
                  final isTop = _activeBars[i].amount == topAmount &&
                      _activeBars[i].amount > 0;
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: _activeBars[i].amount,
                        width: isWeek ? 24 : 42,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(7)),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: isTop
                              // Gold accent for highest bar
                              ? [
                                  const Color(0xFFB8860B),
                                  const Color(0xFFF5D87A),
                                ]
                              : [
                                  // Pink bars
                                  AppColors.primary.withValues(alpha: 0.60),
                                  const Color(0xFFE91E63),
                                ],
                        ),
                      ),
                    ],
                  );
                }),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppColors.primaryDark,
                    tooltipRoundedRadius: 8,
                    getTooltipItem: (group, _, rod, __) => BarTooltipItem(
                      '₹${_moneyFmt.format(rod.toY.toInt())}',
                      const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              swapAnimationDuration: const Duration(milliseconds: 380),
              swapAnimationCurve: Curves.easeOutCubic,
            ),
          ),
        ],
      ),
    );
  }

  // ── Section header ──────────────────────────────────────────────────────────
  Widget _buildSectionHeader(String title, String count) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title,
            style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const Spacer(),
        Text(count,
            style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: AppColors.textHint)),
      ],
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
//  Header summary tile
// ═════════════════════════════════════════════════════════════════════════════

class _HeaderTile extends StatelessWidget {
  const _HeaderTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.bgColor,
    this.valueColor,
    this.highlighted = false,
  });
  final String   label, value;
  final IconData icon;
  final Color    bgColor;
  final Color?   valueColor;
  final bool     highlighted;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: highlighted
              ? Border.all(
                  color: Colors.white.withValues(alpha: 0.35), width: 1.5)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 12, color: Colors.white70),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(label,
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 9.5,
                          color: Colors.white70)),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(value,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: valueColor ?? Colors.white),
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
//  Filter toggle button (Week / Month)
// ═════════════════════════════════════════════════════════════════════════════

class _FilterBtn extends StatelessWidget {
  const _FilterBtn({
    required this.label,
    required this.active,
    required this.onTap,
  });
  final String       label;
  final bool         active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Text(
          label,
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: active ? Colors.white : AppColors.textSecondary),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
//  Payment History Tile
// ═════════════════════════════════════════════════════════════════════════════

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.entry, required this.moneyFmt});
  final _HistoryEntry entry;
  final NumberFormat  moneyFmt;

  @override
  Widget build(BuildContext context) {
    final isReceived = !entry.isDeduction;
    final color      = isReceived ? AppColors.success : AppColors.error;
    final sign       = isReceived ? '+' : '-';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.subtle,
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isReceived
                  ? Icons.check_circle_rounded
                  : Icons.remove_circle_rounded,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),

          // Description + meta
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.description,
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded,
                        size: 11, color: AppColors.textHint),
                    const SizedBox(width: 4),
                    Text(entry.date,
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10.5,
                            color: AppColors.textHint)),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.person_rounded,
                        size: 11, color: AppColors.textHint),
                    const SizedBox(width: 4),
                    Text(entry.givenBy,
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10.5,
                            color: AppColors.textHint)),
                  ],
                ),
              ],
            ),
          ),

          // Amount + badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$sign₹${moneyFmt.format(entry.amount)}',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: color),
              ),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isReceived
                          ? Icons.check_rounded
                          : Icons.close_rounded,
                      size: 10,
                      color: color,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      isReceived ? 'Received' : 'Deducted',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                          color: color),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
