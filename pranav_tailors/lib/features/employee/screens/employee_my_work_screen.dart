// ════════════════════════════════════════════════════════════════════════════
//  employee_my_work_screen.dart
//  Pranav Ladies Tailors — Employee My Work Screen
//  Employee: Sunita | 8 dummy work items with measurements expansion
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:pranav_tailors/core/theme/app_theme.dart';

// ═════════════════════════════════════════════════════════════════════════════
//  DATA MODELS
// ═════════════════════════════════════════════════════════════════════════════

enum WorkStatus { pending, completed }

enum ItemType { blouse, dress }

class _Measurement {
  const _Measurement({
    required this.labelEn,
    required this.labelMr,
    required this.value,
  });
  final String labelEn;
  final String labelMr;
  final String value;
}

class _WorkItem {
  const _WorkItem({
    required this.id,
    required this.customer,
    required this.itemType,
    required this.itemLabel,
    required this.deliveryDate,
    required this.assignedDate,
    required this.status,
    required this.measurements,
    this.isUrgent = false,
    this.completedDate,
    required this.thumbnailIcon,
    required this.accentColor,
  });

  final String        id;
  final String        customer;
  final ItemType      itemType;
  final String        itemLabel;
  final String        deliveryDate;
  final String        assignedDate;
  final WorkStatus    status;
  final List<_Measurement> measurements;
  final bool          isUrgent;
  final String?       completedDate;
  final IconData      thumbnailIcon;
  final Color         accentColor;
}

// ─── 8 dummy work items for Sunita ──────────────────────────────────────────

