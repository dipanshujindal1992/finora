import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finora/models/user_model.dart' hide ThemeMode;
import 'package:finora/models/transaction_model.dart';
import 'package:finora/providers/app_providers.dart';
import 'package:finora/providers/settings_providers.dart';
import 'package:finora/data/mock_data.dart';
import 'package:finora/widgets/common_widgets.dart'
    show SectionHeader, EmptyState;
import 'package:finora/core/theme/app_theme.dart';
import 'package:finora/core/constants/app_constants.dart';
import 'package:finora/core/utils/formatters.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);
    final themeMode = ref.watch(themeModeProvider);
    final transactions = ref.watch(transactionListProvider);
    final budgets = ref.watch(budgetListProvider);

    final totalTransactions = transactions.length;
    final totalIncome = transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (a, b) => a + b.amount);
    final totalExpenses = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (a, b) => a + b.amount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spacingMD),
              child: Column(
                children: [
                  _buildProfileHeader(context, user),
                  const SizedBox(height: AppConstants.spacingLG),
                  _buildStatsGrid(context, totalTransactions, totalIncome,
                      totalExpenses, budgets.length),
                  const SizedBox(height: AppConstants.spacingLG),
                  _buildSettingsSections(context, ref, user, themeMode),
                  const SizedBox(height: AppConstants.spacingLG),
                  _buildDangerZone(context, ref),
                  const SizedBox(height: AppConstants.spacingXL),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserProfile user) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingLG),
        child: Column(
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: colorScheme.primaryContainer,
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                style: theme.textTheme.displayMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spacingMD),
            Text(
              user.name,
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppConstants.spacingXS),
            Text(
              user.email,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: AppConstants.spacingSM),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadiusCircular),
              ),
              child: Text(
                'Finora ${AppConstants.appVersion}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(
    BuildContext context,
    int totalTransactions,
    double totalIncome,
    double totalExpenses,
    int totalBudgets,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            'Transactions',
            totalTransactions.toString(),
            Icons.receipt_long_rounded,
            colorScheme.primary,
          ),
        ),
        const SizedBox(width: AppConstants.spacingMD),
        Expanded(
          child: _buildStatCard(
            context,
            'Total Income',
            Formatters.formatCurrencyCompact(totalIncome),
            Icons.arrow_downward_rounded,
            AppColors.incomeColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingMD),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadiusCircular),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: AppConstants.spacingSM),
            Text(
              value,
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              label,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSections(
    BuildContext context,
    WidgetRef ref,
    UserProfile user,
    ThemeMode themeMode,
  ) {
    return Column(
      children: [
        _buildSectionCard(context, 'Appearance', [
          _buildSettingTile(
            context,
            'Theme',
            _getThemeModeLabel(themeMode),
            Icons.palette_outlined,
            onTap: () => _showThemeSelector(context, ref),
          ),
          _buildSettingTile(
            context,
            'Currency',
            user.currency,
            Icons.currency_rupee_rounded,
            onTap: () => _showCurrencySelector(context, ref),
          ),
        ]),
        const SizedBox(height: AppConstants.spacingMD),
        _buildSectionCard(context, 'Notifications', [
          _buildSwitchTile(
            context,
            'Push Notifications',
            'Receive transaction alerts and reminders',
            Icons.notifications_outlined,
            user.notificationsEnabled,
            (value) => ref
                .read(userProfileProvider.notifier)
                .toggleNotifications(value),
          ),
          _buildSwitchTile(
            context,
            'Biometric Auth',
            'Use fingerprint or face ID to unlock',
            Icons.fingerprint_rounded,
            user.biometricEnabled,
            (value) =>
                ref.read(userProfileProvider.notifier).toggleBiometric(value),
          ),
        ]),
        const SizedBox(height: AppConstants.spacingMD),
        _buildSectionCard(context, 'Data & Privacy', [
          _buildSettingTile(
            context,
            'Export Data',
            'Download your transactions as CSV',
            Icons.download_outlined,
            onTap: () => _exportData(context),
          ),
          _buildSettingTile(
            context,
            'Privacy Policy',
            'Read our privacy policy',
            Icons.privacy_tip_outlined,
            onTap: () => _showPrivacyPolicy(context),
          ),
          _buildSettingTile(
            context,
            'Terms of Service',
            'Read our terms of service',
            Icons.description_outlined,
            onTap: () => _showTermsOfService(context),
          ),
        ]),
        const SizedBox(height: AppConstants.spacingMD),
        _buildSectionCard(context, 'About', [
          _buildSettingTile(
            context,
            'App Version',
            AppConstants.appVersion,
            Icons.info_outlined,
          ),
          _buildSettingTile(
            context,
            'Open Source Licenses',
            'View licenses for dependencies',
            Icons.library_books_outlined,
            onTap: () => _showLicenses(context),
          ),
          _buildSettingTile(
            context,
            'Feedback & Support',
            'Send feedback or report an issue',
            Icons.feedback_outlined,
            onTap: () => _showFeedback(context),
          ),
        ]),
      ],
    );
  }

  Widget _buildSectionCard(
      BuildContext context, String title, List<Widget> children) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppConstants.spacingMD,
              AppConstants.spacingMD,
              AppConstants.spacingMD,
              0,
            ),
            child: Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: Icon(icon, color: colorScheme.onSurfaceVariant),
      title: Text(title, style: theme.textTheme.bodyLarge),
      subtitle: Text(subtitle,
          style: theme.textTheme.bodySmall
              ?.copyWith(color: colorScheme.onSurfaceVariant)),
      trailing: onTap != null
          ? Icon(Icons.chevron_right_rounded,
              color: colorScheme.onSurfaceVariant)
          : null,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMD, vertical: 4),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SwitchListTile(
      secondary: Icon(icon, color: colorScheme.onSurfaceVariant),
      title: Text(title, style: theme.textTheme.bodyLarge),
      subtitle: Text(subtitle,
          style: theme.textTheme.bodySmall
              ?.copyWith(color: colorScheme.onSurfaceVariant)),
      value: value,
      onChanged: onChanged,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: AppConstants.spacingMD),
    );
  }

  Widget _buildDangerZone(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppConstants.spacingMD,
              AppConstants.spacingMD,
              AppConstants.spacingMD,
              0,
            ),
            child: Text(
              'Danger Zone',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.expenseColor,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.delete_forever_outlined,
                color: AppColors.expenseColor),
            title: Text('Reset All Data',
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: AppColors.expenseColor)),
            subtitle: Text(
              'Delete all transactions, budgets, and settings. This cannot be undone.',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            onTap: () => _confirmResetData(context, ref),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingMD, vertical: 4),
          ),
        ],
      ),
    );
  }

  String _getThemeModeLabel(dynamic mode) {
    final modeName =
        mode is ThemeMode ? _getFlutterThemeModeName(mode) : mode.name;
    switch (modeName) {
      case 'system':
        return 'System Default';
      case 'light':
        return 'Light';
      case 'dark':
        return 'Dark';
      default:
        return 'System Default';
    }
  }

  String _getFlutterThemeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'system';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
    }
  }

  void _showThemeSelector(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final currentTheme = ref.watch(themeModeProvider);
        return Container(
          padding: const EdgeInsets.all(AppConstants.spacingLG),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppConstants.spacingLG),
              Text('Select Theme',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: AppConstants.spacingLG),
              ...ThemeMode.values.map((mode) => RadioListTile<ThemeMode>(
                    title: Text(_getThemeModeLabel(mode)),
                    value: mode,
                    groupValue: currentTheme,
                    onChanged: (value) {
                      if (value != null) {
                        ref
                            .read(themeModeProvider.notifier)
                            .setThemeMode(value);
                        Navigator.pop(context);
                      }
                    },
                  )),
            ],
          ),
        );
      },
    );
  }

  void _showCurrencySelector(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final currencies = [
          {'code': 'INR', 'symbol': '₹', 'name': 'Indian Rupee'},
          {'code': 'USD', 'symbol': '\$', 'name': 'US Dollar'},
          {'code': 'EUR', 'symbol': '€', 'name': 'Euro'},
          {'code': 'GBP', 'symbol': '£', 'name': 'British Pound'},
        ];
        final user = ref.watch(userProfileProvider);

        return Container(
          padding: const EdgeInsets.all(AppConstants.spacingLG),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppConstants.spacingLG),
              Text('Select Currency',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: AppConstants.spacingLG),
              ...currencies.map((currency) => RadioListTile<String>(
                    title: Text('${currency['symbol']} ${currency['name']}'),
                    subtitle: Text(currency['code']!),
                    value: currency['code']!,
                    groupValue: user.currency,
                    onChanged: (value) {
                      if (value != null) {
                        ref
                            .read(userProfileProvider.notifier)
                            .updateCurrency(value);
                        Navigator.pop(context);
                      }
                    },
                  )),
            ],
          ),
        );
      },
    );
  }

  void _exportData(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export feature coming soon!')),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'Finora respects your privacy. All data is stored locally on your device and is never transmitted to external servers. '
            'We do not collect any personal information. Your financial data remains completely private and under your control.',
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close')),
        ],
      ),
    );
  }

  void _showTermsOfService(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text(
            'By using Finora, you agree to use the app for personal finance tracking purposes only. '
            'The app provides mock data for demonstration and does not connect to real banking services. '
            'All financial calculations are for informational purposes and should not be considered financial advice.',
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close')),
        ],
      ),
    );
  }

  void _showLicenses(BuildContext context) {
    showLicensePage(
        context: context,
        applicationName: 'Finora',
        applicationVersion: AppConstants.appVersion);
  }

  void _showFeedback(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feedback feature coming soon!')),
    );
  }

  void _confirmResetData(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_rounded, color: AppColors.expenseColor),
            const SizedBox(width: 8),
            const Text('Reset All Data'),
          ],
        ),
        content: const Text(
          'This will permanently delete all your transactions, budgets, and settings. This action cannot be undone. Are you sure?',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              ref.read(transactionListProvider.notifier).resetToMockData();
              ref.read(budgetListProvider.notifier).resetToMockData();
              ref
                  .read(userProfileProvider.notifier)
                  .updateProfile(MockData.defaultUser);
              ref.read(selectedMonthProvider.notifier).state = DateTime.now();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All data reset to defaults')),
              );
            },
            style:
                FilledButton.styleFrom(backgroundColor: AppColors.expenseColor),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
