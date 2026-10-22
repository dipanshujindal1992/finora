import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finora/models/transaction_model.dart';
import 'package:finora/models/category_model.dart';
import 'package:finora/providers/app_providers.dart'
    show transactionListProvider;
import 'package:finora/widgets/common_widgets.dart'
    show
        CategoryChipGroup,
        AmountInputField,
        DatePickerField,
        NoteInputField,
        SearchField,
        SectionHeader;
import 'package:finora/core/theme/app_theme.dart';
import 'package:finora/core/constants/app_constants.dart';
import 'package:finora/core/utils/formatters.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  final TransactionType initialType;
  final Transaction? editingTransaction;

  const AddTransactionScreen({
    super.key,
    this.initialType = TransactionType.expense,
    this.editingTransaction,
  });

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _searchController = TextEditingController();

  late TransactionType _selectedType;
  late CategoryType _selectedCategory;
  late DateTime _selectedDate;
  late String _selectedPaymentMethod;
  bool _isLoading = false;

  static const List<String> _paymentMethods = [
    'UPI',
    'Credit Card',
    'Debit Card',
    'Net Banking',
    'Cash',
    'Wallet',
    'Auto Pay',
    'Bank Transfer',
  ];

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
    _selectedDate = DateTime.now();
    _selectedPaymentMethod = 'UPI';

    if (widget.editingTransaction != null) {
      final txn = widget.editingTransaction!;
      _titleController.text = txn.title;
      _amountController.text = txn.amount.toStringAsFixed(2);
      _noteController.text = txn.note ?? '';
      _selectedType = txn.type;
      _selectedCategory = txn.category;
      _selectedDate = txn.date;
      _selectedPaymentMethod = txn.paymentMethod;
    } else {
      _selectedCategory = _selectedType == TransactionType.income
          ? CategoryType.salary
          : CategoryType.food;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEditing = widget.editingTransaction != null;
    final isIncome = _selectedType == TransactionType.income;
    final categories = CategoryType.values
        .where((c) => isIncome ? c.isIncomeCategory : !c.isIncomeCategory)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Transaction' : 'Add Transaction'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close_rounded),
        ),
      ),
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingMD),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTypeSelector(context),
                    const SizedBox(height: AppConstants.spacingLG),
                    _buildAmountField(context),
                    const SizedBox(height: AppConstants.spacingLG),
                    _buildTitleField(context),
                    const SizedBox(height: AppConstants.spacingLG),
                    _buildCategorySelector(context, categories),
                    const SizedBox(height: AppConstants.spacingLG),
                    _buildDateField(context),
                    const SizedBox(height: AppConstants.spacingLG),
                    _buildPaymentMethodSelector(context),
                    const SizedBox(height: AppConstants.spacingLG),
                    _buildNoteField(context),
                    const SizedBox(height: AppConstants.spacingXL),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context, isEditing, isIncome),
    );
  }

  Widget _buildTypeSelector(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Type',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: AppConstants.spacingMD),
        Row(
          children: [
            Expanded(
              child: _buildTypeCard(
                context,
                'Income',
                Icons.arrow_downward_rounded,
                AppColors.incomeColor,
                TransactionType.income,
              ),
            ),
            const SizedBox(width: AppConstants.spacingMD),
            Expanded(
              child: _buildTypeCard(
                context,
                'Expense',
                Icons.arrow_upward_rounded,
                AppColors.expenseColor,
                TransactionType.expense,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeCard(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    TransactionType type,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = _selectedType == type;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedType = type;
          _selectedCategory = type == TransactionType.income
              ? CategoryType.salary
              : CategoryType.food;
        });
      },
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingLG),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.15)
              : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          border: Border.all(
            color: isSelected ? color : colorScheme.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon,
                color: isSelected ? color : colorScheme.onSurfaceVariant,
                size: 28),
            const SizedBox(height: AppConstants.spacingSM),
            Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? color : colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountField(BuildContext context) {
    return AmountInputField(
      controller: _amountController,
      label: 'Amount',
      hint: 'Enter amount',
      errorText: _amountController.text.isNotEmpty &&
              double.tryParse(_amountController.text) == null
          ? 'Invalid amount'
          : null,
      autofocus: widget.editingTransaction == null,
    );
  }

  Widget _buildTitleField(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TextFormField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText: 'Title',
        hintText: 'e.g., Groceries, Salary, Rent',
        prefixIcon:
            Icon(Icons.title_rounded, color: colorScheme.onSurfaceVariant),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a title';
        }
        return null;
      },
    );
  }

  Widget _buildCategorySelector(
      BuildContext context, List<CategoryType> categories) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: AppConstants.spacingMD),
        CategoryChipGroup(
          categories: categories,
          selectedCategory: _selectedCategory,
          onCategorySelected: (category) =>
              setState(() => _selectedCategory = category),
          isIncomeCategory: _selectedType == TransactionType.income,
        ),
      ],
    );
  }

  Widget _buildDateField(BuildContext context) {
    return DatePickerField(
      selectedDate: _selectedDate,
      onDateSelected: (date) => setState(() => _selectedDate = date),
      label: 'Date',
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
  }

  Widget _buildPaymentMethodSelector(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Method',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: AppConstants.spacingMD),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _paymentMethods.map((method) {
            final isSelected = _selectedPaymentMethod == method;
            return FilterChip(
              selected: isSelected,
              onSelected: (_) =>
                  setState(() => _selectedPaymentMethod = method),
              label: Text(method),
              selectedColor: colorScheme.primaryContainer,
              labelStyle: theme.textTheme.labelLarge?.copyWith(
                color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              backgroundColor:
                  colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              side: BorderSide(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.outlineVariant,
                width: isSelected ? 2 : 1,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadiusCircular)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNoteField(BuildContext context) {
    return NoteInputField(
      controller: _noteController,
      label: 'Note (optional)',
      hint: 'Add a note...',
    );
  }

  Widget _buildBottomBar(BuildContext context, bool isEditing, bool isIncome) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingMD),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _isLoading ? null : () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusMedium)),
                ),
                child: Text(isEditing ? 'Cancel' : 'Cancel',
                    style: theme.textTheme.labelLarge),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMD),
            Expanded(
              child: FilledButton(
                onPressed: _isLoading ? null : _saveTransaction,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusMedium)),
                  backgroundColor:
                      isIncome ? AppColors.incomeColor : colorScheme.primary,
                ),
                child: _isLoading
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.onPrimary,
                        ),
                      )
                    : Text(
                        isEditing ? 'Update' : 'Save',
                        style: theme.textTheme.labelLarge
                            ?.copyWith(color: colorScheme.onPrimary),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final amount = double.parse(_amountController.text);
      final transaction = Transaction(
        id: widget.editingTransaction?.id,
        title: _titleController.text.trim(),
        amount: amount,
        type: _selectedType,
        category: _selectedCategory,
        date: _selectedDate,
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
        paymentMethod: _selectedPaymentMethod,
        createdAt: widget.editingTransaction?.createdAt,
      );

      if (widget.editingTransaction != null) {
        ref
            .read(transactionListProvider.notifier)
            .updateTransaction(transaction);
      } else {
        ref.read(transactionListProvider.notifier).addTransaction(transaction);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.editingTransaction != null
                ? 'Transaction updated'
                : 'Transaction added'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error: $e'),
              backgroundColor: AppColors.expenseColor),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
