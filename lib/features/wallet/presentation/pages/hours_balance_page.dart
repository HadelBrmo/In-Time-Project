import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/mediaQuery.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../../../injection_container.dart';
import '../../../../core/utils/auth_utils.dart';
import '../../../../core/widgets/customAppBar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../domain/entity/wallet_entity.dart';
import '../bloc/wallet_bloc.dart';
import '../bloc/wallet_event.dart';
import '../bloc/wallet_state.dart';
import '../widgets/balance_card.dart';

class HoursBalancePage extends StatelessWidget {
  const HoursBalancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    if (!AuthUtils.isLoggedIn()) {
      return Scaffold(
        appBar: CustomAppBar(
          title: Text(
            context.tr('hours_balance'),
            style: theme.textTheme.titleSmall,
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 64, color: AppColors.greyColor),
              const SizedBox(height: 16),
              Text(
                context.tr('login_required_balance'),
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: context.tr('login'),
                color: AppColors.primaryColor,
                onPressed: () => AuthUtils.showLoginPrompt(context),
              ),
            ],
          ),
        ),
      );
    }

    final textColor = isDarkMode ? AppColors.whiteColor : AppColors.blackColor;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider(
        create: (context) => sl<WalletBloc>()..add(GetMyWalletsEvent()),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: CustomAppBar(
              title: Text(
                context.tr('hours_balance'),
                style: theme.textTheme.titleSmall,
              ),
            ).animate().fade(duration: 500.ms),
          ),
          body: BlocBuilder<WalletBloc, WalletState>(
            builder: (context, state) {
              if (state is WalletLoading) {
                return const LoadingWidget();
              } else if (state is WalletError) {
                return Center(
                  child: Text(
                    state.message,
                    style: theme.textTheme.titleMedium?.copyWith(color: textColor, fontSize: 16),
                  ),
                );
              } else if (state is WalletLoaded) {
                final hourWallets = state.wallets.where(
                  (wallet) => wallet.unitName.toLowerCase() == 'hour' || wallet.title.contains('Wallet'),
                ).toList();

                final WalletEntity hourWallet = hourWallets.isNotEmpty
                    ? hourWallets.first
                    : state.wallets.first;

                return ResponsiveLayout(
                  mobileBody: _buildBalanceContent(media, hourWallet),
                  tabletBody: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: _buildBalanceContent(media, hourWallet),
                    ),
                  ),
                  desktopBody: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 700),
                      child: _buildBalanceContent(media, hourWallet),
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceContent(MediaQueryHelper media, WalletEntity hourWallet) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: media.width * 0.05,
        vertical: media.height * 0.03,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BalanceCard(
            currentHours: hourWallet.balance.toInt(),
            targetHours: 20,
          ),
          SizedBox(height: media.height * 0.05),
        ],
      ),
    );
  }
}