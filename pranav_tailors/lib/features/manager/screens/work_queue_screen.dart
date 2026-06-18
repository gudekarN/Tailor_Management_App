// ════════════════════════════════════════════════════════════════════════════
//  work_queue_screen.dart
//  Pranav Ladies Tailors — Work Queue (Manager)
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pranav_tailors/core/theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════════════════
//  Enums & Models
// ════════════════════════════════════════════════════════════════════════════

enum _WorkStatus { unassigned, inProgress, completed }
enum _MsgType    { partial, complete, apology }

class _Employee {
  const _Employee(this.name, this.role, this.initials, this.color);
  final String name;
  final String role;
  final String initials;
  final Color  color;
}

class _WorkItem {
  _WorkItem({
    required this.id,
    required this.customer,
    required this.phone,
    required this.itemType,
    required this.isUrgent,
    required this.deliveryDate,
    required this.status,
    this.assignee,
    this.completedDate,
    this.hasMorePending = false,
  });
  final int    id;
  final String customer;
  final String phone;
  final String itemType;
  final bool   isUrgent;
  DateTime     deliveryDate;
  _WorkStatus  status;
  _Employee?   assignee;
  DateTime?    completedDate;
  bool         hasMorePending;
}

// ════════════════════════════════════════════════════════════════════════════
//  Static data
// ════════════════════════════════════════════════════════════════════════════

const _kEmployees = [
  _Employee('Manager (Self)',  'Manager', 'MG', Color(0xFFC2185B)),
  _Employee('Kaveri Shinde',  'Tailor',  'KS', Color(0xFF26A69A)),
  _Employee('Sunanda More',   'Tailor',  'SM', Color(0xFF5E35B1)),
  _Employee('Rekha Jadhav',   'Helper',  'RJ', Color(0xFFE65100)),
  _Employee('Priya Kulkarni', 'Tailor',  'PK', Color(0xFF1565C0)),
];

List<_WorkItem> _buildDummies() {
  final now = DateTime.now();
  return [
    // ── Unassigned ───────────────────────────────────────────────────────────
    _WorkItem(id: 1, customer: 'Meena Patil',     phone: '9823456701',
        itemType: 'Silk Blouse',        isUrgent: true,
        deliveryDate: now.add(const Duration(days: 4)),
        status: _WorkStatus.unassigned),
    _WorkItem(id: 2, customer: 'Rekha Joshi',     phone: '9765432109',
        itemType: 'Salwar Suit',        isUrgent: false,
        deliveryDate: now.add(const Duration(days: 7)),
        status: _WorkStatus.unassigned),
    _WorkItem(id: 3, customer: 'Anita Kulkarni',  phone: '9871234560',
        itemType: 'Lehenga Blouse',     isUrgent: true,
        deliveryDate: now.subtract(const Duration(days: 1)),  // overdue
        status: _WorkStatus.unassigned),
    // ── In Progress ──────────────────────────────────────────────────────────
    _WorkItem(id: 4, customer: 'Priya Sharma',    phone: '9876543210',
        itemType: 'Silk Blouse × 2',   isUrgent: false,
        deliveryDate: now.add(const Duration(days: 3)),
        status: _WorkStatus.inProgress, assignee: _kEmployees[1]),
    _WorkItem(id: 5, customer: 'Sunita Desai',    phone: '9812345670',
        itemType: 'Salwar Kameez',     isUrgent: false,
        deliveryDate: now.add(const Duration(days: 5)),
        status: _WorkStatus.inProgress, assignee: _kEmployees[2]),
    _WorkItem(id: 6, customer: 'Kavita Rane',     phone: '9900112233',
        itemType: 'Kurti × 3',         isUrgent: true,
        deliveryDate: now.subtract(const Duration(days: 2)),  // overdue
        status: _WorkStatus.inProgress, assignee: _kEmployees[0]),
    _WorkItem(id: 7, customer: 'Pooja Nair',      phone: '9654321098',
        itemType: 'Blouse + Fall & Pico', isUrgent: false,
        deliveryDate: now.add(const Duration(days: 9)),
        status: _WorkStatus.inProgress, assignee: _kEmployees[3]),
    // ── Completed ────────────────────────────────────────────────────────────
    _WorkItem(id: 8, customer: 'Lata Sawant',     phone: '9789012345',
        itemType: 'Cotton Kurti',      isUrgent: false,
        deliveryDate: now.subtract(const Duration(days: 3)),
        status: _WorkStatus.completed,  assignee: _kEmployees[1],
        completedDate: now.subtract(const Duration(days: 1)),
        hasMorePending: true),
    _WorkItem(id: 9, customer: 'Deepa Chavan',    phone: '9512345678',
        itemType: 'Silk Blouse',       isUrgent: false,
        deliveryDate: now.add(const Duration(days: 1)),
        status: _WorkStatus.completed,  assignee: _kEmployees[2],
        completedDate: now),
    _WorkItem(id: 10, customer: 'Usha Deshpande', phone: '9933445566',
        itemType: 'Salwar Suit',       isUrgent: false,
        deliveryDate: now.subtract(const Duration(days: 5)),
        status: _WorkStatus.completed,  assignee: _kEmployees[0],
        completedDate: now.subtract(const Duration(days: 1)),
        hasMorePending: false),
  ];
}

