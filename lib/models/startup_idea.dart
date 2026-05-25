import 'dart:convert';

class StartupIdea {
  final String id;
  final String name;
  final String tagline;
  final String description;
  final int aiRating;
  int votes;
  bool hasVoted;

  StartupIdea({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.aiRating,
    this.votes = 0,
    this.hasVoted = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'tagline': tagline,
        'description': description,
        'aiRating': aiRating,
        'votes': votes,
        'hasVoted': hasVoted,
      };

  factory StartupIdea.fromJson(Map<String, dynamic> json) => StartupIdea(
        id: json['id'],
        name: json['name'],
        tagline: json['tagline'],
        description: json['description'],
        aiRating: json['aiRating'],
        votes: json['votes'] ?? 0,
        hasVoted: json['hasVoted'] ?? false,
      );

  StartupIdea copyWith({
    int? votes,
    bool? hasVoted,
  }) =>
      StartupIdea(
        id: id,
        name: name,
        tagline: tagline,
        description: description,
        aiRating: aiRating,
        votes: votes ?? this.votes,
        hasVoted: hasVoted ?? this.hasVoted,
      );

  String toJsonString() => jsonEncode(toJson());
}
