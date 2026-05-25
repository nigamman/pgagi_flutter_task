import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/startup_idea.dart';

enum SortOption { byRating, byVotes }

class IdeasProvider extends ChangeNotifier {
  List<StartupIdea> _ideas = [];
  SortOption _sortOption = SortOption.byVotes;
  bool _isDarkMode = false;
  final _uuid = const Uuid();

  List<StartupIdea> get ideas {
    final sorted = List<StartupIdea>.from(_ideas);
    if (_sortOption == SortOption.byRating) {
      sorted.sort((a, b) => b.aiRating.compareTo(a.aiRating));
    } else {
      sorted.sort((a, b) => b.votes.compareTo(a.votes));
    }
    return sorted;
  }

  List<StartupIdea> get topIdeas {
    final sorted = List<StartupIdea>.from(_ideas);
    sorted.sort((a, b) => b.votes != a.votes
        ? b.votes.compareTo(a.votes)
        : b.aiRating.compareTo(a.aiRating));
    return sorted.take(5).toList();
  }

  SortOption get sortOption => _sortOption;
  bool get isDarkMode => _isDarkMode;

  IdeasProvider() {
    _loadIdeas();
    _loadDarkMode();
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    _saveDarkMode();
    notifyListeners();
  }

  void setSortOption(SortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  int _generateAiRating(String name, String tagline, String description) {
    // Fun fake AI rating logic
    final random = Random(name.length + tagline.length + description.length);
    final base = random.nextInt(40) + 45; // 45–84 base
    int bonus = 0;
    if (description.length > 100) bonus += 5;
    if (tagline.contains('!') || tagline.contains('🚀')) bonus += 3;
    if (name.length > 8) bonus += 2;
    if (description.toLowerCase().contains('ai') ||
        description.toLowerCase().contains('blockchain')) bonus += 5;
    if (description.toLowerCase().contains('disrupt')) bonus += 4;
    return min(100, base + bonus);
  }

  Future<StartupIdea> submitIdea({
    required String name,
    required String tagline,
    required String description,
  }) async {
    final rating = _generateAiRating(name, tagline, description);
    final idea = StartupIdea(
      id: _uuid.v4(),
      name: name,
      tagline: tagline,
      description: description,
      aiRating: rating,
      votes: 0,
      hasVoted: false,
    );
    _ideas.add(idea);
    await _saveIdeas();
    notifyListeners();
    return idea;
  }

  Future<void> upvoteIdea(String id) async {
    final idx = _ideas.indexWhere((i) => i.id == id);
    if (idx == -1) return;
    final idea = _ideas[idx];
    if (idea.hasVoted) return;
    _ideas[idx] = idea.copyWith(votes: idea.votes + 1, hasVoted: true);
    await _saveIdeas();
    notifyListeners();
  }

  Future<void> _saveIdeas() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_ideas.map((i) => i.toJson()).toList());
    await prefs.setString('ideas', encoded);
  }

  Future<void> _loadIdeas() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('ideas');
    if (raw != null) {
      final list = jsonDecode(raw) as List;
      _ideas = list.map((e) => StartupIdea.fromJson(e)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _isDarkMode);
  }

  Future<void> _loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('darkMode') ?? false;
    notifyListeners();
  }
}
