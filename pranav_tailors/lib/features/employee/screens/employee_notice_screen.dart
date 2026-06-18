// ════════════════════════════════════════════════════════════════════════════
//  employee_notice_screen.dart
//  Pranav Ladies Tailors — Employee Notices (Read-Only) + Delivery Dues
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pranav_tailors/core/theme/app_theme.dart';

// ═════════════════════════════════════════════════════════════════════════════
//  DATA MODELS
// ═════════════════════════════════════════════════════════════════════════════

enum _NoticePriority { normal, important, urgent }

class _Notice {
  const _Notice({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    required this.postedBy,
    this.priority = _NoticePriority.normal,
  });
  final int             id;
  final String          title;
  final String          message;
  final DateTime        date;
  final String          postedBy;
  final _NoticePriority priority;
}

class _DueItem {
  const _DueItem({
    required this.customer,
    required this.itemLabel,
    required this.deliveryDate,
    this.isUrgent = false,
    required this.receiptNo,
  });
  final String   customer;
  final String   itemLabel;
  final DateTime deliveryDate;
  final bool     isUrgent;
  final String   receiptNo;

  int get daysOverdue {
    final today = DateTime.now();
    final t = DateTime(today.year, today.month, today.day);
    final d = DateTime(deliveryDate.year, deliveryDate.month, deliveryDate.day);
    return t.difference(d).inDays;
  }

  bool get isDueToday => daysOverdue == 0;
  bool get isOverdue  => daysOverdue > 0;
}

// ─── Dummy data ───────────────────────────────────────────────────────────────

// Note: DateTime is not a const type, so data lists are final not const.
final _kNotices = [
  _Notice(
    id: 1,
    title: 'Wedding Season Rush — All Hands On Deck',
    message:
        'June and July are peak wedding season. Please prioritise silk blouse and lehenga orders. Overtime may be required this month. Quality checks are mandatory before delivery.',
    date: DateTime(2026, 6, 11),
    postedBy: 'Manager',
    priority: _NoticePriority.urgent,
  ),
  _Notice(
    id: 2,
    title: 'Revised Stitching Rate Card — Effective 1st July',
    message:
        'Starting 1 July 2026, all blouse rates will increase by ₹20 per piece. Salwar-suit and kurti rates remain unchanged. Please inform regular customers.',
    date: DateTime(2026, 6, 9),
    postedBy: 'Manager',
  ),
  _Notice(
    id: 3,
    title: 'Shop Closed — Sunday 15th June',
    message:
        'The shop will remain closed on Sunday 15 June for a public holiday. No work assignments on that day. Plan deliveries accordingly.',
    date: DateTime(2026, 6, 7),
    postedBy: 'Manager',
    priority: _NoticePriority.important,
  ),
  _Notice(
    id: 4,
    title: 'New Fabric Samples Have Arrived',
    message:
        'New silk and cotton fabric samples from Pune wholesale market are available for display. Please check the sample book for fresh patterns and colours.',
    date: DateTime(2026, 6, 5),
    postedBy: 'Manager',
  ),
  _Notice(
    id: 5,
    title: 'Employee Work Log — Submit Every Friday',
    message:
        'All tailors and helpers are required to submit their weekly work log by 6 PM every Friday. Non-submission will affect payment calculations.',
    date: DateTime(2026, 6, 1),
    postedBy: 'Manager',
    priority: _NoticePriority.important,
  ),
];

// Delivery dues assigned to Sunita (today = 15 Jun 2026)
final _kSunitaDues = [
  _DueItem(
    customer:     'Meena Patil',
    itemLabel:    'Silk Blouse',
    deliveryDate: DateTime(2026, 6, 15),
    isUrgent:     true,
    receiptNo:    'EMP-001',
  ),
  _DueItem(
    customer:     'Rekha Joshi',
    itemLabel:    'Lehenga Blouse',
    deliveryDate: DateTime(2026, 6, 15),
    isUrgent:     true,
    receiptNo:    'EMP-002',
  ),
  _DueItem(
    customer:     'Kavita Rane',
    itemLabel:    'Cotton Blouse',
    deliveryDate: DateTime(2026, 6, 10),
    isUrgent:     false,
    receiptNo:    'EMP-007',
  ),
  _DueItem(
    customer:     'Anita Kulkarni',
    itemLabel:    'Anarkali Dress',
    deliveryDate: DateTime(2026, 6, 12),
    isUrgent:     false,
    receiptNo:    'EMP-005',
  ),
  _DueItem(
    customer:     'Sunita Desai',
    itemLabel:    'Salwar Suit',
    deliveryDate: DateTime(2026, 6, 17),
    isUrgent:     false,
    receiptNo:    'EMP-003',
  ),
];

