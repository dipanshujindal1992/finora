import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

class Formatters {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: AppConstants.currencySymbol,
    decimalDigits: 2,
  );

  static final NumberFormat _currencyFormatCompact =
      NumberFormat.compactCurrency(
    locale: 'en_IN',
    symbol: AppConstants.currencySymbol,
    decimalDigits: 1,
  );

  static final DateFormat _dateFormat = DateFormat(AppConstants.dateFormat);
  static final DateFormat _dateFormatShort =
      DateFormat(AppConstants.dateFormatShort);
  static final DateFormat _dateFormatMonth =
      DateFormat(AppConstants.dateFormatMonth);
  static final DateFormat _timeFormat = DateFormat(AppConstants.timeFormat);
  static final DateFormat _dateTimeFormat =
      DateFormat('${AppConstants.dateFormat}, ${AppConstants.timeFormat}');

  static String formatCurrency(double amount, {bool compact = false}) {
    if (compact) {
      return _currencyFormatCompact.format(amount);
    }
    return _currencyFormat.format(amount);
  }

  static String formatCurrencySigned(double amount, {bool compact = false}) {
    final prefix = amount >= 0 ? '+' : '';
    return '$prefix${formatCurrency(amount, compact: compact)}';
  }

  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  static String formatDateShort(DateTime date) {
    return _dateFormatShort.format(date);
  }

  static String formatMonth(DateTime date) {
    return _dateFormatMonth.format(date);
  }

  static String formatTime(DateTime date) {
    return _timeFormat.format(date);
  }

  static String formatDateTime(DateTime date) {
    return _dateTimeFormat.format(date);
  }

  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final targetDate = DateTime(date.year, date.month, date.day);

    if (targetDate == today) {
      return 'Today';
    } else if (targetDate == yesterday) {
      return 'Yesterday';
    } else if (targetDate.isAfter(today)) {
      return _dateFormatShort.format(date);
    } else if (targetDate.isAfter(today.subtract(const Duration(days: 7)))) {
      return DateFormat('EEEE').format(date);
    } else {
      return _dateFormatShort.format(date);
    }
  }

  static String formatNumber(double number, {int decimals = 0}) {
    final format = NumberFormat('#,##0.${'#' * decimals}', 'en_IN');
    return format.format(number);
  }

  static String formatPercentage(double value, {int decimals = 1}) {
    return '${(value * 100).toStringAsFixed(decimals)}%';
  }

  static String formatLargeNumber(double number) {
    if (number >= 10000000) {
      return '${(number / 10000000).toStringAsFixed(1)}Cr';
    } else if (number >= 100000) {
      return '${(number / 100000).toStringAsFixed(1)}L';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toStringAsFixed(0);
  }

  static String formatCurrencyCompact(double amount) {
    final format = NumberFormat.compactCurrency(
      locale: 'en_IN',
      symbol: AppConstants.currencySymbol,
      decimalDigits: 1,
    );
    return format.format(amount);
  }
}

extension DateTimeExtensions on DateTime {
  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);
  DateTime get startOfWeek => subtract(Duration(days: weekday - 1));
  DateTime get endOfWeek => startOfWeek.add(const Duration(days: 6));
  DateTime get startOfMonth => DateTime(year, month, 1);
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59, 999);

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }
}
