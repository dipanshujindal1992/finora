import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finora/models/budget_model.dart';
import 'package:finora/models/category_model.dart';
import 'package:finora/providers/app_providers.dart';
import 'package:finora/widgets/budget_progress_card.dart';
import 'package:finora/widgets/common_widgets.dart'
    show EmptyState, SectionHeader;
import 'package:finora/core/theme/app_theme.dart';
import 'package:finora/core/constants/app_constants.dart';
import 'package:finora/core/utils/formatters.dart';

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgets = ref.watch(budgetListProvider);
    final selectedMonth = ref.watch(selectedMonthProvider);
    final categorySpending = ref.watch(categorySpendingProvider);

    final monthlyBudgets = budgets
        .where((b) =>
            b.month.year == selectedMonth.year &&
            b.month.month == selectedMonth.month)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
        actions: [
          IconButton(
            onPressed: () => _showMonthPicker(context, ref),
            icon: const Icon(Icons.calendar_month_outlined),
            tooltip: 'Select Month',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildBudgetSummary(context, monthlyBudgets),
          const SizedBox(height: AppConstants.spacingMD),
          Expanded(
            child: monthlyBudgets.isEmpty
                ? _buildEmptyState(context, ref)
                : _buildBudgetsList(
                    context, monthlyBudgets, categorySpending, ref),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBudgetDialog(context, ref),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildBudgetSummary(BuildContext context, List<Budget> budgets) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final totalBudget = budgets.fold(0.0, (sum, b) => sum + b.limit);
    final totalSpent = budgets.fold(0.0, (sum, b) => sum + b.spent);
    final totalRemaining = totalBudget - totalSpent;
    final overBudgetCount = budgets.where((b) => b.isOverBudget).length;

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMD),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  context,
                  'Total Budget',
                  Formatters.formatCurrency(totalBudget),
                  Icons.account_balance_wallet_outlined,
                  colorScheme.primary,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMD),
              Expanded(
                child: _buildSummaryItem(
                  context,
                  'Spent',
                  Formatters.formatCurrency(totalSpent),
                  Icons.trending_up_rounded,
                  AppColors.expenseColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMD),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  context,
                  'Remaining',
                  Formatters.formatCurrency(totalRemaining),
                  totalRemaining >= 0
                      ? Icons.savings_outlined
                      : Icons.warning_rounded,
                  totalRemaining >= 0
                      ? AppColors.incomeColor
                      : AppColors.expenseColor,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMD),
              Expanded(
                child: _buildSummaryItem(
                  context,
                  overBudgetCount > 0
                      ? '$overBudgetCount Over Budget'
                      : 'On Track',
                  overBudgetCount > 0 ? '' : '',
                  overBudgetCount > 0
                      ? Icons.warning_rounded
                      : Icons.check_circle_outlined,
                  overBudgetCount > 0
                      ? AppColors.expenseColor
                      : AppColors.incomeColor,
                ),
              ),
            ],
          ),
          if (totalBudget > 0) ...[
            const SizedBox(height: AppConstants.spacingMD),
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(AppConstants.borderRadiusCircular),
              child: LinearProgressIndicator(
                value: (totalSpent / totalBudget).clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  totalSpent > totalBudget
                      ? AppColors.expenseColor
                      : colorScheme.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMD),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(label,
                  style: theme.textTheme.labelMedium?.copyWith(color: color)),
            ],
          ),
          const SizedBox(height: 8),
          Text(value,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return EmptyState(
      icon: Icons.account_balance_wallet_outlined,
      title: 'No Budgets Set',
      message:
          'Create budgets for your spending categories to track your expenses',
      actionLabel: 'Create Budget',
      onAction: () => _showAddBudgetDialog(context, ref),
    );
  }

  Widget _buildBudgetsList(
    BuildContext context,
    List<Budget> budgets,
    Map<CategoryType, double> categorySpending,
    WidgetRef ref,
  ) {
    // Update budgets with actual spending
    final updatedBudgets = budgets.map((budget) {
      final actualSpent = categorySpending[budget.category] ?? 0;
      if (actualSpent != budget.spent) {
        return budget.copyWith(spent: actualSpent);
      }
      return budget;
    }).toList();

    // Sort: over budget first, then by progress
    updatedBudgets.sort((a, b) {
      if (a.isOverBudget != b.isOverBudget) {
        return a.isOverBudget ? -1 : 1;
      }
      return b.progress.compareTo(a.progress);
    });

    return ListView.separated(
      padding: const EdgeInsets.all(AppConstants.spacingMD),
      itemCount: updatedBudgets.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppConstants.spacingMD),
      itemBuilder: (context, index) {
        final budget = updatedBudgets[index];
        return BudgetProgressCard(
          budget: budget,
          onTap: () => _showBudgetDetails(context, budget, ref),
          onEdit: () => _showEditBudgetDialog(context, budget, ref),
          onDelete: () => _confirmDeleteBudget(context, budget, ref),
        );
      },
    );
  }

  void _showAddBudgetDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _BudgetDialog(
        onSave: (category, limit) {
          final selectedMonth = ref.read(selectedMonthProvider);
          final budget = Budget(
            category: category,
            limit: limit,
            month: selectedMonth,
          );
          ref.read(budgetListProvider.notifier).addBudget(budget);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Budget created')),
          );
        },
      ),
    );
  }

  void _showEditBudgetDialog(
      BuildContext context, Budget budget, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _BudgetDialog(
        initialCategory: budget.category,
        initialLimit: budget.limit,
        onSave: (category, limit) {
          final updatedBudget =
              budget.copyWith(category: category, limit: limit);
          ref.read(budgetListProvider.notifier).updateBudget(updatedBudget);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Budget updated')),
          );
        },
      ),
    );
  }

  void _confirmDeleteBudget(
      BuildContext context, Budget budget, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Budget'),
        content: Text(
            'Are you sure you want to delete the budget for ${budget.category.label}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              ref.read(budgetListProvider.notifier).deleteBudget(budget.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Budget deleted')),
              );
            },
            style:
                FilledButton.styleFrom(backgroundColor: AppColors.expenseColor),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showBudgetDetails(BuildContext context, Budget budget, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _BudgetDetailsSheet(budget: budget),
    );
  }

  void _showMonthPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _MonthPickerSheet(),
    );
  }
}

