import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:in_time/core/constants/app_routes.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/utils/auth_utils.dart';
import '../../../../../core/widgets/responsive_layout.dart';
import '../../../../../core/widgets/customAppBar.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../../../domain/entities/chatEntity.dart';
import '../../bloc/chatBloc/blocState.dart';
import '../../bloc/chatBloc/chatBloc.dart';
import '../../widgets/chats/buildChatList.dart';
import '../../widgets/chats/buildChatTile.dart';
import 'chat_room_page.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  int? _selectedChatId;
  String? _selectedChatTitle;
  bool _isGroup = false;

  @override
  void initState() {
    super.initState();
    if (AuthUtils.isLoggedIn()) {
      context.read<ChatBloc>().startChatsPulling();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return ResponsiveLayout(
      mobileBody: _buildMobileLayout(context, theme),
      tabletBody: _buildDesktopLayout(context, theme),
      desktopBody: _buildDesktopLayout(context, theme),
    );
  }

  Widget _buildMobileLayout(BuildContext context, ThemeData theme) {
    if (!AuthUtils.isLoggedIn()) {
      return _buildLoginRequired(context, theme);
    }
    return _buildChatsContent(context, theme, true);
  }

  Widget _buildDesktopLayout(BuildContext context, ThemeData theme) {
    if (!AuthUtils.isLoggedIn()) {
      return _buildLoginRequired(context, theme);
    }
    return Scaffold(
      appBar: CustomAppBar(title: Text(context.tr('chats'))),
      body: Row(
        children: [
          SizedBox(
            width: 350,
            child: _buildChatsContent(context, theme, false),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: _selectedChatId == null
                ? Center(child: Text(context.tr('select_chat_to_start')))
                : ChatRoomPage(
                    key: ValueKey(_selectedChatId),
                    chatId: _selectedChatId!,
                    chatTitle: _selectedChatTitle ?? '',
                    isGroup: _isGroup,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginRequired(BuildContext context, ThemeData theme) {
    return Scaffold(
      appBar: CustomAppBar(title: Text(context.tr('chats'))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 64, color: AppColors.greyColor),
            const SizedBox(height: 16),
            Text(
              context.tr('login_required_chats'),
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: context.tr('login'),
              color: AppColors.primaryColor,
              onPressed: () => AuthUtils.showLoginPrompt(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatsContent(BuildContext context, ThemeData theme, bool isMobile) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: isMobile ? CustomAppBar(title: Text(context.tr('chats'))) : null,
        body: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TabBar(
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.primaryColor,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: AppColors.whiteColor,
                unselectedLabelColor: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                tabs: [
                  Tab(text: context.tr('personal_chats')),
                  Tab(text: context.tr('groups')),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                buildWhen: (previous, current) =>
                    current is ChatsLoading || current is ChatsLoaded || current is ChatsError,
                builder: (context, state) {
                  if (state is ChatsLoading) {
                    return const Center(child: LoadingWidget());
                  } else if (state is ChatsLoaded) {
                    final allChats = state.chats;
                    final personalChats = allChats.where((c) => c.type == 'personal').toList();
                    final groupChats = allChats.where((c) => c.type == 'group').toList();

                    return TabBarView(
                      children: [
                        _buildList(personalChats, theme, isMobile),
                        _buildList(groupChats, theme, isMobile),
                      ],
                    );
                  } else if (state is ChatsError) {
                    return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
                  }
                  return const Center(child: LoadingWidget());
                },
              ),
            ),
          ],
        ),
        floatingActionButton: isMobile
            ? FloatingActionButton(
                heroTag: 'create_group_btn',
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.createGroupScreen);
                },
                backgroundColor: AppColors.primaryColor,
                tooltip: context.tr('create_group'),
                child: const Icon(
                  Icons.group_add_rounded,
                  color: AppColors.whiteColor,
                  size: 28,
                ),
              ).animate().fade(delay: 400.ms)
            : null,
      ),
    );
  }

  Widget _buildList(List<ChatEntity> chats, ThemeData theme, bool isMobile) {
    if (chats.isEmpty) {
      return Center(child: Text(context.tr('no_chats_yet')));
    }
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        final isSelected = _selectedChatId == chat.id;

        return buildChatTile(
          context,
          chat,
          theme,
          isSelected: isSelected,
          onTap: () {
            if (isMobile) {
              Navigator.pushNamed(
                context,
                AppRoutes.chatRoomPage,
                arguments: {
                  'chatId': chat.id,
                  'chatTitle': chat.type == 'group'
                      ? (chat.name ?? context.tr('group'))
                      : (chat.otherUser?.fullName ?? context.tr('chat_room')),
                  'isGroup': chat.type == 'group',
                },
              );
            } else {
              setState(() {
                _selectedChatId = chat.id;
                _selectedChatTitle = chat.type == 'group'
                    ? (chat.name ?? context.tr('group'))
                    : (chat.otherUser?.fullName ?? context.tr('chat_room'));
                _isGroup = chat.type == 'group';
              });
            }
          },
        );
      },
    );
  }

}
