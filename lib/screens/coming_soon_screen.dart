import 'package:flutter/material.dart';
import '../widgets/navigation_utils.dart';

class ComingSoonScreen extends StatelessWidget {
  final String title;

  const ComingSoonScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          NavigationUtils.buildProfileMenu(context, color: Colors.white),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.construction, size: 80, color: Colors.teal.shade200),
              const SizedBox(height: 24),
              Text(
                'Coming Soon!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade800,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'We are working hard to bring you more $title questions. Stay tuned!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.teal.shade600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
