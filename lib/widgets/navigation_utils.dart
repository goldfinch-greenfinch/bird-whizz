import 'package:flutter/material.dart';
import '../screens/profile_selection_screen.dart';

class NavigationUtils {
  static Widget buildProfileMenu(
    BuildContext context, {
    Color color = Colors.white,
  }) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert_rounded, color: color),
      tooltip: 'Options',
      onSelected: (value) {
        if (value == 'profile') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const ProfileSelectionScreen()),
            (route) => false,
          );
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: 'profile',
            child: Row(
              children: [
                Icon(Icons.people_outline, color: Colors.teal),
                SizedBox(width: 12),
                Text('Back to Profiles'),
              ],
            ),
          ),
        ];
      },
    );
  }

  static Widget buildBackButton(
    BuildContext context, {
    Color color = Colors.white,
    VoidCallback? onPressed,
  }) {
    return IconButton(
      onPressed: onPressed ?? () => Navigator.maybePop(context),
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
      color: color,
      tooltip: 'Back',
    );
  }
}
