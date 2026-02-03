import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/bird.dart';
import '../providers/quiz_provider.dart';
import 'main_selection_screen.dart';

class BirdSelectionScreen extends StatefulWidget {
  const BirdSelectionScreen({super.key});

  @override
  State<BirdSelectionScreen> createState() => _BirdSelectionScreenState();
}

class _BirdSelectionScreenState extends State<BirdSelectionScreen> {
  String? _selectedId;
  final TextEditingController _nameController = TextEditingController();

  void _onBirdSelected(String id) {
    setState(() {
      _selectedId = id;
    });
  }

  void _onConfirm() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name adventurer!')),
      );
      return;
    }

    if (_selectedId != null) {
      final quizProvider = Provider.of<QuizProvider>(context, listen: false);
      try {
        await quizProvider.createProfile(name, _selectedId!);
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const MainSelectionScreen()),
            (route) => false,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.toString())));
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        title: const Text('Create Profile'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Your Name',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Pick your bird companion to start.',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.teal[700]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Consumer<QuizProvider>(
                  builder: (context, provider, child) {
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4, // Changed to 4
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.8,
                          ),
                      itemCount: availableBirds.length,
                      itemBuilder: (context, index) {
                        final bird = availableBirds[index];
                        final isTaken = provider.isBirdTaken(bird.id);
                        final isSelected = _selectedId == bird.id;
                        final isEnabled = !isTaken;

                        return GestureDetector(
                          onTap: isEnabled
                              ? () => _onBirdSelected(bird.id)
                              : null,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isTaken
                                  ? Colors.grey[300]
                                  : isSelected
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isTaken
                                    ? Colors.grey
                                    : isSelected
                                    ? bird.color
                                    : Colors.transparent,
                                width: 2.5,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: bird.color.withValues(
                                          alpha: 0.4,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Opacity(
                                    opacity: isTaken ? 0.4 : 1.0,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          bird.emoji,
                                          style: const TextStyle(
                                            fontSize: 32,
                                          ), // Slightly smaller font
                                        ),
                                        const SizedBox(height: 4),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 2.0,
                                          ),
                                          child: Text(
                                            bird.name,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 11, // Smaller font
                                              fontWeight: FontWeight.bold,
                                              color: Colors.teal[800],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (isTaken)
                                  Center(
                                    child: Transform.rotate(
                                      angle: -0.5,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withValues(
                                            alpha: 0.8,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: const Text(
                                          'TAKEN',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _selectedId != null ? _onConfirm : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Start Adventure',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
