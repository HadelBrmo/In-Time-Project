import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_time/core/widgets/customAppBar.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/mediaQuery.dart';
import '../../../../injection_container.dart';
import '../../../requests/presentation/widgets/buildDisabledButton.dart';
import '../../../requests/presentation/widgets/showRequestDialog.dart';
import '../../../strategies/presentation/bloc/comment/comment_bloc.dart';
import '../../../strategies/presentation/pages/comment/service_comments_page.dart';
import '../../domain/entities/service_entity.dart';
import '../widgets/buildGridInfoRow.dart';
import '../../../requests/presentation/bloc/request_bloc.dart';
import '../../../requests/presentation/bloc/request_event.dart';
import '../../../requests/presentation/bloc/request_state.dart';

class ServiceDetailsPage extends StatelessWidget {
  final ServicingEntity service;
  final bool isFromRequests;

  const ServiceDetailsPage({
    super.key,
    required this.service,
    this.isFromRequests = false,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final scaffoldBg = isDarkMode ? Theme.of(context).scaffoldBackgroundColor : const Color(0xFFFAFAFA);
    final cardBg = isDarkMode ? const Color(0xFF252525) : AppColors.whiteColor;
    final textColor = isDarkMode ? AppColors.whiteColor : AppColors.blackColor;
    final subTextColor = isDarkMode ? AppColors.greyColor : AppColors.darkGreyColor;
    final infoItemBg = isDarkMode ? const Color(0xFF323232) : const Color(0xFFE8F8F5);

    final shortAddress = (service.locationAddress != null && service.locationAddress!.isNotEmpty)
        ? service.locationAddress!.split(',').take(2).join(' - ')
        : "دمشق _ المزة";

    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider(
        create: (context) => sl<RequestsBloc>(),
        child: Scaffold(
          backgroundColor: scaffoldBg,
          appBar: const CustomAppBar(title: Text('تفاصيل الخدمة')),
          body: BlocListener<RequestsBloc, RequestsState>(
            listener: (context, state) {
              if (state is CreateRequestLoadingState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('جاري إرسال طلبك...'), backgroundColor: AppColors.primaryColor),
                );
              } else if (state is CreateRequestSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message), backgroundColor: Colors.green),
                );
              } else if (state is CreateRequestErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage), backgroundColor: Colors.red),
                );
              }
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: media.width * 0.05, vertical: media.height * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: media.width * 0.06,
                            backgroundColor: isDarkMode ? const Color(0xFF3A3A3A) : const Color(0xFFE0F2F1),
                            child: Icon(Icons.person, color: AppColors.primaryColor, size: media.width * 0.06),
                          ),
                          SizedBox(width: media.width * 0.03),
                          Text(
                            service.userFullName ?? "مستخدم النظام",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
                          ),
                        ],
                      ),
                      isFromRequests
                          ? buildDisabledButton(media, isDarkMode, "تم الطلب")
                          : BlocBuilder<RequestsBloc, RequestsState>(
                        builder: (context, state) {
                          if (state is CreateRequestSuccessState) {
                            return buildDisabledButton(media, isDarkMode, "تم الطلب");
                          }

                          if (state is CreateRequestLoadingState) {
                            return const SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryColor),
                            );
                          }

                          return GestureDetector(
                            onTap: () {
                              showRequestDialog(
                                context: context,
                                servingId: service.id ?? 0,
                                media: media,
                                isDarkMode: isDarkMode,
                                cardBg: cardBg,
                                textColor: textColor,
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: media.width * 0.05, vertical: media.height * 0.008),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                "طلب",
                                style: TextStyle(color: AppColors.whiteColor, fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: media.height * 0.02),
                  Container(
                    width: double.infinity,
                    height: media.height * 0.26,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: service.imageUrl != null && service.imageUrl!.isNotEmpty
                          ? Image.network(service.imageUrl!, fit: BoxFit.cover)
                          : Container(
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor.withOpacity(0.6),
                        ),
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: AppColors.primaryColor.withOpacity(0.6),
                          size: media.width * 0.12,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: media.height * 0.025),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(media.width * 0.05),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(25),
                      border: isDarkMode ? Border.all(color: const Color(0xFF3A3A3A)) : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
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
                                service.title,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
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
                                "${service.servingTypeName ?? ''}",
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
                            Icon(Icons.grid_view_rounded, color: AppColors.primaryColor),
                            SizedBox(width: media.width * 0.05),
                            Text("${service.categoryName ?? "خدمة منزلية"}"),
                          ],
                        ),
                        SizedBox(height: media.height * 0.02),
                        Row(
                          children: [
                            Icon(Icons.location_on, color: AppColors.primaryColor),
                            SizedBox(width: media.width * 0.05),
                            Expanded(child: Text(shortAddress)),
                          ],
                        ),
                        SizedBox(height: media.height * 0.02),
                        buildGridInfoRow(
                          context,
                          icon1: Icons.money_outlined,
                          text1: "${service.costAmount ?? '0'} ${service.unitName ?? ''}",
                          icon2: Icons.assignment,
                          text2: service.meetingType == 'online' ? "خدمة أونلاين" : "خدمة حضورية",
                          infoItemBg: infoItemBg,
                          textColor: textColor,
                          media: media,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: media.height * 0.025),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(media.width * 0.05),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(25),
                      border: isDarkMode ? Border.all(color: const Color(0xFF3A3A3A)) : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
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
                              "وصف الخدمة",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
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
                            style: TextStyle(fontSize: 14, color: subTextColor, height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: media.height * 0.04),
                  Center(
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
                        child: const Text(
                          "التعليقات",
                          style: TextStyle(color: AppColors.whiteColor, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}