import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/mediaQuery.dart';
// import '../../../../../core/widgets/customAppBar.dart';
import '../../../../../injection_container.dart';
import '../../../../core/widgets/customAppBar.dart';
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
              title: const Text("رصيد الساعات"),
            ).animate().fade(duration: 500.ms),
          ),
          body: BlocBuilder<WalletBloc, WalletState>(
            builder: (context, state) {
              if (state is WalletLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primaryColor),
                );
              } else if (state is WalletError) {
                return Center(
                  child: Text(
                    state.message,
                    style: TextStyle(color: textColor, fontSize: 16),
                  ),
                );
              } else if (state is WalletLoaded) {
            final hourWallets = state.wallets.where(
            (wallet) => wallet.unitName.toLowerCase() == 'hour' || wallet.title.contains('Wallet'),
    ).toList();

    final WalletEntity hourWallet = hourWallets.isNotEmpty
        ? hourWallets.first
        : state.wallets.first;

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

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}