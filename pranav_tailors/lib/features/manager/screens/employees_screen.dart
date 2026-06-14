// ════════════════════════════════════════════════════════════════════════════
//  employees_screen.dart
//  Pranav Ladies Tailors — Employee Management List (Manager)
//  Defines shared data models imported by detail & payment screens.
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pranav_tailors/core/theme/app_theme.dart';
import 'package:pranav_tailors/features/manager/screens/employee_detail_screen.dart';

// ════════════════════════════════════════════════════════════════════════════
//  Shared enums & models  (public — imported by child screens)
// ════════════════════════════════════════════════════════════════════════════

enum EmpWorkStatus { inProgress, completed }

class EmpWorkItem {
  const EmpWorkItem({
    required this.id,
    required this.customer,
    required this.itemType,
    required this.status,
    required this.assignedDate,
    required this.deliveryDate,
    this.isUrgent = false,
    this.completionDate,
    required this.earning,
  });
  final int           id;
  final String        customer;
  final String        itemType;
  final EmpWorkStatus status;
  final DateTime      assignedDate;
  final DateTime      deliveryDate;
  final bool          isUrgent;
  final DateTime?     completionDate;
  final double        earning;
}

class EmpPayment {
  EmpPayment({
    required this.id,
    required this.date,
    required this.amount,
    required this.givenBy,
    this.note,
  });
  final int     id;
  DateTime      date;
  double        amount;
  final String  givenBy;
  final String? note;
}

// Work-type constants
const List<String> kWorkTypes = [
  'Blouse Simple',
  'Blouse Designer',
  'Blouse Embroidery',
  'Salwar Simple',
  'Salwar Designer',
  'Full Dress Simple',
  'Full Dress Designer',
  'Lehenga',
  'Other',
];

class Employee {
  Employee({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    required this.initials,
    required this.color,
    required this.ratesPerWorkType,
    required this.workHistory,
    required this.payments,
  });
  final int                    id;
  final String                 name;
  final String                 phone;
  final String                 role;
  final String                 initials;
  final Color                  color;
  /// key = work-type label (e.g. 'Blouse Simple'), value = rate in ₹
  final Map<String, double>    ratesPerWorkType;
  final List<EmpWorkItem>      workHistory;
  final List<EmpPayment>       payments;

  double get totalEarned => workHistory
      .where((w) => w.status == EmpWorkStatus.completed)
      .fold(0.0, (s, w) => s + w.earning);

  double get totalPaid  => payments.fold(0.0, (s, p) => s + p.amount);
  double get balance    => totalEarned - totalPaid;
  bool   get isPaidUp   => balance <= 0;

  List<EmpWorkItem> get currentWork =>
      workHistory.where((w) => w.status == EmpWorkStatus.inProgress).toList();

  List<EmpWorkItem> get completedWork =>
      workHistory.where((w) => w.status == EmpWorkStatus.completed).toList();

  int get activeCount => currentWork.length;

  /// Default rate — first entry or 0
  double get defaultRate => ratesPerWorkType.values.isNotEmpty
      ? ratesPerWorkType.values.first
      : 0;

  /// Backward-compatible alias used by employee_payment_screen
  double get ratePerItem => defaultRate;
}

// ════════════════════════════════════════════════════════════════════════════
//  Dummy data
// ════════════════════════════════════════════════════════════════════════════

