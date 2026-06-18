// ════════════════════════════════════════════════════════════════════════════
//  birthday_notification_helper.dart
//  Pranav Ladies Tailors — Birthday utility functions
//
//  Exposes three pure functions consumed by a separate notification_service.dart:
//    • getTodaysBirthdays   — filters customers whose DOB month/day match today
//    • buildBirthdayWishMessage — crafts a warm WhatsApp-friendly message
//    • openWhatsAppWithMessage  — url_launcher deep-link into WhatsApp
//
//  NOTE: This file deliberately contains NO notification-trigger logic.
//  Wire up scheduled triggers in notification_service.dart instead.
// ════════════════════════════════════════════════════════════════════════════

import 'package:url_launcher/url_launcher.dart';

// ── Model import ──────────────────────────────────────────────────────────────
//
// CustomerData (with the dateOfBirth: DateTime? field added in Fix 1) lives in:
//   lib/features/manager/screens/customer_detail_screen.dart
//
// If the project later migrates CustomerData to a dedicated models/ layer,
// update the import path below accordingly and remove this comment.
import 'package:pranav_tailors/features/manager/screens/customer_detail_screen.dart';

// ════════════════════════════════════════════════════════════════════════════
//  1. Filter today's birthdays
// ════════════════════════════════════════════════════════════════════════════

/// Returns every [CustomerData] in [customers] whose [dateOfBirth] month and
/// day match today's date, regardless of year.
///
/// Customers with a null [dateOfBirth] are silently skipped.
List<CustomerData> getTodaysBirthdays(List<CustomerData> customers) {
  final today = DateTime.now();
  return customers.where((c) {
    final dob = c.dateOfBirth;
    if (dob == null) return false;
    return dob.month == today.month && dob.day == today.day;
  }).toList();
}

// ════════════════════════════════════════════════════════════════════════════
//  2. Build birthday wish message
// ════════════════════════════════════════════════════════════════════════════

/// Returns a professional, warm birthday wish message (<= 300 characters)
/// formatted for WhatsApp, signed off from "Pranav Ladies Tailors".
///
/// Example output:
///   "Dear Priya, wishing you a very Happy Birthday! 🎉 May your day be
///   filled with joy. Thank you for trusting us with your tailoring needs.
///   Warm regards, Pranav Ladies Tailors."
String buildBirthdayWishMessage(String customerName) {
  // Use the customer's first name for a personal touch.
  final firstName = customerName.trim().split(' ').first;
  return 'Dear $firstName, wishing you a very Happy Birthday! 🎉 '
      'May your day be filled with joy and happiness. '
      'Thank you for trusting us with your tailoring needs. '
      'Warm regards, Pranav Ladies Tailors.';
}

// ════════════════════════════════════════════════════════════════════════════
//  3. Open WhatsApp with pre-filled message
// ════════════════════════════════════════════════════════════════════════════

/// Opens WhatsApp with [message] pre-filled for [phoneNumber].
///
/// Rules applied to [phoneNumber]:
///   • All non-digit characters are stripped first.
///   • If the cleaned number is 10 digits (Indian mobile), "91" is prepended.
///   • If it is already 12 digits starting with "91", it is used as-is.
///
/// Uses the `wa.me` deep-link scheme which works on both Android and iOS.
/// Returns `false` and does nothing if WhatsApp cannot be launched.
Future<void> openWhatsAppWithMessage(
  String phoneNumber,
  String message,
) async {
  // Strip every non-digit character.
  final digits = phoneNumber.replaceAll(RegExp(r'\D'), '');

  // Resolve to a full international number.
  final String internationalNumber;
  if (digits.length == 10) {
    // Plain Indian mobile — prepend country code.
    internationalNumber = '91$digits';
  } else if (digits.startsWith('91') && digits.length == 12) {
    internationalNumber = digits;
  } else {
    // Unknown format — use as-is and let WhatsApp handle it.
    internationalNumber = digits;
  }

  final encodedMessage = Uri.encodeComponent(message);
  final uri = Uri.parse(
    'https://wa.me/$internationalNumber?text=$encodedMessage',
  );

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
  // If WhatsApp is not installed / link can't be opened, fail silently.
  // Callers may optionally check the return type if they need feedback.
}
