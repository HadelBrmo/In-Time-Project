import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:in_time/core/constants/app_routes.dart';
import '../../../../core/widgets/customAppBar.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../domain/entities/chatEntity.dart';
import '../bloc/chatBloc/blocState.dart';
import '../bloc/chatBloc/chatBloc.dart';
import '../widgets/buildChatTile.dart';
import 'chat_room_page.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().startChatsPulling();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: const Text('المحادثات'),
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatsLoading) {
            return const Center(child: LoadingWidget());
          } else if (state is ChatsLoaded) {
            final chats = state.chats;
            if (chats.isEmpty) {
              return const Center(child: Text('لا توجد محادثات نشطة بعد.'));
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
          } else if (state is ChatsError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          }
          return const SizedBox.shrink();
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {

           Navigator.pushNamed(context, AppRoutes.createGroupScreen);
        },
        backgroundColor: theme.primaryColor,
        tooltip: 'إنشاء مجموعة جديدة',
        child: const Icon(
          Icons.group_add_rounded,
          color: Colors.white,
          size: 28,
        ),
      )
          .animate()
          .fade(delay: 400.ms),
    );
  }
}