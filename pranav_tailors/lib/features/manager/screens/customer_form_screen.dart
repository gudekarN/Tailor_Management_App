// ════════════════════════════════════════════════════════════════════════════
//  customer_form_screen.dart
//  Pranav Ladies Tailors — Add / Edit Customer with Measurement Tabs
// ════════════════════════════════════════════════════════════════════════════

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:intl/intl.dart';

import 'package:pranav_tailors/core/theme/app_theme.dart';
import 'package:pranav_tailors/features/manager/screens/customer_detail_screen.dart';

// ════════════════════════════════════════════════════════════════════════════
//  Measurement field definitions
// ════════════════════════════════════════════════════════════════════════════

class _MeasField {
  const _MeasField(this.english, this.marathi);
  final String english;
  final String marathi;
}

/// The 13 shared blouse / dress-upper fields
const _kBlouseFields = [
  _MeasField('Back Length',      'पाठीची लांबी'),
  _MeasField('Full Shoulder',    'खांद्याची रुंदी'),
  _MeasField('Shoulder Strap',   'खांदा पट्टी'),
  _MeasField('Back Neck Depth',  'मागील गळ्याची खोली'),
  _MeasField('Front Neck Depth', 'पुढील गळ्याची खोली'),
  _MeasField('Shoulder to Apex', 'खांद्यापासून छातीचा टोक'),
  _MeasField('Front Length',     'पुढील लांबी'),
  _MeasField('Chest Around',     'छातीचा घेर'),
  _MeasField('Waist Around',     'कमरेचा घेर'),
  _MeasField('Sleeve Length',    'बाहीची लांबी'),
  _MeasField('Arm Round',        'दंडाचा घेर'),
  _MeasField('Sleeve Round',     'मनगटाचा घेर'),
  _MeasField('Arm Hole',         'बगलेचा घेर'),
];

/// Dress Upper = blouse 13 + Seat (14 total)
const _kDressUpperExtra = [
  _MeasField('Seat', 'नितंबाचा घेर'),
];

/// Dress Lower fields (4)
const _kDressLowerFields = [
  _MeasField('Height', 'उंची'),
  _MeasField('Waist',  'कमर'),
  _MeasField('Seat',   'नितंब'),
  _MeasField('Bottom', 'तळाचा घेर'),
];

// ── Tab heights (fixed, avoids Expanded inside ScrollView) ─────────────────
// Heights adjusted to better fit the dynamic content
const _kTabHeights = [820.0, 1250.0];

// ════════════════════════════════════════════════════════════════════════════
//  Screen
// ════════════════════════════════════════════════════════════════════════════

class CustomerFormScreen extends StatefulWidget {
  /// Pass [existingCustomer] to open the form in edit-mode pre-filled with
  /// that customer's data. Leave null to open in add-mode.
  const CustomerFormScreen({super.key, this.existingCustomer});
  final CustomerData? existingCustomer;

  /// True when editing an existing customer, false when adding a new one.
  bool get isEditing => existingCustomer != null;

  @override
  State<CustomerFormScreen> createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends State<CustomerFormScreen>
    with SingleTickerProviderStateMixin {
  // ── Tab controller ─────────────────────────────────────────────────────
  late final TabController _tabCtrl;
  int _activeTab = 0;

  // ── Customer photo ──────────────────────────────────────────────────────
  File? _customerPhoto;
  final _picker = ImagePicker();

  // ── Personal info ───────────────────────────────────────────────────────
  final _formKey     = GlobalKey<FormState>();
  final _nameCtrl    = TextEditingController();
  final _phoneCtrl   = TextEditingController();
  final _addressCtrl = TextEditingController();

  // ── Date of Birth (replaces the plain age text field) ───────────────────
  DateTime? _selectedDob;

  /// Returns the age in full years from [_selectedDob], or -1 when not set.
  int get _computedAge {
    final dob = _selectedDob;
    if (dob == null) return -1;
    final today = DateTime.now();
    int years = today.year - dob.year;
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) years--;
    return years < 0 ? 0 : years;
  }

  // ── Measurement controllers ─────────────────────────────────────────────
  late final List<TextEditingController> _blouseCtrls;
  late final List<TextEditingController> _dressUpperCtrls;
  late final List<TextEditingController> _dressLowerCtrls;

  // ── Dupatta ─────────────────────────────────────────────────────────────
  bool _dupatta = false;

  // ── Tab listener ────────────────────────────────────────────────────────
  void _onTabChange() {
    if (_tabCtrl.indexIsChanging || _tabCtrl.index != _activeTab) {
      setState(() => _activeTab = _tabCtrl.index);
    }
  }

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _tabCtrl.addListener(_onTabChange);

