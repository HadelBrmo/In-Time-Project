import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/utils/dialog_utils.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/global_particles_wrapper.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../../../../home/presentation/widgets/home_widget/build_service_card.dart';
import '../../bloc/saved_services/saved_services_bloc.dart';

class SavedServicesPage extends StatelessWidget {
  const SavedServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final mediaQuery = MediaQuery.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          title: Text(context.tr('saved')),
          actions: [
            BlocBuilder<SavedServicesBloc, SavedServicesState>(
              builder: (context, state) {
                if (state is SavedServicesLoaded && state.savedServices.isNotEmpty) {
                  return IconButton(
                    icon: const Icon(Icons.delete_sweep_rounded, color: Colors.white),
                    onPressed: () {
                      DialogUtils.showConfirmDialog(
                        context: context,
                        title: "مسح الكل",
                        message: "هل أنت متأكد من رغبتك في مسح جميع الخدمات المحفوظة؟",
                        confirmText: "مسح الكل",
                        confirmColor: Colors.red,
                        onConfirm: () {
                          context.read<SavedServicesBloc>().add(ClearAllSavedServicesEvent());
                        },
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: GlobalParticlesWrapper(
          child: BlocBuilder<SavedServicesBloc, SavedServicesState>(
            builder: (context, state) {
              if (state is SavedServicesLoading) {
                return const Center(child: LoadingWidget());
              } else if (state is SavedServicesLoaded) {
                final savedServices = state.savedServices;

                if (savedServices.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bookmark_border_rounded,
                          size: 80,
                          color: AppColors.greyColor.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "لا توجد خدمات محفوظة بعد",
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: isDarkMode ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: savedServices.length,
                  itemBuilder: (context, index) {
                    final serving = savedServices[index];
                    return buildServiceCard(
                      context,
                      serving,
                      mediaQuery.size.width,
                      mediaQuery.size.height,
                      onLongPress: () {
                        DialogUtils.showConfirmDialog(
                          context: context,
                          title: "إزالة من المحفوظات",
                          message: "هل أنت متأكد من رغبتك في إزالة هذه الخدمة من قائمة المحفوظات؟",
                          confirmText: "إزالة",
                          confirmColor: Colors.red,
                          onConfirm: () {
                            context.read<SavedServicesBloc>().add(ToggleSaveServiceEvent(serving));
                          },
                        );
                      },
                    );
                  },
                );
              } else if (state is SavedServicesError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
