import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';

class UserLevelBadge extends StatelessWidget {
  const UserLevelBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, provider, child) {
        final isMax = provider.isMaxCompletion;
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isMax
                ? Colors.amber.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isMax) ...[
                const Icon(
                  Icons.workspace_premium_rounded,
                  color: Colors.amber,
                  size: 14,
                ),
                const SizedBox(width: 4),
              ],
              Text(
                provider.userStatusTitle,
                style: TextStyle(
                  color: isMax ? Colors.amber : Colors.yellowAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
