// ════════════════════════════════════════════════════════════════════════════
//  customers_screen.dart
//  Pranav Ladies Tailors — Customer List (Manager)
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:pranav_tailors/core/theme/app_theme.dart';
import 'package:pranav_tailors/features/manager/screens/customer_detail_screen.dart';

// ── Dummy data ────────────────────────────────────────────────────────────────

const _kCustomers = [
  CustomerData(name: 'Priya Sharma',   phone: '9876543210', age: 34, address: '12, Shivaji Nagar, Pune', lastOrderDate: '08 Jun 2026', totalOrders: 12, initials: 'PS'),
  CustomerData(name: 'Meena Patil',    phone: '9823456701', age: 28, address: '3, MG Road, Nashik',      lastOrderDate: '05 Jun 2026', totalOrders: 7,  initials: 'MP'),
  CustomerData(name: 'Rekha Joshi',    phone: '9765432109', age: 42, address: '78, FC Road, Pune',       lastOrderDate: '01 Jun 2026', totalOrders: 21, initials: 'RJ'),
  CustomerData(name: 'Sunita Desai',   phone: '9812345670', age: 38, address: '45, Camp, Pune',          lastOrderDate: '28 May 2026', totalOrders: 5,  initials: 'SD'),
  CustomerData(name: 'Kavita Rane',    phone: '9900112233', age: 25, address: '7, Kothrud, Pune',        lastOrderDate: '22 May 2026', totalOrders: 3,  initials: 'KR'),
  CustomerData(name: 'Anita Kulkarni', phone: '9871234560', age: 47, address: '22, Hadapsar, Pune',      lastOrderDate: '18 May 2026', totalOrders: 15, initials: 'AK'),
  CustomerData(name: 'Pooja Nair',     phone: '9654321098', age: 31, address: '90, Aundh, Pune',         lastOrderDate: '12 May 2026', totalOrders: 9,  initials: 'PN'),
  CustomerData(name: 'Lata Sawant',    phone: '9789012345', age: 55, address: '5, Karve Road, Pune',     lastOrderDate: '04 May 2026', totalOrders: 30, initials: 'LS'),
  CustomerData(name: 'Deepa Chavan',   phone: '9512345678', age: 22, address: '33, Sinhagad Rd, Pune',  lastOrderDate: '29 Apr 2026', totalOrders: 2,  initials: 'DC'),
  CustomerData(name: 'Usha Deshpande', phone: '9933445566', age: 61, address: '18, Parvati, Pune',       lastOrderDate: '20 Apr 2026', totalOrders: 18, initials: 'UD'),
];

// ── Screen ────────────────────────────────────────────────────────────────────

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final _searchCtrl = TextEditingController();
  List<CustomerData> _filtered = _kCustomers;

  @override
  void initState() {
    super.initState();
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
          ? _kCustomers
          : _kCustomers.where((c) {
              return c.name.toLowerCase().contains(q) ||
                  c.phone.contains(q);
            }).toList();
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
                            '${_kCustomers.length} total',
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
                  onTap: () => context.push(
                    '/manager/customers/customer-detail',
                    extra: _filtered[i],
                  ),
                  child: _CustomerCard(customer: _filtered[i]),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/manager/customers/customer-form', extra: false),
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
    final idx = _kCustomers.indexOf(customer) % _kAvatarColors.length;
    final avatarColor = _kAvatarColors[idx];

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
                        '${customer.age} yrs',
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
