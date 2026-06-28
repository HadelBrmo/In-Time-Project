import '../../../../core/utils/snackbar_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/customAppBar.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../bloc/chatBloc/chatBloc.dart';
import '../bloc/chatBloc/blocEvent.dart';
import '../bloc/chatBloc/blocState.dart';
import '../widgets/chatItemWidget.dart';

class ChatListScreen extends StatefulWidget {
  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  bool _isSearching = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor:  AppColors.primaryColor,
        child: const Icon(
          Icons.edit,
          color: Colors.white,
        ),
        onPressed: () {

          print("فتح قائمة جهات الاتصال أو بدء محادثة");
        },
      ),

      appBar: CustomAppBar(
        // 1. التحكم في زر الرجوع
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white), 
          decoration: const InputDecoration(
            hintText: "البحث...",
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            context.read<ChatBloc>().add(SearchChatsEvent(value));
          },
        )
            : Text(
          'المحادثات',
          style: TextStyle(color: Colors.white, fontSize: 20.sp),
        ),

        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.white),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  context.read<ChatBloc>().add(LoadChatsEvent());
                }
              });
            },
          ),
        ],
      ),

      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatLoaded && state.deletedChatId != null) {
            SnackBarUtils.showSuccess(
              context,
              'تم حذف المحادثة',
              action: SnackBarAction(
                label: 'تراجع',
                onPressed: () {
                  context.read<ChatBloc>().add(UndoDeleteEvent());
                },
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ChatLoading) return const LoadingWidget();

          if (state is ChatLoaded) {
            return ListView.builder(
              itemCount: state.chats.length,
              itemBuilder: (context, index) {
                final chat = state.chats[index];
                return ChatItemWidget(chat: chat);
              },
            );
          }
          return const Center(child: Text("ابدأ بمراسلة أصدقائك"));
        },

      ),
    );
  }
}