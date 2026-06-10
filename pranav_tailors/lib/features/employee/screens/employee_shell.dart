// ════════════════════════════════════════════════════════════════════════════
//  employee_shell.dart
//  Bottom-nav shell for the Employee role.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pranav_tailors/core/theme/app_theme.dart';

class EmployeeShell extends StatelessWidget {
  const EmployeeShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const List<_TabItem> _tabs = [
    _TabItem(icon: Icons.home_outlined,           activeIcon: Icons.home_rounded,             label: 'Home'),
    _TabItem(icon: Icons.assignment_outlined,     activeIcon: Icons.assignment_rounded,       label: 'My Work'),
    _TabItem(icon: Icons.receipt_long_outlined,   activeIcon: Icons.receipt_long_rounded,     label: 'Receipt'),
    _TabItem(icon: Icons.campaign_outlined,       activeIcon: Icons.campaign_rounded,         label: 'Notice'),
    _TabItem(icon: Icons.more_horiz_outlined,     activeIcon: Icons.more_horiz_rounded,       label: 'More'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: navigationShell,
      ),
      bottomNavigationBar: _EmployeeBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}

class _EmployeeBottomNav extends StatelessWidget {
  const _EmployeeBottomNav({
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
            children: List.generate(EmployeeShell._tabs.length, (i) {
              final tab    = EmployeeShell._tabs[i];
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
