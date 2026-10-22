import 'package:flutter/material.dart';

enum CategoryType {
  food('Food & Dining', Icons.restaurant, 0xFF10B981),
  transport('Transport', Icons.directions_car, 0xFF3B82F6),
  shopping('Shopping', Icons.shopping_bag, 0xFF8B5CF6),
  bills('Bills & Utilities', Icons.receipt_long, 0xFFF59E0B),
  entertainment('Entertainment', Icons.movie, 0xFFEC4899),
  health('Health & Fitness', Icons.local_hospital, 0xFFEF4444),
  salary('Salary', Icons.work, 0xFF10B981),
  investment('Investment', Icons.trending_up, 0xFF06B6D4),
  other('Other', Icons.category, 0xFF6B7280);

  const CategoryType(this.label, this.icon, this.colorValue);

  final String label;
  final IconData icon;
  final int colorValue;

  Color get color => Color(colorValue);

  static CategoryType fromString(String value) {
    return CategoryType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => CategoryType.other,
    );
  }
}

extension CategoryExtension on CategoryType {
  bool get isIncomeCategory =>
      this == CategoryType.salary || this == CategoryType.investment;
}
