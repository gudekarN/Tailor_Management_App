// ════════════════════════════════════════════════════════════════════════════
//  customer_detail_screen.dart
//  Pranav Ladies Tailors — Customer Detail / Measurement View (Manager)
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:pranav_tailors/core/theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════════════════
//  Public data model — shared with customers_screen.dart
// ════════════════════════════════════════════════════════════════════════════

class CustomerData {
  const CustomerData({
    required this.name,
    required this.phone,
    this.age = 0,            // legacy fallback; use computedAge for display
    required this.address,
    required this.initials,
    required this.totalOrders,
    required this.lastOrderDate,
    this.blouseMeasurements = const {},
    this.dressMeasurements  = const {},
    this.dateOfBirth,       // nullable; replaces the manual age field in the form
  });

  final String              name;
  final String              phone;
  /// Stored fallback age — kept for dummy / legacy data that has no [dateOfBirth].
  /// Prefer [computedAge] for all display purposes.
  final int                 age;
  final String              address;
  final String              initials;
  final int                 totalOrders;
  final String              lastOrderDate;
  /// key = English field label, value = measurement string (e.g. '36"')
  final Map<String, String> blouseMeasurements;
  final Map<String, String> dressMeasurements;
  /// Date of birth entered via the date-picker in the customer form.
  final DateTime?           dateOfBirth;

  /// Age in full years, calculated from [dateOfBirth] when available,
  /// otherwise falls back to the stored [age] field.
  int get computedAge {
    final dob = dateOfBirth;
    if (dob == null) return age;
    final today = DateTime.now();
    int years = today.year - dob.year;
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      years--;
    }
    return years < 0 ? 0 : years;
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  Measurement field definitions (mirrored from customer_form_screen)
// ════════════════════════════════════════════════════════════════════════════

class _MeasField {
  const _MeasField(this.english, this.marathi);
  final String english;
  final String marathi;
}

const _kBlouseFields = [
  _MeasField('Back Length',       'पाठीची लांबी'),
  _MeasField('Full Shoulder',     'खांद्याची रुंदी'),
  _MeasField('Shoulder Strap',    'खांदा पट्टी'),
  _MeasField('Back Neck Depth',   'मागील गळ्याची खोली'),
  _MeasField('Front Neck Depth',  'पुढील गळ्याची खोली'),
  _MeasField('Shoulder to Apex',  'खांद्यापासून छातीचा टोक'),
  _MeasField('Front Length',      'पुढील लांबी'),
  _MeasField('Chest Around',      'छातीचा घेर'),
  _MeasField('Waist Around',      'कमरेचा घेर'),
  _MeasField('Sleeve Length',     'बाहीची लांबी'),
  _MeasField('Arm Round',         'दंडाचा घेर'),
  _MeasField('Sleeve Round',      'मनगटाचा घेर'),
  _MeasField('Arm Hole',          'बगलेचा घेर'),
];

const _kDressUpperExtra = [
  _MeasField('Seat', 'नितंबाचा घेर'),
];

const _kDressLowerFields = [
  _MeasField('Height', 'उंची'),
  _MeasField('Waist',  'कमर'),
  _MeasField('Seat',   'नितंब'),
  _MeasField('Bottom', 'तळाचा घेर'),
];

// ════════════════════════════════════════════════════════════════════════════
//  Screen
// ════════════════════════════════════════════════════════════════════════════

class CustomerDetailScreen extends StatefulWidget {
  const CustomerDetailScreen({super.key, required this.customer});
  final CustomerData customer;

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  /// Mutable local copy — updated after each successful edit.
  late CustomerData _customer;

