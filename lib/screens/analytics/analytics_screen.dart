import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finora/providers/app_providers.dart';
import 'package:finora/models/category_model.dart';
import 'package:finora/core/theme/app_theme.dart';
import 'package:finora/widgets/charts.dart';
import 'package:finora/widgets/common_widgets.dart';
import 'package:finora/core/constants/app_constants.dart';
import 'package:finora/core/utils/formatters.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthlyComparison = ref.watch(monthlyComparisonProvider);
    final weeklySpending = ref.watch(weeklySpendingProvider);
    final categorySpending = ref.watch(categorySpendingProvider);
    final savingsRate = ref.watch(savingsRateProvider);
    final totalIncome = ref.watch(monthlyIncomeProvider);
    final totalExpenses = ref.watch(monthlyExpensesProvider);

    final maxMonthly = monthlyComparison
        .map((m) => (m['income'] as double) + (m['expenses'] as double))
        .fold(0.0, (a, b) => a > b ? a : b);

    final maxWeekly = weeklySpending
        .map((w) => w['amount'] as double)
        .fold(0.0, (a, b) => a > b ? a : b);

    final totalSpending = categorySpending.values.fold(0.0, (a, b) => a + b);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        actions: [
          IconButton(
            onPressed: () => _showMonthPicker(context, ref),
            icon: const Icon(Icons.calendar_month_outlined),
            tooltip: 'Select Month',
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spacingMD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryCards(
                      context, totalIncome, totalExpenses, savingsRate),
                  const SizedBox(height: AppConstants.spacingLG),
                  _buildMonthlyChart(context, monthlyComparison, maxMonthly),
                  const SizedBox(height: AppConstants.spacingLG),
                  _buildWeeklyChart(context, weeklySpending, maxWeekly),
                  const SizedBox(height: AppConstants.spacingLG),
                  _buildCategoryBreakdown(
                      context, categorySpending, totalSpending),
                  const SizedBox(height: AppConstants.spacingLG),
                  _buildInsights(context, totalIncome, totalExpenses,
                      savingsRate, categorySpending),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(
    BuildContext context,
    double income,
    double expenses,
    double savingsRate,
  ) {
    final balance = income - expenses;

    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: 'Income',
            value: Formatters.formatCurrency(income),
            icon: Icons.arrow_downward_rounded,
            color: AppColors.incomeColor,
          ),
        ),
        const SizedBox(width: AppConstants.spacingMD),
        Expanded(
          child: StatCard(
            title: 'Expenses',
            value: Formatters.formatCurrency(expenses),
            icon: Icons.arrow_upward_rounded,
            color: AppColors.expenseColor,
          ),
        ),
        const SizedBox(width: AppConstants.spacingMD),
        Expanded(
          child: StatCard(
            title: 'Balance',
            value: Formatters.formatCurrency(balance),
            subtitle: '${(savingsRate * 100).toStringAsFixed(1)}% saved',
            icon: balance >= 0
                ? Icons.trending_up_rounded
                : Icons.trending_down_rounded,
            color:
                balance >= 0 ? AppColors.incomeColor : AppColors.expenseColor,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyChart(
    BuildContext context,
    List<Map<String, dynamic>> data,
    double maxY,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Monthly Overview'),
        const SizedBox(height: AppConstants.spacingMD),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingMD),
            child: Column(
              children: [
                IncomeExpenseBarChart(
                  data: data,
                  maxY: maxY > 0 ? maxY * 1.2 : 100000,
                ),
                const SizedBox(height: AppConstants.spacingMD),
                _buildMonthlyLegend(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyLegend(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(theme, 'Income', AppColors.incomeColor),
        const SizedBox(width: AppConstants.spacingLG),
        _buildLegendItem(theme, 'Expenses', AppColors.expenseColor),
      ],
    );
  }

  Widget _buildLegendItem(ThemeData theme, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 6),
        Text(label,
            style: theme.textTheme.bodyMedium
                ?.copyWith(fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildWeeklyChart(
    BuildContext context,
    List<Map<String, dynamic>> data,
    double maxY,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Weekly Spending'),
        const SizedBox(height: AppConstants.spacingMD),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingMD),
            child: WeeklySpendingBarChart(
              data: data,
              maxY: maxY > 0 ? maxY * 1.3 : 10000,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryBreakdown(
    BuildContext context,
    Map<CategoryType, double> categorySpending,
    double totalSpending,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Category Breakdown'),
        const SizedBox(height: AppConstants.spacingMD),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingMD),
            child: Column(
              children: [
                CategoryDonutChart(
                  categorySpending: categorySpending,
                  totalSpending: totalSpending,
                ),
                const SizedBox(height: AppConstants.spacingMD),
                CategoryLegend(
                  categorySpending: categorySpending,
                  totalSpending: totalSpending,
                ),
                const SizedBox(height: AppConstants.spacingMD),
                _buildCategoryList(context, categorySpending, totalSpending),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryList(
    BuildContext context,
    Map<CategoryType, double> categorySpending,
    double totalSpending,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final sortedEntries = categorySpending.entries
        .where((entry) => entry.value > 0)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: sortedEntries.map((entry) {
        final percentage = (entry.value / totalSpending * 100);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: entry.key.color.withValues(alpha: 0.15),
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadiusCircular),
                ),
                child: Icon(entry.key.icon, color: entry.key.color, size: 18),
              ),
              const SizedBox(width: AppConstants.spacingMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key.label,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 2),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusCircular),
                      child: LinearProgressIndicator(
                        value: (entry.value / totalSpending).clamp(0.0, 1.0),
                        minHeight: 4,
                        backgroundColor: colorScheme.surfaceContainerHighest,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(entry.key.color),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppConstants.spacingMD),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Formatters.formatCurrency(entry.value),
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInsights(
    BuildContext context,
    double income,
    double expenses,
    double savingsRate,
    Map<CategoryType, double> categorySpending,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final insights =
        _generateInsights(income, expenses, savingsRate, categorySpending);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Insights'),
        const SizedBox(height: AppConstants.spacingMD),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingMD),
            child: Column(
              children: insights
                  .map((insight) => _buildInsightCard(context, insight))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  List<_Insight> _generateInsights(
    double income,
    double expenses,
    double savingsRate,
    Map<CategoryType, double> categorySpending,
  ) {
    final insights = <_Insight>[];

    if (savingsRate >= 0.3) {
      insights.add(_Insight(
        icon: Icons.star_rounded,
        color: AppColors.incomeColor,
        title: 'Excellent Savings!',
        message:
            'You\'re saving ${(savingsRate * 100).toStringAsFixed(0)}% of your income. Keep it up!',
      ));
    } else if (savingsRate >= 0.2) {
      insights.add(_Insight(
        icon: Icons.thumb_up_rounded,
        color: AppColors.warningColor,
        title: 'Good Savings Rate',
        message:
            'You\'re saving ${(savingsRate * 100).toStringAsFixed(0)}%. Try to reach 30% for optimal financial health.',
      ));
    } else if (savingsRate > 0) {
      insights.add(_Insight(
        icon: Icons.trending_up_rounded,
        color: AppColors.warningColor,
        title: 'Room for Improvement',
        message:
            'Your savings rate is ${(savingsRate * 100).toStringAsFixed(0)}%. Consider reducing discretionary spending.',
      ));
    } else {
      insights.add(_Insight(
        icon: Icons.warning_rounded,
        color: AppColors.expenseColor,
        title: 'Spending Exceeds Income',
        message:
            'You\'re spending more than you earn. Review your expenses immediately.',
      ));
    }

    if (categorySpending.values.any((v) => v > 0)) {
      final topCategory = categorySpending.entries
          .where((e) => e.value > 0)
          .reduce((a, b) => a.value > b.value ? a : b);

      if (topCategory.value > 0 && expenses > 0) {
        final percentage = (topCategory.value / expenses * 100);
        insights.add(_Insight(
          icon: topCategory.key.icon,
          color: topCategory.key.color,
          title: 'Top Spending Category',
          message:
              '${topCategory.key.label} accounts for ${percentage.toStringAsFixed(0)}% of your expenses (${Formatters.formatCurrency(topCategory.value)}).',
        ));
      }
    }

    if (income > 0 && expenses > income * 0.8) {
      insights.add(_Insight(
        icon: Icons.analytics_rounded,
        color: AppColors.warningColor,
        title: 'High Expense Ratio',
        message:
            'Expenses are ${(expenses / income * 100).toStringAsFixed(0)}% of income. Consider reviewing subscriptions and recurring costs.',
      ));
    }

    return insights;
  }

  Widget _buildInsightCard(BuildContext context, _Insight insight) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMD),
      padding: const EdgeInsets.all(AppConstants.spacingMD),
      decoration: BoxDecoration(
        color: insight.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(color: insight.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: insight.color.withValues(alpha: 0.2),
              borderRadius:
                  BorderRadius.circular(AppConstants.borderRadiusCircular),
            ),
            child: Icon(insight.icon, color: insight.color, size: 20),
          ),
          const SizedBox(width: AppConstants.spacingMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: insight.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  insight.message,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
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

class _Insight {
  final IconData icon;
  final Color color;
  final String title;
  final String message;

  _Insight({
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
  });
}
