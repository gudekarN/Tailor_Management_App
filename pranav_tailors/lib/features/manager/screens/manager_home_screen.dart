// ════════════════════════════════════════════════════════════════════════════
//  manager_home_screen.dart
//  Pranav Ladies Tailors — Manager Dashboard Home
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:intl/intl.dart';
import 'package:pranav_tailors/core/theme/app_theme.dart';
import 'package:pranav_tailors/features/manager/screens/manager_design_gallery_screen.dart';

class ManagerHomeScreen extends StatelessWidget {
  const ManagerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      drawer: _ManagerDrawer(),
      body: _HomeBody(),
    );
  }
}

// ── Drawer ───────────────────────────────────────────────────────────────────

class _ManagerDrawer extends StatelessWidget {
  const _ManagerDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.topbarStart, AppColors.topbarEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white.withValues(alpha: 0.20),
                  child: const Icon(Icons.person_rounded, size: 36, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Manager',
                          style: TextStyle(fontFamily: 'Poppins', 
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white)),
                      Text('Pranav Ladies Tailors',
                          style: TextStyle(fontFamily: 'Poppins', 
                              fontSize: 12, color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _DrawerTile(
                  icon: Icons.people_rounded,
                  title: 'Employees',
                  onTap: () => context.pushNamed('manager-employees'),
                ),
                _DrawerTile(
                  icon: Icons.payments_outlined,
                  title: 'Employee Payment',
                  onTap: () => context.pushNamed('manager-employee-payment'),
                ),
                _DrawerTile(
                  icon: Icons.account_balance_wallet_rounded,
                  title: 'Expense Tracker',
                  onTap: () => context.pushNamed('manager-expense-tracker'),
                ),
                _DrawerTile(
                  icon: Icons.campaign_rounded,
                  title: 'Notices',
                  onTap: () => context.pushNamed('manager-notice-drawer'),
                ),
                const Divider(color: AppColors.border),
                _DrawerTile(
                  icon: Icons.image_rounded,
                  title: 'Design Gallery',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ManagerDesignGalleryScreen(),
                    ),
                  ),
                ),
                _DrawerTile(
                  icon: Icons.settings_rounded,
                  title: 'Settings',
                  onTap: () {}, // context.pushNamed('manager-settings')
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.border, height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: _DrawerTile(
              icon: Icons.logout_rounded,
              title: 'Logout',
              color: AppColors.error,
              onTap: () => context.goNamed('login'),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.color = AppColors.textPrimary,
  });
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color == AppColors.textPrimary ? AppColors.textSecondary : color, size: 24),
      title: Text(title,
          style: TextStyle(fontFamily: 'Poppins', 
              fontSize: 14, fontWeight: FontWeight.w500, color: color)),
      onTap: () {
        Navigator.pop(context); // Close drawer
        onTap();
      },
      horizontalTitleGap: 12,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }
}

// ── Body ─────────────────────────────────────────────────────────────────────

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── Gradient App Bar ────────────────────────────────────────────────
        const _GradientAppBar(),

        // ── Content ─────────────────────────────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Stat cards 2x2 grid
              const _StatCardsGrid(),
              const SizedBox(height: 28),

              // Quick actions
              const _SectionHeader(title: 'Quick Actions'),
              const SizedBox(height: 12),
              const _QuickActions(),
              const SizedBox(height: 28),

              // Today's dues
              const _SectionHeader(title: "Today's Dues"),
              const SizedBox(height: 12),
              const _DuesList(),
              const SizedBox(height: 12),
            ]),
          ),
        ),
      ],
    );
  }
}

// ── Gradient App Bar ──────────────────────────────────────────────────────────

