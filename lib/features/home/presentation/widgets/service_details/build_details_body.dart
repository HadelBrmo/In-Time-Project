import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_routes.dart';
import '../../../../../core/constants/assets_image.dart';
import '../../../../../core/constants/media_query.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/theme/glowing_border.dart';
import '../../../../../core/utils/snackbar_utils.dart';
import '../../../../../core/utils/auth_utils.dart';
import '../../../../../core/widgets/build_animated_item.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../../../../../core/widgets/custom_image_view.dart';
import '../../../../../injection_container.dart';

import '../../../../chat/presentation/bloc/chat_bloc/bloc_event.dart';
import '../../../../chat/presentation/bloc/chat_bloc/bloc_state.dart';
import '../../../../chat/presentation/bloc/chat_bloc/chat_bloc.dart';
import '../../../../servings/domain/entity/service_entity.dart';
import '../../../../servings/presentation/bloc/comment/comment_bloc.dart';
import 'package:in_time/features/servings/presentation/bloc/service/services_bloc.dart';
import '../../../../servings/presentation/pages/comment/service_comments_page.dart';
import '../home_widget/build_grid_info_row.dart';
import 'service_availability_manager.dart';
import 'package:in_time/features/servings/presentation/widgets/services/rating_dialog.dart';
import '../../../../requests/presentation/bloc/request_bloc.dart';
import '../../../../requests/presentation/bloc/request_state.dart';
import '../../../../requests/presentation/widgets/build_disabled_button.dart';
import '../../../../requests/presentation/widgets/show_request_dialog.dart';
import '../../bloc/home_bloc.dart';
import '../../bloc/home_event.dart';

