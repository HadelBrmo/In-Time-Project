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

/// (rank, full_name, profile_picture, serving_type_id, date)
///
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
  int? _selectedServingTypeId = 1;
  late String _selectedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    
    // Fetch initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LeaderboardBloc>().add(
            FetchLeaderboard(servingTypeId: _selectedServingTypeId, month: _selectedMonth),
          );
    });
  }

  void _openFilterSheet(BuildContext context) {
    int? tempServingTypeId = _selectedServingTypeId;
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
            return Padding(
              padding: EdgeInsets.only(
                left: 20, right: 20, top: 20,
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('القسم', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primaryColor)),
                  const SizedBox(height: 8),
                  _FilterRadioTile(
                    label: 'كل الأقسام',
                    selected: tempServingTypeId == null,
                    onTap: () => setSheetState(() => tempServingTypeId = null),
                  ),
                  _FilterRadioTile(
                    label: 'القسم التبادلي',
                    selected: tempServingTypeId == 1,
                    onTap: () => setSheetState(() => tempServingTypeId = 1),
                  ),
                  _FilterRadioTile(
                    label: 'القسم التطوعي',
                    selected: tempServingTypeId == 2,
                    onTap: () => setSheetState(() => tempServingTypeId = 2),
                  ),
                  const SizedBox(height: 16),
                  const Text('الفترة الزمنية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primaryColor)),
                  const SizedBox(height: 8),
                  _FilterRadioTile(
                    label: 'الشهر الحالي',
                    selected: tempMonth == currentMonth,
                    onTap: () => setSheetState(() => tempMonth = currentMonth),
                  ),
                  _FilterRadioTile(
                    label: 'الشهر الماضي',
                    selected: tempMonth == prevMonth,
                    onTap: () => setSheetState(() => tempMonth = prevMonth),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
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
                      child: const Text('تطبيق', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CustomAppBar(
        title: Text(context.tr('leaderboard_nav')),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _openFilterSheet(context),
          ),
        ],
      ),
      body: BlocBuilder<LeaderboardBloc, LeaderboardState>(
        builder: (context, state) {
          if (state is LeaderboardLoading || state is LeaderboardInitial) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
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
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final media = MediaQueryHelper(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: media.width * 0.1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events_outlined, size: media.width * 0.18, color: AppColors.greyColor),
            SizedBox(height: media.height * 0.02),
            const Text('لا يوجد بيانات بعد لهذه الفترة/القسم', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboard(List<LeaderboardUserEntity> users) {
    final top3 = users.where((u) => u.rank <= 3).toList()..sort((a, b) => a.rank.compareTo(b.rank));
    final rest = users.where((u) => u.rank > 3).toList()..sort((a, b) => a.rank.compareTo(b.rank));

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (top3.isNotEmpty) _buildPodium(top3),
        const SizedBox(height: 24),
        ...rest.map((u) => LeaderboardItem(user: u)),
      ],
    );
  }

  Widget _buildPodium(List<LeaderboardUserEntity> top3) {
    LeaderboardUserEntity? first = top3.where((u) => u.rank == 1).isNotEmpty ? top3.firstWhere((u) => u.rank == 1) : null;
    LeaderboardUserEntity? second = top3.where((u) => u.rank == 2).isNotEmpty ? top3.firstWhere((u) => u.rank == 2) : null;
    LeaderboardUserEntity? third = top3.where((u) => u.rank == 3).isNotEmpty ? top3.firstWhere((u) => u.rank == 3) : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (third != null) Expanded(child: _PodiumSlot(user: third, height: 90, color: const Color(0xFF9AD9CE))),
        if (first != null) Expanded(child: _PodiumSlot(user: first, height: 130, color: AppColors.primaryColor, isFirst: true)),
        if (second != null) Expanded(child: _PodiumSlot(user: second, height: 105, color: const Color(0xFF6FCABB))),
      ],
    );
  }
}

class _PodiumSlot extends StatelessWidget {
  final LeaderboardUserEntity user;
  final double height;
  final Color color;
  final bool isFirst;

  const _PodiumSlot({required this.user, required this.height, required this.color, this.isFirst = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: isFirst ? 34 : 26,
            backgroundColor: AppColors.primaryColor.withOpacity(0.1),
            backgroundImage: (user.profilePicture != null && user.profilePicture!.isNotEmpty)
                ? NetworkImage(user.profilePicture!)
                : null,
            child: (user.profilePicture == null || user.profilePicture!.isEmpty)
                ? Icon(Icons.person, color: AppColors.primaryColor, size: isFirst ? 34 : 26)
                : null,
          ),
          const SizedBox(height: 6),
          Text(
            user.fullName,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: isFirst ? 14 : 12),
          ),
          const SizedBox(height: 8),
          Container(
            height: height,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            alignment: Alignment.center,
            child: Text(
              '${user.rank}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 26),
            ),
          ),
        ],
      ),
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.greyColor.withOpacity(0.4)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: AppColors.primaryColor,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(label),
          ],
        ),
      ),
    );
  }
}
