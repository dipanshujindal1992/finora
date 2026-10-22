import 'package:finora/models/transaction_model.dart';
import 'package:finora/models/budget_model.dart';
import 'package:finora/models/category_model.dart';
import 'package:finora/models/user_model.dart';

class MockData {
  static final List<Transaction> transactions = [
    Transaction(
      id: 'txn_1',
      title: 'Salary Credit',
      amount: 65000.00,
      type: TransactionType.income,
      category: CategoryType.salary,
      date: DateTime(2026, 10, 1),
      paymentMethod: 'Bank Transfer',
      note: 'Monthly salary from TechCorp',
    ),
    Transaction(
      id: 'txn_2',
      title: 'Big Bazaar',
      amount: 3240.50,
      type: TransactionType.expense,
      category: CategoryType.food,
      date: DateTime(2026, 10, 2),
      paymentMethod: 'UPI',
      note: 'Groceries for the week',
    ),
    Transaction(
      id: 'txn_3',
      title: 'Uber Ride',
      amount: 245.00,
      type: TransactionType.expense,
      category: CategoryType.transport,
      date: DateTime(2026, 10, 2),
      paymentMethod: 'UPI',
      note: 'Office to home',
    ),
    Transaction(
      id: 'txn_4',
      title: 'Amazon Purchase',
      amount: 2899.00,
      type: TransactionType.expense,
      category: CategoryType.shopping,
      date: DateTime(2026, 10, 3),
      paymentMethod: 'Credit Card',
      note: 'Wireless headphones',
    ),
    Transaction(
      id: 'txn_5',
      title: 'Electricity Bill',
      amount: 1850.00,
      type: TransactionType.expense,
      category: CategoryType.bills,
      date: DateTime(2026, 10, 4),
      paymentMethod: 'Net Banking',
      note: 'BSES Rajdhani - October',
    ),
    Transaction(
      id: 'txn_6',
      title: 'Swiggy Order',
      amount: 485.00,
      type: TransactionType.expense,
      category: CategoryType.food,
      date: DateTime(2026, 10, 4),
      paymentMethod: 'UPI',
      note: 'Lunch delivery',
    ),
    Transaction(
      id: 'txn_7',
      title: 'Metro Recharge',
      amount: 500.00,
      type: TransactionType.expense,
      category: CategoryType.transport,
      date: DateTime(2026, 10, 5),
      paymentMethod: 'Debit Card',
      note: 'Monthly metro pass',
    ),
    Transaction(
      id: 'txn_8',
      title: 'Netflix Subscription',
      amount: 649.00,
      type: TransactionType.expense,
      category: CategoryType.entertainment,
      date: DateTime(2026, 10, 5),
      paymentMethod: 'Credit Card',
      note: 'Premium plan',
    ),
    Transaction(
      id: 'txn_9',
      title: 'Apollo Pharmacy',
      amount: 1250.00,
      type: TransactionType.expense,
      category: CategoryType.health,
      date: DateTime(2026, 10, 6),
      paymentMethod: 'UPI',
      note: 'Medicines and supplements',
    ),
    Transaction(
      id: 'txn_10',
      title: 'Zomato Gold',
      amount: 299.00,
      type: TransactionType.expense,
      category: CategoryType.entertainment,
      date: DateTime(2026, 10, 7),
      paymentMethod: 'UPI',
      note: 'Annual subscription renewal',
    ),
    Transaction(
      id: 'txn_11',
      title: 'Freelance Project',
      amount: 15000.00,
      type: TransactionType.income,
      category: CategoryType.investment,
      date: DateTime(2026, 10, 8),
      paymentMethod: 'Bank Transfer',
      note: 'UI/UX design project',
    ),
    Transaction(
      id: 'txn_12',
      title: 'Petrol Pump',
      amount: 2100.00,
      type: TransactionType.expense,
      category: CategoryType.transport,
      date: DateTime(2026, 10, 9),
      paymentMethod: 'Credit Card',
      note: 'Full tank - Honda City',
    ),
    Transaction(
      id: 'txn_13',
      title: 'Myntra Order',
      amount: 1799.00,
      type: TransactionType.expense,
      category: CategoryType.shopping,
      date: DateTime(2026, 10, 10),
      paymentMethod: 'UPI',
      note: 'Winter jackets',
    ),
    Transaction(
      id: 'txn_14',
      title: 'Internet Bill',
      amount: 799.00,
      type: TransactionType.expense,
      category: CategoryType.bills,
      date: DateTime(2026, 10, 11),
      paymentMethod: 'Auto Pay',
      note: 'JioFiber - October',
    ),
    Transaction(
      id: 'txn_15',
      title: 'Gym Membership',
      amount: 3000.00,
      type: TransactionType.expense,
      category: CategoryType.health,
      date: DateTime(2026, 10, 12),
      paymentMethod: 'Debit Card',
      note: 'Quarterly renewal - Cult.fit',
    ),
    Transaction(
      id: 'txn_16',
      title: 'Starbucks',
      amount: 385.00,
      type: TransactionType.expense,
      category: CategoryType.food,
      date: DateTime(2026, 10, 13),
      paymentMethod: 'UPI',
      note: 'Coffee with colleagues',
    ),
    Transaction(
      id: 'txn_17',
      title: 'Stock Dividend',
      amount: 2450.00,
      type: TransactionType.income,
      category: CategoryType.investment,
      date: DateTime(2026, 10, 14),
      paymentMethod: 'Bank Transfer',
      note: 'RELIANCE quarterly dividend',
    ),
    Transaction(
      id: 'txn_18',
      title: 'BookMyShow',
      amount: 850.00,
      type: TransactionType.expense,
      category: CategoryType.entertainment,
      date: DateTime(2026, 10, 15),
      paymentMethod: 'Credit Card',
      note: 'Movie tickets x2',
    ),
    Transaction(
      id: 'txn_19',
      title: 'Mobile Recharge',
      amount: 299.00,
      type: TransactionType.expense,
      category: CategoryType.bills,
      date: DateTime(2026, 10, 16),
      paymentMethod: 'UPI',
      note: 'Airtel prepaid - 84 days',
    ),
    Transaction(
      id: 'txn_20',
      title: 'Flipkart Grocery',
      amount: 1650.00,
      type: TransactionType.expense,
      category: CategoryType.food,
      date: DateTime(2026, 10, 17),
      paymentMethod: 'UPI',
      note: 'Monthly grocery stock-up',
    ),
    Transaction(
      id: 'txn_21',
      title: 'Ola Ride',
      amount: 180.00,
      type: TransactionType.expense,
      category: CategoryType.transport,
      date: DateTime(2026, 10, 18),
      paymentMethod: 'UPI',
      note: 'Airport drop',
    ),
    Transaction(
      id: 'txn_22',
      title: 'Medical Checkup',
      amount: 2500.00,
      type: TransactionType.expense,
      category: CategoryType.health,
      date: DateTime(2026, 10, 19),
      paymentMethod: 'Credit Card',
      note: 'Annual health screening',
    ),
    Transaction(
      id: 'txn_23',
      title: 'Investment Return',
      amount: 5000.00,
      type: TransactionType.income,
      category: CategoryType.investment,
      date: DateTime(2026, 10, 20),
      paymentMethod: 'Bank Transfer',
      note: 'Mutual fund redemption',
    ),
    Transaction(
      id: 'txn_24',
      title: 'Croma Store',
      amount: 4500.00,
      type: TransactionType.expense,
      category: CategoryType.shopping,
      date: DateTime(2026, 10, 21),
      paymentMethod: 'Credit Card',
      note: 'Bluetooth speaker',
    ),
  ];

