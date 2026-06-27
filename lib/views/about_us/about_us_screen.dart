import 'package:expence_manager/views/transaction/drawer_screen.dart';
import 'package:flutter/material.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen>
    with SingleTickerProviderStateMixin {
  static const Color _brand = Color(0xFF0EA17D);
  static const Color _brandLight = Color(0xFF16C79A);
  static const Color _bgLight = Color(0xFFF7F9FB);

  static const Color _textDark = Color(0xFF1A2634);
  static const Color _textMuted = Color(0xFF6B7785);

  late AnimationController _animCtrl;
  late Animation<double> _logoOpacity;
  late Animation<double> _logoScale;
  late Animation<double> _bodyOffset;
  late Animation<double> _bodyOpacity;

  @override
  void initState() {
    super.initState();

    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animCtrl,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );
    _logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _animCtrl,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
      ),
    );
    _bodyOffset = Tween<double>(begin: 24.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animCtrl,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );
    _bodyOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animCtrl,
        curve: const Interval(0.3, 0.75, curve: Curves.easeOut),
      ),
    );

    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerScreen(selectedIndex: 4),
      backgroundColor: _bgLight,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: _textDark),
        title: const Text(
          'About',
          style: TextStyle(
            color: _textDark,
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),

              AnimatedBuilder(
                animation: _animCtrl,
                builder: (_, __) => Opacity(
                  opacity: _logoOpacity.value,
                  child: Transform.scale(
                    scale: _logoScale.value,
                    child: const _LogoBadge(),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              AnimatedBuilder(
                animation: _animCtrl,
                builder: (_, __) => Opacity(
                  opacity: _logoOpacity.value,
                  child: Column(
                    children: const [
                      Text(
                        'Expense Manager',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _textDark,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 4),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              AnimatedBuilder(
                animation: _animCtrl,
                builder: (_, __) => Opacity(
                  opacity: _bodyOpacity.value,
                  child: Transform.translate(
                    offset: Offset(0, _bodyOffset.value),
                    child: _buildBody(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionCard(
          title: 'Why I built this',
          icon: Icons.auto_stories_rounded,
          child: const Text(
            'Expense Manager started as a personal learning project — a way '
            'for me to move past tutorials and actually build something real. '
            'Every screen here, from sign up to the splash animation, was '
            'built and broken and rebuilt while I figured out how the pieces '
            'fit together.',
            style: TextStyle(
              color: _textMuted,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.6,
            ),
          ),
        ),

        const SizedBox(height: 16),

        _SectionCard(
          title: 'What this project taught me',
          icon: Icons.school_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              _LearningPoint(
                icon: Icons.api_rounded,
                text:
                    'Hands-on API binding — connecting real requests and '
                    'responses to the UI instead of just reading about it.',
              ),
              SizedBox(height: 14),
              _LearningPoint(
                icon: Icons.code_rounded,
                text:
                    'Core Flutter & Dart concepts — state management, '
                    'animations, controllers, and widget composition.',
              ),
              SizedBox(height: 14),
              _LearningPoint(
                icon: Icons.architecture_rounded,
                text:
                    'Structuring an app properly — controllers, models, and '
                    'views kept separate instead of one tangled file.',
              ),
              SizedBox(height: 14),
              _LearningPoint(
                icon: Icons.trending_up_rounded,
                text:
                    'A clearer sense of direction for my career as a '
                    'Flutter developer.',
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        _SectionCard(
          title: 'Made by',
          icon: Icons.person_outline_rounded,
          child: Row(
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [_brand, _brandLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'S',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shivam',
                      style: TextStyle(
                        color: _textDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Flutter Developer (in progress)',
                      style: TextStyle(
                        color: _textMuted,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        _SectionCard(
          title: 'Built with',
          icon: Icons.layers_outlined,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _TechChip(label: 'Flutter'),
              _TechChip(label: 'Dart'),
              _TechChip(label: 'REST API'),
              _TechChip(label: 'Provider'),
            ],
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  static const Color _brand = Color(0xFF0EA17D);
  static const Color _bgCard = Color(0xFFFFFFFF);
  static const Color _textDark = Color(0xFF1A2634);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _bgCard,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: const Color(0xFF1A2634).withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: _brand.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(9),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: _brand, size: 16),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: _textDark,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

// ── Learning point row ──────────────────────────────────────────────────────
class _LearningPoint extends StatelessWidget {
  const _LearningPoint({required this.icon, required this.text});

  final IconData icon;
  final String text;

  static const Color _brand = Color(0xFF0EA17D);
  static const Color _textMuted = Color(0xFF6B7785);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Icon(icon, color: _brand, size: 17),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: _textMuted,
              fontSize: 13.5,
              fontWeight: FontWeight.w400,
              height: 1.55,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Tech stack chip ──────────────────────────────────────────────────────────
class _TechChip extends StatelessWidget {
  const _TechChip({required this.label});

  final String label;

  static const Color _brand = Color(0xFF0EA17D);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: _brand.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
        // ignore: deprecated_member_use
        border: Border.all(color: _brand.withOpacity(0.30)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: _brand,
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ── Logo badge (rings lightened for white background) ──────────────────────
class _LogoBadge extends StatelessWidget {
  const _LogoBadge();

  static const Color _brand = Color(0xFF0EA17D);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 104,
            width: 104,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // ignore: deprecated_member_use
              border: Border.all(color: _brand.withOpacity(0.12), width: 1.5),
            ),
          ),
          Container(
            height: 84,
            width: 84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // ignore: deprecated_member_use
              border: Border.all(color: _brand.withOpacity(0.22), width: 1.5),
            ),
          ),
          Container(
            height: 64,
            width: 64,
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
                  color: _brand.withOpacity(0.30),
                  blurRadius: 20,
                  spreadRadius: 1,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
