import 'dart:developer';
import 'package:expence_manager/controllers/category/category_controller.dart';
import 'package:expence_manager/controllers/graph/graph_controller.dart';
import 'package:expence_manager/controllers/transaction/category_list_provider.dart';
import 'package:expence_manager/controllers/transaction/transaction_controller.dart';
import 'package:expence_manager/controllers/wellcome/user_controller.dart';
import 'package:expence_manager/views/transaction/drawer_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen>
    with SingleTickerProviderStateMixin {
  static const Color _brand = Color(0xFF0EA17D);
  static const Color _brandLight = Color(0xFFE6F7F3);
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

  final UserController _userCtrl = UserController();
  late CategoryController categoryController;
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
      categoryController = context.read<CategoryController>();
      transactionController = context.read<TransactionController>();

      await _userCtrl.getuserData();
      if (!mounted) return;

      await context.read<TransactionController>().getAllTransaction(
        userName: _userCtrl.userName,
      );

      log("Username => ${_userCtrl.userName}");
      if (!mounted) return;

      Map<String, dynamic> map = await categoryController.getAllCategoryData(
        userName: _userCtrl.userName,
      );

      _fabAnim.forward();

      log(map.toString());
    });
  }

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String selectedTime = "";

  @override
  void dispose() {
    _dateController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _fabAnim.dispose();
    super.dispose();
  }

  _CategoryTheme _themeFor(int index) => _themes[index % _themes.length];

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    log("called build");
    return Scaffold(
      backgroundColor: _bg,
      drawer: DrawerScreen(selectedIndex: 0),
      appBar: AppBar(
        backgroundColor: _card,
        elevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Transactions',
              style: TextStyle(
                color: _textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            Text(
              'Track every rupee you spend',
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
          child: Container(height: 1, color: const Color(0xFFEEEEEE)),
        ),
      ),
      body: Consumer<TransactionController>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: _brand),
            );
          }

          if (value.allTransactionList.isEmpty) {
            return _EmptyState(onAdd: bottomSheetBar);
          }

          // Total spent (header summary)
          final double total = value.allTransactionList.fold<double>(
            0,
            (sum, t) => sum + (double.tryParse('${t.amount}') ?? 0),
          );

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
            children: [
              _SummaryCard(
                total: total,
                count: value.allTransactionList.length,
              ),
              const SizedBox(height: 18),
              ...List.generate(value.allTransactionList.length, (index) {
                final txn = value.allTransactionList[index];
                final theme = _themeFor(index);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _TransactionCard(
                    title: txn.category?.categoryName ?? 'Uncategorised',
                    description: txn.description ?? '',
                    date: txn.date ?? '',
                    time: txn.time ?? '',
                    amount: '${txn.amount}',
                    initials: _initials(txn.category?.categoryName ?? '?'),
                    theme: theme,
                    index: index,
                    userController: _userCtrl,
                    onDelete: () {},
                  ),
                );
              }),
            ],
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ScaleTransition(
        scale: _fabScale,
        child: _AddFab(onTap: bottomSheetBar),
      ),
    );
  }

  Future bottomSheetBar() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        final bottom = MediaQuery.of(sheetContext).viewInsets.bottom;

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
                        color: _brandLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.receipt_long_rounded,
                        color: _brand,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'New Transaction',
                          style: TextStyle(
                            color: _textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Fill in the details below',
                          style: TextStyle(color: _textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                const _FieldLabel(label: 'Date & time'),
                const SizedBox(height: 8),
                _StyledTextField(
                  controller: _dateController,
                  hint: 'Select date',
                  icon: Icons.calendar_today_outlined,
                  readOnly: true,
                  onTap: () async {
                    DateTime? dateTime = await showDatePicker(
                      context: sheetContext,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(3000),
                    );

                    TimeOfDay? timeOfDay;

                    if (dateTime != null) {
                      String formattedDate = DateFormat(
                        'yyyy-MM-dd',
                      ).format(dateTime);

                      _dateController.text = formattedDate;

                      if (!sheetContext.mounted) return;

                      timeOfDay = await showTimePicker(
                        context: sheetContext,
                        initialTime: TimeOfDay.now(),
                      );
                      if (timeOfDay != null) {
                        selectedTime =
                            "${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}:00";
                      }
                    }

                    log("time $timeOfDay");
                  },
                ),
                const SizedBox(height: 20),

                const _FieldLabel(label: 'Amount'),
                const SizedBox(height: 8),
                _StyledTextField(
                  controller: _amountController,
                  hint: '₹ 0.00',
                  icon: Icons.currency_rupee_rounded,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),

                const _FieldLabel(label: 'Category'),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFEEEEEE)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Consumer<CategoryListProvider>(
                    builder: (context, provider, child) {
                      int? selectedCategory =
                          categoryController.list.any(
                            (e) => e.categoryId == provider.category,
                          )
                          ? provider.category
                          : null;

                      return DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          value: selectedCategory,
                          hint: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              "Select category",
                              style: TextStyle(
                                color: _textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          isExpanded: true,
                          borderRadius: BorderRadius.circular(14),
                          icon: const Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: _textSecondary,
                            ),
                          ),
                          items: categoryController.list.map((element) {
                            return DropdownMenuItem<int>(
                              value: element.categoryId,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(
                                  element.name ?? "",
                                  style: const TextStyle(
                                    color: _textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            provider.categorySelect(value);
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                const _FieldLabel(label: 'Description'),
                const SizedBox(height: 8),
                _StyledTextField(
                  controller: _descriptionController,
                  hint: "What's this for?",
                  icon: Icons.notes_rounded,
                ),
                const SizedBox(height: 32),

                Consumer<TransactionController>(
                  builder: (_, provider, __) {
                    return GestureDetector(
                      onTap: provider.isLoading
                          ? null
                          : () async {
                              Map<String, dynamic> map = {
                                "amount": _amountController.text.trim(),
                                "description": _descriptionController.text
                                    .trim(),
                                "date": _dateController.text.trim(),
                                "time": selectedTime,
                                "category": {
                                  "catId": sheetContext
                                      .read<CategoryListProvider>()
                                      .category,
                                },
                                "user": {"userName": _userCtrl.userName},
                              };

                              await transactionController.postUserTransaction(
                                json: map,
                              );

                              log("button tap are done");

                              if (!sheetContext.mounted) return;
                              Navigator.of(sheetContext).pop();
                              _dateController.clear();
                              _amountController.clear();
                              _descriptionController.clear();
                            },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: provider.isLoading
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFFB0BEC5),
                                    Color(0xFFB0BEC5),
                                  ],
                                )
                              : const LinearGradient(
                                  colors: [
                                    Color(0xFF0EA17D),
                                    Color(0xFF16C79A),
                                  ],
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
                                  'Add Transaction',
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
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.total, required this.count});
  final double total;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0EA17D), Color(0xFF16C79A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x400EA17D),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total spent',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '₹${total.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.receipt_long_rounded,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  '$count txns',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
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

// ignore: must_be_immutable
class _TransactionCard extends StatelessWidget {
  _TransactionCard({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.amount,
    required this.initials,
    required this.theme,
    required this.onDelete,
    required this.index,
    required this.userController,
  });

  final String title;
  final String description;
  final String date;
  final String time;
  final String amount;
  final String initials;
  final _CategoryTheme theme;
  final VoidCallback onDelete;
  int index;
  UserController userController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _TransactionScreenState._card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(color: theme.bg, shape: BoxShape.circle),
            child: Center(
              child: Text(
                initials,
                style: TextStyle(
                  color: theme.accent,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _TransactionScreenState._textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '₹$amount',
                      style: const TextStyle(
                        color: _TransactionScreenState._textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        _confirmDelete(context: context, index: index);
                      },
                      icon: Icon(
                        Icons.remove_circle_outline_outlined,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _TransactionScreenState._textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 11,
                      color: _TransactionScreenState._textSecondary.withOpacity(
                        0.7,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: TextStyle(
                        color: _TransactionScreenState._textSecondary
                            .withOpacity(0.8),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      Icons.access_time_rounded,
                      size: 11,
                      color: _TransactionScreenState._textSecondary.withOpacity(
                        0.7,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: TextStyle(
                        color: _TransactionScreenState._textSecondary
                            .withOpacity(0.8),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete({required int index, required BuildContext context}) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Row(
          children: const [
            Icon(Icons.delete_outline_rounded, color: Colors.red, size: 22),
            SizedBox(width: 8),
            Text(
              'Delete Transaction?',
              style: TextStyle(
                color: Color(0xFF1A1A2E),
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: const Text(
          "This will remove the Transaction . You can't undo this.",
          style: TextStyle(color: Color(0xFF6B7280), fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF6B7280)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
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

              await transactionController.deleteTransaction(
                expId: transactionController.allTransactionList[index].expId,
                userName: userController.userName,
                obj: transactionController,
              );

              if (!context.mounted) return;

              await context.read<GraphController>().getAllGraphData(
                userName: userController.userName,
                transactionController: transactionController,
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
        width: 200,
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
              'Add Transaction',
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
              decoration: const BoxDecoration(
                color: _TransactionScreenState._brandLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.receipt_long_rounded,
                size: 48,
                color: _TransactionScreenState._brand,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No transactions yet',
              style: TextStyle(
                color: _TransactionScreenState._textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add your first transaction to start tracking your expenses.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _TransactionScreenState._textSecondary,
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

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: _TransactionScreenState._textPrimary,
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
    this.readOnly = false,
    this.onTap,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      style: const TextStyle(
        fontSize: 14,
        color: _TransactionScreenState._textPrimary,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: _TransactionScreenState._textSecondary.withOpacity(0.6),
          fontSize: 14,
        ),
        prefixIcon: Icon(
          icon,
          color: _TransactionScreenState._textSecondary,
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
            color: _TransactionScreenState._brand,
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
