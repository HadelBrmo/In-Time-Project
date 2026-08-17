import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/constants/app_routes.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../injection_container.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/utils/snackbar_utils.dart';
import '../../../../../core/utils/dialog_utils.dart';

import '../../bloc/chat_bloc/bloc_event.dart';
import '../../bloc/chat_bloc/bloc_state.dart';
import '../../bloc/chat_bloc/chat_bloc.dart';
import '../../widgets/messages/build_message_bubble.dart';
import '../../widgets/messages/build_message_input_field.dart';
import '../../widgets/messages/typing_indicator.dart';
import '../groups/group_info_page.dart';
import '../../../../requests/presentation/bloc/request_bloc.dart';
import '../../../../requests/presentation/bloc/request_event.dart';
import '../../../../requests/presentation/bloc/request_state.dart';

class ChatRoomPage extends StatefulWidget {
  final int chatId;
  final String chatTitle;
  final bool isGroup;

  const ChatRoomPage({super.key, required this.chatId, required this.chatTitle, this.isGroup = false});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late int _currentUserId;
  int? _groupCreatedBy;
  String? _profilePicture;
  Timer? _typingTimer;
  bool _isTyping = false;
  int? _requestId;
  String? _unitId;
  bool? _isProvider;

  late ChatBloc _chatBloc;

  @override
  void initState() {
    super.initState();
    _currentUserId = sl<SharedPreferences>().getInt("user_id") ?? 0;

    final chatState = context.read<ChatBloc>().state;
    if (chatState is ChatsLoaded && chatState.chats.isNotEmpty) {
      final index = chatState.chats.indexWhere((c) => c.id == widget.chatId);
      if (index != -1) {
        final currentChat = chatState.chats[index];
        _groupCreatedBy = currentChat.createdBy;
        _profilePicture = widget.isGroup ? null : currentChat.otherUser?.profilePicture;
        _requestId = currentChat.requestId;
        _unitId = currentChat.unitId;
        _isProvider = currentChat.isProvider;
      }
    }

    context.read<ChatBloc>().add(ClearMessagesEvent());
    context.read<ChatBloc>().startMessagesPulling(widget.chatId, isGroup: widget.isGroup);
    context.read<ChatBloc>().add(MarkAsReceivedEvent(widget.chatId));
    context.read<ChatBloc>().add(MarkAsReadEvent(widget.chatId));
    context.read<ChatBloc>().add(LoadChatDraftEvent(widget.chatId));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _chatBloc = context.read<ChatBloc>();
  }

  @override
  void dispose() {
    _chatBloc.add(SaveChatDraftEvent(
      chatId: widget.chatId,
      draftText: _messageController.text,
    ));

    _chatBloc.stopMessagesPulling(isGroup: widget.isGroup);

    _typingTimer?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      _stopTyping();
      context.read<ChatBloc>().add(SendMessageEvent(widget.chatId, _messageController.text.trim()));
      _messageController.clear();
      context.read<ChatBloc>().add(SaveChatDraftEvent(chatId: widget.chatId, draftText: ''));
    }
  }

  void _onTextChanged(String value) {
    if (value.isEmpty) {
      _stopTyping();
    } else {
      _startTyping();
    }
  }

  void _startTyping() {
    if (!_isTyping) {
      _isTyping = true;
      context.read<ChatBloc>().add(StartTypingEvent(widget.chatId));
    }

    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 3), () {
      _stopTyping();
    });
  }

  void _stopTyping() {
    if (_isTyping) {
      _isTyping = false;
      context.read<ChatBloc>().add(StopTypingEvent(widget.chatId));
      _typingTimer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return BlocProvider(
      create: (context) => sl<RequestsBloc>(),
      child: BlocListener<RequestsBloc, RequestsState>(
        listener: (context, state) {
          if (state is RequestActionSuccessState) {
            SnackBarUtils.showSuccess(context, state.message);
          } else if (state is RequestActionErrorState) {
            SnackBarUtils.showError(context, state.message);
          }
        },
        child: Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: CustomAppBar(
            title: GestureDetector(
              onTap: widget.isGroup
                  ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: context.read<ChatBloc>(),
                      child: GroupInfoPage(
                        chatId: widget.chatId,
                        chatTitle: widget.chatTitle,
                        createdBy: _groupCreatedBy,
                      ),
                    ),
                  ),
                );
              }
                  : null,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white24,
                    backgroundImage: _profilePicture != null ? NetworkImage(_profilePicture!) : null,
                    child: _profilePicture == null
                        ? Icon(widget.isGroup ? Icons.groups_rounded : Icons.person_rounded, color: Colors.white, size: 18)
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      widget.chatTitle,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              if (_unitId == "2" && _requestId != null && _isProvider == true)
                Builder(
                  builder: (context) => BlocBuilder<RequestsBloc, RequestsState>(
                    builder: (context, state) {
                      if (state is RequestActionLoadingState) {
                        return const Center(child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                        ));
                      }
                      return IconButton(
                        icon: const Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 28),
                        tooltip: 'طلب إكمال الخدمة',
                        onPressed: () => _showCompletionDialog(context),
                      );
                    },
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.videocam_rounded, color: Colors.white),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.videoCallPage,
                    arguments: {
                      'chatId': widget.chatId,
                      'chatTitle': widget.chatTitle,
                    },
                  );
                },
              ),
            ],
          ),
          body: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 900),
              child: Column(
                children: [
                  Expanded(
                    child: BlocConsumer<ChatBloc, ChatState>(
                      buildWhen: (previous, current) {
                        return current is MessagesLoading ||
                            current is MessagesLoaded ||
                            current is ChatsError;
                      },
                      listener: (context, state) {
                        if (state is ChatDraftLoaded && state.draftText != null) {
                          _messageController.text = state.draftText!;
                          _messageController.selection = TextSelection.fromPosition(
                            TextPosition(offset: _messageController.text.length),
                          );
                        }

                        if (state is MessagesLoaded) {
                          context.read<ChatBloc>().add(MarkAsReadEvent(widget.chatId));

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
                          final messages = state.messages.reversed.toList();
                          return ListView.builder(
                            controller: _scrollController,
                            reverse: true,
                            padding: const EdgeInsets.all(16),
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              final isMe = message.senderId == _currentUserId;
                              return MessageBubble(
                                message: message,
                                isMe: isMe,
                                isGroup: widget.isGroup,
                              )
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
                  BlocBuilder<ChatBloc, ChatState>(
                    buildWhen: (prev, curr) => curr is UserTypingState,
                    builder: (context, state) {
                      if (state is UserTypingState && state.isTyping) {
                        return TypingIndicator(
                          userName: widget.isGroup ? state.userName : null,
                        ).animate().fade().slideY(begin: 0.5, end: 0);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  MessageInputField(
                    controller: _messageController,
                    onSend: _sendMessage,
                    onChanged: _onTextChanged,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showCompletionDialog(BuildContext context) {
    DialogUtils.showConfirmDialog(
      context: context,
      title: "إكمال الخدمة",
      message: "هل أنت متأكد من أنك انتهيت من تقديم الخدمة بالكامل؟ سيتم إرسال طلب للمستفيد لتأكيد ذلك.",
      confirmText: "نعم، انتهيت",
      onConfirm: () {
        if (_requestId != null) {
          context.read<RequestsBloc>().add(RequestCompletionEvent(_requestId!));
        }
      },
    );
  }
}
