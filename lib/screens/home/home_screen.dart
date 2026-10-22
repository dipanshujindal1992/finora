import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finora/providers/app_providers.dart';
import 'package:finora/providers/settings_providers.dart';
import 'package:finora/models/transaction_model.dart';
import 'package:finora/models/user_model.dart';
import 'package:finora/models/category_model.dart';
import 'package:finora/core/theme/app_theme.dart';
import 'package:finora/widgets/balance_card.dart';
import 'package:finora/widgets/charts.dart';
import 'package:finora/widgets/common_widgets.dart';
import 'package:finora/widgets/transaction_tile.dart';
import 'package:finora/screens/add_transaction/add_transaction_screen.dart';
import 'package:finora/core/constants/app_constants.dart';
import 'package:finora/core/utils/formatters.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(monthlyBalanceProvider);
    final income = ref.watch(monthlyIncomeProvider);
    final expenses = ref.watch(monthlyExpensesProvider);
    final savingsRate = ref.watch(savingsRateProvider);
    final selectedMonth = ref.watch(selectedMonthProvider);
    final user = ref.watch(userProfileProvider);
    final categorySpending = ref.watch(categorySpendingProvider);
    final monthlyComparison = ref.watch(monthlyComparisonProvider);
    final recentTransactions =
        ref.watch(filteredTransactionsProvider).take(5).toList();

    final maxMonthly = monthlyComparison
        .map((m) => (m['income'] as double) + (m['expenses'] as double))
        .fold(0.0, (a, b) => a > b ? a : b);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, user, selectedMonth, ref),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spacingMD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BalanceCard(
                    balance: balance,
                    income: income,
                    expenses: expenses,
                    onTap: () => _showBalanceDetails(context, ref),
                  ),
                  const SizedBox(height: AppConstants.spacingLG),
                  _buildQuickActions(context, ref),
                  const SizedBox(height: AppConstants.spacingLG),
                  _buildIncomeExpenseChart(
                      context, monthlyComparison, maxMonthly),
                  const SizedBox(height: AppConstants.spacingLG),
                  _buildSavingsAndCategory(
                      context, savingsRate, categorySpending),
                  const SizedBox(height: AppConstants.spacingLG),
                  _buildRecentTransactions(context, recentTransactions, ref),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddTransaction(context),
        child: const Icon(Icons.add_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildSliverAppBar(
    BuildContext context,
    UserProfile user,
    DateTime selectedMonth,
    WidgetRef ref,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final greeting = _getGreeting();

    return SliverAppBar(
      expandedHeight: 140,
      floating: false,
      pinned: true,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: colorScheme.surface,
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppConstants.spacingMD,
              AppConstants.spacingMD,
              AppConstants.spacingMD,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$greeting, ${user.name.split(' ').first}',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          Formatters.formatMonth(selectedMonth),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => _showMonthPicker(context, ref),
                          icon: Icon(
                            Icons.calendar_month_outlined,
                            color: colorScheme.onSurface,
                          ),
                          tooltip: 'Select Month',
                        ),
                        IconButton(
                          onPressed: () => _showNotifications(context),
                          icon: Icon(
                            Icons.notifications_outlined,
                            color: colorScheme.onSurface,
                          ),
                          tooltip: 'Notifications',
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  Widget _buildQuickActions(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Quick Actions',
          onAction: () => _navigateToAddTransaction(context),
          actionLabel: 'Add Transaction',
          actionIcon: Icons.add_rounded,
        ),
        const SizedBox(height: AppConstants.spacingMD),
        Row(
          children: [
            Expanded(
              child: QuickActionButton(
                icon: Icons.add_circle_outline_rounded,
                label: 'Add Income',
                color: AppColors.incomeColor,
                onTap: () => _navigateToAddTransaction(context,
                    type: TransactionType.income),
              ),
            ),
            const SizedBox(width: AppConstants.spacingSM),
            Expanded(
              child: QuickActionButton(
                icon: Icons.remove_circle_outline_rounded,
                label: 'Add Expense',
                color: AppColors.expenseColor,
                onTap: () => _navigateToAddTransaction(context,
                    type: TransactionType.expense),
              ),
            ),
            const SizedBox(width: AppConstants.spacingSM),
            Expanded(
              child: QuickActionButton(
                icon: Icons.swap_horiz_rounded,
                label: 'Transfer',
                color: AppColors.warningColor,
                onTap: () => _showTransferDialog(context),
              ),
            ),
            const SizedBox(width: AppConstants.spacingSM),
            Expanded(
              child: QuickActionButton(
                icon: Icons.analytics_outlined,
                label: 'Reports',
                color: Theme.of(context).colorScheme.primary,
                onTap: () => _navigateToAnalytics(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIncomeExpenseChart(
    BuildContext context,
    List<Map<String, dynamic>> data,
    double maxY,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Income vs Expenses',
          subtitle: 'Last 6 months',
        ),
        const SizedBox(height: AppConstants.spacingMD),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingMD),
            child: IncomeExpenseBarChart(
              data: data,
              maxY: maxY > 0 ? maxY * 1.2 : 100000,
            ),
          ),
        ),
        const SizedBox(height: AppConstants.spacingMD),
        _buildLegendRow(context),
      ],
    );
  }

  Widget _buildLegendRow(BuildContext context) {
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
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSavingsAndCategory(
    BuildContext context,
    double savingsRate,
    Map<CategoryType, double> categorySpending,
  ) {
    final totalSpending = categorySpending.values.fold(0.0, (a, b) => a + b);

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SavingsRateIndicator(savingsRate: savingsRate),
        ),
        const SizedBox(width: AppConstants.spacingMD),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(title: 'Spending by Category'),
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactions(
    BuildContext context,
    List<Transaction> transactions,
    WidgetRef ref,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Recent Transactions',
          onAction: () => _navigateToTransactions(context),
          actionLabel: 'View All',
        ),
        const SizedBox(height: AppConstants.spacingMD),
        if (transactions.isEmpty)
          Card(
            child: EmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'No transactions yet',
              message: 'Add your first transaction to get started',
              actionLabel: 'Add Transaction',
              onAction: () => _navigateToAddTransaction(context),
            ),
          )
        else
          Card(
            child: Column(
              children: transactions.asMap().entries.map((entry) {
                final index = entry.key;
                final transaction = entry.value;
                final isLast = index == transactions.length - 1;

                return Column(
                  children: [
                    TransactionTile(
                      transaction: transaction,
                      onTap: () =>
                          _showTransactionDetails(context, transaction),
                    ),
                    if (!isLast)
                      Divider(
                        height: 1,
                        indent: 60,
                        endIndent: 16,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  void _navigateToAddTransaction(BuildContext context,
      {TransactionType type = TransactionType.expense}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTransactionScreen(initialType: type),
      ),
    );
  }

  void _navigateToTransactions(BuildContext context) {
    // This would be handled by the bottom nav bar
  }

  void _navigateToAnalytics(BuildContext context) {
    // This would be handled by the bottom nav bar
  }

  void _showBalanceDetails(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _BalanceDetailsSheet(),
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

  void _showNotifications(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notifications coming soon!')),
    );
  }

  void _showTransferDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transfer feature coming soon!')),
    );
  }

  void _showTransactionDetails(BuildContext context, Transaction transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TransactionDetailsSheet(transaction: transaction),
    );
  }
}

class _BalanceDetailsSheet extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final income = ref.watch(monthlyIncomeProvider);
    final expenses = ref.watch(monthlyExpensesProvider);
    final balance = ref.watch(monthlyBalanceProvider);
    final savingsRate = ref.watch(savingsRateProvider);

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
          Text(
            'Balance Details',
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppConstants.spacingLG),
          Row(
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
            ],
          ),
          const SizedBox(height: AppConstants.spacingMD),
          StatCard(
            title: 'Net Balance',
            value: Formatters.formatCurrency(balance),
            subtitle:
                'Savings rate: ${(savingsRate * 100).toStringAsFixed(1)}%',
            icon: balance >= 0
                ? Icons.trending_up_rounded
                : Icons.trending_down_rounded,
            color:
                balance >= 0 ? AppColors.incomeColor : AppColors.expenseColor,
          ),
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
          Text(
            'Select Month',
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
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

class _TransactionDetailsSheet extends ConsumerWidget {
  final Transaction transaction;

  const _TransactionDetailsSheet({required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isIncome = transaction.type == TransactionType.income;

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
                  color:
                      isIncome ? AppColors.incomeLight : AppColors.expenseLight,
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadiusCircular),
                ),
                child: Icon(
                  transaction.category.icon,
                  color:
                      isIncome ? AppColors.incomeColor : AppColors.expenseColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      transaction.category.label,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Text(
                '${isIncome ? '+' : '-'}${Formatters.formatCurrency(transaction.amount)}',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color:
                      isIncome ? AppColors.incomeColor : AppColors.expenseColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingLG),
          Divider(color: colorScheme.outlineVariant),
          const SizedBox(height: AppConstants.spacingMD),
          _buildDetailRow(
              context, 'Date', Formatters.formatDateTime(transaction.date)),
          _buildDetailRow(context, 'Payment Method', transaction.paymentMethod),
          if (transaction.note != null && transaction.note!.isNotEmpty)
            _buildDetailRow(context, 'Note', transaction.note!),
          _buildDetailRow(context, 'Type', isIncome ? 'Income' : 'Expense'),
          const SizedBox(height: AppConstants.spacingLG),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddTransactionScreen(
                            editingTransaction: transaction),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Edit'),
                ),
              ),
              const SizedBox(width: AppConstants.spacingMD),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    ref
                        .read(transactionListProvider.notifier)
                        .deleteTransaction(transaction.id);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Transaction deleted')),
                    );
                  },
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('Delete'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.expenseColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
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
                  ?.copyWith(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
