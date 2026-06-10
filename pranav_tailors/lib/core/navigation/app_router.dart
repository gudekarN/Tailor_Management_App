// ════════════════════════════════════════════════════════════════════════════
//  app_router.dart
//  Pranav Ladies Tailors — go_router v14 configuration
//
//  Route Map
//  ─────────────────────────────────────────────────────────────────────────
//  /splash
//  /login
//
//  /manager  (StatefulShellRoute — 5 bottom-nav branches)
//    /manager/home
//    /manager/customers
//    /manager/work-queue
//    /manager/calendar
//    /manager/receipt
//    (Drawer extras — push on top of manager shell)
//    /manager/employees
//    /manager/employee-payment
//    /manager/expense-tracker
//    /manager/notice
//    /manager/design-gallery
//    /manager/settings
//
//  /employee  (StatefulShellRoute — 5 bottom-nav branches)
//    /employee/home
//    /employee/my-work
//    /employee/receipt
//    /employee/notice
//    /employee/more        (placeholder for "More" tab)
//    (Drawer extras)
//    /employee/design-gallery
//    /employee/my-payment
//    /employee/settings
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ── Screens ─────────────────────────────────────────────────────────────────
import 'package:pranav_tailors/features/splash/screens/splash_screen.dart';
import 'package:pranav_tailors/features/auth/screens/login_screen.dart';

// Manager
import 'package:pranav_tailors/features/manager/screens/manager_shell.dart';
import 'package:pranav_tailors/features/manager/screens/manager_home_screen.dart';
import 'package:pranav_tailors/features/manager/screens/manager_customers_screen.dart';
import 'package:pranav_tailors/features/manager/screens/manager_work_queue_screen.dart';
import 'package:pranav_tailors/features/manager/screens/manager_calendar_screen.dart';
import 'package:pranav_tailors/features/manager/screens/manager_receipt_screen.dart';
import 'package:pranav_tailors/features/manager/screens/manager_employees_screen.dart';
import 'package:pranav_tailors/features/manager/screens/manager_employee_payment_screen.dart';
import 'package:pranav_tailors/features/manager/screens/manager_expense_tracker_screen.dart';
import 'package:pranav_tailors/features/manager/screens/manager_notice_screen.dart';
import 'package:pranav_tailors/features/manager/screens/manager_design_gallery_screen.dart';
import 'package:pranav_tailors/features/manager/screens/manager_settings_screen.dart';

// Employee
import 'package:pranav_tailors/features/employee/screens/employee_shell.dart';
import 'package:pranav_tailors/features/employee/screens/employee_home_screen.dart';
import 'package:pranav_tailors/features/employee/screens/employee_my_work_screen.dart';
import 'package:pranav_tailors/features/employee/screens/employee_receipt_screen.dart';
import 'package:pranav_tailors/features/employee/screens/employee_notice_screen.dart';
import 'package:pranav_tailors/features/employee/screens/employee_design_gallery_screen.dart';
import 'package:pranav_tailors/features/employee/screens/employee_my_payment_screen.dart';
import 'package:pranav_tailors/features/employee/screens/employee_settings_screen.dart';

// ── Route name constants ──────────────────────────────────────────────────
abstract class AppRoutes {
  AppRoutes._();

  // Top-level
  static const String splash  = '/splash';
  static const String login   = '/login';

  // Manager
  static const String manager                = '/manager';
  static const String managerHome            = '/manager/home';
  static const String managerCustomers       = '/manager/customers';
  static const String managerWorkQueue       = '/manager/work-queue';
  static const String managerCalendar        = '/manager/calendar';
  static const String managerReceipt         = '/manager/receipt';
  // Manager drawer
  static const String managerEmployees       = '/manager/employees';
  static const String managerEmployeePayment = '/manager/employee-payment';
  static const String managerExpenseTracker  = '/manager/expense-tracker';
  static const String managerNotice          = '/manager/notice';
  static const String managerDesignGallery   = '/manager/design-gallery';
  static const String managerSettings        = '/manager/settings';

  // Employee
  static const String employee               = '/employee';
  static const String employeeHome           = '/employee/home';
  static const String employeeMyWork         = '/employee/my-work';
  static const String employeeReceipt        = '/employee/receipt';
  static const String employeeNotice         = '/employee/notice';
  static const String employeeMore           = '/employee/more';
  // Employee drawer
  static const String employeeDesignGallery  = '/employee/design-gallery';
  static const String employeeMyPayment      = '/employee/my-payment';
  static const String employeeSettings       = '/employee/settings';
}

