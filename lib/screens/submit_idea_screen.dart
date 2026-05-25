import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../providers/ideas_provider.dart';
import 'idea_listing_screen.dart';

class SubmitIdeaScreen extends StatefulWidget {
  const SubmitIdeaScreen({super.key});

  @override
  State<SubmitIdeaScreen> createState() => _SubmitIdeaScreenState();
}

class _SubmitIdeaScreenState extends State<SubmitIdeaScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _taglineController = TextEditingController();
  final _descController = TextEditingController();
  bool _isLoading = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _taglineController.dispose();
    _descController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    // Fake AI "processing" delay
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;
    final idea = await context.read<IdeasProvider>().submitIdea(
          name: _nameController.text.trim(),
          tagline: _taglineController.text.trim(),
          description: _descController.text.trim(),
        );

    setState(() => _isLoading = false);

    Fluttertoast.showToast(
      msg: "🚀 Idea submitted! AI rated it ${idea.aiRating}/100",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFF6C63FF),
      textColor: Colors.white,
      fontSize: 14.0,
    );

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const IdeaListingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<IdeasProvider>();
    final isDark = provider.isDarkMode;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '🚀 Startup Evaluator',
          style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => context.read<IdeasProvider>().toggleDarkMode(),
            tooltip: 'Toggle dark mode',
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary,
                        colorScheme.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Got a startup idea?',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Submit it and let our AI evaluate its potential 🤖✨',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                _label('Startup Name'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. UberForDogs',
                    prefixIcon: Icon(Icons.lightbulb_outline),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                ),
                const SizedBox(height: 20),

                _label('Tagline'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _taglineController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Disrupting the pet transport industry 🚀',
                    prefixIcon: Icon(Icons.tag),
                  ),
                  maxLength: 80,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Tagline is required' : null,
                ),
                const SizedBox(height: 20),

                _label('Description'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(
                    hintText:
                        'Describe your idea in detail. What problem does it solve? Who is your target market?',
                    prefixIcon: Icon(Icons.description_outlined),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 5,
                  maxLength: 500,
                  validator: (v) => (v == null || v.trim().length < 20)
                      ? 'Description must be at least 20 characters'
                      : null,
                ),
                const SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  child: _isLoading
                      ? Container(
                          height: 54,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                colorScheme.primary,
                                colorScheme.secondary,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'AI is evaluating... 🤖',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ElevatedButton.icon(
                          onPressed: _submit,
                          icon: const Icon(Icons.send_rounded),
                          label: const Text('Submit Idea'),
                        ),
                ),
                const SizedBox(height: 16),

                // Navigate to listing
                Center(
                  child: TextButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const IdeaListingScreen()),
                    ),
                    icon: const Icon(Icons.list_alt_rounded),
                    label: const Text('View all ideas'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: GoogleFonts.spaceGrotesk(
          fontWeight: FontWeight.w700,
          fontSize: 15,
        ),
      );
}
