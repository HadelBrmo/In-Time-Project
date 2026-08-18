import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/media_query.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_error_view.dart';
import '../../domain/entities/portfolio_item_entity.dart';
import '../bloc/protfilo/portfolio_bloc.dart';
import '../bloc/protfilo/portfolio_event.dart';
import '../bloc/protfilo/portfolio_state.dart';


class PortfolioPage extends StatelessWidget {
  final int userId;
  final PortfolioBloc bloc;
  const PortfolioPage({super.key, required this.userId, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: _PortfolioView(userId: userId),
    );
  }
}

class _PortfolioView extends StatelessWidget {
  final int userId;
  const _PortfolioView({required this.userId});

  @override
  Widget build(BuildContext context) {
    final media = MediaQueryHelper(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CustomAppBar(
        title: Text(context.tr('portfolio')),
      ),
      body: BlocBuilder<PortfolioBloc, PortfolioState>(
        builder: (context, state) {
          if (state is PortfolioLoading || state is PortfolioInitial) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
          } else if (state is PortfolioError) {
            return CustomErrorView(
              message: state.message,
              onRetry: () {
                context.read<PortfolioBloc>().add(FetchPortfolio(userId));
              },
            );
          } else if (state is PortfolioLoaded) {
            if (state.items.isEmpty) {
              return _buildEmptyState(media, theme, context);
            }
            return GridView.builder(
              padding: EdgeInsets.all(media.width * 0.04),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.85,
              ),
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                return _PortfolioCard(item: state.items[index]);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState(MediaQueryHelper media, ThemeData theme, BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: media.width * 0.1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.work_outline_rounded, size: media.width * 0.18, color: AppColors.greyColor),
            SizedBox(height: media.height * 0.02),
            Text(
              context.tr('no_portfolio_items'),
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: media.height * 0.01),
            Text(
              context.tr('add_portfolio_hint'),
              style: theme.textTheme.bodySmall?.copyWith(color: AppColors.greyColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _PortfolioCard extends StatelessWidget {
  final PortfolioItemEntity item;
  const _PortfolioCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final hasImage = item.files.isNotEmpty;
    final firstFileUrl = hasImage ? item.files.first : null;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: firstFileUrl == null
          ? null
          : () async {
              final uri = Uri.tryParse(firstFileUrl);
              if (uri != null && await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF252525) : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: (isDarkMode ? Colors.black : AppColors.blackColor).withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Expanded(
              child: firstFileUrl != null
                  ? Image.network(
                      firstFileUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _iconPlaceholder(),
                    )
                  : _iconPlaceholder(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  if (item.dateOfAchievement != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.dateOfAchievement!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 11, color: AppColors.greyColor),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconPlaceholder() {
    return Container(
      color: AppColors.primaryColor.withOpacity(0.08),
      alignment: Alignment.center,
      child: Icon(Icons.work_outline_rounded, size: 40, color: AppColors.primaryColor),
    );
  }
}
