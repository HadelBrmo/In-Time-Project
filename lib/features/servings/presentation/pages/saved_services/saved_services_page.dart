import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

    final currentDirection = Directionality.of(context);

    return Directionality(
      textDirection: currentDirection,
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
                        title: context.tr('clear_all'),
                        message: context.tr('clear_all_saved_confirm_desc'),
                        confirmText: context.tr('clear_all'),
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
                          context.tr('no_saved_services_yet'),
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
                          title: context.tr('remove_from_saved'),
                          message: context.tr('remove_from_saved_confirm_desc'),
                          confirmText: context.tr('remove'),
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