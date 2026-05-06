import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // يفضل استخدامه لأنه مهيأ في الـ main

import '../../../../core/constants/app_colors.dart';
import '../bloc/chatBloc/chatBloc.dart';
import '../../domain/entities/chatEntity.dart';
import '../bloc/chatBloc/blocEvent.dart';

class ChatItemWidget extends StatelessWidget {
  final ChatEntity chat;
  const ChatItemWidget({required this.chat});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Dismissible(
      key: Key(chat.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        context.read<ChatBloc>().add(DeleteChatEvent(chat.id));
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Icon(Icons.delete, color: Colors.white, size: screenWidth * 0.07),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: screenWidth * 0.065,
          backgroundImage: chat.profileUrl.isNotEmpty
              ? AssetImage(chat.profileUrl)
              : null,
          child:  null,
        ),
        title: Text(
            chat.senderName,
            style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold
            )
        ),
        subtitle: Text(
          chat.lastMessage,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: screenWidth * 0.04),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              chat.timestamp.toString().substring(11, 16),
              style: TextStyle(fontSize: screenWidth * 0.035),
            ),
            SizedBox(
              height: screenWidth * 0.015,
            ),
            if (chat.unreadCount > 0)
              CircleAvatar(
                  radius: screenWidth * 0.028,
                  backgroundColor: AppColors.primaryColor,
                  child: Text(
                      chat.unreadCount.toString(),
                      style: TextStyle(
                          fontSize: screenWidth * 0.028,
                          color: Colors.white
                      )
                  )
              ),
          ],
        ),
      ),
    );
  }
}