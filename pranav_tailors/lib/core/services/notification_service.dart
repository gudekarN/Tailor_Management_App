// ════════════════════════════════════════════════════════════════════════════
//  notification_service.dart
//  Pranav Ladies Tailors — Local Notification Service
//
//  Provides two top-level classes:
//    • NotificationService  — thin singleton wrapper around
//                             FlutterLocalNotificationsPlugin.
//    • DeliveryNotificationChecker — checks overdue orders, today's deliveries,
//                             and today's customer birthdays, then fires local
//                             notifications (once per item per day, guarded by
//                             SharedPreferences).
//
//  ⚠  KNOWN LIMITATION:
//  These notifications fire ONLY when the app is open or resumed from the
//  background. They will NOT fire when the app is fully closed because this
//  implementation uses show() (immediate), not zonedSchedule() (alarm-based).
//  To deliver notifications to a closed app you have two options:
//    1. Use flutter_local_notifications' zonedSchedule() with the
//       SCHEDULE_EXACT_ALARM / USE_EXACT_ALARM permission (Android 12+).
//    2. Integrate Firebase Cloud Messaging (FCM) once the FastAPI backend
//       exists — the backend can push a message at the right time and the
//       FCM plugin delivers it even when the app is fully killed.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pranav_tailors/features/manager/screens/customer_detail_screen.dart'
    show CustomerData;
import 'package:pranav_tailors/core/services/birthday_notification_helper.dart'
    show getTodaysBirthdays;

// ════════════════════════════════════════════════════════════════════════════
//  Bridging work-item model
//
//  Both work_queue_screen.dart (_WorkItem) and calendar_screen.dart
//  (_DeliveryOrder) define their own private local models. Until the project
//  has a shared data / repository layer, callers convert their local objects
//  into this lightweight struct before calling DeliveryNotificationChecker.
//
//  TODO: Once a shared models/ or data/ layer is introduced (e.g. alongside
//  the FastAPI backend), replace this class with the real shared WorkItem
//  and update all call sites accordingly.
// ════════════════════════════════════════════════════════════════════════════

class NotifWorkItem {
  const NotifWorkItem({
    required this.id,
    required this.customerName,
    required this.deliveryDate,
    required this.isCompleted,
  });

  /// Unique identifier that matches the id in the screen's local model.
  final int      id;
  final String   customerName;
  final DateTime deliveryDate;

  /// True when the order status is "completed" (whatever the screen calls it).
  final bool     isCompleted;
}

// ════════════════════════════════════════════════════════════════════════════
//  Notification channel & ID constants
// ════════════════════════════════════════════════════════════════════════════

const _kChannelId          = 'tailor_shop_alerts';
const _kChannelName        = 'Tailor Shop Alerts';
const _kChannelDescription =
    'Order overdue, delivery-due, and birthday notifications for Pranav Ladies Tailors.';

// Notification IDs — use a fixed base per type, add item id as offset so IDs
// are unique across types. Keep below 2^31 - 1.
const _kBaseOverdue   = 10000;
const _kBaseToday     = 20000;
const _kBaseBirthday  = 30000;

// ════════════════════════════════════════════════════════════════════════════
//  1.  NotificationService  (singleton)
// ════════════════════════════════════════════════════════════════════════════

class NotificationService {
  // Singleton boilerplate.
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // ── Initialise ──────────────────────────────────────────────────────────

  /// Call once, before [runApp], or inside the root widget's [initState].
  ///
  /// • Registers the Android notification channel "tailor_shop_alerts".
  /// • Requests POST_NOTIFICATIONS permission (Android 13 / API 33+) using
  ///   the plugin's built-in request method — no separate permission_handler
  ///   package is needed.
  Future<void> init() async {
    // ── Android init settings ────────────────────────────────────────────
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(android: androidInit);

    await _plugin.initialize(initSettings);

    // ── Create notification channel (Android 8.0+) ───────────────────────
    const channel = AndroidNotificationChannel(
      _kChannelId,
      _kChannelName,
      description: _kChannelDescription,
      importance: Importance.high,
      playSound: true,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // ── Request POST_NOTIFICATIONS permission (Android 13 / API 33+) ─────
    // The plugin exposes this natively — no permission_handler needed.
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidImpl != null) {
      final granted = await androidImpl.requestNotificationsPermission();
      if (kDebugMode) {
        debugPrint('[NotificationService] Permission granted: $granted');
      }
    }
  }

