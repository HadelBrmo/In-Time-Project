import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/localization/app_localizations.dart';


class MessageInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const MessageInputField({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: theme.cardColor,
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                style: theme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: context.tr('type_message_here'),
                  hintStyle: theme.textTheme.titleMedium?.copyWith(color: theme.hintColor),
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send_rounded, color: AppColors.primaryColor),
              onPressed: onSend,
            )
                .animate(onPlay: (animController) => animController.repeat(reverse: true))
                .shimmer(
              delay: 3.seconds,
              duration: 1.5.seconds,
              color: theme.colorScheme.primaryContainer,
            ),
          ],
        ),
      ),
    );
  }
}