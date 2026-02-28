import 'package:flutter/foundation.dart';

@immutable
class Memo {
  final String id;
  final String content;
  final String metadata; // URL OG metadata or categorization tags
  final DateTime createdAt;

  const Memo({
    required this.id,
    required this.content,
    required this.metadata,
    required this.createdAt,
  });

  Memo copyWith({
    String? id,
    String? content,
    String? metadata,
    DateTime? createdAt,
  }) {
    return Memo(
      id: id ?? this.id,
      content: content ?? this.content,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Memo.fromMap(Map<String, dynamic> map) {
    return Memo(
      id: map['id'] as String,
      content: map['content'] as String,
      metadata: map['metadata'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
