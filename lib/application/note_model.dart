import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class Note {
  final String note;
  final String title;
  Note({
    required this.note,
    required this.title,
  });

  Map<String, dynamic> toMap() {
    return {
      'note': note,
      'title': title,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      note: map['note'],
      title: map['title'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Note && other.note == note && other.title == title;
  }

  @override
  int get hashCode => note.hashCode ^ title.hashCode;

  @override
  String toString() => 'Note(note: $note, title: $title)';

  Note copyWith({
    String? note,
    String? title,
  }) {
    return Note(
      note: note ?? this.note,
      title: title ?? this.title,
    );
  }
}
