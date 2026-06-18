// ════════════════════════════════════════════════════════════════════════════
//  customers_screen.dart
//  Pranav Ladies Tailors — Customer List (Manager)
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:pranav_tailors/core/theme/app_theme.dart';
import 'package:pranav_tailors/features/manager/screens/customer_detail_screen.dart';

// ── Dummy data ────────────────────────────────────────────────────────────────
// Blouse measurement keys match _kBlouseFields in customer_detail_screen.dart.
// Dress upper keys are prefixed 'upper_', lower keys 'lower_', dupatta = 'yes'/'no'.

final _kCustomers = <CustomerData>[
  CustomerData(
    name: 'Priya Sharma', phone: '9876543210', age: 34,
    address: '12, Shivaji Nagar, Pune', lastOrderDate: '08 Jun 2026',
    totalOrders: 12, initials: 'PS',
    blouseMeasurements: const {
      'Back Length': '15', 'Full Shoulder': '13.5', 'Shoulder Strap': '4.5',
      'Back Neck Depth': '6', 'Front Neck Depth': '7', 'Shoulder to Apex': '9',
      'Front Length': '14', 'Chest Around': '36', 'Waist Around': '30',
      'Sleeve Length': '7', 'Arm Round': '12', 'Sleeve Round': '9',
      'Arm Hole': '15',
    },
    dressMeasurements: const {
      'upper_Back Length': '15', 'upper_Full Shoulder': '13.5',
      'upper_Shoulder Strap': '4.5', 'upper_Back Neck Depth': '6',
      'upper_Front Neck Depth': '7', 'upper_Shoulder to Apex': '9',
      'upper_Front Length': '14', 'upper_Chest Around': '36',
      'upper_Waist Around': '30', 'upper_Sleeve Length': '7',
      'upper_Arm Round': '12', 'upper_Sleeve Round': '9',
      'upper_Arm Hole': '15', 'upper_Seat': '38',
      'lower_Height': '40', 'lower_Waist': '30',
      'lower_Seat': '38', 'lower_Bottom': '44',
      'dupatta': 'yes',
    },
  ),
  CustomerData(
    name: 'Meena Patil', phone: '9823456701', age: 28,
    address: '3, MG Road, Nashik', lastOrderDate: '05 Jun 2026',
    totalOrders: 7, initials: 'MP',
    blouseMeasurements: const {
      'Back Length': '14.5', 'Full Shoulder': '13', 'Shoulder Strap': '4',
      'Back Neck Depth': '5.5', 'Front Neck Depth': '6.5', 'Shoulder to Apex': '8.5',
      'Front Length': '13.5', 'Chest Around': '34', 'Waist Around': '28',
      'Sleeve Length': '6.5', 'Arm Round': '11.5', 'Sleeve Round': '8.5',
      'Arm Hole': '14',
    },
    dressMeasurements: const {
      'upper_Back Length': '14.5', 'upper_Full Shoulder': '13',
      'upper_Shoulder Strap': '4', 'upper_Back Neck Depth': '5.5',
      'upper_Front Neck Depth': '6.5', 'upper_Shoulder to Apex': '8.5',
      'upper_Front Length': '13.5', 'upper_Chest Around': '34',
      'upper_Waist Around': '28', 'upper_Sleeve Length': '6.5',
      'upper_Arm Round': '11.5', 'upper_Sleeve Round': '8.5',
      'upper_Arm Hole': '14', 'upper_Seat': '36',
      'lower_Height': '38', 'lower_Waist': '28',
      'lower_Seat': '36', 'lower_Bottom': '42',
      'dupatta': 'no',
    },
  ),
  CustomerData(
    name: 'Rekha Joshi', phone: '9765432109', age: 42,
    address: '78, FC Road, Pune', lastOrderDate: '01 Jun 2026',
    totalOrders: 21, initials: 'RJ',
    blouseMeasurements: const {
      'Back Length': '15.5', 'Full Shoulder': '14', 'Shoulder Strap': '5',
      'Back Neck Depth': '6.5', 'Front Neck Depth': '7.5', 'Shoulder to Apex': '9.5',
      'Front Length': '15', 'Chest Around': '38', 'Waist Around': '32',
      'Sleeve Length': '7.5', 'Arm Round': '13', 'Sleeve Round': '10',
      'Arm Hole': '16',
    },
    dressMeasurements: const {
      'upper_Back Length': '15.5', 'upper_Full Shoulder': '14',
      'upper_Shoulder Strap': '5', 'upper_Back Neck Depth': '6.5',
      'upper_Front Neck Depth': '7.5', 'upper_Shoulder to Apex': '9.5',
      'upper_Front Length': '15', 'upper_Chest Around': '38',
      'upper_Waist Around': '32', 'upper_Sleeve Length': '7.5',
      'upper_Arm Round': '13', 'upper_Sleeve Round': '10',
      'upper_Arm Hole': '16', 'upper_Seat': '40',
      'lower_Height': '42', 'lower_Waist': '32',
      'lower_Seat': '40', 'lower_Bottom': '46',
      'dupatta': 'yes',
    },
  ),
  CustomerData(
    name: 'Sunita Desai', phone: '9812345670', age: 38,
    address: '45, Camp, Pune', lastOrderDate: '28 May 2026',
    totalOrders: 5, initials: 'SD',
    blouseMeasurements: const {
      'Back Length': '15', 'Full Shoulder': '13.5', 'Shoulder Strap': '4.5',
      'Back Neck Depth': '6', 'Front Neck Depth': '7', 'Shoulder to Apex': '9',
      'Front Length': '14.5', 'Chest Around': '37', 'Waist Around': '31',
      'Sleeve Length': '7', 'Arm Round': '12.5', 'Sleeve Round': '9.5',
      'Arm Hole': '15.5',
    },
    dressMeasurements: const {
      'upper_Back Length': '15', 'upper_Full Shoulder': '13.5',
      'upper_Shoulder Strap': '4.5', 'upper_Back Neck Depth': '6',
      'upper_Front Neck Depth': '7', 'upper_Shoulder to Apex': '9',
      'upper_Front Length': '14.5', 'upper_Chest Around': '37',
      'upper_Waist Around': '31', 'upper_Sleeve Length': '7',
      'upper_Arm Round': '12.5', 'upper_Sleeve Round': '9.5',
      'upper_Arm Hole': '15.5', 'upper_Seat': '39',
      'lower_Height': '40', 'lower_Waist': '31',
      'lower_Seat': '39', 'lower_Bottom': '44',
      'dupatta': 'no',
    },
  ),
  CustomerData(
    name: 'Kavita Rane', phone: '9900112233', age: 25,
    address: '7, Kothrud, Pune', lastOrderDate: '22 May 2026',
    totalOrders: 3, initials: 'KR',
    blouseMeasurements: const {
      'Back Length': '14', 'Full Shoulder': '12.5', 'Shoulder Strap': '4',
      'Back Neck Depth': '5', 'Front Neck Depth': '6', 'Shoulder to Apex': '8',
      'Front Length': '13', 'Chest Around': '33', 'Waist Around': '27',
      'Sleeve Length': '6', 'Arm Round': '11', 'Sleeve Round': '8',
      'Arm Hole': '13.5',
    },
    dressMeasurements: const {
      'upper_Back Length': '14', 'upper_Full Shoulder': '12.5',
      'upper_Shoulder Strap': '4', 'upper_Back Neck Depth': '5',
      'upper_Front Neck Depth': '6', 'upper_Shoulder to Apex': '8',
      'upper_Front Length': '13', 'upper_Chest Around': '33',
      'upper_Waist Around': '27', 'upper_Sleeve Length': '6',
      'upper_Arm Round': '11', 'upper_Sleeve Round': '8',
      'upper_Arm Hole': '13.5', 'upper_Seat': '35',
      'lower_Height': '38', 'lower_Waist': '27',
      'lower_Seat': '35', 'lower_Bottom': '40',
      'dupatta': 'yes',
    },
  ),
  CustomerData(
    name: 'Anita Kulkarni', phone: '9871234560', age: 47,
    address: '22, Hadapsar, Pune', lastOrderDate: '18 May 2026',
    totalOrders: 15, initials: 'AK',
    blouseMeasurements: const {
      'Back Length': '16', 'Full Shoulder': '14.5', 'Shoulder Strap': '5',
      'Back Neck Depth': '7', 'Front Neck Depth': '8', 'Shoulder to Apex': '10',
      'Front Length': '15.5', 'Chest Around': '40', 'Waist Around': '34',
      'Sleeve Length': '8', 'Arm Round': '14', 'Sleeve Round': '10.5',
      'Arm Hole': '16.5',
    },
    dressMeasurements: const {
      'upper_Back Length': '16', 'upper_Full Shoulder': '14.5',
      'upper_Shoulder Strap': '5', 'upper_Back Neck Depth': '7',
      'upper_Front Neck Depth': '8', 'upper_Shoulder to Apex': '10',
      'upper_Front Length': '15.5', 'upper_Chest Around': '40',
      'upper_Waist Around': '34', 'upper_Sleeve Length': '8',
      'upper_Arm Round': '14', 'upper_Sleeve Round': '10.5',
      'upper_Arm Hole': '16.5', 'upper_Seat': '42',
      'lower_Height': '41', 'lower_Waist': '34',
      'lower_Seat': '42', 'lower_Bottom': '48',
      'dupatta': 'yes',
    },
  ),
  CustomerData(
    name: 'Pooja Nair', phone: '9654321098', age: 31,
    address: '90, Aundh, Pune', lastOrderDate: '12 May 2026',
    totalOrders: 9, initials: 'PN',
    blouseMeasurements: const {
      'Back Length': '14.5', 'Full Shoulder': '13', 'Shoulder Strap': '4',
      'Back Neck Depth': '5.5', 'Front Neck Depth': '6.5', 'Shoulder to Apex': '8.5',
      'Front Length': '14', 'Chest Around': '35', 'Waist Around': '29',
      'Sleeve Length': '6.5', 'Arm Round': '12', 'Sleeve Round': '9',
      'Arm Hole': '14.5',
    },
    dressMeasurements: const {
      'upper_Back Length': '14.5', 'upper_Full Shoulder': '13',
      'upper_Shoulder Strap': '4', 'upper_Back Neck Depth': '5.5',
      'upper_Front Neck Depth': '6.5', 'upper_Shoulder to Apex': '8.5',
      'upper_Front Length': '14', 'upper_Chest Around': '35',
      'upper_Waist Around': '29', 'upper_Sleeve Length': '6.5',
      'upper_Arm Round': '12', 'upper_Sleeve Round': '9',
      'upper_Arm Hole': '14.5', 'upper_Seat': '37',
      'lower_Height': '39', 'lower_Waist': '29',
      'lower_Seat': '37', 'lower_Bottom': '43',
      'dupatta': 'no',
    },
  ),
  CustomerData(
    name: 'Lata Sawant', phone: '9789012345', age: 55,
    address: '5, Karve Road, Pune', lastOrderDate: '04 May 2026',
    totalOrders: 30, initials: 'LS',
    blouseMeasurements: const {
      'Back Length': '16.5', 'Full Shoulder': '15', 'Shoulder Strap': '5.5',
      'Back Neck Depth': '7', 'Front Neck Depth': '8', 'Shoulder to Apex': '10.5',
      'Front Length': '16', 'Chest Around': '42', 'Waist Around': '36',
      'Sleeve Length': '8', 'Arm Round': '14.5', 'Sleeve Round': '11',
      'Arm Hole': '17',
    },
    dressMeasurements: const {
      'upper_Back Length': '16.5', 'upper_Full Shoulder': '15',
      'upper_Shoulder Strap': '5.5', 'upper_Back Neck Depth': '7',
      'upper_Front Neck Depth': '8', 'upper_Shoulder to Apex': '10.5',
      'upper_Front Length': '16', 'upper_Chest Around': '42',
      'upper_Waist Around': '36', 'upper_Sleeve Length': '8',
      'upper_Arm Round': '14.5', 'upper_Sleeve Round': '11',
      'upper_Arm Hole': '17', 'upper_Seat': '44',
      'lower_Height': '40', 'lower_Waist': '36',
      'lower_Seat': '44', 'lower_Bottom': '50',
      'dupatta': 'yes',
    },
  ),
  CustomerData(
    name: 'Deepa Chavan', phone: '9512345678', age: 22,
    address: '33, Sinhagad Rd, Pune', lastOrderDate: '29 Apr 2026',
    totalOrders: 2, initials: 'DC',
    blouseMeasurements: const {
      'Back Length': '14', 'Full Shoulder': '12', 'Shoulder Strap': '3.5',
      'Back Neck Depth': '5', 'Front Neck Depth': '6', 'Shoulder to Apex': '8',
      'Front Length': '13', 'Chest Around': '32', 'Waist Around': '26',
      'Sleeve Length': '6', 'Arm Round': '10.5', 'Sleeve Round': '7.5',
      'Arm Hole': '13',
    },
    dressMeasurements: const {
      'upper_Back Length': '14', 'upper_Full Shoulder': '12',
      'upper_Shoulder Strap': '3.5', 'upper_Back Neck Depth': '5',
      'upper_Front Neck Depth': '6', 'upper_Shoulder to Apex': '8',
      'upper_Front Length': '13', 'upper_Chest Around': '32',
      'upper_Waist Around': '26', 'upper_Sleeve Length': '6',
      'upper_Arm Round': '10.5', 'upper_Sleeve Round': '7.5',
      'upper_Arm Hole': '13', 'upper_Seat': '34',
      'lower_Height': '37', 'lower_Waist': '26',
      'lower_Seat': '34', 'lower_Bottom': '40',
      'dupatta': 'no',
    },
  ),
  CustomerData(
    name: 'Usha Deshpande', phone: '9933445566', age: 61,
    address: '18, Parvati, Pune', lastOrderDate: '20 Apr 2026',
    totalOrders: 18, initials: 'UD',
    blouseMeasurements: const {
      'Back Length': '17', 'Full Shoulder': '15.5', 'Shoulder Strap': '6',
      'Back Neck Depth': '7.5', 'Front Neck Depth': '8.5', 'Shoulder to Apex': '11',
      'Front Length': '16.5', 'Chest Around': '44', 'Waist Around': '38',
      'Sleeve Length': '8.5', 'Arm Round': '15', 'Sleeve Round': '11.5',
      'Arm Hole': '17.5',
    },
    dressMeasurements: const {
      'upper_Back Length': '17', 'upper_Full Shoulder': '15.5',
      'upper_Shoulder Strap': '6', 'upper_Back Neck Depth': '7.5',
      'upper_Front Neck Depth': '8.5', 'upper_Shoulder to Apex': '11',
      'upper_Front Length': '16.5', 'upper_Chest Around': '44',
      'upper_Waist Around': '38', 'upper_Sleeve Length': '8.5',
      'upper_Arm Round': '15', 'upper_Sleeve Round': '11.5',
      'upper_Arm Hole': '17.5', 'upper_Seat': '46',
      'lower_Height': '41', 'lower_Waist': '38',
      'lower_Seat': '46', 'lower_Bottom': '52',
      'dupatta': 'yes',
    },
  ),
];

