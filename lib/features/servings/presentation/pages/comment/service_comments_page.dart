import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_time/core/widgets/custom_app_bar.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/media_query.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../../../domain/entity/comment_entity.dart';
import '../../bloc/comment/comment_bloc.dart';
import '../../bloc/comment/comment_event.dart';
import '../../bloc/comment/comment_state.dart';
import '../../widgets/comment/build_bottom_input_field.dart';
import '../../widgets/comment/build_comment_card.dart';

class ServiceCommentsPage extends StatefulWidget {
  final int servingId;

  const ServiceCommentsPage({super.key, required this.servingId});

  @override
  State<ServiceCommentsPage> createState() => _ServiceCommentsPageState();
}

class _ServiceCommentsPageState extends State<ServiceCommentsPage> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CommentBloc>().add(FetchCommentsEvent(widget.servingId));
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final scaffoldBg = isDarkMode ? Theme.of(context).scaffoldBackgroundColor : const Color(0xFFF8F9FA);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(title: const Text('التعليقات')),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: media.width * 0.05, vertical: media.height * 0.015),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.sort, color: AppColors.greyColor, size: 20),
                      const SizedBox(width: 5),
                      const Text("الأحدث أولاً", style: TextStyle(color: AppColors.greyColor, fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: BlocBuilder<CommentBloc, CommentState>(
                builder: (context, state) {
                  if (state is CommentsLoadingState) {
                    return const LoadingWidget();
                  } else if (state is CommentsLoadedState) {
                    if (state.comments.isEmpty) {
                      return const Center(
                        child: Text("لا توجد تعليقات بعد. كن أول من يعلق!", style: TextStyle(color: AppColors.greyColor)),
                      );
                    }
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: media.width * 0.05),
                      itemCount: state.comments.length,
                      itemBuilder: (context, index) {
                        return
                          buildCommentCard(
                            context,
                            state.comments[index],
                            media,
                            isDarkMode,
                            onReplyTap: () {
                              _commentController.text = "@${state.comments[index].userFullName} ";

                              print("الرد على التعليق رقم: ${state.comments[index].id}");
                            },
                          );
                        },
                    );
                  } else if (state is CommentsErrorState) {
                    return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
                  }
                  return const SizedBox();
                },
              ),
            ),

            buildBottomInputField(context, media, isDarkMode, _commentController, widget.servingId),
          ],
        ),
      ),
    );
  }
}