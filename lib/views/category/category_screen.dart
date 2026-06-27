import 'dart:developer';

import 'package:expence_manager/controllers/category/category_controller.dart';
import 'package:expence_manager/controllers/transaction/transaction_controller.dart';

import 'package:expence_manager/controllers/wellcome/user_controller.dart';
import 'package:expence_manager/models/category_model.dart';
import 'package:expence_manager/views/transaction/drawer_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  static const Color _brand = Color(0xFF0EA17D);
  static const Color _brandLight = Color(0xFFE6F7F3);
  static const Color _danger = Color(0xFFEF4444);
  static const Color _bg = Color(0xFFF8F9FA);
  static const Color _card = Colors.white;
  static const Color _textPrimary = Color(0xFF1A1A2E);
  static const Color _textSecondary = Color(0xFF6B7280);

  static const List<_CategoryTheme> _themes = [
    _CategoryTheme(Color(0xFFE6F7F3), Color(0xFF0EA17D)),
    _CategoryTheme(Color(0xFFFEE2E2), Color(0xFFEF4444)),
    _CategoryTheme(Color(0xFFF3E8FF), Color(0xFF9333EA)),
    _CategoryTheme(Color(0xFFDEF7FF), Color(0xFF0EA5E9)),
    _CategoryTheme(Color(0xFFFFF7E6), Color(0xFFF59E0B)),
    _CategoryTheme(Color(0xFFFFE4EF), Color(0xFFEC4899)),
  ];

  final TextEditingController _imageUrlCtrl = TextEditingController();
  final TextEditingController _categoryCtrl = TextEditingController();
  final UserController _userCtrl = UserController();
  late TransactionController transactionController;
  late AnimationController _fabAnim;
  late Animation<double> _fabScale;

  @override
  void initState() {
    super.initState();

    _fabAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fabScale = CurvedAnimation(parent: _fabAnim, curve: Curves.elasticOut);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _userCtrl.getuserData();

      if (!mounted) return;
      await context.read<CategoryController>().getAllCategoryData(
        userName: _userCtrl.userName,
      );

      if (!context.mounted) return;

      await context.read<TransactionController>();

      _fabAnim.forward();

      log("Username => ${_userCtrl.userName}");
    });
  }

  @override
  void dispose() {
    _categoryCtrl.dispose();
    _imageUrlCtrl.dispose();
    _fabAnim.dispose();
    super.dispose();
  }

  _CategoryTheme _themeFor(int index) => _themes[index % _themes.length];

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      drawer: DrawerScreen(selectedIndex: 2),

      appBar: AppBar(
        backgroundColor: _card,
        elevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Categories',
              style: TextStyle(
                color: _textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            Text(
              'Manage your spending groups',
              style: TextStyle(
                color: _textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: _textPrimary),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Color(0xFFEEEEEE)),
        ),
      ),

      body: Consumer<CategoryController>(
        builder: (context, ctrl, _) {
          if (ctrl.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: _brand),
            );
          }

          if (ctrl.list.isEmpty) {
            return _EmptyState(onAdd: _openAddSheet);
          }

          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.95,
            ),
            itemCount: ctrl.list.length,
            itemBuilder: (context, index) => _CategoryCard(
              name: ctrl.list[index].name ?? '',
              initials: _initials(ctrl.list[index].name ?? '?'),
              theme: _themeFor(index),
              onDelete: () => _confirmDelete(index),
            ),
          );
        },
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ScaleTransition(
        scale: _fabScale,
        child: _AddFab(onTap: _openAddSheet),
      ),
    );
  }

  void _confirmDelete(int index) {
    final ctrl = context.read<CategoryController>();
    final int catId = ctrl.list[index].categoryId!;

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: _card,
        title: Row(
          children: const [
            Icon(Icons.delete_outline_rounded, color: _danger, size: 22),
            SizedBox(width: 8),
            Text(
              'Delete category?',
              style: TextStyle(
                color: _textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: const Text(
          "This will remove the category permanently. You can't undo this.",
          style: TextStyle(color: _textSecondary, fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: _textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _danger,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () async {
              Navigator.pop(dialogCtx);

              TransactionController transactionController = context
                  .read<TransactionController>();

              final result = await ctrl.deleteUserCategory(
                catId: catId,
                userName: _userCtrl.userName,
                obj: transactionController,
              );

              log('Delete result: $result');

              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: _danger,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.all(16),
                  content: Row(
                    children: const [
                      Icon(Icons.delete_rounded, color: Colors.white, size: 18),
                      SizedBox(width: 10),
                      Text(
                        'Category deleted',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddCategorySheet(
        categoryCtrl: _categoryCtrl,
        imageUrlCtrl: _imageUrlCtrl,
        userCtrl: _userCtrl,
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.name,
    required this.initials,
    required this.theme,
    required this.onDelete,
  });

  final String name;
  final String initials;
  final _CategoryTheme theme;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onDelete,
      child: Container(
        decoration: BoxDecoration(
          color: _CategoryScreenState._card,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 12,
              spreadRadius: 2,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: theme.bg,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  initials,
                  style: TextStyle(
                    color: theme.accent,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _CategoryScreenState._textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            const SizedBox(height: 4),

            Text(
              'Hold to delete',
              style: TextStyle(
                color: _CategoryScreenState._textSecondary.withOpacity(0.6),
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddFab extends StatelessWidget {
  const _AddFab({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        width: 180,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0EA17D), Color(0xFF16C79A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(50),
          boxShadow: const [
            BoxShadow(
              color: Color(0x400EA17D),
              blurRadius: 16,
              spreadRadius: 0,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add_rounded, color: Colors.white, size: 22),
            SizedBox(width: 6),
            Text(
              'Add Category',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: _CategoryScreenState._brandLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.grid_view_rounded,
                size: 48,
                color: _CategoryScreenState._brand,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No categories yet',
              style: TextStyle(
                color: _CategoryScreenState._textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Create a category to start organising your expenses.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _CategoryScreenState._textSecondary,
                fontSize: 14,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),
            _AddFab(onTap: onAdd),
          ],
        ),
      ),
    );
  }
}

class _AddCategorySheet extends StatelessWidget {
  const _AddCategorySheet({
    required this.categoryCtrl,
    required this.imageUrlCtrl,
    required this.userCtrl,
  });

  final TextEditingController categoryCtrl;
  final TextEditingController imageUrlCtrl;
  final UserController userCtrl;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + bottom),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    color: _CategoryScreenState._brandLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.category_rounded,
                    color: _CategoryScreenState._brand,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'New Category',
                      style: TextStyle(
                        color: _CategoryScreenState._textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Fill in the details below',
                      style: TextStyle(
                        color: _CategoryScreenState._textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 28),

            _FieldLabel(label: 'Category name'),
            const SizedBox(height: 8),
            _StyledTextField(
              controller: categoryCtrl,
              hint: 'e.g. Food & Drinks',
              icon: Icons.label_outline_rounded,
            ),
            const SizedBox(height: 20),

            _FieldLabel(label: 'Image URL '),
            const SizedBox(height: 8),
            _StyledTextField(
              controller: imageUrlCtrl,
              hint: 'https://example.com/icon.png',
              icon: Icons.image_outlined,
            ),
            const SizedBox(height: 32),

            Consumer<CategoryController>(
              builder: (_, provider, __) {
                return GestureDetector(
                  onTap: provider.isLoading
                      ? null
                      : () async {
                          final data = CategoryModel1(
                            categoryName: categoryCtrl.text.trim(),
                            imageUrl: imageUrlCtrl.text.trim(),
                            color: '#ff002586',
                            user: {'userName': userCtrl.userName},
                          );
                          final json = await provider.addUserCategory(
                            data: data.toJson(),
                          );

                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: _CategoryScreenState._brand,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              margin: const EdgeInsets.all(16),
                              content: Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    json['message'] ?? 'Category added!',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );

                          Navigator.of(context).pop();
                          categoryCtrl.clear();
                          imageUrlCtrl.clear();
                          log('Category added successfully');
                        },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: provider.isLoading
                          ? const LinearGradient(
                              colors: [Color(0xFFB0BEC5), Color(0xFFB0BEC5)],
                            )
                          : const LinearGradient(
                              colors: [Color(0xFF0EA17D), Color(0xFF16C79A)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: provider.isLoading
                          ? []
                          : const [
                              BoxShadow(
                                color: Color(0x400EA17D),
                                blurRadius: 14,
                                offset: Offset(0, 5),
                              ),
                            ],
                    ),
                    child: provider.isLoading
                        ? const Center(
                            child: SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            ),
                          )
                        : const Center(
                            child: Text(
                              'Save Category',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                  ),
                );
              },
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: _CategoryScreenState._textPrimary,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
    );
  }
}

class _StyledTextField extends StatelessWidget {
  const _StyledTextField({
    required this.controller,
    required this.hint,
    required this.icon,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        fontSize: 14,
        color: _CategoryScreenState._textPrimary,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: _CategoryScreenState._textSecondary.withOpacity(0.6),
          fontSize: 14,
        ),
        prefixIcon: Icon(
          icon,
          color: _CategoryScreenState._textSecondary,
          size: 20,
        ),
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: _CategoryScreenState._brand,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

class _CategoryTheme {
  const _CategoryTheme(this.bg, this.accent);
  final Color bg;
  final Color accent;
}
