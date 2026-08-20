import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/media_query.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_error_view.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/leaderboard_user_entity.dart';
import '../bloc/leaderboard_bloc.dart';
import '../bloc/leaderboard_event.dart';
import '../bloc/leaderboard_state.dart';
import '../widgets/leaderboard_item.dart';
import '../../../../core/widgets/build_animated_item.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LeaderboardBloc>(),
      child: const _LeaderboardView(),
    );
  }
}

class _LeaderboardView extends StatefulWidget {
  const _LeaderboardView();

  @override
  State<_LeaderboardView> createState() => _LeaderboardViewState();
}

class _LeaderboardViewState extends State<_LeaderboardView> {
  int _selectedServingTypeId = 1; // Default to Voluntary (1)
  late String _selectedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final prevMonthDate = DateTime(now.year, now.month - 1);
    _selectedMonth = '${prevMonthDate.year}-${prevMonthDate.month.toString().padLeft(2, '0')}';
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LeaderboardBloc>().add(
            FetchLeaderboard(servingTypeId: _selectedServingTypeId, month: _selectedMonth),
          );
    });
  }

  void _openFilterSheet(BuildContext context) {
    int tempServingTypeId = _selectedServingTypeId;
    String tempMonth = _selectedMonth;
    final now = DateTime.now();
    final prevMonthDate = DateTime(now.year, now.month - 1);
    final prevMonth = '${prevMonthDate.year}-${prevMonthDate.month.toString().padLeft(2, '0')}';
    final currentMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            bool isCustomMonth = tempMonth != currentMonth && tempMonth != prevMonth;

            return Padding(
              padding: EdgeInsets.only(
                left: 20, right: 20, top: 20,
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('department'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _FilterRadioTile(
                    label: context.tr('voluntary_department'),
                    selected: tempServingTypeId == 1,
                    onTap: () => setSheetState(() => tempServingTypeId = 1),
                  ),
                  _FilterRadioTile(
                    label: context.tr('paid_department'),
                    selected: tempServingTypeId == 3,
                    onTap: () => setSheetState(() => tempServingTypeId = 3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.tr('time_period'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _FilterRadioTile(
                    label: context.tr('current_month'),
                    selected: tempMonth == currentMonth,
                    onTap: () => setSheetState(() => tempMonth = currentMonth),
                  ),
                  _FilterRadioTile(
                    label: context.tr('last_month'),
                    selected: tempMonth == prevMonth,
                    onTap: () => setSheetState(() => tempMonth = prevMonth),
                  ),
                  _FilterRadioTile(
                    label: isCustomMonth ? '${context.tr('month')}: $tempMonth' : context.tr('select_month'),
                    selected: isCustomMonth,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: now,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                        helpText: context.tr('select_month'),
                      );
                      if (picked != null) {
                        setSheetState(() {
                          tempMonth = '${picked.year}-${picked.month.toString().padLeft(2, '0')}';
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedServingTypeId = tempServingTypeId;
                          _selectedMonth = tempMonth;
                        });
                        Navigator.pop(sheetContext);
                        context.read<LeaderboardBloc>().add(
                              FetchLeaderboard(servingTypeId: _selectedServingTypeId, month: _selectedMonth),
                            );
                      },
                      child: Text(
                        context.tr('apply'),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CustomAppBar(
        title: Text(
          context.tr('leaderboard_nav'),
          style: theme.textTheme.titleSmall,
        ),
      ),
      body: Column(
        children: [
          buildAnimatedItem(
            delayFactor: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: InkWell(
                onTap: () => _openFilterSheet(context),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isDarkMode ? Colors.white.withOpacity(0.15) : Colors.transparent,
                      width: isDarkMode ? 1 : 0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDarkMode ? 0.4 : 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _getFilterText(context),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.filter_list, color: theme.primaryColor, size: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<LeaderboardBloc, LeaderboardState>(
              builder: (context, state) {
                if (state is LeaderboardLoading || state is LeaderboardInitial) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: theme.primaryColor,
                    ),
                  );
                } else if (state is LeaderboardError) {
                  return CustomErrorView(
                    message: state.message,
                    onRetry: () => context.read<LeaderboardBloc>().add(
                          FetchLeaderboard(servingTypeId: _selectedServingTypeId, month: _selectedMonth),
                        ),
                  );
                } else if (state is LeaderboardLoaded) {
                  if (state.users.isEmpty) {
                    return _buildEmptyState(context);
                  }
                  return _buildLeaderboard(state.users);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getFilterText(BuildContext context) {
    String dept = '';
    if (_selectedServingTypeId == 1) {
      dept = context.tr('voluntary_department');
    } else if (_selectedServingTypeId == 3) {
      dept = context.tr('paid_department');
    }

    String period = '';
    final now = DateTime.now();
    final prevMonthDate = DateTime(now.year, now.month - 1);
    final currentMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    final lastMonth = '${prevMonthDate.year}-${prevMonthDate.month.toString().padLeft(2, '0')}';

    if (_selectedMonth == currentMonth) {
      period = context.tr('current_month');
    } else if (_selectedMonth == lastMonth) {
      period = context.tr('last_month');
    } else {
      period = _selectedMonth;
    }

    return '$dept ${context.tr('in')} $period';
  }

  Widget _buildEmptyState(BuildContext context) {
    final media = MediaQueryHelper(context);
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: media.width * 0.1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: media.width * 0.18,
              color: theme.hintColor.withOpacity(0.3),
            ),
            SizedBox(height: media.height * 0.02),
            Text(
              context.tr('no_leaderboard_data'),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboard(List<LeaderboardUserEntity> users) {
    final top3 = users.where((u) => u.rank <= 3).toList()..sort((a, b) => a.rank.compareTo(b.rank));
    final rest = users.where((u) => u.rank > 3).toList()..sort((a, b) => a.rank.compareTo(b.rank));

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      physics: const BouncingScrollPhysics(),
      children: [
        if (top3.isNotEmpty)
          buildAnimatedItem(
            delayFactor: 0,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 30),
              child: _buildPodium(top3),
            ),
          ),
        ...rest.asMap().entries.map((entry) {
          final index = entry.key;
          final user = entry.value;
          return buildAnimatedItem(
            delayFactor: index + 2,
            child: LeaderboardItem(user: user),
          );
        }),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildPodium(List<LeaderboardUserEntity> top3) {
    LeaderboardUserEntity? first = top3.any((u) => u.rank == 1) ? top3.firstWhere((u) => u.rank == 1) : null;
    LeaderboardUserEntity? second = top3.any((u) => u.rank == 2) ? top3.firstWhere((u) => u.rank == 2) : null;
    LeaderboardUserEntity? third = top3.any((u) => u.rank == 3) ? top3.firstWhere((u) => u.rank == 3) : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (third != null)
          Expanded(
            child: _PodiumSlot(
              user: third,
              height: 160,
              color: const Color(0xFFA1E3D8),
            ),
          ),
        if (first != null)
          Expanded(
            child: _PodiumSlot(
              user: first,
              height: 220,
              color: AppColors.primaryColor,
              isFirst: true,
            ),
          ),
        if (second != null)
          Expanded(
            child: _PodiumSlot(
              user: second,
              height: 185,
              color: const Color(0xFF6FCABB),
            ),
          ),
      ],
    );
  }
}

class _PodiumSlot extends StatelessWidget {
  final LeaderboardUserEntity user;
  final double height;
  final Color color;
  final bool isFirst;

  const _PodiumSlot({
    required this.user,
    required this.height,
    required this.color,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isFirst ? theme.primaryColor.withOpacity(0.5) : Colors.grey.withOpacity(0.3),
                    width: isFirst ? 3 : 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: isFirst ? 42 : 32,
                  backgroundColor: theme.primaryColor.withOpacity(0.1),
                  backgroundImage: (user.profilePicture != null && user.profilePicture!.isNotEmpty)
                      ? NetworkImage(user.profilePicture!)
                      : null,
                  child: (user.profilePicture == null || user.profilePicture!.isEmpty)
                      ? Icon(
                          Icons.person,
                          color: theme.primaryColor,
                          size: isFirst ? 42 : 32,
                        )
                      : null,
                ),
              ),
              if (isFirst)
                Positioned(
                  top: -5,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.8, end: 1.2),
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Transform.rotate(
                          angle: -0.1,
                          child: const Icon(
                            Icons.workspace_premium,
                            color: Colors.amber,
                            size: 28,
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          buildAnimatedItem(
            delayFactor: isFirst ? 1 : 2,
            child: Text(
              user.fullName,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: isFirst ? 14 : 12,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: height),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.elasticOut,
            builder: (context, val, child) {
              return Container(
                height: val,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    if (val > height * 0.8)
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                        offset: const Offset(0, -2),
                      ),
                  ],
                ),
                child: val > height * 0.5
                    ? FadeInWidget(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${user.rank}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: isFirst ? 52 : 40,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class FadeInWidget extends StatelessWidget {
  final Widget child;
  const FadeInWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) => Opacity(opacity: value, child: child),
      child: child,
    );
  }
}

class _FilterRadioTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterRadioTile({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: theme.dividerColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: theme.primaryColor,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
