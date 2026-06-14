// ════════════════════════════════════════════════════════════════════════════
//  employee_detail_screen.dart
//  Pranav Ladies Tailors — Employee Detail (Current Work + Work History)
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:pranav_tailors/core/theme/app_theme.dart';
import 'package:pranav_tailors/features/manager/screens/employees_screen.dart'
    show Employee, EmpWorkItem;

// ════════════════════════════════════════════════════════════════════════════
//  Screen
// ════════════════════════════════════════════════════════════════════════════

class EmployeeDetailScreen extends StatefulWidget {
  const EmployeeDetailScreen({super.key, required this.employee});
  final Employee employee;

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  final _dateFmt = DateFormat('dd MMM yyyy');

  Employee get emp => widget.employee;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 12),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                _CurrentWorkTab(emp: emp, dateFmt: _dateFmt),
                _WorkHistoryTab(emp: emp, dateFmt: _dateFmt),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── App Bar ───────────────────────────────────────────────────────────────
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
      title: Text(emp.name,
          style: TextStyle(fontFamily: 'Poppins', 
              fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white)),
    );
  }

  // ── Employee header card ──────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: emp.color.withValues(alpha: 0.10),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 30,
            backgroundColor: emp.color.withValues(alpha: 0.14),
            child: Text(emp.initials,
                style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 20, fontWeight: FontWeight.w800,
                    color: emp.color)),
          ),
          const SizedBox(width: 14),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(emp.name,
                    style: TextStyle(fontFamily: 'Poppins', 
                        fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: emp.color.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(emp.role,
                          style: TextStyle(fontFamily: 'Poppins', 
                              fontSize: 11, fontWeight: FontWeight.w600,
                              color: emp.color)),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.phone_rounded,
                        size: 12, color: AppColors.textHint),
                    const SizedBox(width: 3),
                    Text(emp.phone,
                        style: TextStyle(fontFamily: 'Poppins', 
                            fontSize: 12.5,
                            color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
          // Summary stats
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _StatPill(
                icon: Icons.pending_actions_rounded,
                label: '${emp.activeCount} active',
                color: emp.activeCount > 0
                    ? const Color(0xFF1565C0)
                    : AppColors.success,
              ),
              const SizedBox(height: 6),
              _StatPill(
                icon: Icons.check_circle_rounded,
                label: '${emp.completedWork.length} done',
                color: AppColors.success,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Segmented tab bar ─────────────────────────────────────────────────────
  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: TabBar(
        controller: _tab,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelStyle: TextStyle(fontFamily: 'Poppins', 
            fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontFamily: 'Poppins', 
            fontSize: 13, fontWeight: FontWeight.w400),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        padding: const EdgeInsets.all(4),
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.pending_actions_rounded, size: 15),
                const SizedBox(width: 6),
                Text('Current Work (${emp.activeCount})'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.work_history_rounded, size: 15),
                const SizedBox(width: 6),
                Text('History (${emp.completedWork.length})'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Small stat pill widget ────────────────────────────────────────────────────
class _StatPill extends StatelessWidget {
  const _StatPill({required this.icon, required this.label, required this.color});
  final IconData icon;
  final String   label;
  final Color    color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(fontFamily: 'Poppins', 
                  fontSize: 11.5, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  Tab 1: Current Work
// ════════════════════════════════════════════════════════════════════════════

class _CurrentWorkTab extends StatelessWidget {
  const _CurrentWorkTab({required this.emp, required this.dateFmt});
  final Employee   emp;
  final DateFormat dateFmt;

  @override
  Widget build(BuildContext context) {
    final items = emp.currentWork;
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline_rounded,
                size: 52,
                color: AppColors.success.withValues(alpha: 0.40)),
            const SizedBox(height: 12),
            Text('No active work items',
                style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 15, color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            Text('This employee is currently free',
                style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 12, color: AppColors.textHint)),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _CurrentWorkCard(item: items[i], dateFmt: dateFmt),
    );
  }
}

class _CurrentWorkCard extends StatelessWidget {
  const _CurrentWorkCard({required this.item, required this.dateFmt});
  final EmpWorkItem item;
  final DateFormat  dateFmt;

  bool get _isOverdue =>
      item.deliveryDate.isBefore(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final overdue = _isOverdue;
    return Container(
      decoration: BoxDecoration(
        color: overdue
            ? AppColors.errorLight
            : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: overdue
              ? AppColors.error.withValues(alpha: 0.50)
              : AppColors.border,
          width: overdue ? 1.5 : 1,
        ),
        boxShadow: AppShadows.subtle,
      ),
      child: Column(
        children: [
          // Top stripe — pink for in-progress, red for overdue
          Container(
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: overdue
                  ? [AppColors.error, AppColors.error.withValues(alpha: 0.50)]
                  : [AppColors.primary, AppColors.primaryLight]),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Icon ────────────────────────────────────────────────
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withValues(alpha: 0.40),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.style_rounded,
                      color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 12),
                // ── Info ─────────────────────────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(item.customer,
                                style: TextStyle(fontFamily: 'Poppins', 
                                    fontSize: 14, fontWeight: FontWeight.w700)),
                          ),
                          if (item.isUrgent) _UrgentBadge(),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(item.itemType,
                          style: TextStyle(fontFamily: 'Poppins', 
                              fontSize: 12.5,
                              color: AppColors.textSecondary)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          // Delivery date chip
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: overdue
                                  ? AppColors.error.withValues(alpha: 0.10)
                                  : AppColors.primaryLight.withValues(alpha: 0.40),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: overdue
                                    ? AppColors.error.withValues(alpha: 0.40)
                                    : AppColors.primary.withValues(alpha: 0.30),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  overdue
                                      ? Icons.warning_rounded
                                      : Icons.event_rounded,
                                  size: 11,
                                  color: overdue
                                      ? AppColors.error
                                      : AppColors.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  overdue
                                      ? 'Overdue · ${dateFmt.format(item.deliveryDate)}'
                                      : 'Due ${dateFmt.format(item.deliveryDate)}',
                                  style: TextStyle(fontFamily: 'Poppins', 
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                    color: overdue
                                        ? AppColors.error
                                        : AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          // Status chip
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1565C0).withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('In Progress',
                                style: TextStyle(fontFamily: 'Poppins', 
                                    fontSize: 10.5, fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1565C0))),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Urgent badge ──────────────────────────────────────────────────────────────
class _UrgentBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.urgent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.urgent.withValues(alpha: 0.40)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bolt_rounded, size: 11, color: AppColors.urgent),
          const SizedBox(width: 2),
          Text('Urgent',
              style: TextStyle(fontFamily: 'Poppins', 
                  fontSize: 10, fontWeight: FontWeight.w700,
                  color: AppColors.urgent)),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  Tab 2: Work History (completed only)
// ════════════════════════════════════════════════════════════════════════════

class _WorkHistoryTab extends StatelessWidget {
  const _WorkHistoryTab({required this.emp, required this.dateFmt});
  final Employee   emp;
  final DateFormat dateFmt;

  @override
  Widget build(BuildContext context) {
    final items = emp.completedWork;
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.history_rounded,
                size: 52, color: AppColors.textHint.withValues(alpha: 0.50)),
            const SizedBox(height: 12),
            Text('No completed work yet',
                style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 15, color: AppColors.textSecondary)),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _HistoryCard(item: items[i], dateFmt: dateFmt),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.item, required this.dateFmt});
  final EmpWorkItem item;
  final DateFormat  dateFmt;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        leading: Container(
          width: 42, height: 42,
          decoration: BoxDecoration(
            color: AppColors.successLight,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_circle_rounded,
              size: 22, color: AppColors.success),
        ),
        title: Text(item.customer,
            style: TextStyle(fontFamily: 'Poppins', 
                fontSize: 14, fontWeight: FontWeight.w700)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(item.itemType,
                style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 12.5, color: AppColors.textSecondary)),
            const SizedBox(height: 5),
            if (item.completionDate != null)
              Row(
                children: [
                  const Icon(Icons.event_available_rounded,
                      size: 12, color: AppColors.textHint),
                  const SizedBox(width: 4),
                  Text(
                    'Completed ${dateFmt.format(item.completionDate!)}',
                    style: TextStyle(fontFamily: 'Poppins', 
                        fontSize: 11, color: AppColors.textHint),
                  ),
                ],
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('₹${item.earning.toStringAsFixed(0)}',
                style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 15, fontWeight: FontWeight.w800,
                    color: AppColors.success)),
            Text('earned',
                style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 10, color: AppColors.textHint)),
          ],
        ),
      ),
    );
  }
}