List<Employee> buildDummyEmployees() {
  const g = 'Manager';
  final now = DateTime.now();

  return [
    Employee(
      id: 1, name: 'Kaveri Shinde', phone: '9823001122',
      role: 'Tailor', initials: 'KS', color: const Color(0xFF26A69A),
      ratesPerWorkType: {
        'Blouse Simple': 80, 'Blouse Designer': 120, 'Blouse Embroidery': 150,
        'Salwar Simple': 100, 'Salwar Designer': 140, 'Full Dress Simple': 150,
        'Full Dress Designer': 200, 'Lehenga': 250, 'Other': 80,
      },
      workHistory: [
        EmpWorkItem(id: 101, customer: 'Priya Sharma',   itemType: 'Silk Blouse',    status: EmpWorkStatus.completed, assignedDate: DateTime(2026,6,2), deliveryDate: DateTime(2026,6,3), completionDate: DateTime(2026,6,3),  earning: 80),
        EmpWorkItem(id: 102, customer: 'Meena Patil',    itemType: 'Salwar Suit',    status: EmpWorkStatus.completed, assignedDate: DateTime(2026,6,4), deliveryDate: DateTime(2026,6,5), completionDate: DateTime(2026,6,5),  earning: 100),
        EmpWorkItem(id: 103, customer: 'Anita Kulkarni', itemType: 'Lehenga Blouse', status: EmpWorkStatus.completed, assignedDate: DateTime(2026,6,6), deliveryDate: DateTime(2026,6,7), completionDate: DateTime(2026,6,7),  earning: 250),
        EmpWorkItem(id: 104, customer: 'Lata Sawant',    itemType: 'Cotton Kurti',   status: EmpWorkStatus.completed, assignedDate: DateTime(2026,6,8), deliveryDate: DateTime(2026,6,9), completionDate: DateTime(2026,6,9),  earning: 80),
        EmpWorkItem(id: 105, customer: 'Nanda Shinde',   itemType: 'Wedding Blouse', status: EmpWorkStatus.completed, assignedDate: DateTime(2026,6,9), deliveryDate: DateTime(2026,6,10), completionDate: DateTime(2026,6,10), earning: 150),
        EmpWorkItem(id: 106, customer: 'Deepa Chavan',   itemType: 'Silk Blouse',    status: EmpWorkStatus.completed, assignedDate: DateTime(2026,6,10), deliveryDate: DateTime(2026,6,11), completionDate: DateTime(2026,6,11), earning: 80),
        EmpWorkItem(id: 107, customer: 'Pooja Nair',     itemType: 'Blouse + Pico',  status: EmpWorkStatus.inProgress, isUrgent: false, assignedDate: DateTime(2026,6,11), deliveryDate: now.add(const Duration(days: 3)), earning: 80),
        EmpWorkItem(id: 108, customer: 'Vandana More',   itemType: 'Saree Blouse',   status: EmpWorkStatus.inProgress, isUrgent: true,  assignedDate: DateTime(2026,6,11), deliveryDate: now.add(const Duration(days: 1)), earning: 80),
      ],
      payments: [
        EmpPayment(id: 1001, date: DateTime(2026,6,1),  amount: 300, givenBy: g),
        EmpPayment(id: 1002, date: DateTime(2026,6,8),  amount:  80, givenBy: g),
      ],
    ),

    Employee(
      id: 2, name: 'Sunanda More', phone: '9765443322',
      role: 'Tailor', initials: 'SM', color: const Color(0xFF5E35B1),
      ratesPerWorkType: {
        'Blouse Simple': 75, 'Blouse Designer': 110, 'Blouse Embroidery': 140,
        'Salwar Simple': 90, 'Salwar Designer': 130, 'Full Dress Simple': 140,
        'Full Dress Designer': 180, 'Lehenga': 220, 'Other': 75,
      },
      workHistory: [
        EmpWorkItem(id: 201, customer: 'Rekha Joshi',       itemType: 'Salwar Kameez',   status: EmpWorkStatus.completed, assignedDate: DateTime(2026,6,3), deliveryDate: DateTime(2026,6,4), completionDate: DateTime(2026,6,4),  earning: 90),
        EmpWorkItem(id: 202, customer: 'Sunita Desai',      itemType: 'Salwar Kameez',   status: EmpWorkStatus.completed, assignedDate: DateTime(2026,6,5), deliveryDate: DateTime(2026,6,6), completionDate: DateTime(2026,6,6),  earning: 90),
        EmpWorkItem(id: 203, customer: 'Rohini Kulkarni',   itemType: 'Lehenga Full Set',status: EmpWorkStatus.completed, assignedDate: DateTime(2026,6,7), deliveryDate: DateTime(2026,6,8), completionDate: DateTime(2026,6,8),  earning: 220),
        EmpWorkItem(id: 204, customer: 'Madhuri Deshpande', itemType: 'Dress + Fall',    status: EmpWorkStatus.completed, assignedDate: DateTime(2026,6,8), deliveryDate: DateTime(2026,6,9), completionDate: DateTime(2026,6,9),  earning: 140),
        EmpWorkItem(id: 205, customer: 'Sujata Mane',       itemType: 'Embroidered Blouse', status: EmpWorkStatus.completed, assignedDate: DateTime(2026,6,9), deliveryDate: DateTime(2026,6,10), completionDate: DateTime(2026,6,10), earning: 140),
        EmpWorkItem(id: 206, customer: 'Kavita Rane',       itemType: 'Kurti × 3',       status: EmpWorkStatus.inProgress, isUrgent: true,  assignedDate: DateTime(2026,6,11), deliveryDate: now.subtract(const Duration(days: 1)), earning: 75),
        EmpWorkItem(id: 207, customer: 'Alka Bhosale',      itemType: 'Silk Blouse',     status: EmpWorkStatus.inProgress, isUrgent: false, assignedDate: DateTime(2026,6,11), deliveryDate: now.add(const Duration(days: 5)), earning: 75),
      ],
      payments: [
        EmpPayment(id: 2001, date: DateTime(2026,5,28), amount: 200, givenBy: g),
        EmpPayment(id: 2002, date: DateTime(2026,6,6),  amount: 100, givenBy: g),
      ],
    ),

    Employee(
      id: 3, name: 'Rekha Jadhav', phone: '9900445566',
      role: 'Helper', initials: 'RJ', color: const Color(0xFFE65100),
      ratesPerWorkType: {
        'Blouse Simple': 50, 'Blouse Designer': 50, 'Blouse Embroidery': 50,
        'Salwar Simple': 50, 'Salwar Designer': 50, 'Full Dress Simple': 50,
        'Full Dress Designer': 50, 'Lehenga': 50, 'Other': 50,
      },
      workHistory: [
        EmpWorkItem(id: 301, customer: 'Pooja Nair',     itemType: 'Fall & Pico',   status: EmpWorkStatus.completed, assignedDate: DateTime(2026,6,4), deliveryDate: DateTime(2026,6,5), completionDate: DateTime(2026,6,5),  earning: 50),
        EmpWorkItem(id: 302, customer: 'Suman Pawar',    itemType: 'Kurti Fall',    status: EmpWorkStatus.completed, assignedDate: DateTime(2026,6,6), deliveryDate: DateTime(2026,6,7), completionDate: DateTime(2026,6,7),  earning: 50),
        EmpWorkItem(id: 303, customer: 'Pushpa Gaikwad', itemType: 'Blouse Fall',   status: EmpWorkStatus.completed, assignedDate: DateTime(2026,6,8), deliveryDate: DateTime(2026,6,9), completionDate: DateTime(2026,6,9),  earning: 50),
        EmpWorkItem(id: 304, customer: 'Kalpana Jadhav', itemType: 'Pico Work',     status: EmpWorkStatus.completed, assignedDate: DateTime(2026,6,9), deliveryDate: DateTime(2026,6,10), completionDate: DateTime(2026,6,10), earning: 50),
        EmpWorkItem(id: 305, customer: 'Smita Deshmukh', itemType: 'Fall & Pico',   status: EmpWorkStatus.inProgress, isUrgent: false, assignedDate: DateTime(2026,6,11), deliveryDate: now.add(const Duration(days: 2)), earning: 50),
      ],
      payments: [
        EmpPayment(id: 3001, date: DateTime(2026,6,10), amount: 200, givenBy: g),
      ],
    ),

    Employee(
      id: 4, name: 'Priya Kulkarni', phone: '9811223344',
      role: 'Tailor', initials: 'PK', color: const Color(0xFF1565C0),
      ratesPerWorkType: {
        'Blouse Simple': 80, 'Blouse Designer': 120, 'Blouse Embroidery': 160,
        'Salwar Simple': 100, 'Salwar Designer': 145, 'Full Dress Simple': 155,
        'Full Dress Designer': 210, 'Lehenga': 260, 'Other': 80,
      },
      workHistory: [
        EmpWorkItem(id: 401, customer: 'Kavita Rane',       itemType: 'Silk Blouse',      status: EmpWorkStatus.completed, assignedDate: DateTime(2026,6,1), deliveryDate: DateTime(2026,6,2), completionDate: DateTime(2026,6,2),  earning: 80),
        EmpWorkItem(id: 402, customer: 'Sunita Desai',      itemType: 'Kurti',             status: EmpWorkStatus.completed, assignedDate: DateTime(2026,6,3), deliveryDate: DateTime(2026,6,4), completionDate: DateTime(2026,6,4),  earning: 80),
        EmpWorkItem(id: 403, customer: 'Usha Deshpande',    itemType: 'Salwar Suit',       status: EmpWorkStatus.completed, assignedDate: DateTime(2026,6,4), deliveryDate: DateTime(2026,6,5), completionDate: DateTime(2026,6,5),  earning: 100),
        EmpWorkItem(id: 404, customer: 'Meena Patil',       itemType: 'Cotton Blouse',     status: EmpWorkStatus.completed, assignedDate: DateTime(2026,6,6), deliveryDate: DateTime(2026,6,7), completionDate: DateTime(2026,6,7),  earning: 80),
        EmpWorkItem(id: 405, customer: 'Deepa Chavan',      itemType: 'Salwar Kameez',     status: EmpWorkStatus.completed, assignedDate: DateTime(2026,6,7), deliveryDate: DateTime(2026,6,8), completionDate: DateTime(2026,6,8),  earning: 100),
        EmpWorkItem(id: 406, customer: 'Nanda Shinde',      itemType: 'Embroidery Kurti',  status: EmpWorkStatus.completed, assignedDate: DateTime(2026,6,8), deliveryDate: DateTime(2026,6,9), completionDate: DateTime(2026,6,9),  earning: 160),
        EmpWorkItem(id: 407, customer: 'Rohini Kulkarni',   itemType: 'Silk Blouse',       status: EmpWorkStatus.completed, assignedDate: DateTime(2026,6,10), deliveryDate: DateTime(2026,6,11), completionDate: DateTime(2026,6,11), earning: 80),
        EmpWorkItem(id: 408, customer: 'Madhuri Deshpande', itemType: 'Salwar Kameez',     status: EmpWorkStatus.inProgress, isUrgent: false, assignedDate: DateTime(2026,6,11), deliveryDate: now.add(const Duration(days: 4)), earning: 100),
        EmpWorkItem(id: 409, customer: 'Pushpa Gaikwad',    itemType: 'Cotton Kurti × 3', status: EmpWorkStatus.inProgress, isUrgent: true,  assignedDate: DateTime(2026,6,11), deliveryDate: now.add(const Duration(days: 2)), earning: 80),
      ],
      payments: [
        EmpPayment(id: 4001, date: DateTime(2026,5,20), amount: 400, givenBy: g),
        EmpPayment(id: 4002, date: DateTime(2026,6,5),  amount: 200, givenBy: g),
      ],
    ),

    Employee(
      id: 5, name: 'Anita Kale', phone: '9988776655',
      role: 'Trainee', initials: 'AK', color: const Color(0xFF6D4C41),
      ratesPerWorkType: {
        'Blouse Simple': 40, 'Blouse Designer': 40, 'Blouse Embroidery': 40,
        'Salwar Simple': 40, 'Salwar Designer': 40, 'Full Dress Simple': 40,
        'Full Dress Designer': 40, 'Lehenga': 40, 'Other': 40,
      },
      workHistory: [
        EmpWorkItem(id: 501, customer: 'Lata Sawant',    itemType: 'Hem & Tuck Work', status: EmpWorkStatus.completed, assignedDate: DateTime(2026,6,6), deliveryDate: DateTime(2026,6,7), completionDate: DateTime(2026,6,7),  earning: 40),
        EmpWorkItem(id: 502, customer: 'Vandana More',   itemType: 'Pico Work',       status: EmpWorkStatus.completed, assignedDate: DateTime(2026,6,9), deliveryDate: DateTime(2026,6,10), completionDate: DateTime(2026,6,10), earning: 40),
        EmpWorkItem(id: 503, customer: 'Smita Deshmukh', itemType: 'Button & Hook',   status: EmpWorkStatus.inProgress, isUrgent: false, assignedDate: DateTime(2026,6,11), deliveryDate: now.add(const Duration(days: 6)), earning: 40),
      ],
      payments: [
        EmpPayment(id: 5001, date: DateTime(2026,6,9), amount: 50, givenBy: g),
      ],
    ),
  ];
}

