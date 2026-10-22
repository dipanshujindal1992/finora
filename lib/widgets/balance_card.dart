import 'package:flutter/material.dart';
import 'package:finora/core/theme/app_theme.dart';
import 'package:finora/core/constants/app_constants.dart';
import 'package:finora/core/utils/formatters.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final double income;
  final double expenses;
  final VoidCallback? onTap;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.income,
    required this.expenses,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isPositive = balance >= 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppConstants.spacingLG),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusXLarge),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary,
              colorScheme.primary.withValues(alpha: 0.8),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Balance',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onPrimary.withValues(alpha: 0.8),
                  ),
                ),
                Icon(
                  Icons.visibility_outlined,
                  color: colorScheme.onPrimary.withValues(alpha: 0.8),
                  size: AppConstants.iconSizeMD,
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingMD),
            Text(
              Formatters.formatCurrency(balance),
              style: theme.textTheme.displayMedium?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: AppConstants.spacingLG),
            Row(
              children: [
                Expanded(
                  child: _buildStatColumn(
                    context,
                    'Income',
                    income,
                    AppColors.incomeColor,
                    Icons.arrow_downward_rounded,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: colorScheme.onPrimary.withValues(alpha: 0.2),
                  margin: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingMD),
                ),
                Expanded(
                  child: _buildStatColumn(
                    context,
                    'Expenses',
                    expenses,
                    AppColors.expenseColor,
                    Icons.arrow_upward_rounded,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: colorScheme.onPrimary.withValues(alpha: 0.2),
                  margin: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacingMD),
                ),
                Expanded(
                  child: _buildStatColumn(
                    context,
                    'Savings',
                    income - expenses,
                    isPositive ? AppColors.incomeColor : AppColors.expenseColor,
                    isPositive
                        ? Icons.trending_up_rounded
                        : Icons.trending_down_rounded,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(
    BuildContext context,
    String label,
    double amount,
    Color color,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onPrimary.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          Formatters.formatCurrency(amount),
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class SavingsProgressCard extends StatelessWidget {
  final double savingsRate;
  final double savedAmount;
  final double targetAmount;

  const SavingsProgressCard({
    super.key,
    required this.savingsRate,
    required this.savedAmount,
    required this.targetAmount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final progress = savingsRate.clamp(0.0, 1.0);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Savings Progress',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingMD),
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(AppConstants.borderRadiusCircular),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
              ),
            ),
            const SizedBox(height: AppConstants.spacingMD),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Saved ${Formatters.formatCurrency(savedAmount)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  'Target ${Formatters.formatCurrency(targetAmount)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
