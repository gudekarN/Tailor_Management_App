// ════════════════════════════════════════════════════════════════════════════
//  notice_screen.dart
//  Pranav Ladies Tailors — Notices & Delivery Dues (Manager)
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:pranav_tailors/core/theme/app_theme.dart';
import 'package:pranav_tailors/features/manager/screens/receipt_view_screen.dart';

// ════════════════════════════════════════════════════════════════════════════
//  Data models
// ════════════════════════════════════════════════════════════════════════════

enum _NoticePriority { normal, important, urgent }

class _Notice {
  _Notice({
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
  _NoticePriority priority;
}

class _DueOrder {
  const _DueOrder({
    required this.id,
    required this.customerName,
    required this.phone,
    required this.receiptNo,
    required this.items,
    required this.deliveryDate,
    this.isUrgent = false,
  });
  final int          id;
  final String       customerName;
  final String       phone;
  final String       receiptNo;
  final List<String> items;
  final DateTime     deliveryDate;
  final bool         isUrgent;

  int get daysOverdue {
    final today = DateTime.now();
    final t = DateTime(today.year, today.month, today.day);
    final d = DateTime(deliveryDate.year, deliveryDate.month, deliveryDate.day);
    return t.difference(d).inDays;
  }

  bool get isDueToday => daysOverdue == 0;
  bool get isOverdue  => daysOverdue > 0;
}

// ════════════════════════════════════════════════════════════════════════════
//  Dummy data
// ════════════════════════════════════════════════════════════════════════════

List<_Notice> _buildNotices() => [
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

List<_DueOrder> _buildDueOrders() => [
      _DueOrder(
        id: 1,
        customerName: 'Priya Sharma',
        phone: '9823456789',
        receiptNo: 'PLT-2026-001',
        items: ['Silk Blouse', 'Silk Blouse (Matching)'],
        deliveryDate: DateTime(2026, 6, 4),
        isUrgent: true,
      ),
      _DueOrder(
        id: 2,
        customerName: 'Meena Patil',
        phone: '9765432100',
        receiptNo: 'PLT-2026-002',
        items: ['Salwar Suit'],
        deliveryDate: DateTime(2026, 6, 6),
      ),
      _DueOrder(
        id: 3,
        customerName: 'Anita Kulkarni',
        phone: '9898001122',
        receiptNo: 'PLT-2026-004',
        items: ['Lehenga Blouse'],
        deliveryDate: DateTime(2026, 6, 8),
        isUrgent: true,
      ),
      _DueOrder(
        id: 4,
        customerName: 'Rekha Joshi',
        phone: '9654321098',
        receiptNo: 'PLT-2026-003',
        items: ['Salwar Kameez'],
        deliveryDate: DateTime(2026, 6, 10),
      ),
      _DueOrder(
        id: 5,
        customerName: 'Kavita Rane',
        phone: '9823001122',
        receiptNo: 'PLT-2026-005',
        items: ['Kurti', 'Kurti', 'Kurti'],
        deliveryDate: DateTime(2026, 6, 11),
        isUrgent: true,
      ),
      _DueOrder(
        id: 6,
        customerName: 'Sunita Desai',
        phone: '9765443322',
        receiptNo: 'PLT-2026-006',
        items: ['Salwar Kameez'],
        deliveryDate: DateTime(2026, 6, 11),
      ),
    ];

// ════════════════════════════════════════════════════════════════════════════
//  Screen
// ════════════════════════════════════════════════════════════════════════════

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({super.key});
  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  late final List<_Notice>   _notices;
  late final List<_DueOrder> _dueOrders;

  final _dateFmt = DateFormat('dd MMM yyyy');

  @override
  void initState() {
    super.initState();
    _tab       = TabController(length: 2, vsync: this)
      ..addListener(() => setState(() {}));
    _notices   = _buildNotices();
    _dueOrders = _buildDueOrders();
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final overdueCount  = _dueOrders.where((o) => o.isOverdue).length;
    final dueTodayCount = _dueOrders.where((o) => o.isDueToday).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(overdueCount, dueTodayCount),
      body: TabBarView(
        controller: _tab,
        children: [
          _buildNoticesTab(),
          _buildDuesTab(overdueCount, dueTodayCount),
        ],
      ),
      floatingActionButton: _tab.index == 0
          ? FloatingActionButton.extended(
              onPressed: _showComposeDialog,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.edit_rounded),
              label: Text('New Notice',
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
            )
          : null,
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(int overdueCount, int dueTodayCount) {
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
      title: Text('Notices',
          style: TextStyle(fontFamily: 'Poppins', 
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
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
            labelStyle: TextStyle(fontFamily: 'Poppins', 
                fontSize: 12.5, fontWeight: FontWeight.w700),
            unselectedLabelStyle: TextStyle(fontFamily: 'Poppins', 
                fontSize: 12.5, fontWeight: FontWeight.w500),
            padding: const EdgeInsets.all(3),
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.campaign_rounded, size: 15),
                    const SizedBox(width: 6),
                    Text('Notices (${_notices.length})'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.warning_amber_rounded, size: 15),
                    const SizedBox(width: 6),
                    Row(
                      children: [
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
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white)),
                          ),
                        ],
                      ],
                    ),
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
    if (_notices.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.campaign_outlined,
                size: 56,
                color: AppColors.textHint.withValues(alpha: 0.50)),
            const SizedBox(height: 12),
            Text('No notices posted yet.',
                style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 14, color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            Text('Tap "New Notice" to post one.',
                style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 12.5, color: AppColors.textHint)),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
      itemCount: _notices.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => GestureDetector(
        onTap: () => _showNoticeSheet(_notices[i]),
        child: _NoticeCard(
          notice: _notices[i],
          dateFmt: _dateFmt,
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  Delivery Dues Tab
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildDuesTab(int overdueCount, int dueTodayCount) {
    return Column(
      children: [
        // Summary banner
        if (_dueOrders.isNotEmpty)
          _buildDuesSummary(overdueCount, dueTodayCount),
        // List
        Expanded(
          child: _dueOrders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_outline_rounded,
                          size: 56,
                          color: AppColors.success
                              .withValues(alpha: 0.50)),
                      const SizedBox(height: 12),
                      Text('All deliveries are on time! 🎉',
                          style: TextStyle(fontFamily: 'Poppins', 
                              fontSize: 14,
                              color: AppColors.textSecondary)),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: _dueOrders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _DueOrderCard(
                    order: _dueOrders[i],
                    dateFmt: _dateFmt,
                    onTap: () => _showOrderDetail(_dueOrders[i]),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildDuesSummary(int overdueCount, int dueTodayCount) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 13, color: AppColors.textPrimary),
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
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.urgent),
                    ),
                  const TextSpan(
                      text: ' — contact customers promptly.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Compose notice dialog ─────────────────────────────────────────────────
  void _showComposeDialog() {
    final titleCtrl = TextEditingController();
    final msgCtrl   = TextEditingController();
    var priority    = _NoticePriority.normal;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              AppColors.primaryLight.withValues(alpha: 0.60),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.edit_rounded,
                            color: AppColors.primary, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Text('New Notice',
                          style: TextStyle(fontFamily: 'Poppins', 
                              fontSize: 16, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Priority chips
                  Text('Priority',
                      style: TextStyle(fontFamily: 'Poppins', 
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _PriorityChip(
                        label: 'Normal',
                        color: AppColors.primary,
                        selected: priority == _NoticePriority.normal,
                        onTap: () => setStateDialog(
                            () => priority = _NoticePriority.normal),
                      ),
                      const SizedBox(width: 8),
                      _PriorityChip(
                        label: 'Important',
                        color: AppColors.urgent,
                        selected: priority == _NoticePriority.important,
                        onTap: () => setStateDialog(
                            () => priority = _NoticePriority.important),
                      ),
                      const SizedBox(width: 8),
                      _PriorityChip(
                        label: 'Urgent',
                        color: AppColors.error,
                        selected: priority == _NoticePriority.urgent,
                        onTap: () => setStateDialog(
                            () => priority = _NoticePriority.urgent),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Title
                  _DialogField(
                      ctrl: titleCtrl, label: 'Title', hint: 'Notice title…'),
                  const SizedBox(height: 12),

                  // Message
                  _DialogField(
                    ctrl: msgCtrl,
                    label: 'Message',
                    hint: 'Type notice details…',
                    maxLines: 4,
                  ),
                  const SizedBox(height: 18),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: Text('Cancel',
                              style: TextStyle(fontFamily: 'Poppins', 
                                  color: AppColors.textSecondary)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [
                                  AppColors.topbarStart,
                                  AppColors.topbarEnd
                                ]),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final t = titleCtrl.text.trim();
                            final m = msgCtrl.text.trim();
                            if (t.isEmpty || m.isEmpty) return;
                            setState(() {
                              _notices.insert(
                                0,
                                _Notice(
                                  id: DateTime.now().millisecondsSinceEpoch,
                                  title: t,
                                  message: m,
                                  date: DateTime.now(),
                                  postedBy: 'Manager',
                                  priority: priority,
                                ),
                              );
                            });
                            Navigator.pop(ctx);
                          },
                          icon: const Icon(Icons.send_rounded,
                              size: 16, color: Colors.white),
                          label: Text('Post Notice',
                              style: TextStyle(fontFamily: 'Poppins', 
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ),
        ),
      ),
    );
  }

  // ── Notice full-view bottom sheet ─────────────────────────────────────────
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
                          Text(_dateFmt.format(notice.date),
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
                      // Full message
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

  // ── Due order detail — open receipt view ──────────────────────────────────
  void _showOrderDetail(_DueOrder order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReceiptViewScreen(
          generatedBy: 'Manager',
          showActions: true,
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  Notice card
// ════════════════════════════════════════════════════════════════════════════

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({required this.notice, required this.dateFmt});
  final _Notice    notice;
  final DateFormat dateFmt;

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
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: _stripeColor.withValues(alpha: 0.07),
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
                    // Title row + priority badge
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(notice.title,
                              style: TextStyle(fontFamily: 'Poppins', 
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary)),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color:
                                _stripeColor.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_priorityIcon,
                                  size: 10, color: _stripeColor),
                              const SizedBox(width: 3),
                              Text(_priorityLabel,
                                  style: TextStyle(fontFamily: 'Poppins', 
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: _stripeColor)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Message preview
                    Text(notice.message,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontFamily: 'Poppins', 
                            fontSize: 12.5,
                            color: AppColors.textSecondary,
                            height: 1.5)),
                    const SizedBox(height: 8),
                    // Footer
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded,
                            size: 11, color: AppColors.textHint),
                        const SizedBox(width: 4),
                        Text(dateFmt.format(notice.date),
                            style: TextStyle(fontFamily: 'Poppins', 
                                fontSize: 11, color: AppColors.textHint)),
                        const SizedBox(width: 12),
                        const Icon(Icons.person_rounded,
                            size: 11, color: AppColors.textHint),
                        const SizedBox(width: 4),
                        Text(notice.postedBy,
                            style: TextStyle(fontFamily: 'Poppins', 
                                fontSize: 11, color: AppColors.textHint)),
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

// ════════════════════════════════════════════════════════════════════════════
//  Due Order card
// ════════════════════════════════════════════════════════════════════════════

class _DueOrderCard extends StatelessWidget {
  const _DueOrderCard({
    required this.order,
    required this.dateFmt,
    required this.onTap,
  });
  final _DueOrder  order;
  final DateFormat dateFmt;
  final VoidCallback onTap;

  Color get _borderColor {
    if (order.daysOverdue >= 3) return AppColors.error;
    if (order.isOverdue) return AppColors.urgent;
    return const Color(0xFFE65100); // due today
  }

  @override
  Widget build(BuildContext context) {
    final overdue = order.daysOverdue;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _borderColor.withValues(alpha: 0.50)),
          boxShadow: [
            BoxShadow(
              color: _borderColor.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top stripe
            Container(
              height: 3,
              decoration: BoxDecoration(
                color: _borderColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(14)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 18,
                        backgroundColor:
                            _borderColor.withValues(alpha: 0.12),
                        child: Text(
                          order.customerName.substring(0, 1),
                          style: TextStyle(fontFamily: 'Poppins', 
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: _borderColor),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(order.customerName,
                                style: TextStyle(fontFamily: 'Poppins', 
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700)),
                            Text(order.receiptNo,
                                style: TextStyle(fontFamily: 'Poppins', 
                                    fontSize: 11.5,
                                    color: AppColors.textHint)),
                          ],
                        ),
                      ),
                      // Overdue badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: _borderColor.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color:
                                  _borderColor.withValues(alpha: 0.40)),
                        ),
                        child: Text(
                          order.isDueToday
                              ? '⚡ Due Today'
                              : '$overdue day${overdue == 1 ? '' : 's'} overdue',
                          style: TextStyle(fontFamily: 'Poppins', 
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: _borderColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: AppColors.border, height: 1),
                  const SizedBox(height: 8),
                  // Items
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: order.items
                        .map((item) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.surface2,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: AppColors.border),
                              ),
                              child: Text(item,
                                  style: TextStyle(fontFamily: 'Poppins', 
                                      fontSize: 11.5,
                                      color: AppColors.textSecondary)),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  // Footer
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded,
                          size: 12, color: AppColors.textHint),
                      const SizedBox(width: 4),
                      Text('Due: ${dateFmt.format(order.deliveryDate)}',
                          style: TextStyle(fontFamily: 'Poppins', 
                              fontSize: 12, color: AppColors.textSecondary)),
                      const Spacer(),
                      if (order.isUrgent)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.urgentLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.bolt_rounded,
                                  size: 11, color: AppColors.urgent),
                              const SizedBox(width: 3),
                              Text('Urgent',
                                  style: TextStyle(fontFamily: 'Poppins', 
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.urgent)),
                            ],
                          ),
                        ),
                      const SizedBox(width: 6),
                      Text('Tap for details →',
                          style: TextStyle(fontFamily: 'Poppins', 
                              fontSize: 11, color: AppColors.textHint)),
                    ],
                  ),
                ],
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

class _PriorityChip extends StatelessWidget {
  const _PriorityChip({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });
  final String       label;
  final Color        color;
  final bool         selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color : color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? color : color.withValues(alpha: 0.30)),
        ),
        child: Text(label,
            style: TextStyle(fontFamily: 'Poppins', 
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : color)),
      ),
    );
  }
}

class _DialogField extends StatelessWidget {
  const _DialogField({
    required this.ctrl,
    required this.label,
    required this.hint,
    this.maxLines = 1,
  });
  final TextEditingController ctrl;
  final String label;
  final String hint;
  final int    maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontFamily: 'Poppins', 
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary)),
        const SizedBox(height: 5),
        TextField(
          controller: ctrl,
          maxLines: maxLines,
          style: TextStyle(fontFamily: 'Poppins', fontSize: 13.5),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontFamily: 'Poppins', 
                fontSize: 13, color: AppColors.textHint),
            filled: true,
            fillColor: AppColors.background,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: AppColors.primary, width: 1.5)),
          ),
        ),
      ],
    );
  }
}


