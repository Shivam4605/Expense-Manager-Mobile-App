import 'package:expence_manager/controllers/wellcome/user_controller.dart';
import 'package:expence_manager/views/transaction/transaction_screen.dart';
import 'package:expence_manager/views/wellcome/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const Color _brand = Color(0xFF0EA17D);

  static const Color _bgDark = Color(0xFF0F1923);

  static const Color _textWhite = Color(0xFFF0F4F8);
  static const Color _textMuted = Color(0xFF8A9BB0);

  final UserController _userController = UserController();
  late AnimationController _animCtrl;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;

  late Animation<double> _textOffset;
  late Animation<double> _textOpacity;

  late Animation<double> _tagOpacity;

  late Animation<double> _dotsOpacity;

  @override
  void initState() {
    super.initState();

    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _animCtrl,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
      ),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animCtrl,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
      ),
    );

    _textOffset = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animCtrl,
        curve: const Interval(0.25, 0.65, curve: Curves.easeOut),
      ),
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animCtrl,
        curve: const Interval(0.25, 0.60, curve: Curves.easeOut),
      ),
    );

    _tagOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animCtrl,
        curve: const Interval(0.40, 0.75, curve: Curves.easeOut),
      ),
    );

    _dotsOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animCtrl,
        curve: const Interval(0.60, 1.0, curve: Curves.easeOut),
      ),
    );

    _animCtrl.forward();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await _userController.getuserData();
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => _userController.isLoggedIn
              ? const TransactionScreen()
              : const LoginScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    } catch (e) {
      debugPrint('Splash Error: $e');
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDark,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _animCtrl,
                      builder: (_, __) => Opacity(
                        opacity: _logoOpacity.value,
                        child: Transform.scale(
                          scale: _logoScale.value,
                          child: _LogoBadge(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    AnimatedBuilder(
                      animation: _animCtrl,
                      builder: (_, __) => Opacity(
                        opacity: _textOpacity.value,
                        child: Transform.translate(
                          offset: Offset(0, _textOffset.value),
                          child: const Text(
                            'Expense Manager',
                            style: TextStyle(
                              color: _textWhite,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    AnimatedBuilder(
                      animation: _animCtrl,
                      builder: (_, __) => Opacity(
                        opacity: _tagOpacity.value,
                        child: const Text(
                          'Track every rupee, every day',
                          style: TextStyle(
                            color: _textMuted,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            AnimatedBuilder(
              animation: _animCtrl,
              builder: (_, __) => Opacity(
                opacity: _dotsOpacity.value,
                child: const Padding(
                  padding: EdgeInsets.only(bottom: 48),
                  child: _PulsingDots(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 160,
          width: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              // ignore: deprecated_member_use
              color: _SplashScreenState._brand.withOpacity(0.18),
              width: 1.5,
            ),
          ),
        ),

        Container(
          height: 136,
          width: 136,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              // ignore: deprecated_member_use
              color: _SplashScreenState._brand.withOpacity(0.30),
              width: 1.5,
            ),
          ),
        ),

        Container(
          height: 110,
          width: 110,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0EA17D), Color(0xFF16C79A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: _SplashScreenState._brand.withOpacity(0.45),
                blurRadius: 32,
                spreadRadius: 4,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.account_balance_wallet_rounded,
            color: Colors.white,
            size: 48,
          ),
        ),
      ],
    );
  }
}

class _PulsingDots extends StatefulWidget {
  const _PulsingDots();

  @override
  State<_PulsingDots> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<_PulsingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        final delay = i * 0.2;
        final anim = Tween<double>(begin: 0.3, end: 1.0).animate(
          CurvedAnimation(
            parent: _ctrl,
            curve: Interval(delay, delay + 0.5, curve: Curves.easeInOut),
          ),
        );
        return AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) => Opacity(
            opacity: anim.value,
            child: Container(
              height: 7,
              width: 7,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: _SplashScreenState._brand,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }),
    );
  }
}
