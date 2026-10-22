import 'package:flutter/material.dart';
import 'package:finora/models/transaction_model.dart';
import 'package:finora/core/theme/app_theme.dart';
import 'package:finora/core/constants/app_constants.dart';
import 'package:finora/core/utils/formatters.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool showCategory;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.onTap,
    this.onDelete,
    this.showCategory = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isIncome = transaction.type == TransactionType.income;
    final amountColor =
        isIncome ? AppColors.incomeColor : AppColors.expenseColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMD,
          vertical: AppConstants.spacingSM,
        ),
        child: Row(
          children: [
            _buildCategoryAvatar(context),
            const SizedBox(width: AppConstants.spacingMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (showCategory || transaction.note != null) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        if (showCategory) ...[
                          Text(
                            transaction.category.label,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                        if (showCategory && transaction.note != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            '•',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (transaction.note != null) ...[
                          Expanded(
                            child: Text(
                              transaction.note!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isIncome ? '+' : '-'}${Formatters.formatCurrency(transaction.amount)}',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: amountColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  Formatters.formatDateShort(transaction.date),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            if (onDelete != null) ...[
              const SizedBox(width: AppConstants.spacingSM),
              IconButton(
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: colorScheme.onSurfaceVariant,
                  size: AppConstants.iconSizeSM,
                ),
                onPressed: onDelete,
                tooltip: 'Delete',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryAvatar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isIncome = transaction.type == TransactionType.income;

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isIncome ? AppColors.incomeLight : AppColors.expenseLight,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusCircular),
      ),
      child: Icon(
        transaction.category.icon,
        color: isIncome ? AppColors.incomeColor : AppColors.expenseColor,
        size: AppConstants.iconSizeMD,
      ),
    );
  }
}

class TransactionTileAnimated extends StatefulWidget {
  final Transaction transaction;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool showCategory;

  const TransactionTileAnimated({
    super.key,
    required this.transaction,
    this.onTap,
    this.onDelete,
    this.showCategory = true,
  });

  @override
  State<TransactionTileAnimated> createState() =>
      _TransactionTileAnimatedState();
}

class _TransactionTileAnimatedState extends State<TransactionTileAnimated>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: TransactionTile(
        transaction: widget.transaction,
        onTap: () {
          _controller.forward().then((_) => _controller.reverse());
          widget.onTap?.call();
        },
        onDelete: widget.onDelete,
        showCategory: widget.showCategory,
      ),
    );
  }
}