class _GradientAppBar extends StatelessWidget {
  const _GradientAppBar();

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning';
    if (h < 17) return 'Good Afternoon';
    return 'Good Evening';
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
                  // Row 1
                  Row(
                    children: [
                      Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(Icons.menu_rounded, color: Colors.white),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),
                      const Spacer(),
                      // Notification bell
                      GestureDetector(
                        onTap: () => _showNotificationsSheet(context),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.15),
                              ),
                              child: const Icon(
                                Icons.notifications_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                            // Badge
                            Positioned(
                              top: -2,
                              right: -2,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.urgent,
                                ),
                                child: Center(
                                  child: Text(
                                    '3',
                                    style: TextStyle(fontFamily: 'Poppins', 
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Row 2
                  Row(
                    children: [
                      // Avatar
                      Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Greeting + date
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_greeting()}, Manager 👋',
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
                      const Spacer(),
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

  void _showNotificationsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.fromLTRB(
            20, 12, 20, 20 + MediaQuery.of(context).padding.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(4)),
              ),
            ),
            Row(
              children: [
                Text('Notifications',
                    style: TextStyle(fontFamily: 'Poppins', 
                        fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.urgent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('3',
                      style: TextStyle(fontFamily: 'Poppins', 
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _NotifTile(
              icon: Icons.warning_rounded,
              iconColor: AppColors.error,
              title: 'Overdue Delivery — Priya Sharma',
              message: 'Silk Blouse × 2 was due yesterday. Contact customer.',
              time: '2 hrs ago',
            ),
            const SizedBox(height: 10),
            _NotifTile(
              icon: Icons.bolt_rounded,
              iconColor: AppColors.urgent,
              title: 'Urgent Order — Meena Patil',
              message: 'Salwar Suit marked urgent. Due by 2:00 PM today.',
              time: '4 hrs ago',
            ),
            const SizedBox(height: 10),
            _NotifTile(
              icon: Icons.payments_rounded,
              iconColor: AppColors.primary,
              title: 'Payment Received',
              message: '₹1,200 advance paid by Rekha Joshi for Lehenga Blouse.',
              time: 'Yesterday',
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section Header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontFamily: 'Poppins', 
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }
}

// ── Stat Cards Grid ───────────────────────────────────────────────────────────

class _StatCardsGrid extends StatelessWidget {
  const _StatCardsGrid();

  static const _stats = [
    _StatData(
      label: "Today's\nDeliveries",
      value: '8',
      icon: Icons.local_shipping_rounded,
      topColor: Color(0xFF26A69A),
      bgColor: Color(0xFFE0F2F1),
    ),
    _StatData(
      label: 'Pending\nOrders',
      value: '24',
      icon: Icons.pending_actions_rounded,
      topColor: Color(0xFFE65100),
      bgColor: Color(0xFFFFF3E0),
    ),
    _StatData(
      label: 'Total\nCustomers',
      value: '312',
      icon: Icons.people_rounded,
      topColor: Color(0xFF5E35B1),
      bgColor: Color(0xFFEDE7F6),
    ),
    _StatData(
      label: 'Monthly\nRevenue',
      value: '₹48,500',
      icon: Icons.currency_rupee_rounded,
      topColor: Color(0xFFC2185B),
      bgColor: Color(0xFFFFF0F5),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.55,
      ),
      itemCount: _stats.length,
      itemBuilder: (_, i) => _StatCard(data: _stats[i]),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.data});
  final _StatData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppShadows.card,
        border: Border(
          top: BorderSide(color: data.topColor, width: 3.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon bubble
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: data.bgColor,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(data.icon, color: data.topColor, size: 18),
            ),
            // Value + label
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.value,
                  style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.label,
                  style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatData {
  const _StatData({
    required this.label,
    required this.value,
    required this.icon,
    required this.topColor,
    required this.bgColor,
  });
  final String label;
  final String value;
  final IconData icon;
  final Color topColor;
  final Color bgColor;
}

// ── Quick Actions ─────────────────────────────────────────────────────────────

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  static const _actions = [
    _ActionData(
      icon: Icons.receipt_long_rounded,
      label: 'New\nReceipt',
      color: Color(0xFFC2185B),
      route: '/manager/receipt',
    ),
    _ActionData(
      icon: Icons.person_add_rounded,
      label: 'Add\nCustomer',
      color: Color(0xFF26A69A),
      route: '/manager/customers',
    ),
    _ActionData(
      icon: Icons.image_rounded,
      label: 'Design\nGallery',
      color: Color(0xFF5E35B1),
      route: '/manager/home/design-gallery',
    ),
    _ActionData(
      icon: Icons.account_balance_wallet_rounded,
      label: 'Expense\nTracker',
      color: Color(0xFFE65100),
      route: '/manager/home/expense-tracker',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _actions
          .map((a) => Expanded(child: _ActionButton(data: a)))
          .toList(),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.data});
  final _ActionData data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(data.route),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: data.color.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: data.color.withValues(alpha: 0.25)),
              ),
              child: Icon(data.icon, color: data.color, size: 24),
            ),
            const SizedBox(height: 6),
            Text(
              data.label,
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Poppins', 
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionData {
  const _ActionData({
    required this.icon,
    required this.label,
    required this.color,
    required this.route,
  });
  final IconData icon;
  final String   label;
  final Color    color;
  final String   route;
}

// ── Notification tile ─────────────────────────────────────────────────────────

class _NotifTile extends StatelessWidget {
  const _NotifTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.time,
  });
  final IconData icon;
  final Color    iconColor;
  final String   title;
  final String   message;
  final String   time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(fontFamily: 'Poppins', 
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(message,
                    style: TextStyle(fontFamily: 'Poppins', 
                        fontSize: 11.5,
                        color: AppColors.textSecondary,
                        height: 1.4)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(time,
              style: TextStyle(fontFamily: 'Poppins', 
                  fontSize: 10.5, color: AppColors.textHint)),
        ],
      ),
    );
  }
}

// ── Today's Dues ──────────────────────────────────────────────────────────────

enum _DueBadge { urgent, pending, overdue }

class _DueOrder {
  const _DueOrder({
    required this.customer,
    required this.item,
    required this.amount,
    required this.badge,
    required this.dueTime,
  });
  final String customer;
  final String item;
  final String amount;
  final _DueBadge badge;
  final String dueTime;
}

class _DuesList extends StatelessWidget {
  const _DuesList();

  static const _orders = [
    _DueOrder(
      customer: 'Priya Sharma',
      item: 'Silk Blouse × 2',
      amount: '₹1,800',
      badge: _DueBadge.overdue,
      dueTime: 'Was due yesterday',
    ),
    _DueOrder(
      customer: 'Meena Patil',
      item: 'Salwar Suit',
      amount: '₹2,400',
      badge: _DueBadge.urgent,
      dueTime: 'Due by 2:00 PM',
    ),
    _DueOrder(
      customer: 'Rekha Joshi',
      item: 'Lehenga Blouse',
      amount: '₹3,200',
      badge: _DueBadge.urgent,
      dueTime: 'Due by 5:00 PM',
    ),
    _DueOrder(
      customer: 'Sunita Desai',
      item: 'Cotton Kurti × 3',
      amount: '₹900',
      badge: _DueBadge.pending,
      dueTime: 'Due by 7:00 PM',
    ),
    _DueOrder(
      customer: 'Kavita Rane',
      item: 'Blouse + Fall & Pico',
      amount: '₹650',
      badge: _DueBadge.pending,
      dueTime: 'Due by 8:00 PM',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _orders
          .map((o) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _DueCard(order: o),
              ))
          .toList(),
    );
  }
}

class _DueCard extends StatelessWidget {
  const _DueCard({required this.order});
  final _DueOrder order;

  (Color, Color, String, IconData) _badgeProps() {
    switch (order.badge) {
      case _DueBadge.overdue:
        return (
          AppColors.error,
          AppColors.errorLight,
          'Overdue',
          Icons.warning_rounded,
        );
      case _DueBadge.urgent:
        return (
          AppColors.urgent,
          AppColors.urgentLight,
          'Urgent',
          Icons.bolt_rounded,
        );
      case _DueBadge.pending:
        return (
          AppColors.primary,
          AppColors.primaryLight,
          'Pending',
          Icons.schedule_rounded,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final (badgeColor, badgeBg, badgeLabel, badgeIcon) = _badgeProps();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppShadows.subtle,
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // Left accent bar
            Container(
              width: 3.5,
              height: 44,
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            // Customer info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.customer,
                    style: TextStyle(fontFamily: 'Poppins', 
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    order.item,
                    style: TextStyle(fontFamily: 'Poppins', 
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded,
                          size: 11, color: AppColors.textHint),
                      const SizedBox(width: 3),
                      Text(
                        order.dueTime,
                        style: TextStyle(fontFamily: 'Poppins', 
                          fontSize: 10.5,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // Right: amount + badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  order.amount,
                  style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(badgeIcon, size: 10, color: badgeColor),
                      const SizedBox(width: 3),
                      Text(
                        badgeLabel,
                        style: TextStyle(fontFamily: 'Poppins', 
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: badgeColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
