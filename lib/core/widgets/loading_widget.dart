import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../features/settings/presentation/bloc/settings_bloc.dart';
import '../../features/settings/presentation/bloc/settings_state.dart';

class LoadingWidget extends StatelessWidget {
  final double? size;

  const LoadingWidget({
    super.key,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final defaultSize = mediaQuery.size.width * 0.25;

    return Center(
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return SizedBox(
            width: size ?? defaultSize,
            height: size ?? defaultSize,
            child: Lottie.asset(
              'assets/animations/smooth-triple-dot-loading.lottie',
              fit: BoxFit.contain,
              animate: state.animationsEnabled,
            ),
          );
        },
      ),
    );
  }
}
