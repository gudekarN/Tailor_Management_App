// ════════════════════════════════════════════════════════════════════════════
//  login_screen.dart
//  Pranav Ladies Tailors — PIN Login Screen
//
//  Design:
//   • Scissors logo + shop name + tagline header
//   • Manager / Employee role selector cards (tap-to-select)
//   • 6-dot PIN indicator row
//   • Custom numpad (GridView 3×4)
//   • Gradient login button
//   • PIN 1234 → navigate to correct dashboard
//   • Poppins font · Blush Rose theme · no system keyboard
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';


// ─── Inline brand tokens ──────────────────────────────────────────────────────
const Color _kBg          = Color(0xFFFFFBFD);
const Color _kPrimary     = Color(0xFFC2185B);
const Color _kPrimaryDark = Color(0xFF880E4F);
const Color _kPastelPink  = Color(0xFFF48FB1);
const Color _kPastelBg    = Color(0xFFFCE4EC);
const Color _kSurface     = Color(0xFFFFFFFF);
const Color _kBorder      = Color(0xFFF8D7E6);
const Color _kTextPrimary = Color(0xFF1C0A14);
const Color _kTextSub     = Color(0xFF7B4060);
const Color _kTextHint    = Color(0xFFB08090);

const String _kManagerPin  = '111111';
const String _kEmployeePin = '222222';

enum _Role { manager, employee }

