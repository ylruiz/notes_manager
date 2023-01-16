import 'package:equatable/equatable.dart';

class NoteModel extends Equatable {
  const NoteModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.updatedAt,
  });

  NoteModel.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          title: json['title'],
          description: json['description'],
          createdAt: DateTime.parse(json['createdAt']),
          updatedAt: json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'])
              : null,
        );

  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        createdAt,
        updatedAt,
      ];

  NoteModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? Function()? updatedAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt != null ? updatedAt() : this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'createdAt': createdAt.toIso8601String(),
        if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      };
}
