import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/snackbar_utils.dart';
import '../../../../../core/utils/dialog_utils.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../../../../../injection_container.dart';
import '../../bloc/chat_bloc/chat_bloc.dart';
import '../../bloc/chat_bloc/bloc_event.dart';
import '../../bloc/chat_bloc/bloc_state.dart';
import 'select_members_page.dart';

class GroupInfoPage extends StatefulWidget {
  final int chatId;
  final String chatTitle;
  final int? createdBy;

  const GroupInfoPage({
    super.key,
    required this.chatId,
    required this.chatTitle,
    this.createdBy,
  });

  @override
  State<GroupInfoPage> createState() => _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  late int _currentUserId;

  @override
  void initState() {
    super.initState();
    _currentUserId = sl<SharedPreferences>().getInt("user_id") ?? 0;
    context.read<ChatBloc>().add(GetMembersEvent(widget.chatId));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: CustomAppBar(
          title: const Text('معلومات المجموعة'),
        ),
        body: BlocConsumer<ChatBloc, ChatState>(
          buildWhen: (previous, current) =>
              current is MembersLoading || current is MembersLoaded || current is ChatsError,
          listener: (context, state) {
            if (state is MemberActionSuccess) {
              SnackBarUtils.showSuccess(context, state.message);
              if (state.message.contains("left")) {
                Navigator.of(context).pop(); // Close GroupInfo
                Navigator.of(context).pop(); // Close ChatRoom
              }
            } else if (state is ChatsError) {
              SnackBarUtils.showError(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is MembersLoading) {
              return const Center(child: LoadingWidget());
            }

            if (state is MembersLoaded) {
              final members = state.members;
              final isCreator = widget.createdBy == _currentUserId;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                            child: const Icon(Icons.groups, size: 40, color: AppColors.primaryColor),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(widget.chatTitle, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                              if (isCreator)
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 20, color: AppColors.primaryColor),
                                  onPressed: () => _showEditNameDialog(context),
                                ),
                            ],
                          ),
                          Text('${members.length} أعضاء', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('الأعضاء', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          TextButton.icon(
                            onPressed: () => _openAddMembers(context, members),
                            icon: const Icon(Icons.person_add),
                            label: const Text('إضافة'),
                            style: TextButton.styleFrom(foregroundColor: AppColors.primaryColor),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        final member = members[index];
                        final isMe = member.id == _currentUserId;
                        final memberIsCreator = member.id == widget.createdBy;

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: member.profilePicture != null ? NetworkImage(member.profilePicture!) : null,
                            child: member.profilePicture == null ? Text(member.fullName[0]) : null,
                          ),
                          title: Text(member.fullName + (isMe ? ' (أنت)' : '')),
                          subtitle: memberIsCreator 
                              ? const Text('مؤسس المجموعة', style: TextStyle(color: AppColors.primaryColor, fontSize: 12, fontWeight: FontWeight.bold)) 
                              : null,
                          trailing: (isCreator && !memberIsCreator)
                              ? IconButton(
                                  icon: const Icon(Icons.person_remove, color: Colors.red),
                                  onPressed: () => _confirmRemove(context, member.id, member.fullName),
                                )
                              : null,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: TextButton.icon(
                        onPressed: () => _confirmLeave(context),
                        icon: const Icon(Icons.exit_to_app, color: Colors.red),
                        label: const Text('مغادرة المجموعة', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              );
            }

            return const Center(child: Text('حدث خطأ في تحميل الأعضاء'));
          },
        ),
      ),
    );
  }

  void _showEditNameDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController(text: widget.chatTitle);
    DialogUtils.showCustomDialog(
      context: context,
      builder: AlertDialog(
        title: const Text('تعديل اسم المجموعة'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: "اسم المجموعة الجديد"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                context.read<ChatBloc>().add(UpdateGroupEvent(widget.chatId, nameController.text.trim()));
                Navigator.pop(context);
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _confirmRemove(BuildContext context, int userId, String name) {
    DialogUtils.showConfirmDialog(
      context: context,
      title: 'إزالة عضو',
      message: 'هل أنت متأكد من إزالة $name من المجموعة؟',
      confirmText: 'إزالة',
      confirmColor: Colors.red,
      onConfirm: () {
        context.read<ChatBloc>().add(RemoveMemberEvent(widget.chatId, userId));
      },
    );
  }

  void _confirmLeave(BuildContext context) {
    DialogUtils.showConfirmDialog(
      context: context,
      title: 'مغادرة المجموعة',
      message: 'هل أنت متأكد من رغبتك في مغادرة هذه المجموعة؟',
      confirmText: 'مغادرة',
      confirmColor: Colors.red,
      onConfirm: () {
        context.read<ChatBloc>().add(LeaveGroupEvent(widget.chatId));
      },
    );
  }

  void _openAddMembers(BuildContext context, List<dynamic> currentMembers) {
    final List<int> memberIds = currentMembers.map((m) => m.id as int).toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => BlocProvider.value(
          value: context.read<ChatBloc>(),
          child: SelectMembersPage(
            groupName: widget.chatTitle,
            isAddingToExistingGroup: true,
            chatId: widget.chatId,
            existingMemberIds: memberIds,
          ),
        ),
      ),
    );
  }
}
