import 'package:expence_manager/views/about_us/about_us_screen.dart';
import 'package:expence_manager/views/category/category_screen.dart';
import 'package:expence_manager/views/graph/graph_screen.dart';
import 'package:expence_manager/views/transaction/transaction_screen.dart';
import 'package:expence_manager/views/trash/trash_screen.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DrawerScreen extends StatefulWidget {
  int selectedIndex;
  DrawerScreen({super.key, required this.selectedIndex});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  static const Color _brand = Color(0xFF0EA17D);
  static const Color _bgDark = Color(0xFF0F1923);
  static const Color _bgCard = Color(0xFF1A2634);
  static const Color _textWhite = Color(0xFFF0F4F8);
  static const Color _textMuted = Color(0xFF8A9BB0);
  static const Color _divider = Color(0xFF243040);

  final List<_NavItem> _navItems = const [
    _NavItem(icon: Icons.receipt_long_rounded, label: 'Transactions'),
    _NavItem(icon: Icons.bar_chart_rounded, label: 'Graphs'),
    _NavItem(icon: Icons.grid_view_rounded, label: 'Categories'),
    _NavItem(icon: Icons.delete_outline_rounded, label: 'Trash'),
    _NavItem(icon: Icons.info_outline_rounded, label: 'About Us'),
  ];

  void _navigate(int index) {
    Navigator.pop(context);
    if (index == widget.selectedIndex) return;

    Widget destination;
    switch (index) {
      case 0:
        destination = const TransactionScreen();
        break;
      case 1:
        destination = const GraphScreen();
        break;
      case 2:
        destination = const CategoryScreen();
        break;
      case 3:
        destination = const TrashScreen();
      case 4:
        destination = const AboutUsScreen();
      default:
        destination = const TrashScreen();
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => destination,
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 220),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 272,
      backgroundColor: _bgDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DrawerHeader(),

            Container(
              height: 1,
              color: _divider,
              margin: const EdgeInsets.symmetric(horizontal: 20),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                itemCount: _navItems.length,
                itemBuilder: (context, index) {
                  final item = _navItems[index];
                  final isSelected = widget.selectedIndex == index;

                  return _NavTile(
                    item: item,
                    isSelected: isSelected,
                    onTap: () => _navigate(index),
                  );
                },
              ),
            ),

            Container(
              height: 1,
              color: _divider,
              margin: const EdgeInsets.symmetric(horizontal: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0EA17D), Color(0xFF16C79A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x500EA17D),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Expense Manager',
                style: TextStyle(
                  color: _DrawerScreenState._textWhite,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Track every rupee',
                style: TextStyle(
                  color: _DrawerScreenState._textMuted,
                  fontWeight: FontWeight.w400,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          // ignore: deprecated_member_use
          splashColor: _DrawerScreenState._brand.withOpacity(0.15),
          // ignore: deprecated_member_use
          highlightColor: _DrawerScreenState._brand.withOpacity(0.08),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: isSelected
                  // ignore: deprecated_member_use
                  ? _DrawerScreenState._brand.withOpacity(0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected
                    // ignore: deprecated_member_use
                    ? _DrawerScreenState._brand.withOpacity(0.35)
                    : Colors.transparent,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _DrawerScreenState._brand
                        : _DrawerScreenState._bgCard,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    item.icon,
                    size: 18,
                    color: isSelected
                        ? Colors.white
                        : _DrawerScreenState._textMuted,
                  ),
                ),
                const SizedBox(width: 14),

                Text(
                  item.label,
                  style: TextStyle(
                    color: isSelected
                        ? _DrawerScreenState._textWhite
                        : _DrawerScreenState._textMuted,
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    letterSpacing: 0.1,
                  ),
                ),
                const Spacer(),

                if (isSelected)
                  Container(
                    height: 6,
                    width: 6,
                    decoration: const BoxDecoration(
                      color: _DrawerScreenState._brand,
                      shape: BoxShape.circle,
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

class _NavItem {
  const _NavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}