  static final List<Budget> budgets = [
    Budget(
      id: 'budget_1',
      category: CategoryType.food,
      limit: 12000.00,
      spent: 8420.50,
      month: DateTime(2026, 10),
    ),
    Budget(
      id: 'budget_2',
      category: CategoryType.transport,
      limit: 5000.00,
      spent: 4825.00,
      month: DateTime(2026, 10),
    ),
    Budget(
      id: 'budget_3',
      category: CategoryType.shopping,
      limit: 8000.00,
      spent: 9198.00,
      month: DateTime(2026, 10),
    ),
    Budget(
      id: 'budget_4',
      category: CategoryType.bills,
      limit: 4000.00,
      spent: 2948.00,
      month: DateTime(2026, 10),
    ),
    Budget(
      id: 'budget_5',
      category: CategoryType.entertainment,
      limit: 3000.00,
      spent: 1798.00,
      month: DateTime(2026, 10),
    ),
    Budget(
      id: 'budget_6',
      category: CategoryType.health,
      limit: 6000.00,
      spent: 6750.00,
      month: DateTime(2026, 10),
    ),
  ];

  static UserProfile get defaultUser => UserProfile(
        id: 'user_1',
        name: 'Priya Sharma',
        email: 'priya.sharma@email.com',
        avatarUrl: '',
        currency: 'INR',
        themeMode: AppThemeMode.system,
        notificationsEnabled: true,
        biometricEnabled: false,
      );

  static List<Transaction> getTransactionsForMonth(DateTime month) {
    return transactions.where((txn) {
      return txn.date.year == month.year && txn.date.month == month.month;
    }).toList();
  }

  static List<Transaction> getTransactionsForWeek(DateTime startOfWeek) {
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return transactions.where((txn) {
      return txn.date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
          txn.date.isBefore(endOfWeek.add(const Duration(days: 1)));
    }).toList();
  }

  static Map<CategoryType, double> getCategorySpending(DateTime month) {
    final monthlyTxns = getTransactionsForMonth(month);
    final Map<CategoryType, double> spending = {};
    for (var cat in CategoryType.values) {
      spending[cat] = 0.0;
    }
    for (var txn in monthlyTxns) {
      if (txn.type == TransactionType.expense) {
        spending[txn.category] = (spending[txn.category] ?? 0) + txn.amount;
      }
    }
    return spending;
  }

  static double getTotalIncome(DateTime month) {
    return getTransactionsForMonth(month)
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  static double getTotalExpenses(DateTime month) {
    return getTransactionsForMonth(month)
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  static List<Map<String, dynamic>> getWeeklySpendingData(DateTime month) {
    final List<Map<String, dynamic>> weeklyData = [];
    DateTime weekStart = DateTime(month.year, month.month, 1);
    while (weekStart.month == month.month) {
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
  }

  static List<Map<String, dynamic>> getMonthlyComparisonData() {
    final months = [
      DateTime(2026, 5),
      DateTime(2026, 6),
      DateTime(2026, 7),
      DateTime(2026, 8),
      DateTime(2026, 9),
      DateTime(2026, 10),
    ];
    return months.map((month) {
      return {
        'month': _getMonthName(month.month),
        'income': getTotalIncome(month),
        'expenses': getTotalExpenses(month),
      };
    }).toList();
  }

  static String _getMonthName(int month) {
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
}
