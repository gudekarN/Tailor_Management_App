// ════════════════════════════════════════════════════════════════════════════
//  manager_shell.dart
//  Bottom-nav shell for the Manager role.
//  The [StatefulShellRoute] from go_router passes a [StatefulNavigationShell]
//  which handles keeping each branch alive independently.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pranav_tailors/core/theme/app_theme.dart';

class ManagerShell extends StatelessWidget {
  const ManagerShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  // ── Bottom-nav tab definitions ──────────────────────────────────────────
  static const List<_TabItem> _tabs = [
    _TabItem(icon: Icons.home_outlined,     activeIcon: Icons.home_rounded,          label: 'Home'),
    _TabItem(icon: Icons.people_outline,    activeIcon: Icons.people_rounded,        label: 'Customers'),
    _TabItem(icon: Icons.list_alt_outlined, activeIcon: Icons.list_alt_rounded,      label: 'Work Queue'),
    _TabItem(icon: Icons.calendar_month_outlined, activeIcon: Icons.calendar_month_rounded, label: 'Calendar'),
    _TabItem(icon: Icons.receipt_long_outlined,   activeIcon: Icons.receipt_long_rounded,   label: 'Receipt'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: navigationShell,
      ),
      bottomNavigationBar: _ManagerBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}

// ── Bottom Navigation Bar ─────────────────────────────────────────────────
class _ManagerBottomNav extends StatelessWidget {
  const _ManagerBottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(
          top: BorderSide(color: AppColors.border, width: 1.0),
        ),
        boxShadow: AppShadows.elevated,
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(ManagerShell._tabs.length, (i) {
              final tab    = ManagerShell._tabs[i];
              final active = i == currentIndex;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Active indicator pill
                        SizedBox(
                          height: 4,
                          child: Visibility(
                            visible: active,
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            child: Container(
                              width: 36,
                              height: 4,
                              margin: const EdgeInsets.only(bottom: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(AppBorderRadius.full),
                              ),
                            ),
                          ),
                        ),
                        Icon(
                          active ? tab.activeIcon : tab.icon,
                          color: active ? AppColors.primary : AppColors.textHint,
                          size: 22,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          tab.label,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: active ? AppColors.primary : AppColors.textHint,
                            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ── Tab definition helper ─────────────────────────────────────────────────
class _TabItem {
  const _TabItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
  final IconData icon;
  final IconData activeIcon;
  final String  label;
}
