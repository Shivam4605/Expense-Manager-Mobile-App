import 'package:expence_manager/controllers/trash/trash_controller.dart';
import 'package:expence_manager/controllers/trash/trash_model.dart';
import 'package:expence_manager/controllers/wellcome/user_controller.dart';
import 'package:expence_manager/views/transaction/drawer_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TrashScreen extends StatefulWidget {
  const TrashScreen({super.key});

  @override
  State<TrashScreen> createState() => _TrashScreenState();
}

class _TrashScreenState extends State<TrashScreen>
    with SingleTickerProviderStateMixin {
  static const Color _brand = Color(0xFF0EA17D);
  static const Color _brandLight = Color(0xFFE6F7F3);
  static const Color _bg = Color(0xFFF8F9FA);
  static const Color _card = Colors.white;
  static const Color _textPrimary = Color(0xFF1A1A2E);
  static const Color _textSecondary = Color(0xFF6B7280);
  static const Color _danger = Color(0xFFEF4444);
  static const Color _dangerLight = Color(0xFFFEE2E2);
  static const Color _dividerColor = Color(0xFFEEEEEE);

  final UserController _userCtrl = UserController();
  late AnimationController _listAnim;

  @override
  void initState() {
    super.initState();
    _listAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _userCtrl.getuserData();
      if (!mounted) return;
      await context.read<TrashController>().getTrashDetails(
        userName: _userCtrl.userName,
      );
      _listAnim.forward();
    });
  }

  @override
  void dispose() {
    _listAnim.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {required bool isRestore}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isRestore ? _brand : _danger,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            Icon(
              isRestore ? Icons.restore_rounded : Icons.delete_forever_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 10),
            Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete({
    required int index,
    required TrashController trashController,
  }) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: _card,
        title: Row(
          children: [
            Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                color: _dangerLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.delete_forever_rounded,
                color: _danger,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Delete Forever?',
              style: TextStyle(
                color: _textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: const Text(
          "This transaction will be permanently removed.\nThis action cannot be undone.",
          style: TextStyle(color: _textSecondary, fontSize: 13, height: 1.6),
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

              await trashController.deleteTrash(
                trashId: trashController.listOfTrashData[index].trashId!,
              );

              _showSnackBar(
                'Transaction permanently deleted',
                isRestore: false,
              );
            },
            child: const Text(
              'Delete Forever',
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

  void _confirmRestore({
    required int index,
    required TrashController trashController,
  }) {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: _card,
        title: Row(
          children: [
            Container(
              height: 34,
              width: 34,
              decoration: BoxDecoration(
                color: _brandLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.restore_rounded, color: _brand, size: 18),
            ),
            const SizedBox(width: 10),
            const Text(
              'Restore Transaction?',
              style: TextStyle(
                color: _textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: const Text(
          "This transaction will be moved back to your active transactions.",
          style: TextStyle(color: _textSecondary, fontSize: 13, height: 1.6),
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
              backgroundColor: _brand,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () async {
              Navigator.pop(dialogCtx);

              await trashController.restoreTrash(
                trashId: trashController.listOfTrashData[index].trashId!,
              );

              _showSnackBar(
                'Transaction restored successfully',
                isRestore: true,
              );
            },
            child: const Text(
              'Restore',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      drawer: DrawerScreen(selectedIndex: 3),
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: _card,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: _textPrimary),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Trash',
              style: TextStyle(
                color: _textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            Text(
              'Swipe left to delete  •  Swipe right to restore',
              style: TextStyle(
                color: _textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: _dividerColor),
        ),
      ),
      body: Consumer<TrashController>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: _brand),
            );
          }

          if (value.listOfTrashData.isEmpty) {
            return const _EmptyTrash();
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
            itemCount: value.listOfTrashData.length,
            itemBuilder: (context, index) {
              final item = value.listOfTrashData[index];

              final itemAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: _listAnim,
                  curve: Interval(
                    (index * 0.08).clamp(0.0, 0.8),
                    ((index * 0.08) + 0.4).clamp(0.0, 1.0),
                    curve: Curves.easeOut,
                  ),
                ),
              );

              return AnimatedBuilder(
                animation: _listAnim,
                builder: (_, child) => Opacity(
                  opacity: itemAnim.value,
                  child: Transform.translate(
                    offset: Offset(0, 20 * (1 - itemAnim.value)),
                    child: child,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _SwipeableTrashCard(
                    item: item,
                    onDelete: () =>
                        _confirmDelete(index: index, trashController: value),
                    onRestore: () =>
                        _confirmRestore(index: index, trashController: value),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _SwipeableTrashCard extends StatelessWidget {
  const _SwipeableTrashCard({
    required this.item,
    required this.onDelete,
    required this.onRestore,
  });

  final TrashData item;
  final VoidCallback onDelete;
  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),

      secondaryBackground: _SwipeBg(
        color: _TrashScreenState._danger,
        lightColor: _TrashScreenState._dangerLight,
        icon: Icons.delete_forever_rounded,
        label: 'Delete Forever',
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
      ),

      background: _SwipeBg(
        color: _TrashScreenState._brand,
        lightColor: _TrashScreenState._brandLight,
        icon: Icons.restore_rounded,
        label: 'Restore',
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 24),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          onDelete();
        } else {
          onRestore();
        }
        return false;
      },
      child: _TrashCard(item: item, onDelete: onDelete, onRestore: onRestore),
    );
  }
}

class _SwipeBg extends StatelessWidget {
  const _SwipeBg({
    required this.color,
    required this.lightColor,
    required this.icon,
    required this.label,
    required this.alignment,
    required this.padding,
  });

  final Color color;
  final Color lightColor;
  final IconData icon;
  final String label;
  final Alignment alignment;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: lightColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.30)),
      ),
      padding: padding,
      alignment: alignment,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrashCard extends StatelessWidget {
  const _TrashCard({
    required this.item,
    required this.onDelete,
    required this.onRestore,
  });

  final TrashData item;
  final VoidCallback onDelete;
  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context) {
    final String title = item.trashCategory?.categoryName ?? 'Transaction';
    final String amount = item.trashAmount?.toStringAsFixed(2) ?? '0.00';
    final String category = item.trashCategory?.categoryName ?? 'Uncategorized';
    final String date = item.trashDate ?? '—';
    final String time = item.trashTime ?? '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _TrashScreenState._card,
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
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: _TrashScreenState._dangerLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: _TrashScreenState._danger,
                  size: 22,
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
                              color: _TrashScreenState._textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                        Text(
                          '₹$amount',
                          style: TextStyle(
                            color: _TrashScreenState._danger,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Row(
                      children: [
                        Icon(
                          Icons.grid_view_rounded,
                          size: 11,
                          color: _TrashScreenState._textSecondary.withOpacity(
                            0.7,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          category,
                          style: const TextStyle(
                            color: _TrashScreenState._textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),

                    if ((item.trashDescription ?? '').isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        item.trashDescription!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _TrashScreenState._textSecondary.withOpacity(
                            0.75,
                          ),
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 11,
                          color: _TrashScreenState._textSecondary.withOpacity(
                            0.6,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          date,
                          style: TextStyle(
                            color: _TrashScreenState._textSecondary.withOpacity(
                              0.8,
                            ),
                            fontSize: 11,
                          ),
                        ),
                        if (time.isNotEmpty) ...[
                          const SizedBox(width: 10),
                          Icon(
                            Icons.access_time_rounded,
                            size: 11,
                            color: _TrashScreenState._textSecondary.withOpacity(
                              0.6,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            time,
                            style: TextStyle(
                              color: _TrashScreenState._textSecondary
                                  .withOpacity(0.8),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyTrash extends StatelessWidget {
  const _EmptyTrash();

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
                color: _TrashScreenState._dangerLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                size: 46,
                color: _TrashScreenState._danger,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Trash is empty',
              style: TextStyle(
                color: _TrashScreenState._textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Deleted transactions will appear here.\nYou can restore or permanently remove them.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _TrashScreenState._textSecondary,
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
