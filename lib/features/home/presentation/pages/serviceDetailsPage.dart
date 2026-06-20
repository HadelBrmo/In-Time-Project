import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_time/core/widgets/customAppBar.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/assets_image.dart';
import '../../../../core/constants/mediaQuery.dart';
import '../../../../injection_container.dart';
import '../../../requests/presentation/widgets/buildDisabledButton.dart';
import '../../../requests/presentation/widgets/showRequestDialog.dart';
import '../../../strategies/presentation/bloc/comment/comment_bloc.dart';
import '../../../strategies/presentation/pages/comment/service_comments_page.dart';
import '../../../strategies/domain/entity/service_entity.dart';
import '../../../strategies/presentation/widgets/services/buildDetailsBody.dart';
import '../widgets/buildGridInfoRow.dart';
import '../../../requests/presentation/bloc/request_bloc.dart';
import '../../../requests/presentation/bloc/request_state.dart';

import '../../../strategies/presentation/bloc/service/services_bloc.dart';
import '../../../strategies/presentation/bloc/service/services_event.dart';
import '../../../strategies/presentation/bloc/service/services_state.dart';

class ServiceDetailsPage extends StatelessWidget {
  final int serviceId;
  final bool isFromRequests;

  const ServiceDetailsPage({
    super.key,
    required this.serviceId,
    this.isFromRequests = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ServicesBloc>()..add(GetServiceDetailsEvent(serviceId)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const CustomAppBar(title: Text('تفاصيل الخدمة')),
        body: BlocBuilder<ServicesBloc, ServicesState>(
          builder: (context, state) {
            if (state is ServiceDetailsLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              );
            } else if (state is ServiceDetailsError) {
              return Center(
                child: Text(state.message, style: const TextStyle(color: Colors.red)),
              );
            } else if (state is ServiceDetailsLoaded) {
              final service = state.service;
              return buildDetailsBody(context, service,isFromRequests);
            }
            return const Center(child: Text("جاري تحضير البيانات..."));
          },
        ),
      ),
    );
  }


}
