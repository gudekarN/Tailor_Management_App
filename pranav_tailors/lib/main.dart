// ════════════════════════════════════════════════════════════════════════════
//  main.dart
//  Pranav Ladies Tailors — App Entry Point
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:pranav_tailors/core/navigation/app_router.dart';
import 'package:pranav_tailors/core/theme/app_theme.dart';
import 'package:pranav_tailors/core/services/notification_service.dart';
import 'package:pranav_tailors/features/manager/screens/customer_detail_screen.dart'
    show CustomerData;

// ── Dummy data bridging ─────────────────────────────────────────────────────
// The app has no shared data layer yet, so we pass empty lists here.
// Once a real repository / provider layer exists (e.g. with Riverpod),
// replace these with live data fetched from the state layer.
//
// To test notifications during development, replace _kDummyItems and
// _kDummyCustomers with real or seeded data.
const List<NotifWorkItem> _kDummyItems     = [];
const List<CustomerData>  _kDummyCustomers = [];

// ════════════════════════════════════════════════════════════════════════════

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise local notifications (creates channel, requests permission).
  await NotificationService().init();

  runApp(const PranavTailorsApp());
}

// ════════════════════════════════════════════════════════════════════════════
//  Root widget — holds the WidgetsBindingObserver for lifecycle events
// ════════════════════════════════════════════════════════════════════════════

class PranavTailorsApp extends StatefulWidget {
  const PranavTailorsApp({super.key});
  @override
  State<PranavTailorsApp> createState() => _PranavTailorsAppState();
}

class _PranavTailorsAppState extends State<PranavTailorsApp>
    with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Fire notification check after first frame so the UI is up before any
    // async work starts, and so BuildContext-dependent code is safe to call.
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkNotifications());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Called by Flutter when the app lifecycle state changes.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Re-check whenever the user brings the app back to the foreground.
      _checkNotifications();
    }
  }

  /// Delegates to [DeliveryNotificationChecker]. The SharedPreferences guard
  /// inside it ensures each alert fires at most once per day.
  Future<void> _checkNotifications() async {
    await DeliveryNotificationChecker().checkAndNotify(
      items:     _kDummyItems,
      customers: _kDummyCustomers,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pranav Ladies Tailors',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}
