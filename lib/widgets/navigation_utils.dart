import 'package:flutter/material.dart';
import '../screens/profile_selection_screen.dart';
import 'package:provider/provider.dart';
import '../services/audio_service.dart';

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
        } else if (value == 'sound') {
          // Toggle sound
          context.read<AudioService>().toggleMute();
        }
      },
      itemBuilder: (BuildContext context) {
        final audioService = context.read<AudioService>();
        final isMuted = audioService.isMuted;

        return [
          PopupMenuItem<String>(
            value: 'sound',
            child: Row(
              children: [
                Icon(
                  isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                  color: Colors.teal,
                ),
                const SizedBox(width: 12),
                Text(isMuted ? 'Sound Off' : 'Sound On'),
              ],
            ),
          ),
          const PopupMenuItem<String>(
            value: 'profile',
            child: Row(
              children: [
                Icon(Icons.people_outline, color: Colors.teal),
                const SizedBox(width: 12),
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
