// ════════════════════════════════════════════════════════════════════════════
//  employee_home_screen.dart
//  Pranav Ladies Tailors — Employee Home Dashboard
//  Employee: Sunita
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pranav_tailors/core/theme/app_theme.dart';

class EmployeeHomeScreen extends StatelessWidget {
  const EmployeeHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: _HomeBody(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Body
// ─────────────────────────────────────────────────────────────────────────────

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const _GradientAppBar(),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // ── Summary Cards ──────────────────────────────────────────
              const _SummaryCards(),
              const SizedBox(height: 28),

              // ── Today's Urgent Items ───────────────────────────────────
              const _SectionHeader(title: "Today's Urgent Items"),
              const SizedBox(height: 12),
              const _UrgentList(),
              const SizedBox(height: 28),

              // ── Quick Link ─────────────────────────────────────────────
              const _QuickLinkButton(),
              const SizedBox(height: 12),
            ]),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Gradient AppBar
// ─────────────────────────────────────────────────────────────────────────────

class _GradientAppBar extends StatelessWidget {
  const _GradientAppBar();

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning';
    if (h < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _NotificationsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());

    return SliverAppBar(
      expandedHeight: 130,
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.primary,
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Row 1 — title
                  Row(
                    children: [
                      Text(
                        'Pranav Ladies Tailors',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                      ),
                      const Spacer(),
                      // Notification bell — tap to open notifications sheet
                      GestureDetector(
                        onTap: () => _showNotifications(context),
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.15),
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              const Icon(
                                Icons.notifications_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                              Positioned(
                                top: 6,
                                right: 6,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.urgent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Row 2 — greeting
                  Row(
                    children: [
                      // Avatar
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryDark.withValues(alpha: 0.30),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'S',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_greeting()}, Sunita 👋',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            today,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11.5,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withValues(alpha: 0.80),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Section Header
// ─────────────────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Summary Cards
// ─────────────────────────────────────────────────────────────────────────────

class _SummaryCards extends StatelessWidget {
  const _SummaryCards();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Full-width top card — My Pending Work (highlighted)
        _SummaryCard(
          label: 'My Pending Work',
          value: '5',
          icon: Icons.pending_actions_rounded,
          topColor: AppColors.urgent,
          bgColor: AppColors.urgentLight,
          isWide: true,
          subtitle: '2 urgent items today',
        ),
        const SizedBox(height: 12),
        // Two smaller cards side-by-side
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                label: 'Completed\nToday',
                value: '3',
                icon: Icons.check_circle_rounded,
                topColor: AppColors.success,
                bgColor: AppColors.successLight,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                label: 'This Month\nEarnings',
                value: '₹7,400',
                icon: Icons.currency_rupee_rounded,
                topColor: AppColors.primary,
                bgColor: AppColors.surface2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.topColor,
    required this.bgColor,
    this.isWide = false,
    this.subtitle,
  });

  final String   label;
  final String   value;
  final IconData icon;
  final Color    topColor;
  final Color    bgColor;
  final bool     isWide;
  final String?  subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppShadows.card,
        border: Border(
          left: BorderSide(color: topColor, width: 3.5),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: isWide
          ? Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: topColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        value,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: topColor,
                          height: 1.1,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(Icons.bolt_rounded, size: 12, color: topColor),
                            const SizedBox(width: 3),
                            Text(
                              subtitle!,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: topColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(icon, color: topColor, size: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Today's Urgent Items
// ─────────────────────────────────────────────────────────────────────────────

class _UrgentItem {
  const _UrgentItem({
    required this.customer,
    required this.item,
    required this.dueBy,
    required this.assignedDate,
  });
  final String customer;
  final String item;
  final String dueBy;
  final String assignedDate;
}

const _urgentItems = [
  _UrgentItem(
    customer: 'Meena Patil',
    item: 'Silk Blouse',
    dueBy: 'Due by 2:00 PM today',
    assignedDate: 'Assigned: 12 Jun',
  ),
  _UrgentItem(
    customer: 'Rekha Joshi',
    item: 'Lehenga Blouse',
    dueBy: 'Due by 5:00 PM today',
    assignedDate: 'Assigned: 13 Jun',
  ),
];

class _UrgentList extends StatelessWidget {
  const _UrgentList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _urgentItems
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _UrgentItemTile(item: item),
              ))
          .toList(),
    );
  }
}

class _UrgentItemTile extends StatelessWidget {
  const _UrgentItemTile({required this.item});
  final _UrgentItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.urgentLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.urgent.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: AppColors.urgent.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          // Orange flame icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.urgent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.bolt_rounded,
                color: AppColors.urgent, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.customer,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.item,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.assignedDate,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10.5,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.urgent,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'URGENT',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item.dueBy,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.urgent,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Quick Link Button
// ─────────────────────────────────────────────────────────────────────────────

class _QuickLinkButton extends StatelessWidget {
  const _QuickLinkButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/employee/my-work'),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.topbarStart, AppColors.topbarEnd],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppShadows.elevated,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.assignment_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'View My Work',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'See all assigned tasks & update status',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Notifications bottom sheet
// ─────────────────────────────────────────────────────────────────────────────

class _NotificationItem {
  const _NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.timeAgo,
    this.isUnread = true,
  });
  final IconData icon;
  final Color    iconColor;
  final Color    iconBg;
  final String   title;
  final String   subtitle;
  final String   timeAgo;
  final bool     isUnread;
}

const _kNotifications = [
  _NotificationItem(
    icon:      Icons.assignment_rounded,
    iconColor: AppColors.primary,
    iconBg:    AppColors.primaryLight,
    title:     'New Work Assigned',
    subtitle:  'Silk Blouse for Priya Sharma — due 18 Jun',
    timeAgo:   '10 min ago',
    isUnread:  true,
  ),
  _NotificationItem(
    icon:      Icons.local_shipping_rounded,
    iconColor: AppColors.urgent,
    iconBg:    Color(0xFFFFECCC),
    title:     'Delivery Due Tomorrow',
    subtitle:  'Salwar Kameez for Meena Patil — 17 Jun 2026',
    timeAgo:   '2 hrs ago',
    isUnread:  true,
  ),
  _NotificationItem(
    icon:      Icons.campaign_rounded,
    iconColor: AppColors.secondary,
    iconBg:    AppColors.secondaryLight,
    title:     'New Manager Notice',
    subtitle:  'Wedding Season Rush — check the notice board',
    timeAgo:   'Yesterday',
    isUnread:  false,
  ),
];

class _NotificationsSheet extends StatelessWidget {
  const _NotificationsSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 38, height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(99),
            ),
          ),

          // Gradient header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
            margin: const EdgeInsets.only(top: 6),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.topbarStart, AppColors.topbarEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.notifications_active_rounded,
                      color: Colors.white, size: 18),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Notifications',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      Text('3 notifications',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 11,
                              color: Colors.white70)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.urgent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('2 new',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ),
              ],
            ),
          ),

          // Notification tiles
          ..._kNotifications.map((n) => _NotifTile(item: n)),
          const SizedBox(height: 8),

          // Close button
          Padding(
            padding: EdgeInsets.fromLTRB(
                16, 4, 16, MediaQuery.of(context).padding.bottom + 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surface2,
                  foregroundColor: AppColors.primary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Close',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotifTile extends StatelessWidget {
  const _NotifTile({required this.item});
  final _NotificationItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: item.isUnread
            ? AppColors.primaryLight.withValues(alpha: 0.35)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: item.isUnread
              ? AppColors.primary.withValues(alpha: 0.20)
              : AppColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon badge
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: item.iconBg,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(item.icon, color: item.iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          // Text body
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(item.title,
                          style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary)),
                    ),
                    if (item.isUnread)
                      Container(
                        width: 7, height: 7,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(item.subtitle,
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11.5,
                        color: AppColors.textSecondary,
                        height: 1.4)),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded,
                        size: 11, color: AppColors.textHint),
                    const SizedBox(width: 3),
                    Text(item.timeAgo,
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10.5,
                            color: AppColors.textHint)),
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
