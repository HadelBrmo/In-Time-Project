import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../domain/entities/chatEntity.dart';
import 'buildChatTile.dart';

Widget buildChatList(List<ChatEntity> chats, BuildContext context, ThemeData theme, bool isMobile) {
  if (chats.isEmpty) {
    return Center(
      child: Text(
        context.tr('no_chats'),
        style: theme.textTheme.titleMedium,
      ),
    );
  }
  return Center(
    child: Container(
      constraints: BoxConstraints(
        maxWidth: isMobile ? double.infinity : 800,
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        itemCount: chats.length,
        separatorBuilder: (_, __) => Divider(color: theme.dividerColor.withAlpha(50), indent: 80),
        itemBuilder: (context, index) {
          final chat = chats[index];
          return buildChatTile(context, chat, theme)
              .animate()
              .fade(duration: 350.ms, delay: (index * 50).ms)
              .slideX(begin: 0.1, end: 0, curve: Curves.easeOutQuad);
        },
      ),
    ),
  );
}
