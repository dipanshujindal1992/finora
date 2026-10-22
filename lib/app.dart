import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finora/core/theme/app_theme.dart';
import 'package:finora/providers/settings_providers.dart';
import 'package:finora/screens/home/home_screen.dart';
import 'package:finora/screens/transactions/transactions_screen.dart';
import 'package:finora/screens/analytics/analytics_screen.dart';
import 'package:finora/screens/budgets/budgets_screen.dart';
import 'package:finora/screens/profile/profile_screen.dart';
import 'package:finora/screens/add_transaction/add_transaction_screen.dart';
import 'package:finora/widgets/bottom_navigation.dart';

class FinoraApp extends ConsumerStatefulWidget {
  const FinoraApp({super.key});

  @override
  ConsumerState<FinoraApp> createState() => _FinoraAppState();
}

class _FinoraAppState extends ConsumerState<FinoraApp> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const TransactionsScreen(),
    const AnalyticsScreen(),
    const BudgetsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Finora',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: FinoraBottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
        floatingActionButton: _currentIndex == 0 || _currentIndex == 1
            ? FloatingActionButton(
                onPressed: () => _navigateToAddTransaction(context),
                child: const Icon(Icons.add_rounded),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  void _navigateToAddTransaction(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTransactionScreen(),
      ),
    );
  }
}