  @override
  void initState() {
    super.initState();
    _customer = widget.customer;
    _tab = TabController(length: 2, vsync: this)
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  CustomerData get _c => _customer;

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Pop back with the (possibly updated) customer data so the list refreshes
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.pop(_customer);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: NestedScrollView(
          headerSliverBuilder: (_, __) => [_buildAppBar(), _buildTabBar()],
          body: TabBarView(
            controller: _tab,
            children: [
              _BlouseMeasurementsTab(measurements: _c.blouseMeasurements),
              _DressMeasurementsTab(measurements: _c.dressMeasurements),
            ],
          ),
        ),
      ),
    );
  }

  // ── App Bar (gradient + profile card) ─────────────────────────────────────
  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 210,
      pinned: true,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      leading: BackButton(
        color: Colors.white,
        onPressed: () => context.pop(_customer),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_rounded, color: Colors.white),
          tooltip: 'Edit Customer',
          onPressed: () async {
            // Pass the full CustomerData as extra so the form pre-fills all fields
            final updated = await context.push<CustomerData>(
              '/manager/customers/customer-form',
              extra: _customer,
            );
            if (updated != null) {
              setState(() => _customer = updated);
            }
          },
        ),
      ],
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 36),
                // Avatar
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.20),
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.50), width: 2),
                  ),
                  child: Center(
                    child: Text(
                      _c.initials,
                      style: TextStyle(fontFamily: 'Poppins', 
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Name
                Text(
                  _c.name,
                  style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                // Info chips row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _WhiteChip(
                        icon: Icons.phone_rounded, label: _c.phone),
                    const SizedBox(width: 8),
                    _WhiteChip(
                        icon: Icons.cake_rounded,
                        label: '${_c.computedAge} yrs'),
                    const SizedBox(width: 8),
                    _WhiteChip(
                        icon: Icons.shopping_bag_rounded,
                        label: '${_c.totalOrders} orders'),
                  ],
                ),
                const SizedBox(height: 6),
                if (_c.address.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      _c.address,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontFamily: 'Poppins', 
                        fontSize: 11.5,
                        color: Colors.white.withValues(alpha: 0.80),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── TabBar pinned below app bar ────────────────────────────────────────────
  Widget _buildTabBar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _TabBarDelegate(
        Container(
          color: AppColors.primary,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TabBar(
              controller: _tab,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.white70,
              labelStyle: TextStyle(fontFamily: 'Poppins', 
                  fontSize: 12.5, fontWeight: FontWeight.w700),
              unselectedLabelStyle:
                  TextStyle(fontFamily: 'Poppins', fontSize: 12.5, fontWeight: FontWeight.w500),
              padding: const EdgeInsets.all(3),
              tabs: const [
                Tab(text: 'Blouse Measurements'),
                Tab(text: 'Dress Measurements'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  Blouse Measurements Tab
// ════════════════════════════════════════════════════════════════════════════

class _BlouseMeasurementsTab extends StatelessWidget {
  const _BlouseMeasurementsTab({required this.measurements});
  final Map<String, String> measurements;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        _SectionTitle(title: 'Blouse Measurements', icon: Icons.checkroom_rounded),
        const SizedBox(height: 12),
        ..._kBlouseFields.map(
          (f) => _MeasRow(
            field: f,
            value: measurements[f.english] ?? '—',
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  Dress Measurements Tab
// ════════════════════════════════════════════════════════════════════════════

class _DressMeasurementsTab extends StatelessWidget {
  const _DressMeasurementsTab({required this.measurements});
  final Map<String, String> measurements;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        // ── Upper ──────────────────────────────────────────────────────────
        _SectionTitle(title: 'Upper (Blouse Section)', icon: Icons.checkroom_rounded),
        const SizedBox(height: 12),
        ...[..._kBlouseFields, ..._kDressUpperExtra].map(
          (f) => _MeasRow(
            field: f,
            value: measurements['upper_${f.english}'] ?? '—',
          ),
        ),
        const SizedBox(height: 20),

        // ── Lower ──────────────────────────────────────────────────────────
        _SectionTitle(title: 'Lower (Skirt / Pant)', icon: Icons.straighten_rounded),
        const SizedBox(height: 12),
        ..._kDressLowerFields.map(
          (f) => _MeasRow(
            field: f,
            value: measurements['lower_${f.english}'] ?? '—',
          ),
        ),
        const SizedBox(height: 12),

        // ── Dupatta ────────────────────────────────────────────────────────
        _DupattaRow(hasDupatta: measurements['dupatta'] == 'yes'),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  Shared row widgets
// ════════════════════════════════════════════════════════════════════════════

class _MeasRow extends StatelessWidget {
  const _MeasRow({required this.field, required this.value});
  final _MeasField field;
  final String     value;

  @override
  Widget build(BuildContext context) {
    final hasValue = value != '—';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Labels
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  field.english,
                  style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  field.marathi,
                  style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 11,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
          // Value chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: hasValue
                  ? AppColors.primaryLight.withValues(alpha: 0.50)
                  : AppColors.surface2,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: hasValue
                    ? AppColors.primary.withValues(alpha: 0.30)
                    : AppColors.border,
              ),
            ),
            child: Text(
              value,
              style: TextStyle(fontFamily: 'Poppins', 
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: hasValue ? AppColors.primary : AppColors.textHint,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DupattaRow extends StatelessWidget {
  const _DupattaRow({required this.hasDupatta});
  final bool hasDupatta;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dupatta',
                    style: TextStyle(fontFamily: 'Poppins', 
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                Text('दुपट्टा',
                    style: TextStyle(fontFamily: 'Poppins', 
                        fontSize: 11, color: AppColors.textHint)),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: hasDupatta
                  ? AppColors.success.withValues(alpha: 0.12)
                  : AppColors.surface2,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: hasDupatta
                    ? AppColors.success.withValues(alpha: 0.40)
                    : AppColors.border,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  hasDupatta
                      ? Icons.check_circle_rounded
                      : Icons.cancel_rounded,
                  size: 14,
                  color: hasDupatta ? AppColors.success : AppColors.textHint,
                ),
                const SizedBox(width: 5),
                Text(
                  hasDupatta ? 'Yes' : 'No',
                  style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: hasDupatta ? AppColors.success : AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.icon});
  final String   title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.50),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, size: 16, color: AppColors.primary),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(fontFamily: 'Poppins', 
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _WhiteChip extends StatelessWidget {
  const _WhiteChip({required this.icon, required this.label});
  final IconData icon;
  final String   label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontFamily: 'Poppins', 
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  SliverPersistentHeaderDelegate for the sticky TabBar
// ════════════════════════════════════════════════════════════════════════════

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  const _TabBarDelegate(this.child);
  final Widget child;

  @override
  double get minExtent => 52;
  @override
  double get maxExtent => 52;

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      child;

  @override
  bool shouldRebuild(_TabBarDelegate old) => old.child != child;
}