  // ── Show an immediate notification ──────────────────────────────────────

  /// Fires an immediate local notification.
  ///
  /// [id] must be unique per notification; reusing an id updates/replaces the
  /// existing notification with that id. Use the [_kBase*] constants + item id
  /// for stable, type-scoped IDs.
  Future<void> showNotification({
    required int    id,
    required String title,
    required String body,
    String?         payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      _kChannelId,
      _kChannelName,
      channelDescription: _kChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(id, title, body, details, payload: payload);
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  2.  DeliveryNotificationChecker
// ════════════════════════════════════════════════════════════════════════════

class DeliveryNotificationChecker {
  // Singleton — same pattern as NotificationService.
  static final DeliveryNotificationChecker _instance =
      DeliveryNotificationChecker._internal();
  factory DeliveryNotificationChecker() => _instance;
  DeliveryNotificationChecker._internal();

  final _svc     = NotificationService();
  final _dateFmt = DateFormat('yyyyMMdd'); // key suffix, e.g. "20260618"

  // ── Public entry-point ───────────────────────────────────────────────────

  /// Call this on app launch AND every time [AppLifecycleState.resumed] fires.
  ///
  /// [items]     — convert your screen-local work-item objects into
  ///               [NotifWorkItem] before passing them in (see model note
  ///               at the top of this file).
  /// [customers] — pass the same [CustomerData] list used by CustomersScreen.
  ///
  /// Duplicate-notification guard: each notification type+id is stored as a
  /// date-stamped key in SharedPreferences. If the key already exists for
  /// today, the notification is skipped — so the user sees each alert once
  /// per day at most.
  Future<void> checkAndNotify({
    required List<NotifWorkItem> items,
    required List<CustomerData>  customers,
  }) async {
    final prefs   = await SharedPreferences.getInstance();
    final today   = DateTime.now();
    final todayKey = _dateFmt.format(today);

    // ── a) Overdue orders ────────────────────────────────────────────────
    for (final item in items) {
      if (item.isCompleted) continue;
      final dueDay = DateTime(
          item.deliveryDate.year, item.deliveryDate.month, item.deliveryDate.day);
      final nowDay = DateTime(today.year, today.month, today.day);

      if (dueDay.isBefore(nowDay)) {
        final key = 'notified_overdue_${item.id}_$todayKey';
        if (prefs.containsKey(key)) continue; // already notified today

        await _svc.showNotification(
          id:    _kBaseOverdue + item.id,
          title: 'Order Overdue',
          body:  "${item.customerName}'s order is overdue. Tap to reschedule.",
          payload: 'overdue:${item.id}',
        );
        await prefs.setBool(key, true);
      }
    }

    // ── b) Deliveries due today ───────────────────────────────────────────
    for (final item in items) {
      if (item.isCompleted) continue;
      final dueDay = DateTime(
          item.deliveryDate.year, item.deliveryDate.month, item.deliveryDate.day);
      final nowDay = DateTime(today.year, today.month, today.day);

      if (dueDay.isAtSameMomentAs(nowDay)) {
        final key = 'notified_today_${item.id}_$todayKey';
        if (prefs.containsKey(key)) continue;

        await _svc.showNotification(
          id:    _kBaseToday + item.id,
          title: 'Delivery Due Today',
          body:  "${item.customerName}'s order is due today.",
          payload: 'today:${item.id}',
        );
        await prefs.setBool(key, true);
      }
    }

    // ── c) Customer birthdays ─────────────────────────────────────────────
    final birthdays = getTodaysBirthdays(customers);
    for (final customer in birthdays) {
      // Use a stable ID derived from the customer's name (no shared int id
      // on CustomerData yet). hashCode can theoretically collide but is
      // fine for a local notification ID — add a real id field when the
      // shared model is introduced.
      final stableId  = customer.name.hashCode.abs() % 9000; // keep < 9999
      final key       = 'notified_birthday_${customer.name}_$todayKey';
      if (prefs.containsKey(key)) continue;

      await _svc.showNotification(
        id:    _kBaseBirthday + stableId,
        title: '🎂 Customer Birthday Today',
        body:  "It's ${customer.name}'s birthday today! Tap to send wishes.",
        payload: 'birthday:${customer.name}',
      );
      await prefs.setBool(key, true);
    }
  }
}