// ════════════════════════════════════════════════════════════════════════════

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  // ── State ─────────────────────────────────────────────────────────────────
  _Role  _selectedRole  = _Role.manager;
  String _pin           = '';
  bool   _loading       = false;
  String _errorMessage  = '';

  // ── Animations ────────────────────────────────────────────────────────────
  late final AnimationController _headerCtrl;
  late final Animation<double>   _headerFade;
  late final Animation<Offset>   _headerSlide;

  late final AnimationController _cardCtrl;
  late final Animation<double>   _cardFade;
  late final Animation<Offset>   _cardSlide;

  late final AnimationController _padCtrl;
  late final Animation<double>   _padFade;

  late final AnimationController _shakeCtrl;
  late final Animation<double>   _shakeAnim;

  @override
  void initState() {
    super.initState();

    // ── Enter animations ──────────────────────────────────────────────────
    _headerCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _headerFade  = CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut);
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.15),
      end:   Offset.zero,
    ).animate(CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOutCubic));

    _cardCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _cardFade  = CurvedAnimation(parent: _cardCtrl, curve: Curves.easeOut);
    _cardSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end:   Offset.zero,
    ).animate(CurvedAnimation(parent: _cardCtrl, curve: Curves.easeOutCubic));

    _padCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    _padFade = CurvedAnimation(parent: _padCtrl, curve: Curves.easeOut);

    // ── Shake animation for wrong PIN ──────────────────────────────────────
    _shakeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 480));
    _shakeAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -8.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: -6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -6.0, end: 6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 6.0, end: 0.0),  weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.easeInOut));

    // ── Staggered entrance ─────────────────────────────────────────────────
    Future.delayed(const Duration(milliseconds: 80),  () { if (mounted) _headerCtrl.forward(); });
    Future.delayed(const Duration(milliseconds: 250), () { if (mounted) _cardCtrl.forward();   });
    Future.delayed(const Duration(milliseconds: 400), () { if (mounted) _padCtrl.forward();    });
  }

  @override
  void dispose() {
    _headerCtrl.dispose();
    _cardCtrl.dispose();
    _padCtrl.dispose();
    _shakeCtrl.dispose();
    super.dispose();
  }

  // ── PIN logic ─────────────────────────────────────────────────────────────

  void _onDigit(String d) {
    if (_pin.length >= 6 || _loading) return;
    HapticFeedback.lightImpact();
    setState(() {
      _pin += d;
      _errorMessage = '';   // clear any previous error on new input
    });
  }

  void _onBackspace() {
    if (_pin.isEmpty || _loading) return;
    HapticFeedback.lightImpact();
    setState(() {
      _pin = _pin.substring(0, _pin.length - 1);
      _errorMessage = '';
    });
  }

  Future<void> _onLogin() async {
    if (_pin.length < 6 || _loading) return;
    HapticFeedback.mediumImpact();

    // Role-based PINs: Manager = 111111, Employee = 222222
    final correctPin = _selectedRole == _Role.manager
        ? _kManagerPin
        : _kEmployeePin;
    final isCorrect = _pin == correctPin;

    if (!isCorrect) {
      HapticFeedback.vibrate();
      await _shakeCtrl.forward(from: 0);
      setState(() {
        _pin = '';
        _errorMessage = _selectedRole == _Role.manager
            ? 'Incorrect Manager PIN. Please try again.'
            : 'Incorrect Employee PIN. Please try again.';
      });
      _shakeCtrl.reset();
      return;
    }

    setState(() {
      _loading      = true;
      _errorMessage = '';
    });
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    if (_selectedRole == _Role.manager) {
      context.go('/manager/home');
    } else {
      context.go('/employee/home');
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  BUILD
  // ══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final isCompact = mq.size.height < 700;

    return Scaffold(
      backgroundColor: _kBg,
      // Prevent system keyboard from appearing
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────────────
            FadeTransition(
              opacity: _headerFade,
              child: SlideTransition(
                position: _headerSlide,
                child: _Header(compact: isCompact),
              ),
            ),

            // ── Role cards + PIN area ────────────────────────────────────────
            Expanded(
              child: FadeTransition(
                opacity: _cardFade,
                child: SlideTransition(
                  position: _cardSlide,
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          SizedBox(height: isCompact ? 12 : 20),

                          // ── Role selector ──────────────────────────────
                          Row(
                            children: [
                              Expanded(
                                child: _RoleCard(
                                  role: _Role.manager,
                                  selected: _selectedRole == _Role.manager,
                                  onTap: () => _onRoleSelected(_Role.manager),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _RoleCard(
                                  role: _Role.employee,
                                  selected: _selectedRole == _Role.employee,
                                  onTap: () => _onRoleSelected(_Role.employee),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: isCompact ? 20 : 28),

                          // ── PIN prompt label ───────────────────────────
                          Text(
                            'Enter your PIN',
                            style: TextStyle(fontFamily: 'Poppins', 
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: _kTextSub,
                              letterSpacing: 0.4,
                            ),
                          ),

                          SizedBox(height: isCompact ? 14 : 18),

                          // ── 6-dot PIN indicator ────────────────────────
                          AnimatedBuilder(
                            animation: _shakeAnim,
                            builder: (context, child) => Transform.translate(
                              offset: Offset(_shakeAnim.value, 0),
                              child: child,
                            ),
                            child: _PinDots(pinLength: _pin.length),
                          ),

                          // ── Error message (fixed height — no layout shift) ──
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 20,
                            child: _errorMessage.isNotEmpty
                                ? Text(
                                    'Incorrect PIN. Please try again.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontFamily: 'Poppins', 
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFFB71C1C),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),

                          SizedBox(height: isCompact ? 12 : 18),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Numpad + Login button (fade in last) ─────────────────────────
            FadeTransition(
              opacity: _padFade,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _NumPad(
                      onDigit:     _onDigit,
                      onBackspace: _onBackspace,
                      enabled:     !_loading,
                    ),
                    const SizedBox(height: 14),
                    _LoginButton(
                      ready:   _pin.length == 6,
                      loading: _loading,
                      onTap:   _onLogin,
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onRoleSelected(_Role role) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedRole = role;
      _pin          = '';
      _errorMessage = '';
    });
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  Header
// ════════════════════════════════════════════════════════════════════════════

class _Header extends StatelessWidget {
  const _Header({required this.compact});
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, compact ? 16 : 24, 20, compact ? 16 : 20),
      decoration: const BoxDecoration(
        color: _kSurface,
        border: Border(bottom: BorderSide(color: _kBorder, width: 1)),
      ),
      child: Column(
        children: [
          // ── Scissors badge ───────────────────────────────────────────────
          Container(
            width: compact ? 56 : 68,
            height: compact ? 56 : 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _kPastelBg,
              boxShadow: [
                BoxShadow(
                  color: _kPastelPink.withValues(alpha: 0.30),
                  blurRadius: 14,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Transform.rotate(
              angle: -0.785398,
              child: Icon(
                Icons.content_cut_rounded,
                size: compact ? 26 : 32,
                color: _kPastelPink,
              ),
            ),
          ),

          SizedBox(height: compact ? 10 : 14),

          // ── Shop name ────────────────────────────────────────────────────
          Text(
            'Pranav Ladies Tailors',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Poppins', 
              fontSize: compact ? 18 : 21,
              fontWeight: FontWeight.w700,
              color: _kPrimary,
              letterSpacing: -0.3,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 5),

          // ── Tagline ──────────────────────────────────────────────────────
          Text(
            'Ladies Dress & Blouse Specialist  |  Pico, Fall, Beading Center',
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Poppins', 
              fontSize: compact ? 10.5 : 11.5,
              fontWeight: FontWeight.w400,
              color: _kTextSub,
              letterSpacing: 0.2,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  Role Selector Card
// ════════════════════════════════════════════════════════════════════════════

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.role,
    required this.selected,
    required this.onTap,
  });

  final _Role   role;
  final bool    selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isManager = role == _Role.manager;
    final icon  = isManager ? Icons.manage_accounts_rounded : Icons.person_rounded;
    final label = isManager ? 'Manager' : 'Employee';
    final desc  = isManager ? 'Full access' : 'Work queue';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: selected ? _kPastelBg : _kSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? _kPastelPink : _kBorder,
          width: selected ? 2.0 : 1.5,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: _kPastelPink.withValues(alpha: 0.22),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: _kPastelPink.withValues(alpha: 0.18),
          highlightColor: _kPastelPink.withValues(alpha: 0.10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? _kPastelPink : const Color(0xFFF5F5F5),
                  ),
                  child: Icon(
                    icon,
                    size: 22,
                    color: selected ? _kSurface : _kTextHint,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: selected ? _kPrimary : _kTextPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: selected ? _kTextSub : _kTextHint,
                  ),
                ),
                const SizedBox(height: 8),
                // Selection indicator dot
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: selected ? 20 : 8,
                  height: 4,
                  decoration: BoxDecoration(
                    color: selected ? _kPastelPink : _kBorder,
                    borderRadius: BorderRadius.circular(99),
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
//  6-Dot PIN Indicator
// ════════════════════════════════════════════════════════════════════════════

class _PinDots extends StatelessWidget {
  const _PinDots({required this.pinLength});
  final int pinLength;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(6, (i) {
        final filled = i < pinLength;
        return Container(
          width: 16,
          height: 16,
          margin: const EdgeInsets.symmetric(horizontal: 7),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled ? _kPrimary : Colors.transparent,
            border: Border.all(
              color: filled ? _kPrimary : _kTextHint,
              width: 1.5,
            ),
          ),
        );
      }),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  Custom NumPad
// ════════════════════════════════════════════════════════════════════════════

class _NumPad extends StatelessWidget {
  const _NumPad({
    required this.onDigit,
    required this.onBackspace,
    required this.enabled,
  });

  final void Function(String) onDigit;
  final VoidCallback           onBackspace;
  final bool                   enabled;

  static const _keys = [
    '1', '2', '3',
    '4', '5', '6',
    '7', '8', '9',
    '',  '0', '⌫',
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.1,
      ),
      itemCount: _keys.length,
      itemBuilder: (context, i) {
        final key = _keys[i];

        if (key.isEmpty) {
          // Blank placeholder
          return const SizedBox.shrink();
        }

        if (key == '⌫') {
          return _NumKey(
            label: key,
            isBackspace: true,
            onTap: enabled ? onBackspace : null,
          );
        }

        return _NumKey(
          label: key,
          onTap: enabled ? () => onDigit(key) : null,
        );
      },
    );
  }
}

class _NumKey extends StatelessWidget {
  const _NumKey({
    required this.label,
    this.isBackspace = false,
    this.onTap,
  });

  final String    label;
  final bool      isBackspace;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        splashColor: _kPastelPink.withValues(alpha: 0.22),
        highlightColor: _kPastelPink.withValues(alpha: 0.12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: isBackspace ? Colors.transparent : _kSurface,
            borderRadius: BorderRadius.circular(14),
            border: isBackspace
                ? null
                : Border.all(color: _kBorder, width: 1.2),
            boxShadow: isBackspace
                ? []
                : [
                    BoxShadow(
                      color: _kPrimary.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          alignment: Alignment.center,
          child: isBackspace
              ? Icon(Icons.backspace_outlined, size: 22, color: _kTextSub)
              : Text(
                  label,
                  style: TextStyle(fontFamily: 'Poppins', 
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: _kTextPrimary,
                    height: 1,
                  ),
                ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  Login Button
// ════════════════════════════════════════════════════════════════════════════

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    required this.ready,
    required this.loading,
    required this.onTap,
  });

  final bool          ready;
  final bool          loading;
  final VoidCallback  onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: ready ? 1.0 : 0.45,
      child: GestureDetector(
        onTap: ready && !loading ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          height: 52,
          decoration: BoxDecoration(
            gradient: ready
                ? const LinearGradient(
                    colors: [_kPrimary, _kPrimaryDark],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : LinearGradient(
                    colors: [
                      _kPrimary.withValues(alpha: 0.55),
                      _kPrimaryDark.withValues(alpha: 0.55),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: ready
                ? [
                    BoxShadow(
                      color: _kPrimary.withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: loading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(fontFamily: 'Poppins', 
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded,
                        color: Colors.white, size: 18),
                  ],
                ),
        ),
      ),
    );
  }
}