const List<_WorkItem> _allItems = [
  _WorkItem(
    id: 'WRK-001',
    customer: 'Meena Patil',
    itemType: ItemType.blouse,
    itemLabel: 'Silk Blouse',
    deliveryDate: '15 Jun 2026',
    assignedDate: '12 Jun 2026',
    status: WorkStatus.pending,
    isUrgent: true,
    thumbnailIcon: Icons.checkroom_rounded,
    accentColor: Color(0xFFC2185B),
    measurements: [
      _Measurement(labelEn: 'Length',        labelMr: 'लांबी',       value: '14.5"'),
      _Measurement(labelEn: 'Chest',         labelMr: 'छाती',        value: '36"'),
      _Measurement(labelEn: 'Waist',         labelMr: 'कमर',         value: '32"'),
      _Measurement(labelEn: 'Shoulder',      labelMr: 'खांदा',       value: '13"'),
      _Measurement(labelEn: 'Sleeve Length', labelMr: 'बाही लांबी', value: '22"'),
      _Measurement(labelEn: 'Sleeve Round',  labelMr: 'बाही गोल',   value: '12"'),
      _Measurement(labelEn: 'Front Neck',    labelMr: 'पुढील मान',   value: '6"'),
      _Measurement(labelEn: 'Back Neck',     labelMr: 'मागील मान',   value: '4"'),
    ],
  ),
  _WorkItem(
    id: 'WRK-002',
    customer: 'Rekha Joshi',
    itemType: ItemType.blouse,
    itemLabel: 'Lehenga Blouse',
    deliveryDate: '15 Jun 2026',
    assignedDate: '13 Jun 2026',
    status: WorkStatus.pending,
    isUrgent: true,
    thumbnailIcon: Icons.checkroom_rounded,
    accentColor: Color(0xFFAD1457),
    measurements: [
      _Measurement(labelEn: 'Length',        labelMr: 'लांबी',       value: '13"'),
      _Measurement(labelEn: 'Chest',         labelMr: 'छाती',        value: '34"'),
      _Measurement(labelEn: 'Waist',         labelMr: 'कमर',         value: '30"'),
      _Measurement(labelEn: 'Shoulder',      labelMr: 'खांदा',       value: '12.5"'),
      _Measurement(labelEn: 'Sleeve Length', labelMr: 'बाही लांबी', value: '21"'),
      _Measurement(labelEn: 'Sleeve Round',  labelMr: 'बाही गोल',   value: '11"'),
      _Measurement(labelEn: 'Front Neck',    labelMr: 'पुढील मान',   value: '5.5"'),
      _Measurement(labelEn: 'Back Neck',     labelMr: 'मागील मान',   value: '3.5"'),
    ],
  ),
  _WorkItem(
    id: 'WRK-003',
    customer: 'Sunita Desai',
    itemType: ItemType.dress,
    itemLabel: 'Salwar Suit',
    deliveryDate: '17 Jun 2026',
    assignedDate: '10 Jun 2026',
    status: WorkStatus.pending,
    isUrgent: false,
    thumbnailIcon: Icons.dry_cleaning_rounded,
    accentColor: Color(0xFF6A1B9A),
    measurements: [
      _Measurement(labelEn: 'Top Length',    labelMr: 'वरची लांबी',   value: '42"'),
      _Measurement(labelEn: 'Chest',         labelMr: 'छाती',         value: '38"'),
      _Measurement(labelEn: 'Waist',         labelMr: 'कमर',          value: '34"'),
      _Measurement(labelEn: 'Hip',           labelMr: 'नितंब',        value: '40"'),
      _Measurement(labelEn: 'Shoulder',      labelMr: 'खांदा',        value: '14"'),
      _Measurement(labelEn: 'Sleeve Length', labelMr: 'बाही लांबी',  value: '23"'),
      _Measurement(labelEn: 'Pant Length',   labelMr: 'पॅन्ट लांबी', value: '38"'),
      _Measurement(labelEn: 'Pant Waist',    labelMr: 'पॅन्ट कमर',   value: '33"'),
    ],
  ),
  _WorkItem(
    id: 'WRK-004',
    customer: 'Kavita Rane',
    itemType: ItemType.blouse,
    itemLabel: 'Cotton Blouse',
    deliveryDate: '18 Jun 2026',
    assignedDate: '11 Jun 2026',
    status: WorkStatus.pending,
    isUrgent: false,
    thumbnailIcon: Icons.checkroom_rounded,
    accentColor: Color(0xFF00897B),
    measurements: [
      _Measurement(labelEn: 'Length',        labelMr: 'लांबी',       value: '15"'),
      _Measurement(labelEn: 'Chest',         labelMr: 'छाती',        value: '40"'),
      _Measurement(labelEn: 'Waist',         labelMr: 'कमर',         value: '36"'),
      _Measurement(labelEn: 'Shoulder',      labelMr: 'खांदा',       value: '14.5"'),
      _Measurement(labelEn: 'Sleeve Length', labelMr: 'बाही लांबी', value: '24"'),
      _Measurement(labelEn: 'Sleeve Round',  labelMr: 'बाही गोल',   value: '13"'),
      _Measurement(labelEn: 'Front Neck',    labelMr: 'पुढील मान',   value: '6.5"'),
      _Measurement(labelEn: 'Back Neck',     labelMr: 'मागील मान',   value: '4.5"'),
    ],
  ),
  _WorkItem(
    id: 'WRK-005',
    customer: 'Anita Kulkarni',
    itemType: ItemType.dress,
    itemLabel: 'Anarkali Dress',
    deliveryDate: '20 Jun 2026',
    assignedDate: '9 Jun 2026',
    status: WorkStatus.pending,
    isUrgent: false,
    thumbnailIcon: Icons.dry_cleaning_rounded,
    accentColor: Color(0xFFE65100),
    measurements: [
      _Measurement(labelEn: 'Length',        labelMr: 'लांबी',        value: '52"'),
      _Measurement(labelEn: 'Chest',         labelMr: 'छाती',         value: '37"'),
      _Measurement(labelEn: 'Waist',         labelMr: 'कमर',          value: '33"'),
      _Measurement(labelEn: 'Hip',           labelMr: 'नितंब',        value: '39"'),
      _Measurement(labelEn: 'Shoulder',      labelMr: 'खांदा',        value: '13.5"'),
      _Measurement(labelEn: 'Sleeve Length', labelMr: 'बाही लांबी',  value: '22.5"'),
      _Measurement(labelEn: 'Front Neck',    labelMr: 'पुढील मान',    value: '7"'),
      _Measurement(labelEn: 'Back Neck',     labelMr: 'मागील मान',    value: '4"'),
    ],
  ),
  _WorkItem(
    id: 'WRK-006',
    customer: 'Priya Sharma',
    itemType: ItemType.blouse,
    itemLabel: 'Saree Blouse',
    deliveryDate: '10 Jun 2026',
    assignedDate: '5 Jun 2026',
    status: WorkStatus.completed,
    completedDate: '9 Jun 2026',
    isUrgent: false,
    thumbnailIcon: Icons.checkroom_rounded,
    accentColor: Color(0xFF2E7D32),
    measurements: [
      _Measurement(labelEn: 'Length',        labelMr: 'लांबी',       value: '14"'),
      _Measurement(labelEn: 'Chest',         labelMr: 'छाती',        value: '35"'),
      _Measurement(labelEn: 'Waist',         labelMr: 'कमर',         value: '31"'),
      _Measurement(labelEn: 'Shoulder',      labelMr: 'खांदा',       value: '12"'),
      _Measurement(labelEn: 'Sleeve Length', labelMr: 'बाही लांबी', value: '20"'),
      _Measurement(labelEn: 'Sleeve Round',  labelMr: 'बाही गोल',   value: '11.5"'),
      _Measurement(labelEn: 'Front Neck',    labelMr: 'पुढील मान',   value: '5"'),
      _Measurement(labelEn: 'Back Neck',     labelMr: 'मागील मान',   value: '3"'),
    ],
  ),
  _WorkItem(
    id: 'WRK-007',
    customer: 'Pooja Nair',
    itemType: ItemType.dress,
    itemLabel: 'Churidar Suit',
    deliveryDate: '12 Jun 2026',
    assignedDate: '6 Jun 2026',
    status: WorkStatus.completed,
    completedDate: '11 Jun 2026',
    isUrgent: false,
    thumbnailIcon: Icons.dry_cleaning_rounded,
    accentColor: Color(0xFF1565C0),
    measurements: [
      _Measurement(labelEn: 'Top Length',    labelMr: 'वरची लांबी',   value: '40"'),
      _Measurement(labelEn: 'Chest',         labelMr: 'छाती',         value: '36"'),
      _Measurement(labelEn: 'Waist',         labelMr: 'कमर',          value: '32"'),
      _Measurement(labelEn: 'Hip',           labelMr: 'नितंब',        value: '38"'),
      _Measurement(labelEn: 'Shoulder',      labelMr: 'खांदा',        value: '13"'),
      _Measurement(labelEn: 'Sleeve Length', labelMr: 'बाही लांबी',  value: '22"'),
      _Measurement(labelEn: 'Pant Length',   labelMr: 'पॅन्ट लांबी', value: '37"'),
      _Measurement(labelEn: 'Pant Waist',    labelMr: 'पॅन्ट कमर',   value: '32"'),
    ],
  ),
  _WorkItem(
    id: 'WRK-008',
    customer: 'Nisha Borkar',
    itemType: ItemType.blouse,
    itemLabel: 'Velvet Blouse',
    deliveryDate: '13 Jun 2026',
    assignedDate: '7 Jun 2026',
    status: WorkStatus.completed,
    completedDate: '12 Jun 2026',
    isUrgent: false,
    thumbnailIcon: Icons.checkroom_rounded,
    accentColor: Color(0xFF6A1B9A),
    measurements: [
      _Measurement(labelEn: 'Length',        labelMr: 'लांबी',       value: '15.5"'),
      _Measurement(labelEn: 'Chest',         labelMr: 'छाती',        value: '38"'),
      _Measurement(labelEn: 'Waist',         labelMr: 'कमर',         value: '34"'),
      _Measurement(labelEn: 'Shoulder',      labelMr: 'खांदा',       value: '13.5"'),
      _Measurement(labelEn: 'Sleeve Length', labelMr: 'बाही लांबी', value: '21.5"'),
      _Measurement(labelEn: 'Sleeve Round',  labelMr: 'बाही गोल',   value: '12.5"'),
      _Measurement(labelEn: 'Front Neck',    labelMr: 'पुढील मान',   value: '6"'),
      _Measurement(labelEn: 'Back Neck',     labelMr: 'मागील मान',   value: '4"'),
    ],
  ),
];

