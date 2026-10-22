import 'package:uuid/uuid.dart';
import 'category_model.dart';

enum TransactionType { income, expense }

class Transaction {
  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final CategoryType category;
  final DateTime date;
  final String? note;
  final String paymentMethod;
  final DateTime createdAt;

  Transaction({
    String? id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.note,
    required this.paymentMethod,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  Transaction copyWith({
    String? id,
    String? title,
    double? amount,
    TransactionType? type,
    CategoryType? category,
    DateTime? date,
    String? note,
    String? paymentMethod,
    DateTime? createdAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      date: date ?? this.date,
      note: note ?? this.note,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type.name,
      'category': category.name,
      'date': date.toIso8601String(),
      'note': note,
      'paymentMethod': paymentMethod,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: TransactionType.values.byName(json['type'] as String),
      category: CategoryType.values.byName(json['category'] as String),
      date: DateTime.parse(json['date'] as String),
      note: json['note'] as String?,
      paymentMethod: json['paymentMethod'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Transaction &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Transaction(id: $id, title: $title, amount: $amount, type: $type, category: $category, date: $date)';
  }
}
