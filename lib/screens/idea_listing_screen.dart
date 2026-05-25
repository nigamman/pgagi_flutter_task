import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/ideas_provider.dart';
import '../widgets/idea_card.dart';
import 'leaderboard_screen.dart';
import 'submit_idea_screen.dart';

class IdeaListingScreen extends StatelessWidget {
  const IdeaListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<IdeasProvider>();
    final ideas = provider.ideas;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '💡 All Ideas',
          style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: Icon(
                provider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => context.read<IdeasProvider>().toggleDarkMode(),
            tooltip: 'Toggle dark mode',
          ),
          IconButton(
            icon: const Icon(Icons.emoji_events_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
            ),
            tooltip: 'Leaderboard',
          ),
        ],
      ),
      body: Column(
        children: [
          // Sort options
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Text(
                  '${ideas.length} idea${ideas.length != 1 ? 's' : ''}',
                  style: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.5),
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                Text(
                  'Sort by: ',
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                _SortChip(
                  label: '👍 Votes',
                  selected: provider.sortOption == SortOption.byVotes,
                  onTap: () => provider.setSortOption(SortOption.byVotes),
                ),
                const SizedBox(width: 6),
                _SortChip(
                  label: '🤖 Rating',
                  selected: provider.sortOption == SortOption.byRating,
                  onTap: () => provider.setSortOption(SortOption.byRating),
                ),
              ],
            ),
          ),

          Expanded(
            child: ideas.isEmpty
                ? _EmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: ideas.length,
                    itemBuilder: (context, i) => IdeaCard(idea: ideas[i]),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SubmitIdeaScreen()),
        ),
        icon: const Icon(Icons.add_rounded),
        label: Text(
          'New Idea',
          style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700),
        ),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SortChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? colorScheme.primary
              : colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🚀', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(
            'No ideas yet!',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to submit your startup idea.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
