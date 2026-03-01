import 'package:flutter/foundation.dart';

@immutable
class Category {
  final String id;
  final String name;
  final bool isDefault;

  const Category({
    required this.id,
    required this.name,
    this.isDefault = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isDefault': isDefault ? 1 : 0,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as String,
      name: map['name'] as String,
      isDefault: (map['isDefault'] as int) == 1,
    );
  }
}