Widget buildDetailsBody(
    BuildContext context,
    ServiceEntity service,
    bool isFromRequests,
    bool isOwner,
    ) {
  final media = MediaQueryHelper(context);
  final theme = Theme.of(context);
  final isDarkMode = theme.brightness == Brightness.dark;

  final cardBg = isDarkMode ? AppColors.blackColor : AppColors.whiteColor;
  final textColor = isDarkMode ? AppColors.whiteColor : AppColors.blackColor;
  final subTextColor = isDarkMode ? AppColors.greyColor : AppColors.darkGreyColor;
  final infoItemBg = isDarkMode ? const Color(0xFF323232) : const Color(0xFFE8F8F5);

  final shortAddress = (service.locationAddress != null && service.locationAddress!.isNotEmpty)
      ? service.locationAddress!.split(',').take(2).join(' - ')
      : "دمشق _ المزة";

  final bool isAlreadyRequested = isFromRequests || service.isRequested;

  final glowColors = [
    AppColors.primaryColor,
    AppColors.secondaryColor,
    AppColors.primaryColor,
    AppColors.secondaryColor,
  ];

  return Directionality(
    textDirection: TextDirection.rtl,
    child: MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<RequestsBloc>()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<RequestsBloc, RequestsState>(
            listener: (context, state) {
              if (state is CreateRequestLoadingState) {
                SnackBarUtils.showSuccess(
                  context,
                  context.tr('sending_request'),

                );
              } else if (state is CreateRequestSuccessState) {
                SnackBarUtils.showSuccess(context, state.message);
              } else if (state is CreateRequestErrorState) {
                SnackBarUtils.showError(context, state.errorMessage);
              }
            },
          ),
          BlocListener<ChatBloc, ChatState>(
            listener: (context, state) {
              if (state is ChatsLoading) {
                SnackBarUtils.showSuccess(context, context.tr('opening_chat'));
              } else if (state is ChatCreated) {
                Navigator.pushNamed(
                  context,
                  AppRoutes.chatRoomPage,
                  arguments: {
                    'chatId': state.chat.id,
                    'chatTitle': state.chat.otherUser?.fullName ?? context.tr('chat_room'),
                  },
                );
              } else if (state is ChatInitial) {
              } else if (state is ChatsError) {
                SnackBarUtils.showError(context, state.message);
              }
            },
          ),
        ],
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: media.width * 0.05, vertical: media.height * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAnimatedItem(
                delayFactor: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: media.width * 0.08,
                          backgroundColor: isDarkMode ? const Color(0xFF3A3A3A) : const Color(0xFFE0F2F1),
                          child: Icon(Icons.person, color: AppColors.primaryColor, size: media.width * 0.06),
                        ),
                        SizedBox(width: media.width * 0.03),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  service.userFullName ?? context.tr('system_user'),
                                  style: theme.textTheme.titleMedium?.copyWith(fontSize: 17, fontWeight: FontWeight.bold, color: textColor),
                                ),
                                if (service.isUserVerified == true) ...[
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.verified,
                                    color: Colors.blue,
                                    size: 18,
                                  ),
                                ],
                              ],
                            ),
                            if (service.userEmail != null && service.userEmail!.isNotEmpty)
                              Text(
                                service.userEmail!,
                                style: theme.textTheme.titleMedium?.copyWith(fontSize: 15.5, color: subTextColor),
                              ),
                          ],
                        ),
                      ],
                    ),
                    (isOwner ||
                            service.servingTypeId == 1 ||
                            service.servingTypeName?.toLowerCase() == 'paid' ||
                            service.servingTypeName == 'مدفوعة')
                        ? const SizedBox.shrink()
                        : isAlreadyRequested
                        ? buildDisabledButton(media, isDarkMode, context.tr('requested'))
                        : BlocBuilder<RequestsBloc, RequestsState>(
                      builder: (context, state) {
                        if (state is CreateRequestSuccessState) {
                          return buildDisabledButton(media, isDarkMode, context.tr('requested'));
                        }
                        if (state is CreateRequestLoadingState) {
                          return const SizedBox(
                            width: 30,
                            height: 30,
                            child: LoadingWidget(size: 20),
                          );
                        }
                        return GestureDetector(
                          onTap: () {
                            if (AuthUtils.checkAuth(context)) {
                              showRequestDialog(
                                context: context,
                                servingId: service.id ?? 0,
                                media: media,
                                isDarkMode: isDarkMode,
                                cardBg: cardBg,
                                textColor: textColor,
                              );
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: media.width * 0.04, vertical: media.height * 0.005),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              context.tr('request'),
                              style: const TextStyle(color: AppColors.whiteColor, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: media.height * 0.04),

              buildAnimatedItem(
                delayFactor: 1,
                child: Center(
                  child: GlowingBorder(
                    shape: BoxShape.circle,
                    glowColors: glowColors,
                    child: Container(
                      width: media.width * 0.45,
                      height: media.width * 0.45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.17),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Hero(
                        tag: 'service-img-${service.id ?? 0}',
                        child: CustomImageView(
                          imageUrl: service.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: media.height * 0.025),

              buildAnimatedItem(
                delayFactor: 2,
                child: GlowingBorder(
                  borderRadius: 25,
                  glowColors: glowColors,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(media.width * 0.05),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(25),
                      border: isDarkMode ? Border.all(color: const Color(0xFF3A3A3A)) : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.17) ,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                service.title.trim().split(RegExp(r'\s+')).take(2).join(' '),
                                style: theme.textTheme.headlineSmall?.copyWith(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isDarkMode ? const Color(0xFF2C3E3B) : const Color(0xFFE4F3F0),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                service.unitId == "2" ? context.tr('exchange') : (service.servingTypeName ?? ''),
                                style: const TextStyle(color: AppColors.primaryColor, fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: media.height * 0.02),
                        const Divider(height: 1, color: Color(0xFFEEEEEE)),
                        SizedBox(height: media.height * 0.02),
                        Row(
                          children: [
                            const Icon(Icons.grid_view_rounded, color: AppColors.primaryColor),
                            SizedBox(width: media.width * 0.05),
                            Text(service.categoryName ?? context.tr('home_service'), style: theme.textTheme.titleMedium),
                          ],
                        ),
                        SizedBox(height: media.height * 0.02),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: AppColors.primaryColor),
                            SizedBox(width: media.width * 0.05),
                            Expanded(child: Text(shortAddress, style: theme.textTheme.titleMedium)),
                          ],
                        ),
                        SizedBox(height: media.height * 0.02),
                        buildGridInfoRow(
                          context,
                          icon1: Icons.money_outlined,
                          text1: "${service.costAmount ?? '0'} ${service.unitName ?? ''}",
                          icon2: Icons.assignment,
                          text2: service.meetingType == 'online' ? context.tr('online_service') : context.tr('physical_service'),
                          infoItemBg: infoItemBg,
                          textColor: textColor,
                          media: media,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: media.height * 0.025),

              if (isOwner) ...[
                buildAnimatedItem(
                  delayFactor: 3,
                  child: ServiceAvailabilityManager(
                    serviceId: service.id ?? 0,
                    existingSlots: service.availabilitySlots ?? [],
                    onSaveSlots: (payload) {
                      context.read<HomeBloc>().add(
                        UpdateServiceAvailabilityEvent(
                          serviceId: service.id ?? 0,
                          slotsData: payload,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: media.height * 0.025),
              ],
              buildAnimatedItem(
                delayFactor: 3,
                child: GlowingBorder(
                  borderRadius: 25,
                  glowColors: glowColors,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(media.width * 0.05),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(25),
                      border: isDarkMode ? Border.all(color: const Color(0xFF3A3A3A)) : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.17),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_month, color: AppColors.primaryColor, size: 22),
                            SizedBox(width: media.width * 0.02),
                            Text(
                              context.tr('available_times'),
                              style: theme.textTheme.titleSmall?.copyWith(fontSize: 16, color: textColor),
                            ),
                          ],
                        ),
                        SizedBox(height: media.height * 0.015),

                        if (service.availabilitySlots == null || service.availabilitySlots!.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(media.width * 0.04),
                            alignment: Alignment.center,
                            child: Text(
                              context.tr('no_available_times'),
                              style: theme.textTheme.titleMedium?.copyWith(fontSize: 14, color: subTextColor),
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: service.availabilitySlots!.length,
                            itemBuilder: (context, index) {
                              final slot = service.availabilitySlots![index];

                              String startTime = slot['start_time'] ?? '';
                              String endTime = slot['end_time'] ?? '';
                              if (startTime.length > 5) startTime = startTime.substring(0, 5);
                              if (endTime.length > 5) endTime = endTime.substring(0, 5);

                              String dayName = "";
                              if (slot['day_of_week'] != null) {
                                final Map<int, String> numberToDayMap = {
                                  0: context.tr('sunday'),
                                  1: context.tr('monday'),
                                  2: context.tr('tuesday'),
                                  3: context.tr('wednesday'),
                                  4: context.tr('thursday'),
                                  5: context.tr('friday'),
                                  6: context.tr('saturday'),
                                };
                                dayName = numberToDayMap[slot['day_of_week']] ?? "";
                              } else if (slot['date'] != null) {
                                dayName = slot['date'].toString().split('T').first;
                              }

                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: EdgeInsets.symmetric(
                                  horizontal: media.width * 0.04,
                                  vertical: media.height * 0.015,
                                ),
                                decoration: BoxDecoration(
                                  color: isDarkMode ? const Color(0xFF2D2D2D) : const Color(0xFFF9F9F9),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isDarkMode ? const Color(0xFF3A3A3A) : AppColors.greyColor.withOpacity(0.2),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.check_circle_outline, color: AppColors.primaryColor, size: 18),
                                        SizedBox(width: media.width * 0.02),
                                        Text(
                                          dayName,
                                          style: theme.textTheme.titleMedium?.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: textColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.access_time_rounded, color: isDarkMode ? AppColors.greyColor : AppColors.darkGreyColor, size: 16),
                                        SizedBox(width: media.width * 0.01),
                                        Text(
                                          "${context.tr('from')} $startTime ${context.tr('to')} $endTime",
                                          style: theme.textTheme.titleMedium?.copyWith(
                                            fontSize: 13,
                                            color: isDarkMode ? AppColors.greyColor : Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: media.height * 0.025),
              buildAnimatedItem(
                delayFactor: 3,
                child: GlowingBorder(
                  borderRadius: 25,
                  glowColors: glowColors,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(media.width * 0.05),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(25),
                      border: isDarkMode ? Border.all(color: const Color(0xFF3A3A3A)) : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.17) ,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.description, color: AppColors.primaryColor, size: 22),
                            SizedBox(width: media.width * 0.02),
                            Text(
                              context.tr('service_description'),
                              style: theme.textTheme.titleSmall?.copyWith(fontSize: 16, color: textColor),
                            ),
                          ],
                        ),
                        SizedBox(height: media.height * 0.015),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(media.width * 0.04),
                          decoration: BoxDecoration(
                            color: isDarkMode ? const Color(0xFF2D2D2D) : const Color(0xFFEBF8F6),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            service.description,
                            style: theme.textTheme.titleMedium?.copyWith(fontSize: 14, color: subTextColor, height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: media.height * 0.04),

              if (service.isOwner != true) ...[
                buildAnimatedItem(
                  delayFactor: 4,
                  child: Builder(
                    builder: (context) {
                      return Center(
                        child: SizedBox(
                          width: media.width * 0.85,
                          height: media.height * 0.065,
                          child: ElevatedButton(
                            onPressed: () {
                              if (AuthUtils.checkAuth(context)) {
                                final chatBloc = context.read<ChatBloc>();
                                final currentState = chatBloc.state;

                                int? existingChatId;
                                if (currentState is ChatsLoaded) {
                                  for (final chat in currentState.chats) {
                                    if (chat.type == 'personal' && chat.otherUser?.id == service.userId) {
                                      existingChatId = chat.id;
                                      break;
                                    }
                                  }
                                }

                                if (existingChatId != null) {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.chatRoomPage,
                                    arguments: {
                                      'chatId': existingChatId,
                                      'chatTitle': service.userFullName ?? context.tr('chat_room'),
                                    },
                                  );
                                } else {
                                  chatBloc.add(
                                    CreatePersonalChatEvent(
                                      service.userId ?? 0,
                                      "${context.tr('chat_inquiry')} ${service.title}",
                                    ),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 2,
                            ),
                            child: Text(
                              context.tr('message'),
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: AppColors.whiteColor,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: media.height * 0.02),
              ],

              buildAnimatedItem(
                delayFactor: 4,
                child: Center(
                  child: SizedBox(
                    width: media.width * 0.85,
                    height: media.height * 0.065,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (context) => sl<CommentBloc>(),
                              child: ServiceCommentsPage(servingId: service.id ?? 0),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        context.tr('comments'),
                        style: theme.textTheme.titleSmall?.copyWith(color: AppColors.whiteColor, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}