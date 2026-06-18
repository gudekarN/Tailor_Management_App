// ════════════════════════════════════════════════════════════════════════════
//  employee_design_gallery_screen.dart
//  Pranav Ladies Tailors — Design Gallery (Employee — view + upload, no delete)
//  Thin wrapper over ManagerDesignGalleryScreen with readOnly: true.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:pranav_tailors/features/manager/screens/manager_design_gallery_screen.dart';

/// Reuses the manager gallery in read-only mode:
///   ✓ Browse all designs, ✓ Tap to full-screen view
///   ✓ Upload new photos via camera FAB
///   ✗ No long-press delete
class EmployeeDesignGalleryScreen extends StatelessWidget {
  const EmployeeDesignGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const ManagerDesignGalleryScreen(readOnly: true);
}
