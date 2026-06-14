// ════════════════════════════════════════════════════════════════════════════
//  calendar_screen.dart
//  Pranav Ladies Tailors — Work / Delivery Calendar (Manager)
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pranav_tailors/core/theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════════════════
//  Data models
// ════════════════════════════════════════════════════════════════════════════

enum _OrderStatus { unassigned, inProgress, completed }

class _DeliveryOrder {
  const _DeliveryOrder({
    required this.id,
    required this.customer,
    required this.itemType,
    required this.isUrgent,
    required this.status,
    required this.assignee,
    required this.assigneeColor,
    required this.deliveryDate,
  });
  final int          id;
  final String       customer;
  final String       itemType;
  final bool         isUrgent;
  final _OrderStatus status;
  final String       assignee;
  final Color        assigneeColor;
  final DateTime     deliveryDate;
}

// ════════════════════════════════════════════════════════════════════════════
//  Dummy data — deliveries spread across current month
// ════════════════════════════════════════════════════════════════════════════

List<_DeliveryOrder> _buildOrders() {
  final now = DateTime.now();
  // Helper: create date at midnight (normalised)
  DateTime d(int dayOffset) =>
      DateTime(now.year, now.month, now.day + dayOffset);

  return [
    _DeliveryOrder(id: 1,  customer: 'Priya Sharma',     itemType: 'Silk Blouse × 2',    isUrgent: false, status: _OrderStatus.inProgress,  assignee: 'Kaveri',  assigneeColor: const Color(0xFF26A69A), deliveryDate: d(-5)),
    _DeliveryOrder(id: 2,  customer: 'Meena Patil',      itemType: 'Silk Blouse',         isUrgent: true,  status: _OrderStatus.inProgress,  assignee: 'Sunanda', assigneeColor: const Color(0xFF5E35B1), deliveryDate: d(-3)),
    _DeliveryOrder(id: 3,  customer: 'Rekha Joshi',      itemType: 'Salwar Suit',         isUrgent: false, status: _OrderStatus.unassigned,  assignee: '—',        assigneeColor: AppColors.textHint,     deliveryDate: d(-1)),
    _DeliveryOrder(id: 4,  customer: 'Anita Kulkarni',   itemType: 'Lehenga Blouse',      isUrgent: true,  status: _OrderStatus.inProgress,  assignee: 'Manager', assigneeColor: AppColors.primary,       deliveryDate: d(-1)),
    _DeliveryOrder(id: 5,  customer: 'Kavita Rane',      itemType: 'Kurti × 3',           isUrgent: true,  status: _OrderStatus.inProgress,  assignee: 'Manager', assigneeColor: AppColors.primary,       deliveryDate: d(0)),
    _DeliveryOrder(id: 6,  customer: 'Sunita Desai',     itemType: 'Salwar Kameez',       isUrgent: false, status: _OrderStatus.inProgress,  assignee: 'Sunanda', assigneeColor: const Color(0xFF5E35B1), deliveryDate: d(0)),
    _DeliveryOrder(id: 7,  customer: 'Lata Sawant',      itemType: 'Cotton Kurti',        isUrgent: false, status: _OrderStatus.completed,   assignee: 'Kaveri',  assigneeColor: const Color(0xFF26A69A), deliveryDate: d(2)),
    _DeliveryOrder(id: 8,  customer: 'Pooja Nair',       itemType: 'Blouse + Fall & Pico',isUrgent: false, status: _OrderStatus.inProgress,  assignee: 'Rekha',   assigneeColor: const Color(0xFFE65100), deliveryDate: d(3)),
    _DeliveryOrder(id: 9,  customer: 'Deepa Chavan',     itemType: 'Silk Blouse',         isUrgent: false, status: _OrderStatus.completed,   assignee: 'Sunanda', assigneeColor: const Color(0xFF5E35B1), deliveryDate: d(3)),
    _DeliveryOrder(id: 10, customer: 'Usha Deshpande',   itemType: 'Salwar Suit',         isUrgent: false, status: _OrderStatus.completed,   assignee: 'Manager', assigneeColor: AppColors.primary,       deliveryDate: d(5)),
    _DeliveryOrder(id: 11, customer: 'Nanda Shinde',     itemType: 'Wedding Blouse',      isUrgent: true,  status: _OrderStatus.inProgress,  assignee: 'Kaveri',  assigneeColor: const Color(0xFF26A69A), deliveryDate: d(5)),
    _DeliveryOrder(id: 12, customer: 'Smita Deshmukh',   itemType: 'Kurti + Pant Set',    isUrgent: false, status: _OrderStatus.unassigned,  assignee: '—',        assigneeColor: AppColors.textHint,     deliveryDate: d(7)),
    _DeliveryOrder(id: 13, customer: 'Vandana More',     itemType: 'Silk Saree Blouse',   isUrgent: false, status: _OrderStatus.inProgress,  assignee: 'Priya',   assigneeColor: const Color(0xFF1565C0), deliveryDate: d(8)),
    _DeliveryOrder(id: 14, customer: 'Kalpana Jadhav',   itemType: 'Salwar Kameez × 2',  isUrgent: true,  status: _OrderStatus.unassigned,  assignee: '—',        assigneeColor: AppColors.textHint,     deliveryDate: d(10)),
    _DeliveryOrder(id: 15, customer: 'Rohini Kulkarni',  itemType: 'Lehenga Full Set',    isUrgent: false, status: _OrderStatus.inProgress,  assignee: 'Sunanda', assigneeColor: const Color(0xFF5E35B1), deliveryDate: d(12)),
    _DeliveryOrder(id: 16, customer: 'Pushpa Gaikwad',   itemType: 'Cotton Blouse × 3',  isUrgent: false, status: _OrderStatus.unassigned,  assignee: '—',        assigneeColor: AppColors.textHint,     deliveryDate: d(14)),
    _DeliveryOrder(id: 17, customer: 'Suman Pawar',      itemType: 'Kurti',               isUrgent: true,  status: _OrderStatus.inProgress,  assignee: 'Rekha',   assigneeColor: const Color(0xFFE65100), deliveryDate: d(14)),
    _DeliveryOrder(id: 18, customer: 'Alka Bhosale',     itemType: 'Silk Blouse',         isUrgent: false, status: _OrderStatus.unassigned,  assignee: '—',        assigneeColor: AppColors.textHint,     deliveryDate: d(17)),
    _DeliveryOrder(id: 19, customer: 'Madhuri Deshpande',itemType: 'Dress + Fall',        isUrgent: false, status: _OrderStatus.inProgress,  assignee: 'Priya',   assigneeColor: const Color(0xFF1565C0), deliveryDate: d(19)),
    _DeliveryOrder(id: 20, customer: 'Sujata Mane',      itemType: 'Embroidered Blouse',  isUrgent: true,  status: _OrderStatus.inProgress,  assignee: 'Kaveri',  assigneeColor: const Color(0xFF26A69A), deliveryDate: d(21)),
  ];
}

