import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/customAppBar.dart';
import '../../domain/entities/message_entity.dart';
import '../bloc/chatBloc/blocEvent.dart';
import '../bloc/chatBloc/blocState.dart';
import '../bloc/chatBloc/chatBloc.dart';

class ChatRoomPage extends StatefulWidget {
  final int chatId;
  final String chatTitle;

  const ChatRoomPage({super.key, required this.chatId, required this.chatTitle});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().startMessagesPulling(widget.chatId);
  }

  @override
  void dispose() {
    context.read<ChatBloc>().stopMessagesPulling();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      context.read<ChatBloc>().add(SendMessageEvent(widget.chatId, _messageController.text.trim()));
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: Text(widget.chatTitle),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 900),
          child: Column(
            children: [
              Expanded(
                child: BlocConsumer<ChatBloc, ChatState>(
                  listener: (context, state) {
                    if (state is MessagesLoaded) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_scrollController.hasClients) {
                          _scrollController.animateTo(
                            0.0,
                            duration: 300.ms,
                            curve: Curves.easeOut,
                          );
                        }
                      });
                    }
                  },
                  builder: (context, state) {
                    if (state is MessagesLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is MessagesLoaded) {
                      return ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        padding: const EdgeInsets.all(16),
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          final message = state.messages[index];
                          final isMe = message.senderId != 1;
                          return _buildMessageBubble(message, isMe, theme)
                              .animate()
                              .fade(duration: 200.ms)
                              .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic);
                        },
                      );
                    }
                    return Center(
                      child: Text(
                        context.tr('start_chat_now'),
                        style: theme.textTheme.titleMedium,
                      ),
                    );
                  },
                ),
              ),
              _buildMessageInputField(theme, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(MessageEntity message, bool isMe, ThemeData theme) {
    return Align(
      alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.75),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primaryColor : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMe ? Radius.zero : const Radius.circular(16),
            bottomRight: isMe ? const Radius.circular(16) : Radius.zero,
          ),
        ),
        child: Text(
          message.content,
          style: theme.textTheme.titleMedium?.copyWith(
            color: isMe ? AppColors.whiteColor : theme.textTheme.bodyLarge?.color,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInputField(ThemeData theme, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: theme.cardColor,
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
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
              onPressed: _sendMessage,
            ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                .shimmer(delay: 3.seconds, duration: 1.5.seconds, color: theme.colorScheme.primaryContainer),
          ],
        ),
      ),
    );
  }
}