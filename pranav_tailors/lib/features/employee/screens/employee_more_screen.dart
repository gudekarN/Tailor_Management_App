// ════════════════════════════════════════════════════════════════════════════
//  employee_more_screen.dart
//  Pranav Ladies Tailors — Employee "More" tab
//  Quick-access hub for secondary employee features.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pranav_tailors/core/navigation/app_router.dart';
import 'package:pranav_tailors/core/theme/app_theme.dart';

// ─── Feature tile descriptor ──────────────────────────────────────────────────
class _MoreTile {
  const _MoreTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.color,
  });
  final IconData icon;
  final String   title;
  final String   subtitle;
  final String   route;
  final Color    color;
}

const _kTiles = [
  _MoreTile(
    icon:     Icons.account_balance_wallet_rounded,
    title:    'My Payment',
    subtitle: 'Earnings, balance & payment history',
    route:    AppRoutes.employeeMyPayment,
    color:    Color(0xFFC2185B),
  ),
  _MoreTile(
    icon:     Icons.style_rounded,
    title:    'Design Gallery',
    subtitle: 'Browse and reference design patterns',
    route:    AppRoutes.employeeDesignGallery,
    color:    AppColors.secondary,
  ),
  _MoreTile(
    icon:     Icons.settings_rounded,
    title:    'Settings',
    subtitle: 'App preferences and account options',
    route:    AppRoutes.employeeSettings,
    color:    AppColors.textSecondary,
  ),
];

// ─── Stats from dummy data (mirrors employee_home_screen figures) ─────────────
const int _kCompletedThisMonth = 11;
const int _kPendingWork        = 3;
const int _kDaysWorked         = 14;

// ════════════════════════════════════════════════════════════════════════════
//  SCREEN
// ════════════════════════════════════════════════════════════════════════════

class EmployeeMoreScreen extends StatelessWidget {
  const EmployeeMoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Gradient SliverAppBar (profile header) ────────────────────
          SliverAppBar(
            expandedHeight: 200,
            automaticallyImplyLeading: false,
            pinned: true,
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
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Avatar
                        Container(
                          width: 72, height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryDark
                                    .withValues(alpha: 0.30),
                                blurRadius: 14,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text('S',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text('Sunita',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.20),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text('Employee · Pranav Ladies Tailors',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11.5,
                                  color: Colors.white70)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            title: const Text('More',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ),

          // ── Quick stats strip ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.surface,
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                children: [
                  _QuickStat(
                      icon: Icons.done_all_rounded,
                      value: '$_kCompletedThisMonth',
                      label: 'Completed\nThis Month',
                      color: AppColors.success),
                  _Divider(),
                  _QuickStat(
                      icon: Icons.assignment_late_rounded,
                      value: '$_kPendingWork',
                      label: 'Pending\nWork',
                      color: AppColors.urgent),
                  _Divider(),
                  _QuickStat(
                      icon: Icons.calendar_today_rounded,
                      value: '$_kDaysWorked',
                      label: 'Days\nWorked',
                      color: AppColors.primary),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(child: const SizedBox(height: 16)),

          // ── Section header ────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Text('Features',
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.5)),
            ),
          ),

          // ── Feature tiles ─────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final tile = _kTiles[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _FeatureTile(
                      tile: tile,
                      onTap: () => context.push(tile.route),
                    ),
                  );
                },
                childCount: _kTiles.length,
              ),
            ),
          ),

          // ── Divider before logout ──────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: const Divider(color: AppColors.border),
            ),
          ),

          // ── Logout ────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: _LogoutTile(
                onTap: () => _confirmLogout(context),
              ),
            ),
          ),

          // ── Footer ───────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
              child: Center(
                child: Text(
                  'Pranav Ladies Tailors  ·  v1.0.0',
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: AppColors.textHint),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 17,
                fontWeight: FontWeight.w700)),
        content: const Text('Are you sure you want to log out?',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13.5,
                color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go(AppRoutes.login);
            },
            child: const Text('Logout',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Feature tile card
// ─────────────────────────────────────────────────────────────────────────────

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({required this.tile, required this.onTap});
  final _MoreTile   tile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
          boxShadow: AppShadows.subtle,
        ),
        child: Row(
          children: [
            // Icon badge
            Container(
              width: 46, height: 46,
              decoration: BoxDecoration(
                color: tile.color.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: tile.color.withValues(alpha: 0.25)),
              ),
              child:
                  Icon(tile.icon, color: tile.color, size: 22),
            ),
            const SizedBox(width: 14),
            // Labels
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tile.title,
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(tile.subtitle,
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textHint, size: 22),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Logout tile
// ─────────────────────────────────────────────────────────────────────────────

class _LogoutTile extends StatelessWidget {
  const _LogoutTile({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.errorLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.error.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Container(
              width: 46, height: 46,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.25)),
              ),
              child: const Icon(Icons.logout_rounded,
                  color: AppColors.error, size: 22),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Logout',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.error)),
                  SizedBox(height: 2),
                  Text('Sign out of your account',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: AppColors.error,
                          fontWeight: FontWeight.w400)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.error, size: 22),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Quick stat cell
// ─────────────────────────────────────────────────────────────────────────────

class _QuickStat extends StatelessWidget {
  const _QuickStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });
  final IconData icon;
  final String   value, label;
  final Color    color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: color)),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10.5,
                  color: AppColors.textHint,
                  height: 1.35)),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      width: 1, height: 52,
      color: AppColors.border,
      margin: const EdgeInsets.symmetric(horizontal: 4));
}
