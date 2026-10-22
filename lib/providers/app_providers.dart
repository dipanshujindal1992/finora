import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finora/models/transaction_model.dart';
import 'package:finora/models/budget_model.dart';
import 'package:finora/models/category_model.dart';
import 'package:finora/models/user_model.dart';
import 'package:finora/data/mock_data.dart';

final transactionListProvider =
    StateNotifierProvider<TransactionListNotifier, List<Transaction>>((ref) {
  return TransactionListNotifier();
});

class TransactionListNotifier extends StateNotifier<List<Transaction>> {
  TransactionListNotifier() : super(MockData.transactions);

  void addTransaction(Transaction transaction) {
    state = [...state, transaction];
  }

  void updateTransaction(Transaction updatedTransaction) {
    state = state
        .map(
            (txn) => txn.id == updatedTransaction.id ? updatedTransaction : txn)
        .toList();
  }

  void deleteTransaction(String id) {
    state = state.where((txn) => txn.id != id).toList();
  }

  void resetToMockData() {
    state = List.from(MockData.transactions);
  }

  List<Transaction> getTransactionsForMonth(DateTime month) {
    return state.where((txn) {
      return txn.date.year == month.year && txn.date.month == month.month;
    }).toList();
  }
}

final budgetListProvider =
    StateNotifierProvider<BudgetListNotifier, List<Budget>>((ref) {
  return BudgetListNotifier();
});

class BudgetListNotifier extends StateNotifier<List<Budget>> {
  BudgetListNotifier() : super(MockData.budgets);

  void addBudget(Budget budget) {
    state = [...state, budget];
  }

  void updateBudget(Budget updatedBudget) {
    state =
        state.map((b) => b.id == updatedBudget.id ? updatedBudget : b).toList();
  }

  void deleteBudget(String id) {
    state = state.where((b) => b.id != id).toList();
  }

  void updateSpent(CategoryType category, double spent, DateTime month) {
    state = state.map((b) {
      if (b.category == category &&
          b.month.year == month.year &&
          b.month.month == month.month) {
        return b.copyWith(spent: spent);
      }
      return b;
    }).toList();
  }

  void resetToMockData() {
    state = List.from(MockData.budgets);
  }

  Budget? getBudgetForCategory(CategoryType category, DateTime month) {
    try {
      return state.firstWhere((b) =>
          b.category == category &&
          b.month.year == month.year &&
          b.month.month == month.month);
    } catch (_) {
      return null;
    }
  }
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
  return UserProfileNotifier();
});

class UserProfileNotifier extends StateNotifier<UserProfile> {
  UserProfileNotifier() : super(MockData.defaultUser);

  void updateProfile(UserProfile updatedProfile) {
    state = updatedProfile;
  }

  void updateThemeMode(AppThemeMode themeMode) {
    state = state.copyWith(themeMode: themeMode);
  }

  void updateCurrency(String currency) {
    state = state.copyWith(currency: currency);
  }

  void toggleNotifications(bool enabled) {
    state = state.copyWith(notificationsEnabled: enabled);
  }

  void toggleBiometric(bool enabled) {
    state = state.copyWith(biometricEnabled: enabled);
  }
}

final selectedMonthProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

final transactionFilterProvider = StateProvider<TransactionFilter>((ref) {
  return TransactionFilter();
});

class TransactionFilter {
  final String searchQuery;
  final TransactionType? typeFilter;
  final CategoryType? categoryFilter;
  final DateTime? startDate;
  final DateTime? endDate;

  TransactionFilter({
    this.searchQuery = '',
    this.typeFilter,
    this.categoryFilter,
    this.startDate,
    this.endDate,
  });

