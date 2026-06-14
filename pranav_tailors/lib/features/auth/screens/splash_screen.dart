// ════════════════════════════════════════════════════════════════════════════
//  splash_screen.dart
//  Pranav Ladies Tailors — Animated Splash Screen
//
//  Design:
//   • Near-white background  (#FFFBFD)
//   • Animated pastel-pink scissors icon  — fade-in + scale-up
//   • Shop name "Pranav Ladies Tailors"    — staggered fade-in
//   • Tagline "Ladies Dress & Blouse Specialist" — staggered fade-in
//   • Poppins font (via google_fonts already in pubspec)
//   • Navigates to /login via go_router after 2.5 s
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


// ─── Brand colours (inline so this file is self-contained) ──────────────────
const Color _kBackground    = Color(0xFFFFFBFD);
const Color _kScissors      = Color(0xFFF48FB1);  // pastel pink
const Color _kShopName      = Color(0xFF1C0A14);  // near-black rosewood
const Color _kTagline       = Color(0xFF7B4060);  // muted rosewood

// ─── Animation durations ─────────────────────────────────────────────────────
const Duration _kIconDuration    = Duration(milliseconds: 900);
const Duration _kTextDuration    = Duration(milliseconds: 700);
const Duration _kIconDelay       = Duration(milliseconds: 100);
const Duration _kNameDelay       = Duration(milliseconds: 550);
const Duration _kTaglineDelay    = Duration(milliseconds: 800);
const Duration _kNavigateAfter   = Duration(milliseconds: 3000);

// ════════════════════════════════════════════════════════════════════════════

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ── Icon animation (fade + scale) ──────────────────────────────────────
  late final AnimationController _iconCtrl;
  late final Animation<double>   _iconFade;
  late final Animation<double>   _iconScale;

  // ── Shop name fade ──────────────────────────────────────────────────────
  late final AnimationController _nameCtrl;
  late final Animation<double>   _nameFade;
  late final Animation<Offset>   _nameSlide;

  // ── Tagline fade ────────────────────────────────────────────────────────
  late final AnimationController _tagCtrl;
  late final Animation<double>   _tagFade;
  late final Animation<Offset>   _tagSlide;

  // ── Decorative dot pulse ────────────────────────────────────────────────
  late final AnimationController _pulseCtrl;
  late final Animation<double>   _pulseScale;

  @override
  void initState() {
    super.initState();

    // ── Icon ──────────────────────────────────────────────────────────────
    _iconCtrl = AnimationController(vsync: this, duration: _kIconDuration);
    _iconFade  = CurvedAnimation(parent: _iconCtrl, curve: Curves.easeIn);
    _iconScale = Tween<double>(begin: 0.55, end: 1.0).animate(
      CurvedAnimation(parent: _iconCtrl, curve: Curves.elasticOut),
    );

    // ── Shop name ─────────────────────────────────────────────────────────
    _nameCtrl = AnimationController(vsync: this, duration: _kTextDuration);
    _nameFade  = CurvedAnimation(parent: _nameCtrl, curve: Curves.easeIn);
    _nameSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end:   Offset.zero,
    ).animate(CurvedAnimation(parent: _nameCtrl, curve: Curves.easeOutCubic));

    // ── Tagline ───────────────────────────────────────────────────────────
    _tagCtrl = AnimationController(vsync: this, duration: _kTextDuration);
    _tagFade  = CurvedAnimation(parent: _tagCtrl, curve: Curves.easeIn);
    _tagSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end:   Offset.zero,
    ).animate(CurvedAnimation(parent: _tagCtrl, curve: Curves.easeOutCubic));

    // ── Pulse ─────────────────────────────────────────────────────────────
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _pulseScale = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    // ── Staggered start ───────────────────────────────────────────────────
    Future.delayed(_kIconDelay,    () { if (mounted) _iconCtrl.forward(); });
    Future.delayed(_kNameDelay,    () { if (mounted) _nameCtrl.forward(); });
    Future.delayed(_kTaglineDelay, () { if (mounted) _tagCtrl.forward();  });

    // ── Navigate after 2.5 s ─────────────────────────────────────────────
    Future.delayed(_kNavigateAfter, () {
      if (mounted) context.go('/login');
    });
  }

  @override
  void dispose() {
    _iconCtrl.dispose();
    _nameCtrl.dispose();
    _tagCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  BUILD
  // ══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackground,
      body: Stack(
        children: [
          // ── Subtle radial gradient halo behind the icon ─────────────────
          Positioned.fill(
            child: FadeTransition(
              opacity: _iconFade,
              child: Center(
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFFCE4EC).withValues(alpha: 0.55),
                        _kBackground,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Centre content ───────────────────────────────────────────────
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Scissors icon ──────────────────────────────────────────
                FadeTransition(
                  opacity: _iconFade,
                  child: ScaleTransition(
                    scale: _iconScale,
                    child: _ScissorsIcon(pulseAnim: _pulseScale),
                  ),
                ),

                const SizedBox(height: 32),

                // ── Shop name ──────────────────────────────────────────────
                FadeTransition(
                  opacity: _nameFade,
                  child: SlideTransition(
                    position: _nameSlide,
                    child: Text(
                      'Pranav Ladies Tailors',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Poppins', 
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: _kShopName,
                        letterSpacing: -0.3,
                        height: 1.25,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // ── Tagline ────────────────────────────────────────────────
                FadeTransition(
                  opacity: _tagFade,
                  child: SlideTransition(
                    position: _tagSlide,
                    child: Text(
                      'Ladies Dress & Blouse Specialist',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Poppins', 
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: _kTagline,
                        letterSpacing: 0.6,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Bottom brand mark ────────────────────────────────────────────
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _tagFade,
              child: Column(
                children: [
                  // Decorative divider dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _dot(size: 4),
                      const SizedBox(width: 6),
                      _dot(size: 6, opacity: 0.7),
                      const SizedBox(width: 6),
                      _dot(size: 4),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Est. since always',
                    style: TextStyle(fontFamily: 'Poppins', 
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: _kTagline.withValues(alpha: 0.5),
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot({required double size, double opacity = 1.0}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _kScissors.withValues(alpha: opacity * 0.7),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  Scissors Icon Widget (custom painter for elegance + pulsing ring)
// ════════════════════════════════════════════════════════════════════════════

class _ScissorsIcon extends StatelessWidget {
  const _ScissorsIcon({required this.pulseAnim});

  final Animation<double> pulseAnim;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ── Pulsing outer ring ──────────────────────────────────────────
          ScaleTransition(
            scale: pulseAnim,
            child: Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _kScissors.withValues(alpha: 0.20),
                  width: 1.5,
                ),
              ),
            ),
          ),

          // ── Background disc ─────────────────────────────────────────────
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFCE4EC),      // very light rose
              boxShadow: [
                BoxShadow(
                  color: _kScissors.withValues(alpha: 0.18),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
          ),

          // ── Scissors icon ───────────────────────────────────────────────
          Transform.rotate(
            angle: -0.785398,           // −45° for diagonal elegance
            child: const Icon(
              Icons.content_cut_rounded,
              size: 44,
              color: _kScissors,
            ),
          ),
        ],
      ),
    );
  }
}
