import 'package:flutter/material.dart';
import 'package:finora/models/budget_model.dart';
import 'package:finora/models/category_model.dart';
import 'package:finora/core/theme/app_theme.dart';
import 'package:finora/core/constants/app_constants.dart';
import 'package:finora/core/utils/formatters.dart';

class BudgetProgressCard extends StatelessWidget {
  final Budget budget;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const BudgetProgressCard({
    super.key,
    required this.budget,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final progress = budget.progress;
    final isOverBudget = budget.isOverBudget;
    final isNearLimit = budget.isNearLimit;

    Color progressColor;
    if (isOverBudget) {
      progressColor = AppColors.expenseColor;
    } else if (isNearLimit) {
      progressColor = AppColors.warningColor;
    } else {
      progressColor = budget.category.color;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildCategoryIcon(context),
                  const SizedBox(width: AppConstants.spacingMD),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          budget.category.label,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          Formatters.formatCurrency(budget.spent) +
                              ' / ' +
                              Formatters.formatCurrency(budget.limit),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isOverBudget)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingSM,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.expenseLight,
                        borderRadius: BorderRadius.circular(
                            AppConstants.borderRadiusCircular),
                      ),
                      child: Text(
                        'Over Budget',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.expenseColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  else if (isNearLimit)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingSM,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.warningLight,
                        borderRadius: BorderRadius.circular(
                            AppConstants.borderRadiusCircular),
                      ),
                      child: Text(
                        'Near Limit',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.warningColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert_rounded,
                      color: colorScheme.onSurfaceVariant,
                      size: AppConstants.iconSizeSM,
                    ),
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          onEdit?.call();
                          break;
                        case 'delete':
                          onDelete?.call();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 18),
                            SizedBox(width: 8),
                            Text('Edit Budget'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline,
                                size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingMD),
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadiusCircular),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  minHeight: 8,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                ),
              ),
              const SizedBox(height: AppConstants.spacingSM),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Remaining: ${Formatters.formatCurrency(budget.remaining)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: budget.remaining >= 0
                          ? colorScheme.onSurfaceVariant
                          : AppColors.expenseColor,
                      fontWeight: budget.remaining < 0
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                  Text(
                    '${(progress * 100).toStringAsFixed(0)}% used',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isOverBudget = budget.isOverBudget;
    final isNearLimit = budget.isNearLimit;

    Color bgColor;
    Color iconColor;
    if (isOverBudget) {
      bgColor = AppColors.expenseLight;
      iconColor = AppColors.expenseColor;
    } else if (isNearLimit) {
      bgColor = AppColors.warningLight;
      iconColor = AppColors.warningColor;
    } else {
      bgColor = budget.category.color.withValues(alpha: 0.15);
      iconColor = budget.category.color;
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusCircular),
      ),
      child: Icon(
        budget.category.icon,
        color: iconColor,
        size: AppConstants.iconSizeMD,
      ),
    );
  }
}

class EmptyBudgetCard extends StatelessWidget {
  final VoidCallback onAddBudget;

  const EmptyBudgetCard({
    super.key,
    required this.onAddBudget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: InkWell(
        onTap: onAddBudget,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingXL),
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadiusCircular),
                ),
                child: Icon(
                  Icons.add_rounded,
                  color: colorScheme.primary,
                  size: AppConstants.iconSizeXL,
                ),
              ),
              const SizedBox(height: AppConstants.spacingMD),
              Text(
                'No Budgets Yet',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppConstants.spacingXS),
              Text(
                'Create your first budget to track spending',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.spacingMD),
              FilledButton.icon(
                onPressed: onAddBudget,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Create Budget'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
