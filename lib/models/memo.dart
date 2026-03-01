import 'package:flutter/foundation.dart';
import 'dart:convert';

@immutable
class Memo {
  final String id;
  final String url;
  final String title;
  final String notes;
  final String ogTitle;
  final String? imageUrl;
  final String categoryId;
  final List<String> tags;
  final bool isPinned;
  final bool isUnread;
  final bool isArchived;
  final DateTime createdAt;

  const Memo({
    required this.id,
    this.url = '',
    this.title = '',
    this.notes = '',
    this.ogTitle = '',
    this.imageUrl,
    required this.categoryId,
    this.tags = const [],
    this.isPinned = false,
    this.isUnread = true,
    this.isArchived = false,
    required this.createdAt,
  });

  Memo copyWith({
    String? id,
    String? url,
    String? title,
    String? notes,
    String? ogTitle,
    String? imageUrl,
    String? categoryId,
    List<String>? tags,
    bool? isPinned,
    bool? isUnread,
    bool? isArchived,
    DateTime? createdAt,
  }) {
    return Memo(
      id: id ?? this.id,
      url: url ?? this.url,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      ogTitle: ogTitle ?? this.ogTitle,
      imageUrl: imageUrl ?? this.imageUrl,
      categoryId: categoryId ?? this.categoryId,
      tags: tags ?? this.tags,
      isPinned: isPinned ?? this.isPinned,
      isUnread: isUnread ?? this.isUnread,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'title': title,
      'notes': notes,
      'ogTitle': ogTitle,
      'imageUrl': imageUrl,
      'categoryId': categoryId,
      'tags': jsonEncode(tags),
      'isPinned': isPinned ? 1 : 0,
      'isUnread': isUnread ? 1 : 0,
      'isArchived': isArchived ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Memo.fromMap(Map<String, dynamic> map) {
    return Memo(
      id: map['id'] as String,
      url: map['url'] as String? ?? '',
      title: map['title'] as String? ?? '',
      notes: map['notes'] as String? ?? '',
      ogTitle: map['ogTitle'] as String? ?? '',
      imageUrl: map['imageUrl'] as String?,
      categoryId: map['categoryId'] as String? ?? '',
      tags: List<String>.from(jsonDecode(map['tags'] as String? ?? '[]')),
      isPinned: (map['isPinned'] as int?) == 1,
      isUnread: (map['isUnread'] as int?) == 1,
      isArchived: (map['isArchived'] as int?) == 1,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