// ── Normalise a DateTime to midnight ─────────────────────────────────────────
DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

// ════════════════════════════════════════════════════════════════════════════
//  Screen
// ════════════════════════════════════════════════════════════════════════════

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});
  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final List<_DeliveryOrder> _orders;

  // Calendar state
  late DateTime _focusedDay;
  DateTime?     _selectedDay;
  CalendarFormat _calFormat = CalendarFormat.month;

  // Derived map: normalised date → list of orders
  late final Map<DateTime, List<_DeliveryOrder>> _orderMap;

  final _dayFmt     = DateFormat('EEEE, dd MMMM yyyy');

  @override
  void initState() {
    super.initState();
    _orders   = _buildOrders();
    _orderMap = {};
    for (final o in _orders) {
      final key = _day(o.deliveryDate);
      _orderMap.putIfAbsent(key, () => []).add(o);
    }
    _focusedDay  = DateTime.now();
    _selectedDay = _day(DateTime.now());
  }

  List<_DeliveryOrder> _ordersForDay(DateTime day) =>
      _orderMap[_day(day)] ?? [];

  bool _isPastDue(DateTime day) {
    final d = _day(day);
    if (d.isAfter(_day(DateTime.now())) ||
        d.isAtSameMomentAs(_day(DateTime.now()))) return false;
    final orders = _ordersForDay(d);
    return orders.any((o) => o.status != _OrderStatus.completed);
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // ── Legend ─────────────────────────────────────────────────────────
          _buildLegend(),
          // ── Calendar ───────────────────────────────────────────────────────
          _buildCalendar(),
          // ── Selected Day Deliveries ────────────────────────────────────────
          Expanded(child: _buildDayDeliveries()),
        ],
      ),
    );
  }

  Widget _buildDayDeliveries() {
    if (_selectedDay == null) {
      return Center(
        child: Text('Tap a date to see deliveries',
            style: TextStyle(fontFamily: 'Poppins', 
                fontSize: 14, color: AppColors.textSecondary)),
      );
    }

    final day = _selectedDay!;
    final orders = _ordersForDay(day);

    return Column(
      children: [
        _buildDayHeader(day, orders),
        Expanded(
          child: orders.isEmpty
              ? _buildEmptyDay()
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: orders.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _OrderCard(order: orders[i]),
                ),
        ),
      ],
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
            end: Alignment.bottomRight,
          ),
        ),
      ),
      title: Text('Delivery Calendar',
          style: TextStyle(fontFamily: 'Poppins', 
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
      actions: [
        IconButton(
          icon: const Icon(Icons.today_rounded, color: Colors.white),
          tooltip: 'Jump to today',
          onPressed: () => setState(() {
            _focusedDay  = DateTime.now();
            _selectedDay = _day(DateTime.now());
          }),
        ),
      ],
    );
  }

  // ── Legend row ─────────────────────────────────────────────────────────────
  Widget _buildLegend() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          _LegendDot(color: AppColors.primary,     label: 'Today'),
          const SizedBox(width: 16),
          _LegendDot(color: AppColors.primary,     label: 'Has deliveries', dot: true),
          const SizedBox(width: 16),
          _LegendDot(color: AppColors.error,       label: 'Past due', bg: true),
          const SizedBox(width: 16),
          _LegendDot(color: AppColors.success,     label: 'All done', dot: true),
        ],
      ),
    );
  }

  // ── Table Calendar ─────────────────────────────────────────────────────────
  Widget _buildCalendar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: TableCalendar<_DeliveryOrder>(
          firstDay:  DateTime(DateTime.now().year, DateTime.now().month - 2, 1),
          lastDay:   DateTime(DateTime.now().year, DateTime.now().month + 6, 28),
          focusedDay: _focusedDay,
          selectedDayPredicate: (d) =>
              _selectedDay != null && isSameDay(_selectedDay!, d),
          calendarFormat: _calFormat,
          eventLoader: _ordersForDay,
          startingDayOfWeek: StartingDayOfWeek.monday,

          // ── Header style ────────────────────────────────────────────────
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(fontFamily: 'Poppins', 
                fontSize: 15, fontWeight: FontWeight.w700,
                color: AppColors.textPrimary),
            leftChevronIcon: const Icon(Icons.chevron_left_rounded,
                color: AppColors.primary, size: 22),
            rightChevronIcon: const Icon(Icons.chevron_right_rounded,
                color: AppColors.primary, size: 22),
            headerPadding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.surface2,
            ),
          ),

          // ── Day-of-week labels ───────────────────────────────────────────
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(fontFamily: 'Poppins', 
                fontSize: 11.5, fontWeight: FontWeight.w600,
                color: AppColors.textSecondary),
            weekendStyle: TextStyle(fontFamily: 'Poppins', 
                fontSize: 11.5, fontWeight: FontWeight.w600,
                color: AppColors.primary),
          ),

          // ── Calendar style ───────────────────────────────────────────────
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,

            // Today
            todayDecoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            todayTextStyle: TextStyle(fontFamily: 'Poppins', 
                fontSize: 13, fontWeight: FontWeight.w700,
                color: Colors.white),

            // Selected (non-today)
            selectedDecoration: BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 1.5),
            ),
            selectedTextStyle: TextStyle(fontFamily: 'Poppins', 
                fontSize: 13, fontWeight: FontWeight.w700,
                color: AppColors.primary),

            // Default day
            defaultTextStyle: TextStyle(fontFamily: 'Poppins', 
                fontSize: 13, color: AppColors.textPrimary),
            weekendTextStyle: TextStyle(fontFamily: 'Poppins', 
                fontSize: 13, color: AppColors.primary),
            outsideTextStyle: TextStyle(fontFamily: 'Poppins', 
                fontSize: 13, color: AppColors.textHint),

            // Markers (dots)
            markerDecoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            markerSize: 5,
            markersMaxCount: 3,
            markerMargin: const EdgeInsets.symmetric(horizontal: 0.5),

            // Row height
            rowDecoration: const BoxDecoration(color: Colors.transparent),
            tableBorder: const TableBorder(),
          ),

          // ── Custom cell builder (past-due red bg) ────────────────────────
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (ctx, day, focusedDay) {
              if (_isPastDue(day)) {
                return _PastDueCell(day: day);
              }
              return null; // use default
            },
            outsideBuilder: (ctx, day, focusedDay) => const SizedBox.shrink(),

            // Dot markers coloured by status
            markerBuilder: (ctx, day, events) {
              if (events.isEmpty) return const SizedBox.shrink();
              final allDone = events.every(
                  (e) => e.status == _OrderStatus.completed);
              final hasUrgent = events.any((e) => e.isUrgent);
              final dotColor = allDone
                  ? AppColors.success
                  : hasUrgent
                      ? AppColors.urgent
                      : AppColors.primary;
              return Positioned(
                bottom: 4,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    events.length.clamp(1, 3),
                    (_) => Container(
                      width: 5,
                      height: 5,
                      margin: const EdgeInsets.symmetric(horizontal: 0.5),
                      decoration: BoxDecoration(
                          color: dotColor, shape: BoxShape.circle),
                    ),
                  ),
                ),
              );
            },
          ),

          // ── Interactions ─────────────────────────────────────────────────
          onDaySelected: (selected, focused) {
            setState(() {
              _selectedDay = selected;
              _focusedDay  = focused;
            });
          },
          onPageChanged: (focused) {
            setState(() => _focusedDay = focused);
          },
        ),
      ),
    );
  }

  // ── Selected day header ────────────────────────────────────────────────────
  Widget _buildDayHeader(DateTime day, List<_DeliveryOrder> orders) {
    final isToday = isSameDay(day, DateTime.now());
    final pastDue = _isPastDue(day);

    Color bg    = AppColors.surface2;
    Color text  = AppColors.textPrimary;
    if (isToday) { bg = AppColors.primaryLight; text = AppColors.primary; }
    if (pastDue) { bg = AppColors.errorLight;   text = AppColors.error;   }

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 4),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isToday
              ? AppColors.primary.withValues(alpha: 0.40)
              : pastDue
                  ? AppColors.error.withValues(alpha: 0.40)
                  : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_dayFmt.format(day),
                    style: TextStyle(fontFamily: 'Poppins', 
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: text)),
                if (isToday)
                  Text('Today',
                      style: TextStyle(fontFamily: 'Poppins', 
                          fontSize: 11, color: AppColors.primary,
                          fontWeight: FontWeight.w600)),
                if (pastDue && !isToday)
                  Text('Past due — incomplete orders',
                      style: TextStyle(fontFamily: 'Poppins', 
                          fontSize: 11, color: AppColors.error,
                          fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          // Delivery count badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: orders.isEmpty
                  ? AppColors.border.withValues(alpha: 0.60)
                  : isToday
                      ? AppColors.primary
                      : pastDue
                          ? AppColors.error
                          : AppColors.primaryDark,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              orders.isEmpty
                  ? 'No deliveries'
                  : '${orders.length} deliver${orders.length == 1 ? 'y' : 'ies'}',
              style: TextStyle(fontFamily: 'Poppins', 
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ── Empty day state ────────────────────────────────────────────────────────
  Widget _buildEmptyDay() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_available_rounded,
              size: 52,
              color: AppColors.primary.withValues(alpha: 0.30)),
          const SizedBox(height: 10),
          Text('No deliveries on this date',
              style: TextStyle(fontFamily: 'Poppins', 
                  fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text('Select a date with a dot marker to see orders',
              style: TextStyle(fontFamily: 'Poppins', 
                  fontSize: 11.5, color: AppColors.textHint)),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  Past-due cell widget
// ════════════════════════════════════════════════════════════════════════════

class _PastDueCell extends StatelessWidget {
  const _PastDueCell({required this.day});
  final DateTime day;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          '${day.day}',
          style: TextStyle(fontFamily: 'Poppins', 
              fontSize: 13,
              color: AppColors.error,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  Order card (inline list below calendar)
// ════════════════════════════════════════════════════════════════════════════

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});
  final _DeliveryOrder order;

  Color get _statusColor => switch (order.status) {
        _OrderStatus.unassigned => AppColors.urgent,
        _OrderStatus.inProgress => const Color(0xFF1565C0),
        _OrderStatus.completed  => AppColors.success,
      };

  String get _statusLabel => switch (order.status) {
        _OrderStatus.unassigned => 'Unassigned',
        _OrderStatus.inProgress => 'In Progress',
        _OrderStatus.completed  => 'Completed',
      };

  IconData get _statusIcon => switch (order.status) {
        _OrderStatus.unassigned => Icons.person_off_rounded,
        _OrderStatus.inProgress => Icons.pending_rounded,
        _OrderStatus.completed  => Icons.check_circle_rounded,
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
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Colour stripe by status
          Container(
            height: 3,
            decoration: BoxDecoration(
              color: _statusColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(14)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row 1 — customer + urgent badge
                Row(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 18,
                      backgroundColor:
                          AppColors.primary.withValues(alpha: 0.12),
                      child: Text(
                        order.customer.substring(0, 1),
                        style: TextStyle(fontFamily: 'Poppins', 
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(order.customer,
                              style: TextStyle(fontFamily: 'Poppins', 
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary)),
                          Text(order.itemType,
                              style: TextStyle(fontFamily: 'Poppins', 
                                  fontSize: 12.5,
                                  color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    if (order.isUrgent) const _UrgentBadge(),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(color: AppColors.border, height: 1),
                const SizedBox(height: 10),
                // Row 2 — assignee + status
                Row(
                  children: [
                    // Assignee chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: order.assigneeColor.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color:
                                order.assigneeColor.withValues(alpha: 0.30)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.person_rounded,
                              size: 13, color: order.assigneeColor),
                          const SizedBox(width: 4),
                          Text(order.assignee,
                              style: TextStyle(fontFamily: 'Poppins', 
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: order.assigneeColor)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Status chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _statusColor.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: _statusColor.withValues(alpha: 0.30)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_statusIcon, size: 13, color: _statusColor),
                          const SizedBox(width: 4),
                          Text(_statusLabel,
                              style: TextStyle(fontFamily: 'Poppins', 
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _statusColor)),
                        ],
                      ),
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
//  Shared micro-widgets
// ════════════════════════════════════════════════════════════════════════════

class _UrgentBadge extends StatelessWidget {
  const _UrgentBadge();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.urgentLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.urgent.withValues(alpha: 0.50)),
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

class _LegendDot extends StatelessWidget {
  const _LegendDot({
    required this.color,
    required this.label,
    this.dot = false,
    this.bg  = false,
  });
  final Color  color;
  final String label;
  final bool   dot;
  final bool   bg;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (dot)
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          )
        else if (bg)
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: color.withValues(alpha: 0.50)),
            ),
          )
        else
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        const SizedBox(width: 5),
        Text(label,
            style: TextStyle(fontFamily: 'Poppins', 
                fontSize: 10.5, color: AppColors.textSecondary)),
      ],
    );
  }
}