// ═════════════════════════════════════════════════════════════════════════════
//  SCREEN
// ═════════════════════════════════════════════════════════════════════════════

class EmployeeMyWorkScreen extends StatefulWidget {
  const EmployeeMyWorkScreen({super.key});

  @override
  State<EmployeeMyWorkScreen> createState() => _EmployeeMyWorkScreenState();
}

class _EmployeeMyWorkScreenState extends State<EmployeeMyWorkScreen> {
  // Filter: 0=All, 1=Pending, 2=Completed
  int _filterIndex = 0;

  // Track locally completed items (after "Mark Complete" in this session)
  final Set<String> _locallyCompleted = {};

  List<_WorkItem> get _filtered {
    return _allItems.where((item) {
      final effectiveStatus = _locallyCompleted.contains(item.id)
          ? WorkStatus.completed
          : item.status;
      if (_filterIndex == 1) return effectiveStatus == WorkStatus.pending;
      if (_filterIndex == 2) return effectiveStatus == WorkStatus.completed;
      return true;
    }).toList();
  }

  void _markComplete(String id) {
    setState(() {
      _locallyCompleted.add(id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Manager notified — work marked as complete! ✅',
                style: TextStyle(fontFamily: 'Poppins', fontSize: 13),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Gradient Header ──────────────────────────────────────────────
          _WorkHeader(
            filterIndex: _filterIndex,
            onFilterChanged: (i) => setState(() => _filterIndex = i),
          ),

          // ── Work Items List ──────────────────────────────────────────────
          Expanded(
            child: _filtered.isEmpty
                ? _EmptyState(filterIndex: _filterIndex)
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = _filtered[index];
                      final isCompleted = _locallyCompleted.contains(item.id)
                          || item.status == WorkStatus.completed;
                      return _WorkCard(
                        item: item,
                        isCompleted: isCompleted,
                        onMarkComplete: () =>
                            _showConfirmDialog(context, item.id, item.customer),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog(BuildContext ctx, String id, String customer) {
    showDialog(
      context: ctx,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.dialog)),
        icon: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.successLight,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.check_circle_outline_rounded,
              color: AppColors.success, size: 28),
        ),
        title: const Text(
          'Mark as Complete?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'This will notify the manager that work for $customer has been completed.',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: const BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    textStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: Size.zero,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    textStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(dialogCtx);
                    _markComplete(id);
                  },
                  child: const Text('Confirm'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
//  HEADER + FILTER CHIPS
// ═════════════════════════════════════════════════════════════════════════════

class _WorkHeader extends StatelessWidget {
  const _WorkHeader({
    required this.filterIndex,
    required this.onFilterChanged,
  });

  final int filterIndex;
  final ValueChanged<int> onFilterChanged;

  static const _filters = ['All', 'Pending', 'Completed'];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.topbarStart, AppColors.topbarEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title row
              Row(
                children: [
                  const Icon(Icons.assignment_rounded,
                      color: Colors.white, size: 22),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'My Work',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // Item count badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.20),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Sunita · ${_allItems.length} items',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Filter chips
              Row(
                children: List.generate(_filters.length, (i) {
                  final isActive = i == filterIndex;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => onFilterChanged(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 7),
                        decoration: BoxDecoration(
                          color: isActive
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: isActive
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.35),
                          ),
                        ),
                        child: Text(
                          _filters[i],
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: isActive
                                ? AppColors.primary
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
//  WORK CARD  (with AnimatedSize expansion for measurements)
// ═════════════════════════════════════════════════════════════════════════════

class _WorkCard extends StatefulWidget {
  const _WorkCard({
    required this.item,
    required this.isCompleted,
    required this.onMarkComplete,
  });

  final _WorkItem     item;
  final bool          isCompleted;
  final VoidCallback  onMarkComplete;

  @override
  State<_WorkCard> createState() => _WorkCardState();
}

class _WorkCardState extends State<_WorkCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final item        = widget.item;
    final isCompleted = widget.isCompleted;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppShadows.card,
        border: Border.all(
          color: item.isUrgent && !isCompleted
              ? AppColors.urgent.withValues(alpha: 0.40)
              : AppColors.border,
          width: item.isUrgent && !isCompleted ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Card Top accent strip ──────────────────────────────────────
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: isCompleted ? AppColors.success : item.accentColor,
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14)),
            ),
          ),

          // ── Card Content ───────────────────────────────────────────────
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1 — Thumbnail icon + customer + badges
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Design thumbnail
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: (isCompleted
                                  ? AppColors.success
                                  : item.accentColor)
                              .withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: (isCompleted
                                    ? AppColors.success
                                    : item.accentColor)
                                .withValues(alpha: 0.25),
                          ),
                        ),
                        child: Icon(
                          item.thumbnailIcon,
                          color: isCompleted ? AppColors.success : item.accentColor,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Customer + item label
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.customer,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.itemLabel,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12.5,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Badges column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Urgent badge
                          if (item.isUrgent && !isCompleted)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.urgent,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Text(
                                '🔥 URGENT',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          const SizedBox(height: 4),
                          // Status chip
                          _StatusChip(isCompleted: isCompleted),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  const Divider(
                      color: AppColors.border, height: 1, thickness: 1),
                  const SizedBox(height: 10),

                  // Row 2 — Delivery date + Assigned date
                  Row(
                    children: [
                      _InfoPill(
                        icon: Icons.calendar_today_rounded,
                        label: 'Delivery',
                        value: item.deliveryDate,
                        color: isCompleted ? AppColors.success : item.accentColor,
                      ),
                      const SizedBox(width: 10),
                      _InfoPill(
                        icon: Icons.assignment_ind_rounded,
                        label: 'Assigned',
                        value: item.assignedDate,
                        color: AppColors.textSecondary,
                      ),
                      if (isCompleted && item.completedDate != null) ...[
                        const SizedBox(width: 10),
                        _InfoPill(
                          icon: Icons.check_circle_rounded,
                          label: 'Done',
                          value: item.completedDate!,
                          color: AppColors.success,
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Tap to expand hint
                  Row(
                    children: [
                      const Icon(Icons.straighten_rounded,
                          size: 13, color: AppColors.textHint),
                      const SizedBox(width: 4),
                      Text(
                        _expanded
                            ? 'Hide measurements'
                            : 'Tap to view measurements',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: AppColors.textHint,
                        ),
                      ),
                      const Spacer(),
                      AnimatedRotation(
                        turns: _expanded ? 0.5 : 0.0,
                        duration: const Duration(milliseconds: 250),
                        child: const Icon(Icons.expand_more_rounded,
                            size: 18, color: AppColors.textHint),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Animated Measurements Expansion ───────────────────────────
          AnimatedSize(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOut,
            child: _expanded
                ? _MeasurementsPanel(
                    measurements: item.measurements,
                    itemType: item.itemType,
                    accentColor:
                        isCompleted ? AppColors.success : item.accentColor,
                  )
                : const SizedBox.shrink(),
          ),

          // ── Mark Complete Button (pending only) ────────────────────────
          if (!isCompleted) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    textStyle: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: widget.onMarkComplete,
                  icon: const Icon(Icons.check_circle_outline_rounded,
                      size: 18),
                  label: const Text('Mark as Complete'),
                ),
              ),
            ),
          ] else ...[
            // Completed indicator footer
            Container(
              margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.30)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_rounded,
                      color: AppColors.success, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    item.completedDate != null
                        ? 'Completed on ${item.completedDate}'
                        : 'Completed',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Status Chip
// ─────────────────────────────────────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.isCompleted});
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: isCompleted ? AppColors.successLight : AppColors.primaryLight,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        isCompleted ? 'Completed' : 'Pending',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isCompleted ? AppColors.success : AppColors.primary,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Info Pill
// ─────────────────────────────────────────────────────────────────────────────

class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String   label;
  final String   value;
  final Color    color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 11, color: color),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Measurements Panel
// ─────────────────────────────────────────────────────────────────────────────

class _MeasurementsPanel extends StatelessWidget {
  const _MeasurementsPanel({
    required this.measurements,
    required this.itemType,
    required this.accentColor,
  });

  final List<_Measurement> measurements;
  final ItemType           itemType;
  final Color              accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Icon(Icons.straighten_rounded,
                    size: 15, color: accentColor),
              ),
              const SizedBox(width: 8),
              Text(
                itemType == ItemType.blouse
                    ? 'Blouse Measurements'
                    : 'Dress Measurements',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 10),

          // Measurement rows — 2 columns
          ...List.generate(
            (measurements.length / 2).ceil(),
            (rowIndex) {
              final leftIndex  = rowIndex * 2;
              final rightIndex = leftIndex + 1;
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: _MeasurementRow(
                          m: measurements[leftIndex], accent: accentColor),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: rightIndex < measurements.length
                          ? _MeasurementRow(
                              m: measurements[rightIndex], accent: accentColor)
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MeasurementRow extends StatelessWidget {
  const _MeasurementRow({required this.m, required this.accent});
  final _Measurement m;
  final Color        accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // English label
          Text(
            m.labelEn,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 9.5,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          // Marathi label
          Text(
            m.labelMr,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 9,
              fontWeight: FontWeight.w400,
              color: accent.withValues(alpha: 0.70),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            m.value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Empty State
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.filterIndex});
  final int filterIndex;

  @override
  Widget build(BuildContext context) {
    final label = filterIndex == 1
        ? 'No pending work 🎉\nYou\'re all caught up!'
        : filterIndex == 2
            ? 'No completed items yet.\nStart working!'
            : 'No work items found.';

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.assignment_turned_in_rounded,
                color: AppColors.primary, size: 36),
          ),
          const SizedBox(height: 16),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