    _blouseCtrls = List.generate(
        _kBlouseFields.length, (_) => TextEditingController());
    _dressUpperCtrls = List.generate(
        _kBlouseFields.length + _kDressUpperExtra.length,
        (_) => TextEditingController());
    _dressLowerCtrls = List.generate(
        _kDressLowerFields.length, (_) => TextEditingController());

    // ── Pre-fill when editing ───────────────────────────────────────────────
    final e = widget.existingCustomer;
    if (e != null) {
      _nameCtrl.text    = e.name;
      _phoneCtrl.text   = e.phone;
      _addressCtrl.text = e.address;
      _selectedDob      = e.dateOfBirth; // restore date-of-birth if present

      // Blouse fields
      for (int i = 0; i < _kBlouseFields.length; i++) {
        _blouseCtrls[i].text =
            e.blouseMeasurements[_kBlouseFields[i].english] ?? '';
      }

      // Dress upper = blouseFields + extra
      final allUpper = [..._kBlouseFields, ..._kDressUpperExtra];
      for (int i = 0; i < allUpper.length; i++) {
        _dressUpperCtrls[i].text =
            e.dressMeasurements['upper_${allUpper[i].english}'] ?? '';
      }

      // Dress lower
      for (int i = 0; i < _kDressLowerFields.length; i++) {
        _dressLowerCtrls[i].text =
            e.dressMeasurements['lower_${_kDressLowerFields[i].english}'] ?? '';
      }

      // Dupatta
      _dupatta = e.dressMeasurements['dupatta'] == 'yes';
    }
  }

  @override
  void dispose() {
    _tabCtrl.removeListener(_onTabChange);
    _tabCtrl.dispose();
    for (final c in [
      _nameCtrl, _phoneCtrl, _addressCtrl,
      ..._blouseCtrls, ..._dressUpperCtrls, ..._dressLowerCtrls,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  // ── Date of Birth picker ─────────────────────────────────────────────────

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final initial = _selectedDob ??
        DateTime(now.year - 25, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1940),
      lastDate: now,
      helpText: 'Select Date of Birth',
      builder: (context, child) {
        // Tint date-picker to the Blush Rose primary colour.
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedDob = picked);
  }

  // ── Photo helpers ────────────────────────────────────────────────────────

  Future<void> _pickPhoto(ImageSource source) async {
    Navigator.of(context).pop();
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 600,
        maxHeight: 600,
      );
      if (file != null) setState(() => _customerPhoto = File(file.path));
    } catch (_) {
      // silently handle permission denial / unavailable camera
    }
  }

  void _showPhotoSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // handle bar
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 6),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 4),
              child: Text(
                'Customer Photo',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 4),
            _SheetOption(
              icon: Icons.camera_alt_rounded,
              title: 'Take Photo',
              subtitle: 'Open camera to capture',
              onTap: () => _pickPhoto(ImageSource.camera),
            ),
            _SheetOption(
              icon: Icons.photo_library_rounded,
              title: 'Choose from Gallery',
              subtitle: 'Select from device photos',
              onTap: () => _pickPhoto(ImageSource.gallery),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  // ── Save ─────────────────────────────────────────────────────────────────

  void _save() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all required fields',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 13)),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    // Build blouse measurement map
    final blouseMap = <String, String>{};
    for (int i = 0; i < _kBlouseFields.length; i++) {
      final v = _blouseCtrls[i].text.trim();
      if (v.isNotEmpty) blouseMap[_kBlouseFields[i].english] = v;
    }

    // Build dress measurement map
    final allUpper = [..._kBlouseFields, ..._kDressUpperExtra];
    final dressMap = <String, String>{};
    for (int i = 0; i < allUpper.length; i++) {
      final v = _dressUpperCtrls[i].text.trim();
      if (v.isNotEmpty) dressMap['upper_${allUpper[i].english}'] = v;
    }
    for (int i = 0; i < _kDressLowerFields.length; i++) {
      final v = _dressLowerCtrls[i].text.trim();
      if (v.isNotEmpty) dressMap['lower_${_kDressLowerFields[i].english}'] = v;
    }
    dressMap['dupatta'] = _dupatta ? 'yes' : 'no';

    // Build initials from name
    final nameParts = _nameCtrl.text.trim().split(' ');
    final initials = nameParts.length >= 2
        ? '${nameParts.first[0]}${nameParts.last[0]}'.toUpperCase()
        : _nameCtrl.text.trim().substring(0, 1).toUpperCase();

    final updated = CustomerData(
      name:                _nameCtrl.text.trim(),
      phone:               _phoneCtrl.text.trim(),
      // age falls back to legacy value; computedAge derives it from DOB at runtime
      age:                 widget.existingCustomer?.age ?? 0,
      address:             _addressCtrl.text.trim(),
      initials:            initials,
      totalOrders:         widget.existingCustomer?.totalOrders ?? 0,
      lastOrderDate:       widget.existingCustomer?.lastOrderDate ?? '',
      blouseMeasurements:  blouseMap,
      dressMeasurements:   dressMap,
      dateOfBirth:         _selectedDob,
    );

    // Return the updated record to the caller (detail screen or list screen)
    Navigator.of(context).pop(updated);
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          widget.isEditing ? 'Edit Customer' : 'Add Customer',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.topbarStart, AppColors.topbarEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // ── Scrollable content ───────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── 1. Photo picker ──────────────────────────────────
                    _buildPhotoPicker(),

                    const SizedBox(height: 20),

                    // ── 2. Personal info card ────────────────────────────
                    _buildPersonalInfoCard(),

                    const SizedBox(height: 16),

                    // ── 3. Measurements card ─────────────────────────────
                    _buildMeasurementsCard(),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            // ── Fixed Save button ────────────────────────────────────────
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  Section builders
  // ══════════════════════════════════════════════════════════════════════════

  Widget _buildPhotoPicker() {
    return Center(
      child: GestureDetector(
        onTap: _showPhotoSheet,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // circle
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryLight,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.30),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
                image: _customerPhoto != null
                    ? DecorationImage(
                        image: FileImage(_customerPhoto!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: _customerPhoto == null
                  ? const Icon(Icons.person_rounded,
                      size: 44, color: AppColors.primary)
                  : null,
            ),
            // camera badge
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                  border:
                      Border.all(color: AppColors.surface, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.30),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.camera_alt_rounded,
                    size: 14, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoCard() {
    final age = _computedAge;
    return _SectionCard(
      title: 'Personal Information',
      icon: Icons.person_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Full Name ──────────────────────────────────────────────────
          _FormField(
            label: 'Full Name',
            controller: _nameCtrl,
            hint: 'e.g. Priya Sharma',
            isRequired: true,
          ),
          const SizedBox(height: 12),

          // ── Date of Birth (tappable field) ─────────────────────────────
          _DobPickerField(
            selectedDate: _selectedDob,
            onTap: _pickDob,
          ),
          const SizedBox(height: 8),

          // ── Computed Age (read-only badge) ─────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.40),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: age >= 0
                    ? AppColors.primary.withValues(alpha: 0.25)
                    : AppColors.border,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cake_rounded,
                  size: 14,
                  color: age >= 0 ? AppColors.primary : AppColors.textHint,
                ),
                const SizedBox(width: 6),
                Text(
                  age >= 0 ? 'Age: $age yrs' : 'Age: —',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: age >= 0 ? AppColors.primary : AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── Phone ──────────────────────────────────────────────────────
          _FormField(
            label: 'Phone Number',
            controller: _phoneCtrl,
            hint: '10-digit mobile number',
            isRequired: true,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: 10,
          ),
          const SizedBox(height: 12),

          // ── Address ────────────────────────────────────────────────────
          _FormField(
            label: 'Address',
            controller: _addressCtrl,
            hint: 'Street, City, PIN',
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementsCard() {
    return _SectionCard(
      title: 'Measurements',
      icon: Icons.straighten_rounded,
      // Pass child: SizedBox.shrink() — content is built inline below
      // because we need the TabBar and TabBarView together
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── TabBar ────────────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface2,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TabBar(
              controller: _tabCtrl,
              indicator: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(9),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
              unselectedLabelStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w400),
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.textSecondary,
              tabs: const [
                Tab(text: 'Blouse Measurements'),
                Tab(text: 'Dress Measurements'),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ── TabBarView with calculated fixed height ────────────────────
          // AnimatedContainer smoothly transitions height when tab changes.
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: _kTabHeights[_activeTab],
            child: TabBarView(
              controller: _tabCtrl,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // ── Blouse tab ─────────────────────────────────────────
                _BlouseTabContent(controllers: _blouseCtrls),

                // ── Dress tab ──────────────────────────────────────────
                _DressTabContent(
                  upperControllers: _dressUpperCtrls,
                  lowerControllers: _dressLowerCtrls,
                  dupatta: _dupatta,
                  onDupattaChanged: (v) => setState(() => _dupatta = v),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: AppShadows.elevated,
        border:
            const Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      padding: EdgeInsets.fromLTRB(
          16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.topbarStart, AppColors.topbarEnd],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: AppShadows.card,
          ),
          child: TextButton(
            onPressed: _save,
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.save_rounded, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  widget.isEditing ? 'Update Customer' : 'Save Customer',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  Bottom-sheet option row
// ════════════════════════════════════════════════════════════════════════════

class _SheetOption extends StatelessWidget {
  const _SheetOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          color: AppColors.textHint,
        ),
      ),
      onTap: onTap,
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  Blouse tab content  (13 fields, no scroll — parent ScrollView handles it)
// ════════════════════════════════════════════════════════════════════════════

class _BlouseTabContent extends StatelessWidget {
  const _BlouseTabContent({required this.controllers});
  final List<TextEditingController> controllers;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(_kBlouseFields.length, (i) {
        return _MeasurementRow(
          field: _kBlouseFields[i],
          controller: controllers[i],
        );
      }),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  Dress tab content  (14 upper + 4 lower + dupatta)
// ════════════════════════════════════════════════════════════════════════════

class _DressTabContent extends StatelessWidget {
  const _DressTabContent({
    required this.upperControllers,
    required this.lowerControllers,
    required this.dupatta,
    required this.onDupattaChanged,
  });

  final List<TextEditingController> upperControllers;
  final List<TextEditingController> lowerControllers;
  final bool dupatta;
  final ValueChanged<bool> onDupattaChanged;

  static const _allUpper = [..._kBlouseFields, ..._kDressUpperExtra];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Upper Body section
        _SubsectionLabel(
            label: 'Upper Body', icon: Icons.arrow_upward_rounded),
        const SizedBox(height: 8),
        ...List.generate(
          _allUpper.length,
          (i) => _MeasurementRow(
            field: _allUpper[i],
            controller: upperControllers[i],
          ),
        ),

        const SizedBox(height: 16),

        // Lower Body section
        _SubsectionLabel(
            label: 'Lower Body', icon: Icons.arrow_downward_rounded),
        const SizedBox(height: 8),
        ...List.generate(
          _kDressLowerFields.length,
          (i) => _MeasurementRow(
            field: _kDressLowerFields[i],
            controller: lowerControllers[i],
          ),
        ),

        const SizedBox(height: 16),

        // Dupatta toggle
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surface2,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Icon(Icons.spa_rounded,
                  size: 18, color: AppColors.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Dupatta',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'दुपट्टा',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: dupatta,
                onChanged: onDupattaChanged,
                activeThumbColor: AppColors.primary,
                trackColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors.primaryLight;
                  }
                  return AppColors.border;
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  DOB picker field  (tappable, read-only, styled like _FormField)
// ════════════════════════════════════════════════════════════════════════════

class _DobPickerField extends StatelessWidget {
  const _DobPickerField({required this.selectedDate, required this.onTap});
  final DateTime? selectedDate;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasDate = selectedDate != null;
    final display = hasDate
        ? DateFormat('dd/MM/yyyy').format(selectedDate!)
        : 'dd / MM / yyyy';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date of Birth',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 5),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: hasDate
                    ? AppColors.primary.withValues(alpha: 0.60)
                    : AppColors.border,
                width: hasDate ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 16,
                  color: hasDate ? AppColors.primary : AppColors.textHint,
                ),
                const SizedBox(width: 10),
                Text(
                  display,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13.5,
                    color: hasDate ? AppColors.textPrimary : AppColors.textHint,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_drop_down_rounded,
                  color: hasDate ? AppColors.primary : AppColors.textHint,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  Reusable widgets
// ════════════════════════════════════════════════════════════════════════════

/// Card container with gradient header
class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.card,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              color: AppColors.surface2,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              border:
                  const Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Icon(icon, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }
}

/// Labeled text-form-field
class _FormField extends StatelessWidget {
  const _FormField({
    required this.label,
    required this.controller,
    this.hint,
    this.isRequired = false,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
    this.maxLength,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final bool isRequired;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
            children: [
              if (isRequired)
                const TextSpan(
                    text: ' *',
                    style: TextStyle(color: AppColors.error)),
            ],
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          maxLength: maxLength,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 13.5),
          validator: isRequired
              ? (v) => (v == null || v.trim().isEmpty) ? 'Required' : null
              : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12.5,
                color: AppColors.textHint),
            counterText: '',
            filled: true,
            fillColor: AppColors.background,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: AppColors.error, width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: AppColors.error, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

/// Bilingual measurement row with inch input (~80 px tall)
class _MeasurementRow extends StatelessWidget {
  const _MeasurementRow({
    required this.field,
    required this.controller,
  });

  final _MeasField field;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bilingual label
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    field.english,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    field.marathi,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Number input + "cm"
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d{0,3}(\.\d{0,1})?$')),
                    ],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: '0',
                      hintStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          color: AppColors.textHint,
                          fontSize: 13),
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 1.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'inch',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
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

/// Section divider with icon + label + divider line
class _SubsectionLabel extends StatelessWidget {
  const _SubsectionLabel({required this.label, required this.icon});
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 14, color: AppColors.primary),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Divider(color: AppColors.border, thickness: 1),
        ),
      ],
    );
  }
}