// ═════════════════════════════════════════════════════════════════════════════
//  SCREEN
// ═════════════════════════════════════════════════════════════════════════════

class EmployeeNoticeScreen extends StatefulWidget {
  const EmployeeNoticeScreen({super.key});
  @override
  State<EmployeeNoticeScreen> createState() => _EmployeeNoticeScreenState();
}

class _EmployeeNoticeScreenState extends State<EmployeeNoticeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  final _dateFmt = DateFormat('dd MMM yyyy');

  // Track which notices have been expanded (read)
  final Set<int> _readIds = {};

  int get _unreadCount =>
      _kNotices.where((n) => !_readIds.contains(n.id)).length;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this)
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final overdueCount  = _kSunitaDues.where((d) => d.isOverdue).length;
    final dueTodayCount = _kSunitaDues.where((d) => d.isDueToday).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(overdueCount),
      body: TabBarView(
        controller: _tab,
        children: [
          _buildNoticesTab(),
          _buildDuesTab(overdueCount, dueTodayCount),
        ],
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(int overdueCount) {
    return AppBar(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      automaticallyImplyLeading: false,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [AppColors.topbarStart, AppColors.topbarEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
      ),
      title: const Text('Notices',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white)),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(46),
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TabBar(
            controller: _tab,
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.white70,
            labelStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12.5,
                fontWeight: FontWeight.w700),
            unselectedLabelStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12.5,
                fontWeight: FontWeight.w500),
            padding: const EdgeInsets.all(3),
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.campaign_rounded, size: 15),
                    const SizedBox(width: 5),
                    const Text('Notices'),
                    if (_unreadCount > 0) ...[
                      const SizedBox(width: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('$_unreadCount',
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Colors.white)),
                      ),
                    ],
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.warning_amber_rounded, size: 15),
                    const SizedBox(width: 5),
                    const Text('Delivery Dues'),
                    if (overdueCount > 0) ...[
                      const SizedBox(width: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('$overdueCount',
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Colors.white)),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  Notices Tab
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildNoticesTab() {
    return Column(
      children: [
        // Read-only banner
        Container(
          margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.40),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.25)),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  size: 16, color: AppColors.primary),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Notices are posted by the Manager. Tap a notice to read.',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11.5,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),

        // Notice list
        Expanded(
          child: _kNotices.isEmpty
              ? const _EmptyState(
                  icon: Icons.campaign_outlined,
                  message: 'No notices from manager yet.')
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                  itemCount: _kNotices.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final notice = _kNotices[i];
                    final isRead = _readIds.contains(notice.id);
                    return GestureDetector(
                      onTap: () {
                        if (!isRead) setState(() => _readIds.add(notice.id));
                        _showNoticeSheet(notice);
                      },
                      child: _EmployeeNoticeCard(
                        notice:  notice,
                        dateFmt: _dateFmt,
                        isRead:  isRead,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  Delivery Dues Tab
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildDuesTab(int overdueCount, int dueTodayCount) {
    // Sort: overdue first, then due today, then upcoming
    final sorted = [..._kSunitaDues]..sort((a, b) {
        if (a.isOverdue && !b.isOverdue) return -1;
        if (!a.isOverdue && b.isOverdue) return 1;
        if (a.isDueToday && !b.isDueToday) return -1;
        if (!a.isDueToday && b.isDueToday) return 1;
        return a.deliveryDate.compareTo(b.deliveryDate);
      });

    return Column(
      children: [
        if (_kSunitaDues.isNotEmpty)
          _DuesSummaryBanner(
              overdueCount: overdueCount, dueTodayCount: dueTodayCount),

        Expanded(
          child: _kSunitaDues.isEmpty
              ? const _EmptyState(
                  icon: Icons.check_circle_outline_rounded,
                  message: 'All your deliveries are on time! 🎉',
                  color: AppColors.success)
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                  itemCount: sorted.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) =>
                      _DueItemCard(item: sorted[i], dateFmt: _dateFmt),
                ),
        ),
      ],
    );
  }

  // ── Notice bottom sheet ──────────────────────────────────────────────────────
  void _showNoticeSheet(_Notice notice) {
    Color stripeColor;
    String priorityLabel;
    switch (notice.priority) {
      case _NoticePriority.urgent:
        stripeColor   = AppColors.error;
        priorityLabel = 'Urgent';
        break;
      case _NoticePriority.important:
        stripeColor   = AppColors.urgent;
        priorityLabel = 'Important';
        break;
      case _NoticePriority.normal:
        stripeColor   = AppColors.primary;
        priorityLabel = 'General';
        break;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.35,
        maxChildSize: 0.90,
        expand: false,
        builder: (_, scrollCtrl) => Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 4),
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Priority stripe accent line
              Container(
                height: 3,
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: stripeColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollCtrl,
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Priority chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: stripeColor.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: stripeColor.withValues(alpha: 0.35)),
                        ),
                        child: Text(priorityLabel,
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: stripeColor)),
                      ),
                      const SizedBox(height: 10),
                      // Title
                      Text(
                        notice.title,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Date + Posted by
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded,
                              size: 12, color: AppColors.textHint),
                          const SizedBox(width: 4),
                          Text(DateFormat('dd MMM yyyy').format(notice.date),
                              style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11.5,
                                  color: AppColors.textHint)),
                          const SizedBox(width: 14),
                          const Icon(Icons.person_rounded,
                              size: 12, color: AppColors.textHint),
                          const SizedBox(width: 4),
                          Text('Posted by ${notice.postedBy}',
                              style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11.5,
                                  color: AppColors.textHint)),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Divider(color: AppColors.border, height: 1),
                      const SizedBox(height: 14),
                      // Full message body
                      Text(
                        notice.message,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13.5,
                          color: AppColors.textPrimary,
                          height: 1.65,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              // Close button
              Padding(
                padding: EdgeInsets.fromLTRB(
                    20, 8, 20, 12 + MediaQuery.of(context).padding.bottom),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Close',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Notice Card (read/unread aware, tap-to-sheet)
// ─────────────────────────────────────────────────────────────────────────────

class _EmployeeNoticeCard extends StatelessWidget {
  const _EmployeeNoticeCard({
    required this.notice,
    required this.dateFmt,
    required this.isRead,
  });
  final _Notice    notice;
  final DateFormat dateFmt;
  final bool       isRead;

  Color get _stripeColor => switch (notice.priority) {
        _NoticePriority.urgent    => AppColors.error,
        _NoticePriority.important => AppColors.urgent,
        _NoticePriority.normal    => AppColors.primary,
      };

  String get _priorityLabel => switch (notice.priority) {
        _NoticePriority.urgent    => 'Urgent',
        _NoticePriority.important => 'Important',
        _NoticePriority.normal    => 'General',
      };

  IconData get _priorityIcon => switch (notice.priority) {
        _NoticePriority.urgent    => Icons.priority_high_rounded,
        _NoticePriority.important => Icons.info_rounded,
        _NoticePriority.normal    => Icons.campaign_rounded,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isRead ? AppColors.surface : AppColors.surface2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: isRead ? AppColors.border : _stripeColor.withValues(alpha: 0.35),
            width: isRead ? 1.0 : 1.5),
        boxShadow: [
          BoxShadow(
            color: _stripeColor.withValues(alpha: isRead ? 0.04 : 0.10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left colour stripe
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: _stripeColor,
                borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(14)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title row + badges
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(notice.title,
                              style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary)),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Priority badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: _stripeColor.withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(_priorityIcon,
                                      size: 10, color: _stripeColor),
                                  const SizedBox(width: 3),
                                  Text(_priorityLabel,
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: _stripeColor)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Unread dot
                            if (!isRead)
                              Container(
                                width: 8, height: 8,
                                decoration: BoxDecoration(
                                  color: _stripeColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Message preview — always 2 lines, full content in sheet
                    Text(
                      notice.message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12.5,
                          color: AppColors.textSecondary,
                          height: 1.5),
                    ),
                    const SizedBox(height: 8),
                    // Footer
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded,
                            size: 11, color: AppColors.textHint),
                        const SizedBox(width: 4),
                        Text(dateFmt.format(notice.date),
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 11,
                                color: AppColors.textHint)),
                        const SizedBox(width: 12),
                        const Icon(Icons.person_rounded,
                            size: 11, color: AppColors.textHint),
                        const SizedBox(width: 4),
                        Text(notice.postedBy,
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 11,
                                color: AppColors.textHint)),
                        const Spacer(),
                        Text(
                          'Tap to read',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _stripeColor),
                        ),
                        const SizedBox(width: 2),
                        Icon(Icons.open_in_new_rounded,
                            size: 12, color: _stripeColor),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Dues Summary Banner
// ─────────────────────────────────────────────────────────────────────────────

class _DuesSummaryBanner extends StatelessWidget {
  const _DuesSummaryBanner(
      {required this.overdueCount, required this.dueTodayCount});
  final int overdueCount, dueTodayCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.30)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: AppColors.error, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: AppColors.textPrimary),
                children: [
                  if (overdueCount > 0)
                    TextSpan(
                      text: '$overdueCount overdue',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.error),
                    ),
                  if (overdueCount > 0 && dueTodayCount > 0)
                    const TextSpan(text: '  ·  '),
                  if (dueTodayCount > 0)
                    TextSpan(
                      text: '$dueTodayCount due today',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.urgent),
                    ),
                  const TextSpan(text: ' — complete work promptly.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Due Item Card
// ─────────────────────────────────────────────────────────────────────────────

class _DueItemCard extends StatelessWidget {
  const _DueItemCard({required this.item, required this.dateFmt});
  final _DueItem   item;
  final DateFormat dateFmt;

  Color get _accentColor {
    if (item.daysOverdue >= 3) return AppColors.error;
    if (item.isOverdue)        return AppColors.urgent;
    if (item.isDueToday)       return AppColors.urgent;
    return AppColors.primary;
  }

  String get _dueLabel {
    if (item.isOverdue)  return '${item.daysOverdue} day${item.daysOverdue > 1 ? "s" : ""} overdue!';
    if (item.isDueToday) return 'Due today';
    final days = -item.daysOverdue;
    return 'Due in $days day${days > 1 ? "s" : ""}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: _accentColor.withValues(alpha: 0.40),
            width: item.isOverdue || item.isDueToday ? 1.5 : 1.0),
        boxShadow: [
          BoxShadow(
            color: _accentColor.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top accent strip
          Container(
            height: 3,
            decoration: BoxDecoration(
              color: _accentColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(14)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Item type icon
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: _accentColor.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                          item.itemLabel.toLowerCase().contains('dress') ||
                                  item.itemLabel.toLowerCase().contains('suit') ||
                                  item.itemLabel.toLowerCase().contains('anarkali')
                              ? Icons.dry_cleaning_rounded
                              : Icons.checkroom_rounded,
                          color: _accentColor, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.customer,
                              style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary)),
                          Text(item.itemLabel,
                              style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12.5,
                                  color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    // Urgent badge
                    if (item.isUrgent)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.urgent,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text('🔥 URGENT',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(
                    color: AppColors.border, height: 1, thickness: 1),
                const SizedBox(height: 10),
                Row(
                  children: [
                    // Delivery date
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_rounded,
                              size: 13, color: _accentColor),
                          const SizedBox(width: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Delivery',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 9.5,
                                      color: AppColors.textHint)),
                              Text(dateFmt.format(item.deliveryDate),
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: _accentColor)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Receipt no
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.receipt_long_rounded,
                              size: 13, color: AppColors.textHint),
                          const SizedBox(width: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Receipt',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 9.5,
                                      color: AppColors.textHint)),
                              Text(item.receiptNo,
                                  style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Due label pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _accentColor.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                            color: _accentColor.withValues(alpha: 0.35)),
                      ),
                      child: Text(_dueLabel,
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: _accentColor)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Empty State
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState(
      {required this.icon, required this.message, this.color = AppColors.textHint});
  final IconData icon;
  final String   message;
  final Color    color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: color.withValues(alpha: 0.50)),
          const SizedBox(height: 12),
          Text(message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