  TransactionFilter copyWith({
    String? searchQuery,
    TransactionType? typeFilter,
    CategoryType? categoryFilter,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return TransactionFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      typeFilter: typeFilter ?? this.typeFilter,
      categoryFilter: categoryFilter ?? this.categoryFilter,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

final filteredTransactionsProvider = Provider<List<Transaction>>((ref) {
  final transactions = ref.watch(transactionListProvider);
  final filter = ref.watch(transactionFilterProvider);
  final selectedMonth = ref.watch(selectedMonthProvider);

  var filtered = transactions.where((txn) {
    return txn.date.year == selectedMonth.year &&
        txn.date.month == selectedMonth.month;
  }).toList();

  if (filter.searchQuery.isNotEmpty) {
    final query = filter.searchQuery.toLowerCase();
    filtered = filtered
        .where((txn) => txn.title.toLowerCase().contains(query))
        .toList();
  }

  if (filter.typeFilter != null) {
    filtered = filtered.where((txn) => txn.type == filter.typeFilter).toList();
  }

  if (filter.categoryFilter != null) {
    filtered =
        filtered.where((txn) => txn.category == filter.categoryFilter).toList();
  }

  if (filter.startDate != null) {
    filtered = filtered
        .where((txn) => txn.date
            .isAfter(filter.startDate!.subtract(const Duration(days: 1))))
        .toList();
  }

  if (filter.endDate != null) {
    filtered = filtered
        .where((txn) =>
            txn.date.isBefore(filter.endDate!.add(const Duration(days: 1))))
        .toList();
  }

  filtered.sort((a, b) => b.date.compareTo(a.date));
  return filtered;
});

final monthlyIncomeProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionListProvider);
  final selectedMonth = ref.watch(selectedMonthProvider);
  return transactions
      .where((t) =>
          t.type == TransactionType.income &&
          t.date.year == selectedMonth.year &&
          t.date.month == selectedMonth.month)
      .fold(0.0, (sum, t) => sum + t.amount);
});

final monthlyExpensesProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionListProvider);
  final selectedMonth = ref.watch(selectedMonthProvider);
  return transactions
      .where((t) =>
          t.type == TransactionType.expense &&
          t.date.year == selectedMonth.year &&
          t.date.month == selectedMonth.month)
      .fold(0.0, (sum, t) => sum + t.amount);
});

final monthlyBalanceProvider = Provider<double>((ref) {
  final income = ref.watch(monthlyIncomeProvider);
  final expenses = ref.watch(monthlyExpensesProvider);
  return income - expenses;
});

final categorySpendingProvider = Provider<Map<CategoryType, double>>((ref) {
  final transactions = ref.watch(transactionListProvider);
  final selectedMonth = ref.watch(selectedMonthProvider);

  final Map<CategoryType, double> spending = {};
  for (var cat in CategoryType.values) {
    spending[cat] = 0.0;
  }

  for (var txn in transactions) {
    if (txn.type == TransactionType.expense &&
        txn.date.year == selectedMonth.year &&
        txn.date.month == selectedMonth.month) {
      spending[txn.category] = (spending[txn.category] ?? 0) + txn.amount;
    }
  }
  return spending;
});

final savingsRateProvider = Provider<double>((ref) {
  final income = ref.watch(monthlyIncomeProvider);
  final expenses = ref.watch(monthlyExpensesProvider);
  if (income == 0) return 0.0;
  return ((income - expenses) / income).clamp(0.0, 1.0);
});

final weeklySpendingProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final transactions = ref.watch(transactionListProvider);
  final selectedMonth = ref.watch(selectedMonthProvider);

  final List<Map<String, dynamic>> weeklyData = [];
  DateTime weekStart = DateTime(selectedMonth.year, selectedMonth.month, 1);

  while (weekStart.month == selectedMonth.month) {
    final weekEnd = weekStart.add(const Duration(days: 6));
    final weekTxns = transactions.where((txn) {
      return txn.type == TransactionType.expense &&
          txn.date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
          txn.date.isBefore(weekEnd.add(const Duration(days: 1)));
    }).toList();
    final total = weekTxns.fold(0.0, (sum, t) => sum + t.amount);
    weeklyData.add({
      'week': 'W${weeklyData.length + 1}',
      'start': weekStart,
      'end': weekEnd,
      'amount': total,
    });
    weekStart = weekStart.add(const Duration(days: 7));
  }
  return weeklyData;
});

final monthlyComparisonProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final transactions = ref.watch(transactionListProvider);
  final months = [
    DateTime(2026, 5),
    DateTime(2026, 6),
    DateTime(2026, 7),
    DateTime(2026, 8),
    DateTime(2026, 9),
    DateTime(2026, 10),
  ];
  return months.map((month) {
    final income = transactions
        .where((t) =>
            t.type == TransactionType.income &&
            t.date.year == month.year &&
            t.date.month == month.month)
        .fold(0.0, (sum, t) => sum + t.amount);
    final expenses = transactions
        .where((t) =>
            t.type == TransactionType.expense &&
            t.date.year == month.year &&
            t.date.month == month.month)
        .fold(0.0, (sum, t) => sum + t.amount);
    return {
      'month': _getMonthName(month.month),
      'income': income,
      'expenses': expenses,
    };
  }).toList();
});

String _getMonthName(int month) {
  const names = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  return names[month - 1];
}