// ════════════════════════════════════════════════════════════════════════════
//  Bilingual message builders
// ════════════════════════════════════════════════════════════════════════════

String _partialMsg(String cust, String item, bool mr) => mr
    ? 'प्रिय $cust,\n\nतुमची $item प्रणव लेडीज टेलर्स, शिवाजी नगर, पुणे येथे तयार आहे. 🎉\n\nतुमच्या उर्वरित ऑर्डर वस्तू अजूनही तयार होत आहेत. कृपया वेळ मिळाल्यावर भेट द्या.\n\nधन्यवाद! 🙏\n— प्रणव लेडीज टेलर्स'
    : 'Dear $cust,\n\nYour $item is ready for pickup at Pranav Ladies Tailors, Shivaji Nagar, Pune. 🎉\n\nYour remaining order items are still in progress. Please visit at your convenience.\n\nThank you! 🙏\n— Pranav Ladies Tailors';

String _completeMsg(String cust, bool mr) => mr
    ? 'प्रिय $cust,\n\nआनंदाची बातमी! तुमची संपूर्ण ऑर्डर प्रणव लेडीज टेलर्स, शिवाजी नगर, पुणे येथे तयार आहे. 🌸\n\nआम्ही तुमची वाट पाहत आहोत!\n\nआम्हाला निवडल्याबद्दल खूप खूप धन्यवाद. 💕\n— प्रणव लेडीज टेलर्स'
    : 'Dear $cust,\n\nGreat news! Your complete order is ready for pickup at Pranav Ladies Tailors, Shivaji Nagar, Pune. 🌸\n\nWe look forward to seeing you!\n\nThank you so much for choosing us. 💕\n— Pranav Ladies Tailors';

String _apologyMsg(String cust, String item, String newDate, bool mr) => mr
    ? 'प्रिय $cust,\n\nतुमच्या $item ऑर्डरमध्ये झालेल्या उशिरासाठी आम्ही मनापासून क्षमा मागतो. 🙏\n\nतुमची नवीन अपेक्षित वितरण तारीख: $newDate\n\nआम्ही उत्तम गुणवत्तेसाठी प्रयत्नशील आहोत आणि तुमच्या संयमाची खूप कदर करतो.\n\nधन्यवाद!\n— प्रणव लेडीज टेलर्स'
    : 'Dear $cust,\n\nWe sincerely apologize for the delay in your $item order. 🙏\n\nYour new expected delivery date is: $newDate\n\nWe are committed to quality and truly appreciate your patience.\n\nThank you!\n— Pranav Ladies Tailors';

// ════════════════════════════════════════════════════════════════════════════
//  Main Screen
// ════════════════════════════════════════════════════════════════════════════

class WorkQueueScreen extends StatefulWidget {
  const WorkQueueScreen({super.key});
  @override
  State<WorkQueueScreen> createState() => _WorkQueueScreenState();
}

