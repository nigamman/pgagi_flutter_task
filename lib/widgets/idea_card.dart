import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/startup_idea.dart';
import '../providers/ideas_provider.dart';

class IdeaCard extends StatefulWidget {
  final StartupIdea idea;

  const IdeaCard({super.key, required this.idea});

  @override
  State<IdeaCard> createState() => _IdeaCardState();
}

class _IdeaCardState extends State<IdeaCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  Color _ratingColor(int rating) {
    if (rating >= 80) return const Color(0xFF43E97B);
    if (rating >= 60) return const Color(0xFFFFB347);
    return const Color(0xFFFF6584);
  }

  String _ratingLabel(int rating) {
    if (rating >= 85) return '🔥 Hot';
    if (rating >= 70) return '✨ Strong';
    if (rating >= 55) return '👍 Decent';
    return '💡 Needs work';
  }

  Future<void> _upvote() async {
    if (widget.idea.hasVoted) {
      Fluttertoast.showToast(
        msg: "You already voted for this idea!",
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
      return;
    }
    _bounceController.forward().then((_) => _bounceController.reverse());
    await context.read<IdeasProvider>().upvoteIdea(widget.idea.id);
    Fluttertoast.showToast(
      msg: "👍 Upvoted! Thanks for your vote.",
      backgroundColor: const Color(0xFF6C63FF),
      textColor: Colors.white,
    );
  }

  void _share() {
    Share.share(
      '🚀 Check out this startup idea: "${widget.idea.name}"\n\n'
      '"${widget.idea.tagline}"\n\n'
      'AI Rating: ${widget.idea.aiRating}/100\n\n'
      '${widget.idea.description}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final idea = widget.idea;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.primary.withOpacity(0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: (isDark ? Colors.black : Colors.black.withOpacity(0.05)),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          idea.name,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          idea.tagline,
                          style: TextStyle(
                            color: colorScheme.onSurface.withOpacity(0.65),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // AI Rating chip
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _ratingColor(idea.aiRating).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _ratingColor(idea.aiRating).withOpacity(0.4),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${idea.aiRating}',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: _ratingColor(idea.aiRating),
                          ),
                        ),
                        Text(
                          '/100',
                          style: TextStyle(
                            fontSize: 10,
                            color: _ratingColor(idea.aiRating),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Rating label
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'AI says: ${_ratingLabel(idea.aiRating)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: _ratingColor(idea.aiRating),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Expandable description
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    idea.description,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: colorScheme.onSurface.withOpacity(0.8),
                      height: 1.5,
                    ),
                  ),
                ),
                crossFadeState: _expanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 250),
              ),

              const SizedBox(height: 12),

              // Action row
              Row(
                children: [
                  // Upvote button
                  ScaleTransition(
                    scale: _bounceAnimation,
                    child: InkWell(
                      onTap: _upvote,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: idea.hasVoted
                              ? colorScheme.primary.withOpacity(0.15)
                              : colorScheme.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: idea.hasVoted
                              ? Border.all(
                                  color: colorScheme.primary.withOpacity(0.4))
                              : null,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              idea.hasVoted
                                  ? Icons.thumb_up
                                  : Icons.thumb_up_outlined,
                              size: 16,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${idea.votes}',
                              style: GoogleFonts.spaceGrotesk(
                                fontWeight: FontWeight.w700,
                                color: colorScheme.primary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Read more
                  TextButton(
                    onPressed: () => setState(() => _expanded = !_expanded),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    child: Text(
                      _expanded ? 'Show less' : 'Read more',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),

                  const Spacer(),

                  // Share
                  IconButton(
                    onPressed: _share,
                    icon: const Icon(Icons.ios_share_rounded),
                    iconSize: 18,
                    tooltip: 'Share idea',
                    style: IconButton.styleFrom(
                      backgroundColor:
                          colorScheme.surfaceVariant.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