// ════════════════════════════════════════════════════════════════════════════
//  Router Instance
// ════════════════════════════════════════════════════════════════════════════

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,

  routes: [
    // ── Splash ────────────────────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      pageBuilder: (context, state) => _fade(state, const SplashScreen()),
    ),

    // ── Login ─────────────────────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      pageBuilder: (context, state) => _fade(state, const LoginScreen()),
    ),

    // ═══════════════════════════════════════════════════════════════════════
    //  MANAGER — StatefulShellRoute (5 bottom-nav branches)
    // ═══════════════════════════════════════════════════════════════════════
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          ManagerShell(navigationShell: navigationShell),

      branches: [
        // Branch 0 — Home
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.managerHome,
            name: 'manager-home',
            pageBuilder: (context, state) =>
                _slide(state, const ManagerHomeScreen()),
            // Drawer sub-routes pushed on top of this branch
            routes: [
              GoRoute(
                path: 'employees',
                name: 'manager-employees',
                pageBuilder: (context, state) =>
                    _slide(state, const ManagerEmployeesScreen()),
              ),
              GoRoute(
                path: 'employee-payment',
                name: 'manager-employee-payment',
                pageBuilder: (context, state) =>
                    _slide(state, const ManagerEmployeePaymentScreen()),
              ),
              GoRoute(
                path: 'expense-tracker',
                name: 'manager-expense-tracker',
                pageBuilder: (context, state) =>
                    _slide(state, const ManagerExpenseTrackerScreen()),
              ),
              GoRoute(
                path: 'notice',
                name: 'manager-notice-drawer',
                pageBuilder: (context, state) =>
                    _slide(state, const ManagerNoticeScreen()),
              ),
              GoRoute(
                path: 'design-gallery',
                name: 'manager-design-gallery',
                pageBuilder: (context, state) =>
                    _slide(state, const ManagerDesignGalleryScreen()),
              ),
              GoRoute(
                path: 'settings',
                name: 'manager-settings',
                pageBuilder: (context, state) =>
                    _slide(state, const ManagerSettingsScreen()),
              ),
            ],
          ),
        ]),

        // Branch 1 — Customers
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.managerCustomers,
            name: 'manager-customers',
            pageBuilder: (context, state) =>
                _slide(state, const ManagerCustomersScreen()),
          ),
        ]),

        // Branch 2 — Work Queue
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.managerWorkQueue,
            name: 'manager-work-queue',
            pageBuilder: (context, state) =>
                _slide(state, const ManagerWorkQueueScreen()),
          ),
        ]),

        // Branch 3 — Calendar
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.managerCalendar,
            name: 'manager-calendar',
            pageBuilder: (context, state) =>
                _slide(state, const ManagerCalendarScreen()),
          ),
        ]),

        // Branch 4 — Receipt
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.managerReceipt,
            name: 'manager-receipt',
            pageBuilder: (context, state) =>
                _slide(state, const ManagerReceiptScreen()),
          ),
        ]),
      ],
    ),

    // ═══════════════════════════════════════════════════════════════════════
    //  EMPLOYEE — StatefulShellRoute (5 bottom-nav branches)
    // ═══════════════════════════════════════════════════════════════════════
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          EmployeeShell(navigationShell: navigationShell),

      branches: [
        // Branch 0 — Home
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.employeeHome,
            name: 'employee-home',
            pageBuilder: (context, state) =>
                _slide(state, const EmployeeHomeScreen()),
            // Drawer sub-routes pushed on top
            routes: [
              GoRoute(
                path: 'design-gallery',
                name: 'employee-design-gallery',
                pageBuilder: (context, state) =>
                    _slide(state, const EmployeeDesignGalleryScreen()),
              ),
              GoRoute(
                path: 'my-payment',
                name: 'employee-my-payment',
                pageBuilder: (context, state) =>
                    _slide(state, const EmployeeMyPaymentScreen()),
              ),
              GoRoute(
                path: 'settings',
                name: 'employee-settings',
                pageBuilder: (context, state) =>
                    _slide(state, const EmployeeSettingsScreen()),
              ),
            ],
          ),
        ]),

        // Branch 1 — My Work
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.employeeMyWork,
            name: 'employee-my-work',
            pageBuilder: (context, state) =>
                _slide(state, const EmployeeMyWorkScreen()),
          ),
        ]),

        // Branch 2 — Receipt
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.employeeReceipt,
            name: 'employee-receipt',
            pageBuilder: (context, state) =>
                _slide(state, const EmployeeReceiptScreen()),
          ),
        ]),

        // Branch 3 — Notice
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.employeeNotice,
            name: 'employee-notice',
            pageBuilder: (context, state) =>
                _slide(state, const EmployeeNoticeScreen()),
          ),
        ]),

        // Branch 4 — More (placeholder)
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.employeeMore,
            name: 'employee-more',
            pageBuilder: (context, state) => _slide(
              state,
              const _MorePlaceholder(),
            ),
          ),
        ]),
      ],
    ),
  ],

  // ── Error page ─────────────────────────────────────────────────────────
  errorPageBuilder: (context, state) => MaterialPage(
    child: Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  ),
);

// ════════════════════════════════════════════════════════════════════════════
//  Page transition helpers
// ════════════════════════════════════════════════════════════════════════════

/// Fade-in transition — used for splash / login.
CustomTransitionPage<void> _fade(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 350),
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

/// Slide-up transition — used for all feature screens.
CustomTransitionPage<void> _slide(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

// ── "More" placeholder widget ─────────────────────────────────────────────
class _MorePlaceholder extends StatelessWidget {
  const _MorePlaceholder();
  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(child: Text('More')),
      );
}