class _WorkQueueScreenState extends State<WorkQueueScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  late final List<_WorkItem> _items;
  final _dateFmt = DateFormat('dd MMM yyyy');

  @override
  void initState() {
    super.initState();
    _tab   = TabController(length: 3, vsync: this);
    _items = _buildDummies();
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  // ── Computed lists ────────────────────────────────────────────────────────
  List<_WorkItem> get _unassigned =>
      _items.where((i) => i.status == _WorkStatus.unassigned).toList();
  List<_WorkItem> get _inProgress =>
      _items.where((i) => i.status == _WorkStatus.inProgress).toList();
  List<_WorkItem> get _completed =>
      _items.where((i) => i.status == _WorkStatus.completed).toList();

  bool _isOverdue(_WorkItem item) =>
      item.deliveryDate.isBefore(DateTime.now()) &&
      item.status != _WorkStatus.completed;

  // ── Assign / Reassign ─────────────────────────────────────────────────────
  void _showAssignSheet(_WorkItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EmployeeSelectorSheet(
        title: item.assignee == null ? 'Assign Work' : 'Reassign Work',
        subtitle: '${item.customer} — ${item.itemType}',
        currentAssignee: item.assignee,
        onAssign: (emp) => setState(() {
          item.assignee = emp;
          item.status   = _WorkStatus.inProgress;
        }),
      ),
    );
  }

  // ── Set new date → apology message ───────────────────────────────────────
  Future<void> _showNewDatePicker(_WorkItem item) async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 3)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
              primary: AppColors.primary, onPrimary: Colors.white),
        ),
        child: child!,
      ),
    );
    if (d != null && mounted) {
      setState(() => item.deliveryDate = d);
      _showMessageSheet(_MsgType.apology, item, newDate: _dateFmt.format(d));
    }
  }

  // ── Notification message sheet ────────────────────────────────────────────
  void _showMessageSheet(_MsgType type, _WorkItem item,
      {String newDate = ''}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _MessageSheet(
        type: type,
        customer: item.customer,
        phone: item.phone,
        itemType: item.itemType,
        newDate: newDate,
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    // Snapshot filtered lists once per build so tab labels and content are
    // always in sync.
    final unassigned = _unassigned;
    final inProgress = _inProgress;
    final completed  = _completed;

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
        title: Text('Work Queue',
            style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
      ),
      // ── Body: Column → [TabBar, Expanded → TabBarView] ──────────────────
      body: Column(
        children: [
          // ── Tab strip ────────────────────────────────────────────────────
          ColoredBox(
            color: AppColors.primaryDark,
            child: TabBar(
              controller: _tab,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              dividerColor: Colors.transparent,
              labelStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600),
              unselectedLabelStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12.5,
                  fontWeight: FontWeight.w400),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              tabs: [
                Tab(text: 'Unassigned (${unassigned.length})'),
                Tab(text: 'In Progress (${inProgress.length})'),
                Tab(text: 'Completed (${completed.length})'),
              ],
            ),
          ),
          // ── Tab content – Expanded gives TabBarView a bounded height ─────
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                // ── Unassigned ───────────────────────────────────────────
                _buildList(
                  items: unassigned,
                  empty: 'No unassigned items',
                  emptyIcon: Icons.check_circle_outline_rounded,
                  builder: (item) => _UnassignedCard(
                    item: item,
                    overdue: _isOverdue(item),
                    onAssign: () => _showAssignSheet(item),
                  ),
                ),
                // ── In Progress ──────────────────────────────────────────
                _buildList(
                  items: inProgress,
                  empty: 'No items in progress',
                  emptyIcon: Icons.work_off_rounded,
                  builder: (item) => _InProgressCard(
                    item: item,
                    overdue: _isOverdue(item),
                    onReassign: () => _showAssignSheet(item),
                    onSetDate:  () => _showNewDatePicker(item),
                  ),
                ),
                // ── Completed ────────────────────────────────────────────
                _buildList(
                  items: completed,
                  empty: 'No completed items',
                  emptyIcon: Icons.pending_actions_rounded,
                  builder: (item) => _CompletedCard(
                    item: item,
                    onNotify: () => _showMessageSheet(
                        item.hasMorePending ? _MsgType.partial : _MsgType.complete,
                        item),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── List builder ──────────────────────────────────────────────────────────
  // Uses ListView.builder with explicit physics so it always renders its items
  // correctly inside the bounded-height Expanded > TabBarView slot.
  Widget _buildList({
    required List<_WorkItem> items,
    required String empty,
    required IconData emptyIcon,
    required Widget Function(_WorkItem) builder,
  }) {
    if (items.isEmpty) return _EmptyState(message: empty, icon: emptyIcon);

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      // AlwaysScrollableScrollPhysics ensures the list is always scrollable
      // inside TabBarView, preventing the blank-content rendering issue that
      // can occur with ListView.separated in some Flutter versions.
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, i) => Padding(
        padding: EdgeInsets.only(bottom: i < items.length - 1 ? 10 : 0),
        child: builder(items[i]),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  Cards
// ════════════════════════════════════════════════════════════════════════════

// ── Unassigned card ───────────────────────────────────────────────────────────
class _UnassignedCard extends StatelessWidget {
  const _UnassignedCard({
    required this.item,
    required this.overdue,
    required this.onAssign,
  });
  final _WorkItem item;
  final bool overdue;
  final VoidCallback onAssign;

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd MMM');
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppShadows.subtle,
        border: Border.all(
            color: overdue
                ? AppColors.error.withValues(alpha: 0.55)
                : AppColors.border,
            width: overdue ? 1.5 : 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Main content
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Design thumbnail
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Icon(Icons.style_rounded,
                      color: AppColors.primary, size: 26),
                ),
                const SizedBox(width: 12),
                // Info
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
                          if (item.isUrgent) const _UrgentBadge(),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(item.itemType,
                          style: TextStyle(fontFamily: 'Poppins', 
                              fontSize: 12.5, color: AppColors.textSecondary)),
                      const SizedBox(height: 5),
                      _DueDateChip(
                          date: item.deliveryDate,
                          overdue: overdue,
                          df: df),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Footer
          Container(
            decoration: const BoxDecoration(
                border: Border(
                    top: BorderSide(color: AppColors.border, width: 0.5))),
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
            child: Row(
              children: [
                const Icon(Icons.person_off_rounded,
                    size: 14, color: AppColors.textHint),
                const SizedBox(width: 6),
                Text('Not assigned yet',
                    style: TextStyle(fontFamily: 'Poppins', 
                        fontSize: 11.5, color: AppColors.textHint)),
                const Spacer(),
                _PrimaryButton(
                    label: 'Assign',
                    icon: Icons.assignment_ind_rounded,
                    onPressed: onAssign),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── In-progress card ──────────────────────────────────────────────────────────
class _InProgressCard extends StatelessWidget {
  const _InProgressCard({
    required this.item,
    required this.overdue,
    required this.onReassign,
    required this.onSetDate,
  });
  final _WorkItem item;
  final bool overdue;
  final VoidCallback onReassign;
  final VoidCallback onSetDate;

  @override
  Widget build(BuildContext context) {
    final df  = DateFormat('dd MMM');
    final emp = item.assignee!;
    return Container(
      decoration: BoxDecoration(
        color: overdue ? const Color(0xFFFFF5F5) : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppShadows.subtle,
        border: Border.all(
            color: overdue
                ? AppColors.error.withValues(alpha: 0.55)
                : AppColors.border,
            width: overdue ? 1.5 : 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress stripe at top
          Container(
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: overdue
                    ? [AppColors.error, AppColors.error.withValues(alpha: 0.50)]
                    : [AppColors.primary, AppColors.primaryLight],
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(14)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row 1: name + due
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(item.customer,
                                    style: TextStyle(fontFamily: 'Poppins', 
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700)),
                              ),
                              if (item.isUrgent) const _UrgentBadge(),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(item.itemType,
                              style: TextStyle(fontFamily: 'Poppins', 
                                  fontSize: 12.5,
                                  color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _DueDateChip(
                        date: item.deliveryDate, overdue: overdue, df: df),
                  ],
                ),
                const SizedBox(height: 10),
                // Row 2: assignee chip + "Set New Date" (always visible)
                Row(
                  children: [
                    _EmployeeChip(emp: emp),
                    const Spacer(),
                    // "Set New Date" is now shown for EVERY in-progress card.
                    // Overdue cards keep the red (error) colour; others use primary.
                    _OutlineButton(
                      label: 'Set New Date',
                      icon: Icons.edit_calendar_rounded,
                      color: overdue ? AppColors.error : AppColors.primary,
                      onPressed: onSetDate,
                    ),
                  ],
                ),
                // Reassign row — always shown below (full-width for easy tapping).
                // Label is "Reassign Employee" for overdue items (matches existing
                // overdue UX), plain "Reassign" for on-time items.
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: _OutlineButton(
                    label: overdue ? 'Reassign Employee' : 'Reassign',
                    icon: Icons.swap_horiz_rounded,
                    color: AppColors.primary,
                    onPressed: onReassign,
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

// ── Completed card ────────────────────────────────────────────────────────────
class _CompletedCard extends StatelessWidget {
  const _CompletedCard({required this.item, required this.onNotify});
  final _WorkItem item;
  final VoidCallback onNotify;

  @override
  Widget build(BuildContext context) {
    final df  = DateFormat('dd MMM yyyy');
    final emp = item.assignee;
    final isPartial  = item.hasMorePending;
    final btnColor   = isPartial ? const Color(0xFF5E35B1) : AppColors.success;
    final btnLabel   = isPartial ? 'Notify Partial' : 'Order Complete';
    final btnIcon    = isPartial ? Icons.hourglass_bottom_rounded : Icons.celebration_rounded;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppShadows.subtle,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Green stripe
          Container(
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.success, AppColors.success.withValues(alpha: 0.50)],
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(14)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                // Top row
                Row(
                  children: [
                    Container(
                      width: 36, height: 36,
                      decoration: const BoxDecoration(
                          color: AppColors.successLight, shape: BoxShape.circle),
                      child: const Icon(Icons.check_rounded,
                          color: AppColors.success, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.customer,
                              style: TextStyle(fontFamily: 'Poppins', 
                                  fontSize: 14, fontWeight: FontWeight.w700)),
                          Text(item.itemType,
                              style: TextStyle(fontFamily: 'Poppins', 
                                  fontSize: 12.5,
                                  color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    // Notify button — wrapped so it never requests infinite
                    // width from its Row parent.
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 160),
                      child: ElevatedButton.icon(
                        onPressed: onNotify,
                        icon: Icon(btnIcon, size: 14, color: Colors.white),
                        label: Text(btnLabel,
                            style: const TextStyle(fontFamily: 'Poppins',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: btnColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 7),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(color: AppColors.border, height: 1),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (emp != null) ...[
                      Icon(Icons.person_rounded, size: 13, color: emp.color),
                      const SizedBox(width: 4),
                      Text('By ${emp.name.split(' ').first}',
                          style: TextStyle(fontFamily: 'Poppins', 
                              fontSize: 11.5, color: AppColors.textSecondary)),
                      const SizedBox(width: 12),
                    ],
                    if (item.completedDate != null) ...[
                      const Icon(Icons.calendar_today_rounded,
                          size: 12, color: AppColors.textHint),
                      const SizedBox(width: 4),
                      Text(df.format(item.completedDate!),
                          style: TextStyle(fontFamily: 'Poppins', 
                              fontSize: 11.5, color: AppColors.textHint)),
                    ],
                    const Spacer(),
                    if (isPartial)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDE7F6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('More pending',
                            style: TextStyle(fontFamily: 'Poppins', 
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF5E35B1))),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.successLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('All done',
                            style: TextStyle(fontFamily: 'Poppins', 
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.success)),
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

// ════════════════════════════════════════════════════════════════════════════
//  Employee Selector Bottom Sheet
// ════════════════════════════════════════════════════════════════════════════

class _EmployeeSelectorSheet extends StatefulWidget {
  const _EmployeeSelectorSheet({
    required this.title,
    required this.subtitle,
    required this.onAssign,
    this.currentAssignee,
  });
  final String    title;
  final String    subtitle;
  final ValueChanged<_Employee> onAssign;
  final _Employee? currentAssignee;

  @override
  State<_EmployeeSelectorSheet> createState() =>
      _EmployeeSelectorSheetState();
}

class _EmployeeSelectorSheetState extends State<_EmployeeSelectorSheet> {
  _Employee? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.currentAssignee;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, 16 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(4)),
            ),
          ),
          Text(widget.title,
              style: TextStyle(fontFamily: 'Poppins', 
                  fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 3),
          Text(widget.subtitle,
              style: TextStyle(fontFamily: 'Poppins', 
                  fontSize: 12.5, color: AppColors.textSecondary)),
          const SizedBox(height: 14),
          // Employee tiles
          ...List.generate(_kEmployees.length, (i) {
            final emp        = _kEmployees[i];
            final isSelected = _selected?.name == emp.name;
            return GestureDetector(
              onTap: () => setState(() => _selected = emp),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                decoration: BoxDecoration(
                  color: isSelected
                      ? emp.color.withValues(alpha: 0.08)
                      : AppColors.surface2,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: isSelected ? emp.color : AppColors.border,
                      width: isSelected ? 1.5 : 1),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: emp.color.withValues(alpha: 0.14),
                      child: Text(emp.initials,
                          style: TextStyle(fontFamily: 'Poppins', 
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: emp.color)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(emp.name,
                              style: TextStyle(fontFamily: 'Poppins', 
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? emp.color
                                      : AppColors.textPrimary)),
                          Text(emp.role,
                              style: TextStyle(fontFamily: 'Poppins', 
                                  fontSize: 11.5,
                                  color: AppColors.textHint)),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Icon(Icons.check_circle_rounded,
                          color: emp.color, size: 22),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 4),
          // Assign / Reassign button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: _selected != null
                    ? const LinearGradient(
                        colors: [AppColors.topbarStart, AppColors.topbarEnd])
                    : const LinearGradient(
                        colors: [AppColors.border, AppColors.border]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton(
                onPressed: _selected != null
                    ? () {
                        widget.onAssign(_selected!);
                        Navigator.pop(context);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor:     Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  widget.currentAssignee == null ? 'Assign' : 'Reassign',
                  style: TextStyle(fontFamily: 'Poppins', 
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  Message Sheet (Partial / Complete / Apology)
// ════════════════════════════════════════════════════════════════════════════

class _MessageSheet extends StatefulWidget {
  const _MessageSheet({
    required this.type,
    required this.customer,
    required this.phone,
    required this.itemType,
    this.newDate = '',
  });
  final _MsgType type;
  final String   customer;
  final String   phone;
  final String   itemType;
  final String   newDate;

  @override
  State<_MessageSheet> createState() => _MessageSheetState();
}

class _MessageSheetState extends State<_MessageSheet> {
  bool _marathi = false;
  late final TextEditingController _ctrl;

  String _build() {
    return switch (widget.type) {
      _MsgType.partial  => _partialMsg(widget.customer, widget.itemType, _marathi),
      _MsgType.complete => _completeMsg(widget.customer, _marathi),
      _MsgType.apology  => _apologyMsg(
          widget.customer, widget.itemType, widget.newDate, _marathi),
    };
  }

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: _build());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggleLang() => setState(() {
        _marathi = !_marathi;
        _ctrl.text = _build();
      });

  Future<void> _send() async {
    await Share.share(_ctrl.text,
        subject: 'Message from Pranav Ladies Tailors');
    if (mounted) Navigator.pop(context);
  }

  (String, Color, IconData) get _meta => switch (widget.type) {
        _MsgType.partial  => ('Notify Partial Completion', const Color(0xFF5E35B1), Icons.hourglass_bottom_rounded),
        _MsgType.complete => ('Order Complete Notification', AppColors.success,    Icons.celebration_rounded),
        _MsgType.apology  => ('Delay Apology Message',      AppColors.urgent,      Icons.sentiment_dissatisfied_rounded),
      };

  @override
  Widget build(BuildContext context) {
    final (title, color, icon) = _meta;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom
        + MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, 16 + bottomInset),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(4)),
              ),
            ),
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 18, color: color),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: TextStyle(fontFamily: 'Poppins', 
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: color)),
                      Text('To: ${widget.customer} · ${widget.phone}',
                          style: TextStyle(fontFamily: 'Poppins', 
                              fontSize: 11.5, color: AppColors.textHint)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Language toggle
                GestureDetector(
                  onTap: _toggleLang,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _marathi
                          ? AppColors.primaryLight.withValues(alpha: 0.30)
                          : AppColors.surface2,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: _marathi ? AppColors.primary : AppColors.border),
                    ),
                    child: Column(
                      children: [
                        Text(_marathi ? 'EN' : 'म',
                            style: TextStyle(fontFamily: 'Poppins', 
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: _marathi
                                    ? AppColors.primary
                                    : AppColors.textSecondary)),
                        Text(_marathi ? 'Eng' : 'मराठी',
                            style: TextStyle(fontFamily: 'Poppins', 
                                fontSize: 9,
                                color: _marathi
                                    ? AppColors.primary
                                    : AppColors.textHint)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Editable message
            Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                controller: _ctrl,
                maxLines: 10,
                style:
                    TextStyle(fontFamily: 'Poppins', fontSize: 13, height: 1.55),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
            const SizedBox(height: 14),
            // Send button (WhatsApp green)
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _send,
                icon: const Icon(Icons.send_rounded, size: 18, color: Colors.white),
                label: Text('Send via WhatsApp',
                    style: TextStyle(fontFamily: 'Poppins', 
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
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
//  Shared micro-widgets
// ════════════════════════════════════════════════════════════════════════════

class _UrgentBadge extends StatelessWidget {
  const _UrgentBadge();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.urgentLight,
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: AppColors.urgent.withValues(alpha: 0.50)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bolt_rounded, size: 10, color: AppColors.urgent),
          const SizedBox(width: 2),
          Text('Urgent',
              style: TextStyle(fontFamily: 'Poppins', 
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.urgent)),
        ],
      ),
    );
  }
}

class _DueDateChip extends StatelessWidget {
  const _DueDateChip({
    required this.date,
    required this.overdue,
    required this.df,
  });
  final DateTime date;
  final bool overdue;
  final DateFormat df;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.calendar_today_rounded,
            size: 12,
            color: overdue ? AppColors.error : AppColors.textHint),
        const SizedBox(width: 4),
        Text(
          overdue ? 'Overdue: ${df.format(date)}' : 'Due: ${df.format(date)}',
          style: TextStyle(fontFamily: 'Poppins', 
              fontSize: 11.5,
              fontWeight: overdue ? FontWeight.w600 : FontWeight.w400,
              color: overdue ? AppColors.error : AppColors.textHint),
        ),
      ],
    );
  }
}

class _EmployeeChip extends StatelessWidget {
  const _EmployeeChip({required this.emp});
  final _Employee emp;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: emp.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: emp.color.withValues(alpha: 0.30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 9,
            backgroundColor: emp.color.withValues(alpha: 0.18),
            child: Text(emp.initials,
                style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: emp.color)),
          ),
          const SizedBox(width: 6),
          Text(emp.name.split(' ').first,
              style: TextStyle(fontFamily: 'Poppins', 
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: emp.color)),
          const SizedBox(width: 4),
          Text('· ${emp.role}',
              style: TextStyle(fontFamily: 'Poppins', 
                  fontSize: 11,
                  color: emp.color.withValues(alpha: 0.70))),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });
  final String    label;
  final IconData  icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // Wrap in ConstrainedBox so this button always has a bounded max-width
    // when placed directly inside a Row (avoids BoxConstraints infinite-width
    // assertion that crashes the entire list).
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 140),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 15, color: Colors.white),
        label: Text(label,
            style: const TextStyle(fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  const _OutlineButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });
  final String    label;
  final IconData  icon;
  final Color     color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // Wrap in ConstrainedBox so this button always has a bounded max-width
    // when placed directly inside a Row.
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 160),
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 14),
        label: Text(label,
            style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600)),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message, required this.icon});
  final String   message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: AppColors.textHint),
          const SizedBox(height: 12),
          Text(message,
              style: TextStyle(fontFamily: 'Poppins', 
                  fontSize: 15, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