// ════════════════════════════════════════════════════════════════════════════
//  Screen
// ════════════════════════════════════════════════════════════════════════════

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});
  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  late final List<Employee> _employees;

  @override
  void initState() {
    super.initState();
    _employees = buildDummyEmployees();
  }

  void _openDetail(Employee emp) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EmployeeDetailScreen(employee: emp)),
    );
  }

  void _showAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddEmployeeSheet(
        onAdd: (emp) => setState(() => _employees.add(emp)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [AppColors.topbarStart, AppColors.topbarEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
          ),
        ),
        title: Text('Employees',
            style: TextStyle(fontFamily: 'Poppins', 
                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12, top: 12, bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.20),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('${_employees.length} staff',
                style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 12, fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: _employees.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) => _EmployeeCard(
          emp: _employees[i],
          onTap: () => _openDetail(_employees[i]),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddSheet,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_rounded),
        label: Text('Add Employee',
            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  Employee card
// ════════════════════════════════════════════════════════════════════════════

class _EmployeeCard extends StatelessWidget {
  const _EmployeeCard({required this.emp, required this.onTap});
  final Employee     emp;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: emp.color.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            // Colour stripe
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: emp.color,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              child: Row(
                children: [
                  // ── Avatar ───────────────────────────────────────────────
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: emp.color.withValues(alpha: 0.14),
                    child: Text(emp.initials,
                        style: TextStyle(fontFamily: 'Poppins', 
                            fontSize: 17, fontWeight: FontWeight.w800,
                            color: emp.color)),
                  ),
                  const SizedBox(width: 14),
                  // ── Info ─────────────────────────────────────────────────
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(emp.name,
                            style: TextStyle(fontFamily: 'Poppins', 
                                fontSize: 15, fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: emp.color.withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(emp.role,
                                  style: TextStyle(fontFamily: 'Poppins', 
                                      fontSize: 10.5, fontWeight: FontWeight.w600,
                                      color: emp.color)),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.phone_rounded,
                                size: 12, color: AppColors.textHint),
                            const SizedBox(width: 3),
                            Text(emp.phone,
                                style: TextStyle(fontFamily: 'Poppins', 
                                    fontSize: 12, color: AppColors.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // ── Active badge ──────────────────────────────────────────
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (emp.activeCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1565C0).withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: const Color(0xFF1565C0).withValues(alpha: 0.30)),
                          ),
                          child: Text('${emp.activeCount} active',
                              style: TextStyle(fontFamily: 'Poppins', 
                                  fontSize: 11, fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1565C0))),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.successLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text('Free',
                              style: TextStyle(fontFamily: 'Poppins', 
                                  fontSize: 11, fontWeight: FontWeight.w600,
                                  color: AppColors.success)),
                        ),
                      const SizedBox(height: 6),
                      Icon(Icons.chevron_right_rounded,
                          color: AppColors.textHint, size: 20),
                    ],
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

// ════════════════════════════════════════════════════════════════════════════
//  Add Employee bottom sheet
// ════════════════════════════════════════════════════════════════════════════

class _AddEmployeeSheet extends StatefulWidget {
  const _AddEmployeeSheet({required this.onAdd});
  final ValueChanged<Employee> onAdd;

  @override
  State<_AddEmployeeSheet> createState() => _AddEmployeeSheetState();
}

class _AddEmployeeSheetState extends State<_AddEmployeeSheet> {
  final _formKey   = GlobalKey<FormState>();
  final _nameCtrl  = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _roleCtrl  = TextEditingController();

  // One TextEditingController per work type
  late final Map<String, TextEditingController> _rateCtrl;

  static const _avatarColors = [
    Color(0xFF26A69A), Color(0xFF5E35B1), Color(0xFFE65100),
    Color(0xFF1565C0), Color(0xFF6D4C41), Color(0xFFC2185B),
  ];
  int _colorIdx = 0;

  @override
  void initState() {
    super.initState();
    _rateCtrl = {for (final t in kWorkTypes) t: TextEditingController()};
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _roleCtrl.dispose();
    for (final c in _rateCtrl.values) c.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final rates = <String, double>{};
    for (final entry in _rateCtrl.entries) {
      rates[entry.key] = double.tryParse(entry.value.text.trim()) ?? 0;
    }

    final initials = _nameCtrl.text.trim().split(' ')
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() : '')
        .take(2)
        .join();

    widget.onAdd(Employee(
      id: DateTime.now().millisecondsSinceEpoch,
      name:  _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      role:  _roleCtrl.text.trim().isEmpty ? 'Tailor' : _roleCtrl.text.trim(),
      initials: initials,
      color: _avatarColors[_colorIdx % _avatarColors.length],
      ratesPerWorkType: rates,
      workHistory: [],
      payments: [],
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 8, 20, 20 + bottom),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(top: 8, bottom: 16),
                decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(4)),
              ),
            ),
            // Title
            Text('Add Employee',
                style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 18, fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 20),

            // ── Basic info ────────────────────────────────────────────────
            _InputField(ctrl: _nameCtrl, label: 'Full Name', hint: 'e.g. Kaveri Shinde',
                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
            const SizedBox(height: 12),
            _InputField(ctrl: _phoneCtrl, label: 'Phone Number', hint: '10-digit number',
                keyboard: TextInputType.phone,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (v.trim().length < 10) return 'Enter valid phone';
                  return null;
                }),
            const SizedBox(height: 12),
            _InputField(ctrl: _roleCtrl, label: 'Role / Designation',
                hint: 'Tailor, Helper, Trainee…'),
            const SizedBox(height: 20),

            // ── Avatar colour picker ───────────────────────────────────────
            Text('Avatar Colour',
                style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 13, fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary)),
            const SizedBox(height: 10),
            Row(
              children: List.generate(_avatarColors.length, (i) {
                final selected = _colorIdx == i;
                return GestureDetector(
                  onTap: () => setState(() => _colorIdx = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 34, height: 34,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: _avatarColors[i],
                      shape: BoxShape.circle,
                      border: selected
                          ? Border.all(color: AppColors.textPrimary, width: 2.5)
                          : null,
                      boxShadow: selected ? [BoxShadow(
                          color: _avatarColors[i].withValues(alpha: 0.50),
                          blurRadius: 6)] : null,
                    ),
                    child: selected
                        ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
                        : null,
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),

            // ── Rate per work type ─────────────────────────────────────────
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withValues(alpha: 0.50),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.currency_rupee_rounded,
                      size: 16, color: AppColors.primary),
                ),
                const SizedBox(width: 10),
                Text('Rate Per Work Type',
                    style: TextStyle(fontFamily: 'Poppins', 
                        fontSize: 14, fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
              ],
            ),
            const SizedBox(height: 4),
            Text('Set the rate (₹) you pay per item for each work type.',
                style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 12, color: AppColors.textHint)),
            const SizedBox(height: 14),

            ...kWorkTypes.map((type) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(type,
                        style: TextStyle(fontFamily: 'Poppins', 
                            fontSize: 13, fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _rateCtrl[type],
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 13),
                      decoration: InputDecoration(
                        prefixText: '₹ ',
                        prefixStyle: TextStyle(fontFamily: 'Poppins', 
                            fontSize: 13, color: AppColors.textSecondary),
                        hintText: '0',
                        hintStyle: TextStyle(fontFamily: 'Poppins', 
                            fontSize: 13, color: AppColors.textHint),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: AppColors.primary, width: 1.5),
                        ),
                        filled: true,
                        fillColor: AppColors.surface,
                      ),
                    ),
                  ),
                ],
              ),
            )),

            const SizedBox(height: 24),

            // ── Save button ───────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 52,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [AppColors.topbarStart, AppColors.topbarEnd]),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.person_add_rounded,
                      color: Colors.white, size: 18),
                  label: Text('Save Employee',
                      style: TextStyle(fontFamily: 'Poppins', 
                          fontSize: 15, fontWeight: FontWeight.w700,
                          color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared input field ────────────────────────────────────────────────────────
class _InputField extends StatelessWidget {
  const _InputField({
    required this.ctrl,
    required this.label,
    this.hint = '',
    this.keyboard = TextInputType.text,
    this.validator,
  });
  final TextEditingController ctrl;
  final String label;
  final String hint;
  final TextInputType keyboard;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboard,
      style: TextStyle(fontFamily: 'Poppins', fontSize: 14),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.textSecondary),
        hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 13, color: AppColors.textHint),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.8)),
        filled: true,
        fillColor: AppColors.surface,
      ),
    );
  }
}
