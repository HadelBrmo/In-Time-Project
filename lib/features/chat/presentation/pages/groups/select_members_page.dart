import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_routes.dart';
import '../../../../../core/utils/snackbar_utils.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../../bloc/chatBloc/blocEvent.dart';
import '../../bloc/chatBloc/blocState.dart';
import '../../bloc/chatBloc/chatBloc.dart';

class SelectableUser {
  final int id;
  final String name;
  final String? avatarUrl;
  bool isSelected;

  SelectableUser({required this.id, required this.name, this.avatarUrl, this.isSelected = false});
}

class SelectMembersPage extends StatefulWidget {
  final String groupName;
  final bool isAddingToExistingGroup;
  final int? chatId;

  const SelectMembersPage({
    super.key,
    required this.groupName,
    this.isAddingToExistingGroup = false,
    this.chatId,
  });

  @override
  State<SelectMembersPage> createState() => _SelectMembersPageState();
}

class _SelectMembersPageState extends State<SelectMembersPage> {
  final TextEditingController _searchController = TextEditingController();
  List<SelectableUser> _allUsers = [];
  List<SelectableUser> _filteredUsers = [];
  bool _isUsersInitialized = false;

  @override
  void initState() {
    super.initState();
    final state = context.read<ChatBloc>().state;
    if (state is! ChatsLoaded) {
      context.read<ChatBloc>().add(const GetChatsEvent());
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterUsers(String query) {
    setState(() {
      _filteredUsers = _allUsers
          .where((user) => user.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  int get _selectedCount => _allUsers.where((u) => u.isSelected).length;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final inputFillColor = isDarkMode ? const Color(0xFF1E1E1E) : AppColors.whiteColor;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocListener<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatCreated) {
            SnackBarUtils.showSuccess(
              context,
              "تم إنشاء المجموعة بنجاح",

            );
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            
            Navigator.pushNamed(
              context,
              AppRoutes.chatRoomPage,
              arguments: {
                'chatId': state.chat.id,
                'chatTitle': state.chat.name ?? widget.groupName,
                'isGroup': true,
              },
            );
          } else if (state is MemberActionSuccess) {
            SnackBarUtils.showSuccess(context, state.message);
            Navigator.pop(context);
          } else if (state is ChatsError) {
             SnackBarUtils.showError(context, state.message);
          }
        },
        child: Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: CustomAppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('إضافة أعضاء', style: TextStyle(fontSize: 18)),
                Text(
                  'المجموعة: ${widget.groupName}',
                  style: const TextStyle(fontSize: 12, color: Colors.white70, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterUsers,
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    hintText: "البحث عن جهات اتصال ومحادثات...",
                    hintStyle: TextStyle(color: isDarkMode ? Colors.white60 : Colors.grey),
                    filled: true,
                    fillColor: inputFillColor,
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, state) {
                    if (state is ChatsLoading && !_isUsersInitialized) {
                      return const Center(child: LoadingWidget());
                    } else if (state is ChatsLoaded || _isUsersInitialized) {
                      if (!_isUsersInitialized && state is ChatsLoaded) {
                        _allUsers = state.chats
                            .where((chat) => chat.type == 'personal' && chat.otherUser != null)
                            .map((chat) => SelectableUser(
                                  id: chat.otherUser!.id,
                                  name: chat.otherUser!.fullName,
                                  avatarUrl: chat.otherUser!.profilePicture,
                                ))
                            .toList();

                        final Map<int, SelectableUser> uniqueUsers = {};
                        for (var user in _allUsers) {
                          uniqueUsers[user.id] = user;
                        }
                        _allUsers = uniqueUsers.values.toList();

                        _filteredUsers = List.from(_allUsers);
                        _isUsersInitialized = true;
                      }

                      if (_allUsers.isEmpty && state is! ChatsLoading) {
                        return const Center(child: Text("لا توجد محادثات سابقة لإضافة أعضاء."));
                      }

                      if (_filteredUsers.isEmpty && _searchController.text.isNotEmpty) {
                        return const Center(child: Text("لا توجد نتائج مطابقة"));
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        itemCount: _filteredUsers.length,
                        separatorBuilder: (_, __) => Divider(color: isDarkMode ? Colors.white10 : Colors.grey[200], height: 1),
                        itemBuilder: (context, index) {
                          final user = _filteredUsers[index];
                          return CheckboxListTile(
                            activeColor: AppColors.primaryColor,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                            secondary: CircleAvatar(
                              radius: 22,
                              backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                              backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
                              child: user.avatarUrl == null
                                  ? Text(user.name.isNotEmpty ? user.name[0] : "?", style: const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold))
                                  : null,
                            ),
                            value: user.isSelected,
                            onChanged: (bool? value) {
                              setState(() {
                                user.isSelected = value ?? false;
                              });
                            },
                          );
                        },
                      );
                    } else if (state is ChatsError && !_isUsersInitialized) {
                      return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
                    }
                    return const Center(child: LoadingWidget());
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              if (state is ChatsLoading && _isUsersInitialized) {
                return const FloatingActionButton(
                  onPressed: null,
                  backgroundColor: Colors.grey,
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              return _selectedCount > 0
                  ? FloatingActionButton.extended(
                      onPressed: () {
                        final List<int> selectedIds = _allUsers.where((u) => u.isSelected).map((u) => u.id).toList();

                        if (widget.isAddingToExistingGroup && widget.chatId != null) {
                          context.read<ChatBloc>().add(AddMembersEvent(widget.chatId!, selectedIds));
                        } else {
                          context.read<ChatBloc>().add(
                                CreateGroupChatEvent(
                                  name: widget.groupName,
                                  memberIds: selectedIds,
                                ),
                              );
                        }
                      },
                      backgroundColor: AppColors.primaryColor,
                      icon: const Icon(Icons.check, color: Colors.white),
                      label: Text("إنشاء الآن ($_selectedCount)", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ).animate().scale(duration: 200.ms, curve: Curves.easeOutBack)
                  : const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
