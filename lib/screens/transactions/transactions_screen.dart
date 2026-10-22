import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finora/models/transaction_model.dart';
import 'package:finora/models/category_model.dart';
import 'package:finora/providers/app_providers.dart';
import 'package:finora/widgets/transaction_tile.dart';
import 'package:finora/widgets/common_widgets.dart';
import 'package:finora/screens/add_transaction/add_transaction_screen.dart';
import 'package:finora/core/theme/app_theme.dart';
import 'package:finora/core/constants/app_constants.dart';
import 'package:finora/core/utils/formatters.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedTypeFilter = 'All';
  CategoryType? _selectedCategoryFilter;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(filteredTransactionsProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            onPressed: () => _showFilterBottomSheet(context),
            icon: Icon(
              Icons.filter_list_rounded,
              color: _hasActiveFilters()
                  ? colorScheme.primary
                  : colorScheme.onSurface,
            ),
            tooltip: 'Filters',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilters(context),
          Expanded(
            child: transactions.isEmpty
                ? _buildEmptyState(context)
                : _buildTransactionsList(context, transactions),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddTransaction(context),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildSearchAndFilters(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMD),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      child: Column(
        children: [
          SearchField(
            controller: _searchController,
            hintText: 'Search transactions...',
            onChanged: (query) {
              ref.read(transactionFilterProvider.notifier).state = ref
                  .read(transactionFilterProvider)
                  .copyWith(searchQuery: query);
            },
            onClear: () {
              _searchController.clear();
              ref.read(transactionFilterProvider.notifier).state =
                  ref.read(transactionFilterProvider).copyWith(searchQuery: '');
            },
          ),
          const SizedBox(height: AppConstants.spacingSM),
          FilterChipGroup(
            filters: const ['All', 'Income', 'Expense'],
            selectedFilter: _selectedTypeFilter,
            onFilterSelected: (filter) {
              setState(() => _selectedTypeFilter = filter);
              ref.read(transactionFilterProvider.notifier).state = ref
                  .read(transactionFilterProvider)
                  .copyWith(
                    typeFilter: filter == 'All'
                        ? null
                        : TransactionType.values.byName(filter.toLowerCase()),
                  );
            },
          ),
          if (_selectedCategoryFilter != null ||
              _startDate != null ||
              _endDate != null) ...[
            const SizedBox(height: AppConstants.spacingSM),
            _buildActiveFiltersChips(context),
          ],
        ],
      ),
    );
  }

  Widget _buildActiveFiltersChips(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final List<Widget> chips = [];

    if (_selectedCategoryFilter != null) {
      chips.add(
        Chip(
          label: Text(_selectedCategoryFilter!.label),
          avatar: Icon(_selectedCategoryFilter!.icon,
              size: 16, color: _selectedCategoryFilter!.color),
          onDeleted: () {
            setState(() => _selectedCategoryFilter = null);
            ref.read(transactionFilterProvider.notifier).state = ref
                .read(transactionFilterProvider)
                .copyWith(categoryFilter: null);
          },
          deleteIconColor: colorScheme.onSurfaceVariant,
        ),
      );
    }

    if (_startDate != null || _endDate != null) {
      String dateLabel = '';
      if (_startDate != null && _endDate != null) {
        dateLabel =
            '${Formatters.formatDateShort(_startDate!)} - ${Formatters.formatDateShort(_endDate!)}';
      } else if (_startDate != null) {
        dateLabel = 'From ${Formatters.formatDateShort(_startDate!)}';
      } else if (_endDate != null) {
        dateLabel = 'Until ${Formatters.formatDateShort(_endDate!)}';
      }

      chips.add(
        Chip(
          label: Text(dateLabel),
          avatar: const Icon(Icons.date_range_rounded, size: 16),
          onDeleted: () {
            setState(() {
              _startDate = null;
              _endDate = null;
            });
            ref.read(transactionFilterProvider.notifier).state = ref
                .read(transactionFilterProvider)
                .copyWith(startDate: null, endDate: null);
          },
          deleteIconColor: colorScheme.onSurfaceVariant,
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        Text('Active filters:',
            style: theme.textTheme.labelSmall
                ?.copyWith(color: colorScheme.onSurfaceVariant)),
        ...chips,
      ],
    );
  }

  Widget _buildTransactionsList(
      BuildContext context, List<Transaction> transactions) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppConstants.spacingMD),
      itemCount: transactions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 4),
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return TransactionTileAnimated(
          transaction: transaction,
          onTap: () => _showTransactionDetails(context, transaction),
          onDelete: () => _confirmDeleteTransaction(context, transaction),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final filter = ref.watch(transactionFilterProvider);
    final hasFilters = filter.searchQuery.isNotEmpty ||
        filter.typeFilter != null ||
        filter.categoryFilter != null ||
        filter.startDate != null ||
        filter.endDate != null;

    return EmptyState(
      icon: hasFilters ? Icons.search_off_rounded : Icons.receipt_long_outlined,
      title: hasFilters ? 'No matching transactions' : 'No transactions yet',
      message: hasFilters
          ? 'Try adjusting your filters or search query'
          : 'Add your first transaction to get started',
      actionLabel: hasFilters ? 'Clear Filters' : 'Add Transaction',
      onAction: hasFilters
          ? () {
              _searchController.clear();
              setState(() {
                _selectedTypeFilter = 'All';
                _selectedCategoryFilter = null;
                _startDate = null;
                _endDate = null;
              });
              ref.read(transactionFilterProvider.notifier).state =
                  TransactionFilter();
            }
          : () => _navigateToAddTransaction(context),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FilterBottomSheet(
        selectedCategory: _selectedCategoryFilter,
        startDate: _startDate,
        endDate: _endDate,
        onApply: (category, startDate, endDate) {
          setState(() {
            _selectedCategoryFilter = category;
            _startDate = startDate;
            _endDate = endDate;
          });
          ref.read(transactionFilterProvider.notifier).state =
              ref.read(transactionFilterProvider).copyWith(
                    categoryFilter: category,
                    startDate: startDate,
                    endDate: endDate,
                  );
          Navigator.pop(context);
        },
        onClear: () {
          setState(() {
            _selectedCategoryFilter = null;
            _startDate = null;
            _endDate = null;
          });
          ref.read(transactionFilterProvider.notifier).state =
              ref.read(transactionFilterProvider).copyWith(
                    categoryFilter: null,
                    startDate: null,
                    endDate: null,
                  );
          Navigator.pop(context);
        },
      ),
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

  void _confirmDeleteTransaction(
      BuildContext context, Transaction transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction'),
        content:
            Text('Are you sure you want to delete "${transaction.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref
                  .read(transactionListProvider.notifier)
                  .deleteTransaction(transaction.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Transaction deleted')),
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

  void _navigateToAddTransaction(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
    );
  }

  bool _hasActiveFilters() {
    final filter = ref.read(transactionFilterProvider);
    return filter.searchQuery.isNotEmpty ||
        filter.typeFilter != null ||
        filter.categoryFilter != null ||
        filter.startDate != null ||
        filter.endDate != null;
  }
}

class _FilterBottomSheet extends ConsumerStatefulWidget {
  final CategoryType? selectedCategory;
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(CategoryType?, DateTime?, DateTime?) onApply;
  final VoidCallback onClear;

  const _FilterBottomSheet({
    required this.selectedCategory,
    required this.startDate,
    required this.endDate,
    required this.onApply,
    required this.onClear,
  });

  @override
  ConsumerState<_FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<_FilterBottomSheet> {
  late CategoryType? _selectedCategory;
  late DateTime? _startDate;
  late DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategory;
    _startDate = widget.startDate;
    _endDate = widget.endDate;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final expenseCategories =
        CategoryType.values.where((c) => !c.isIncomeCategory).toList();
    final incomeCategories =
        CategoryType.values.where((c) => c.isIncomeCategory).toList();

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Filters',
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600)),
              TextButton(
                onPressed: widget.onClear,
                child: const Text('Clear All'),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingLG),
          _buildCategorySection(
              context, 'Expense Categories', expenseCategories, false),
          const SizedBox(height: AppConstants.spacingLG),
          _buildCategorySection(
              context, 'Income Categories', incomeCategories, true),
          const SizedBox(height: AppConstants.spacingLG),
          _buildDateRangeSection(context),
          const SizedBox(height: AppConstants.spacingLG),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onClear,
                  child: const Text('Clear'),
                ),
              ),
              const SizedBox(width: AppConstants.spacingMD),
              Expanded(
                child: FilledButton(
                  onPressed: () =>
                      widget.onApply(_selectedCategory, _startDate, _endDate),
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    String title,
    List<CategoryType> categories,
    bool isIncome,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: AppConstants.spacingMD),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilterChip(
              selected: _selectedCategory == null,
              onSelected: (_) => setState(() => _selectedCategory = null),
              label: const Text('All'),
              backgroundColor: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.3),
            ),
            ...categories.map((cat) => CategoryChip(
                  category: cat,
                  isSelected: _selectedCategory == cat,
                  onTap: () => setState(() => _selectedCategory = cat),
                  isIncomeCategory: isIncome,
                )),
          ],
        ),
      ],
    );
  }

  Widget _buildDateRangeSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Date Range',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: AppConstants.spacingMD),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _startDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: _endDate ?? DateTime.now(),
                  );
                  if (date != null) setState(() => _startDate = date);
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'From',
                    prefixIcon: Icon(Icons.calendar_today_rounded,
                        color: colorScheme.onSurfaceVariant),
                  ),
                  child: Text(_startDate != null
                      ? Formatters.formatDateShort(_startDate!)
                      : 'Select'),
                ),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMD),
            Expanded(
              child: InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _endDate ?? DateTime.now(),
                    firstDate: _startDate ?? DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) setState(() => _endDate = date);
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'To',
                    prefixIcon: Icon(Icons.calendar_today_rounded,
                        color: colorScheme.onSurfaceVariant),
                  ),
                  child: Text(_endDate != null
                      ? Formatters.formatDateShort(_endDate!)
                      : 'Select'),
                ),
              ),
            ),
          ],
        ),
      ],
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
                      backgroundColor: AppColors.expenseColor),
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
