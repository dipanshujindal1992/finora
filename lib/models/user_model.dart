import 'package:uuid/uuid.dart';

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final String currency;
  final AppThemeMode themeMode;
  final bool notificationsEnabled;
  final bool biometricEnabled;
  final DateTime createdAt;

  UserProfile({
    String? id,
    required this.name,
    required this.email,
    this.avatarUrl = '',
    this.currency = 'INR',
    this.themeMode = AppThemeMode.system,
    this.notificationsEnabled = true,
    this.biometricEnabled = false,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  UserProfile copyWith({
    String? name,
    String? email,
    String? avatarUrl,
    String? currency,
    AppThemeMode? themeMode,
    bool? notificationsEnabled,
    bool? biometricEnabled,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      currency: currency ?? this.currency,
      themeMode: themeMode ?? this.themeMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'currency': currency,
      'themeMode': themeMode.name,
      'notificationsEnabled': notificationsEnabled,
      'biometricEnabled': biometricEnabled,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String? ?? '',
      currency: json['currency'] as String? ?? 'INR',
      themeMode:
          AppThemeMode.values.byName(json['themeMode'] as String? ?? 'system'),
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      biometricEnabled: json['biometricEnabled'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

enum AppThemeMode { system, light, dark }
