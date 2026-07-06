import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/utils/snackbar_utils.dart';
import '../../../../../core/widgets/customAppBar.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../../bloc/my_servings/my_servings_bloc.dart';
import '../../bloc/my_servings/my_servings_event.dart';
import '../../bloc/my_servings/my_servings_state.dart';
import '../../widgets/edit_serving_sheet.dart';
import '../../widgets/my_serving_card.dart';

class MyServingsView extends StatefulWidget {
  const MyServingsView({super.key});

  @override
  State<MyServingsView> createState() => _MyServingsViewState();
}

class _MyServingsViewState extends State<MyServingsView> {
  @override
  void initState() {
    super.initState();
    context.read<MyServingsBloc>().add(FetchMyServingsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CustomAppBar(title: Text(context.tr('my_services'))),
      body: BlocConsumer<MyServingsBloc, MyServingsState>(
        listener: (context, state) {
          if (state is UpdateServingSuccessState) {
            SnackBarUtils.showSuccess(context, context.tr('update_success'));
            context.read<MyServingsBloc>().add(FetchMyServingsEvent());
          }
        },
        builder: (context, state) {
          if (state is MyServingsLoadingState) {
            return const LoadingWidget();
          }
          if (state is MyServingsLoadedState) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.servings.length,
              itemBuilder: (context, index) {
                final serving = state.servings[index];
                return MyServingCard(
                  serving: serving,
                  onEdit: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => EditServingSheet(
                        serving: serving,
                        onSave: (t, d, p, type) {
                          context.read<MyServingsBloc>().add(UpdateMyServingEvent(
                            id: serving.id!, title: t, description: d, costAmount: p, meetingType: type,
                          ));
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                );
              },
            );
          }
          return Center(
            child: Text(
              context.tr('no_services_displayed'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
        },
      ),
    );
  }
}
