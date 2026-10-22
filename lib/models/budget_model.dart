import 'package:uuid/uuid.dart';
import 'category_model.dart';

class Budget {
  final String id;
  final CategoryType category;
  final double limit;
  final double spent;
  final DateTime month;

  Budget({
    String? id,
    required this.category,
    required this.limit,
    this.spent = 0.0,
    required this.month,
  }) : id = id ?? const Uuid().v4();

  double get remaining => limit - spent;
  double get progress => limit > 0 ? (spent / limit).clamp(0.0, 1.0) : 0.0;
  bool get isOverBudget => spent > limit;
  bool get isNearLimit => progress >= 0.8 && !isOverBudget;

  Budget copyWith({
    String? id,
    CategoryType? category,
    double? limit,
    double? spent,
    DateTime? month,
  }) {
    return Budget(
      id: id ?? this.id,
      category: category ?? this.category,
      limit: limit ?? this.limit,
      spent: spent ?? this.spent,
      month: month ?? this.month,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category.name,
      'limit': limit,
      'spent': spent,
      'month': month.toIso8601String(),
    };
  }

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'] as String,
      category: CategoryType.values.byName(json['category'] as String),
      limit: (json['limit'] as num).toDouble(),
      spent: (json['spent'] as num).toDouble(),
      month: DateTime.parse(json['month'] as String),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Budget && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