class _BudgetDialog extends ConsumerStatefulWidget {
  final CategoryType? initialCategory;
  final double? initialLimit;
  final Function(CategoryType, double) onSave;

  const _BudgetDialog({
    this.initialCategory,
    this.initialLimit,
    required this.onSave,
  });

  @override
  ConsumerState<_BudgetDialog> createState() => _BudgetDialogState();
}

class _BudgetDialogState extends ConsumerState<_BudgetDialog> {
  final _formKey = GlobalKey<FormState>();
  final _limitController = TextEditingController();
  late CategoryType _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory ?? CategoryType.food;
    if (widget.initialLimit != null) {
      _limitController.text = widget.initialLimit!.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _limitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEditing = widget.initialLimit != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Budget' : 'Create Budget'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<CategoryType>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category_outlined),
              ),
              items: CategoryType.values
                  .where((c) => !c.isIncomeCategory)
                  .map((cat) => DropdownMenuItem(
                        value: cat,
                        child: Row(
                          children: [
                            Icon(cat.icon, color: cat.color, size: 20),
                            const SizedBox(width: 12),
                            Text(cat.label),
                          ],
                        ),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _selectedCategory = value!),
            ),
            const SizedBox(height: AppConstants.spacingMD),
            TextFormField(
              controller: _limitController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Budget Limit',
                hintText: 'Enter amount',
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 16, right: 8),
                  child: Text('₹'),
                ),
                prefixIconConstraints:
                    BoxConstraints(minWidth: 0, minHeight: 0),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a budget limit';
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSave(
                  _selectedCategory, double.parse(_limitController.text));
            }
          },
          child: Text(isEditing ? 'Update' : 'Create'),
        ),
      ],
    );
  }
}

class _BudgetDetailsSheet extends StatelessWidget {
  final Budget budget;

  const _BudgetDetailsSheet({required this.budget});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isOverBudget = budget.isOverBudget;
    final isNearLimit = budget.isNearLimit;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(AppConstants.spacingLG),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppConstants.spacingLG),
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: budget.category.color.withValues(alpha: 0.15),
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadiusCircular),
                ),
                child: Icon(budget.category.icon,
                    color: budget.category.color, size: 28),
              ),
              const SizedBox(width: AppConstants.spacingMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(budget.category.label,
                        style: theme.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    Text(Formatters.formatMonth(budget.month),
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              if (isOverBudget)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.expenseLight,
                    borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusCircular),
                  ),
                  child: Text('Over Budget',
                      style: theme.textTheme.labelMedium?.copyWith(
                          color: AppColors.expenseColor,
                          fontWeight: FontWeight.w600)),
                )
              else if (isNearLimit)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.warningLight,
                    borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusCircular),
                  ),
                  child: Text('Near Limit',
                      style: theme.textTheme.labelMedium?.copyWith(
                          color: AppColors.warningColor,
                          fontWeight: FontWeight.w600)),
                ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingLG),
          Divider(color: colorScheme.outlineVariant),
          const SizedBox(height: AppConstants.spacingMD),
          _buildDetailRow(
              context, 'Budget Limit', Formatters.formatCurrency(budget.limit)),
          _buildDetailRow(
              context, 'Amount Spent', Formatters.formatCurrency(budget.spent)),
          _buildDetailRow(
            context,
            'Remaining',
            Formatters.formatCurrency(budget.remaining),
            valueColor: budget.remaining >= 0
                ? AppColors.incomeColor
                : AppColors.expenseColor,
          ),
          _buildDetailRow(context, 'Progress',
              '${(budget.progress * 100).toStringAsFixed(1)}%'),
          const SizedBox(height: AppConstants.spacingLG),
          ClipRRect(
            borderRadius:
                BorderRadius.circular(AppConstants.borderRadiusCircular),
            child: LinearProgressIndicator(
              value: budget.progress.clamp(0.0, 1.0),
              minHeight: 12,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(
                isOverBudget
                    ? AppColors.expenseColor
                    : (isNearLimit
                        ? AppColors.warningColor
                        : budget.category.color),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value,
      {Color? valueColor}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: colorScheme.onSurfaceVariant)),
          Text(value,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600, color: valueColor)),
        ],
      ),
    );
  }
}

class _MonthPickerSheet extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedMonth = ref.watch(selectedMonthProvider);
    final now = DateTime.now();

    final months = List.generate(12, (index) {
      final date = DateTime(now.year, index + 1);
      return date;
    });

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(AppConstants.spacingLG),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppConstants.spacingLG),
          Text('Select Month',
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppConstants.spacingLG),
          SizedBox(
            height: 300,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: months.length,
              itemBuilder: (context, index) {
                final month = months[index];
                final isSelected = month.month == selectedMonth.month &&
                    month.year == selectedMonth.year;
                return InkWell(
                  onTap: () {
                    ref.read(selectedMonthProvider.notifier).state = month;
                    Navigator.pop(context);
                  },
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadiusMedium),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primaryContainer
                          : theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusMedium),
                      border: Border.all(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outlineVariant,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      Formatters.formatMonth(month),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