// ── Screen ────────────────────────────────────────────────────────────────────

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final _searchCtrl = TextEditingController();
  late List<CustomerData> _customers;
  List<CustomerData> _filtered = [];

  @override
  void initState() {
    super.initState();
    _customers = List<CustomerData>.from(_kCustomers);
    _filtered  = _customers;
    _searchCtrl.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearch() {
    final q = _searchCtrl.text.trim().toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? _customers
          : _customers.where((c) {
              return c.name.toLowerCase().contains(q) ||
                  c.phone.contains(q);
            }).toList();
    });
  }

  // Called after the detail screen edits a customer and pops back with updated data
  void _replaceCustomer(CustomerData updated) {
    setState(() {
      final idx = _customers.indexWhere((c) => c.phone == updated.phone);
      if (idx != -1) _customers[idx] = updated;
      _onSearch(); // re-apply search filter
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          // ── Gradient App Bar ─────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.primary,
            expandedHeight: 70,
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          'Customers',
                          style: TextStyle(fontFamily: 'Poppins',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.20),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${_customers.length} total',
                            style: TextStyle(fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Search bar ───────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
              child: TextField(
                controller: _searchCtrl,
                style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search by name or phone…',
                  hintStyle: TextStyle(fontFamily: 'Poppins',
                    fontSize: 13,
                    color: AppColors.textHint,
                  ),
                  prefixIcon: const Icon(Icons.search_rounded,
                      color: AppColors.textHint, size: 20),
                  suffixIcon: _searchCtrl.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close_rounded, size: 18),
                          color: AppColors.textHint,
                          onPressed: () {
                            _searchCtrl.clear();
                            FocusScope.of(context).unfocus();
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: AppColors.surface,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                ),
              ),
            ),
          ),
        ],
        body: _filtered.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search_off_rounded,
                        size: 56, color: AppColors.textHint),
                    const SizedBox(height: 12),
                    Text(
                      'No customers found',
                      style: TextStyle(fontFamily: 'Poppins',
                        fontSize: 15,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
                itemCount: _filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) => GestureDetector(
                  onTap: () async {
                    // push detail and wait for possible updated CustomerData back
                    final updated = await context.push<CustomerData>(
                      '/manager/customers/customer-detail',
                      extra: _filtered[i],
                    );
                    if (updated != null) _replaceCustomer(updated);
                  },
                  child: _CustomerCard(customer: _filtered[i]),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final newCustomer = await context.push<CustomerData>(
              '/manager/customers/customer-form', extra: null);
          if (newCustomer != null) {
            setState(() {
              _customers.insert(0, newCustomer);
              _filtered = _customers;
            });
          }
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.person_add_rounded),
        label: Text(
          'Add Customer',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

// ── Customer Card ─────────────────────────────────────────────────────────────

// Avatar color palette rotated per index
const _kAvatarColors = [
  Color(0xFFC2185B),
  Color(0xFF26A69A),
  Color(0xFF5E35B1),
  Color(0xFFE65100),
  Color(0xFF1565C0),
  Color(0xFF2E7D32),
  Color(0xFF6A1B9A),
  Color(0xFF00838F),
  Color(0xFF558B2F),
  Color(0xFFAD1457),
];

class _CustomerCard extends StatelessWidget {
  const _CustomerCard({required this.customer});
  final CustomerData customer;

  @override
  Widget build(BuildContext context) {
    final idx = _kCustomers.indexWhere((c) => c.phone == customer.phone) %
        _kAvatarColors.length;
    final avatarColor = _kAvatarColors[idx < 0 ? 0 : idx];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppShadows.subtle,
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: avatarColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(
                    color: avatarColor.withValues(alpha: 0.30), width: 1.5),
              ),
              child: Center(
                child: Text(
                  customer.initials,
                  style: TextStyle(fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: avatarColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customer.name,
                    style: TextStyle(fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.phone_rounded,
                          size: 12, color: AppColors.textHint),
                      const SizedBox(width: 4),
                      Text(
                        customer.phone,
                        style: TextStyle(fontFamily: 'Poppins',
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.cake_rounded,
                          size: 12, color: AppColors.textHint),
                      const SizedBox(width: 4),
                      Text(
                        '${customer.computedAge} yrs',
                        style: TextStyle(fontFamily: 'Poppins',
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _InfoChip(
                        icon: Icons.shopping_bag_rounded,
                        label: '${customer.totalOrders} orders',
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      _InfoChip(
                        icon: Icons.calendar_today_rounded,
                        label: customer.lastOrderDate,
                        color: const Color(0xFF26A69A),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Arrow
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textHint, size: 20),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontFamily: 'Poppins',
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
