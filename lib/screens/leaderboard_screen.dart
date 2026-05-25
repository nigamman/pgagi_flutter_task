import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/ideas_provider.dart';
import '../models/startup_idea.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ideas = context.watch<IdeasProvider>().topIdeas;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '🏆 Leaderboard',
          style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: Icon(context.watch<IdeasProvider>().isDarkMode
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: () => context.read<IdeasProvider>().toggleDarkMode(),
          ),
        ],
      ),
      body: ideas.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🏆', style: TextStyle(fontSize: 64)),
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
                    'Submit and vote on ideas to see the leaderboard.',
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFF7971E),
                          const Color(0xFFFFD200),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFD200).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Text('🏆', style: TextStyle(fontSize: 40)),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Top 5 Ideas',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Ranked by votes + AI rating',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _LeaderboardCard(
                      idea: ideas[index],
                      rank: index + 1,
                      isDark: isDark,
                    ),
                    childCount: ideas.length,
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            ),
    );
  }
}

class _LeaderboardCard extends StatelessWidget {
  final StartupIdea idea;
  final int rank;
  final bool isDark;

  const _LeaderboardCard({
    required this.idea,
    required this.rank,
    required this.isDark,
  });

  String get _medal {
    switch (rank) {
      case 1:
        return '🥇';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return '#$rank';
    }
  }

  List<Color> get _gradientColors {
    switch (rank) {
      case 1:
        return [const Color(0xFFF7971E), const Color(0xFFFFD200)];
      case 2:
        return [const Color(0xFF8E9EAB), const Color(0xFFCBCDD3)];
      case 3:
        return [const Color(0xFFCD7F32), const Color(0xFFE8A87C)];
      default:
        return [const Color(0xFF6C63FF), const Color(0xFFFF6584)];
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: rank <= 3
            ? LinearGradient(
                colors: _gradientColors
                    .map((c) => c.withOpacity(isDark ? 0.25 : 0.12))
                    .toList(),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: rank > 3
            ? (isDark ? const Color(0xFF1A1A2E) : Colors.white)
            : null,
        border: Border.all(
          color: rank <= 3
              ? _gradientColors[0].withOpacity(0.4)
              : colorScheme.primary.withOpacity(0.1),
          width: rank == 1 ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: rank <= 3
                ? _gradientColors[0].withOpacity(0.15)
                : Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Rank badge
            Container(
              width: 44,
              height: 44,
              decoration: rank <= 3
                  ? BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: _gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _gradientColors[0].withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    )
                  : BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.surfaceVariant,
                    ),
              child: Center(
                child: rank <= 3
                    ? Text(
                        _medal,
                        style: const TextStyle(fontSize: 22),
                      )
                    : Text(
                        '#$rank',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 14),

            // Idea info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    idea.name,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    idea.tagline,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurface.withOpacity(0.55),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Stats
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    const Icon(Icons.thumb_up, size: 14,
                        color: Color(0xFF6C63FF)),
                    const SizedBox(width: 4),
                    Text(
                      '${idea.votes}',
                      style: GoogleFonts.spaceGrotesk(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: const Color(0xFF6C63FF),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: _ratingColor(idea.aiRating).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '🤖 ${idea.aiRating}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _ratingColor(idea.aiRating),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _ratingColor(int rating) {
    if (rating >= 80) return const Color(0xFF43E97B);
    if (rating >= 60) return const Color(0xFFFFB347);
    return const Color(0xFFFF6584);
  }
}
