import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/services/pusher_service.dart';
import '../../../domain/repository/chat_repository.dart';
import '../../../domain/usecases/add_members_usecase.dart';
import '../../../domain/usecases/create_group_chat_usecase.dart';
import '../../../domain/usecases/create_personal_chat_usecase.dart';
import '../../../domain/usecases/get_chats_use_case.dart';
import '../../../domain/usecases/get_members_usecase.dart';
import '../../../domain/usecases/get_messages_usecase.dart';
import '../../../domain/usecases/mark_as_read_usecase.dart';
import '../../../domain/usecases/mark_as_received_usecase.dart';
import '../../../domain/usecases/leave_group_usecase.dart';
import '../../../domain/usecases/remove_member_usecase.dart';
import '../../../domain/usecases/send_message_usecase.dart';
import '../../../domain/usecases/send_typing_usecase.dart';
import '../../../domain/usecases/stop_typing_usecase.dart';
import '../../../domain/usecases/update_group_usecase.dart';
import 'bloc_event.dart';
import 'bloc_state.dart';


class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  final PusherService pusherService;

  final GetChatsUseCase getChatsUseCase;
  final GetMessagesUseCase getMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final CreatePersonalChatUseCase createPersonalChatUseCase;
  final CreateGroupChatUseCase createGroupChatUseCase;
  final MarkAsReadUseCase markAsReadUseCase;
  final MarkAsReceivedUseCase markAsReceivedUseCase;
  final GetMembersUseCase getMembersUseCase;
  final AddMembersUseCase addMembersUseCase;
  final RemoveMemberUseCase removeMemberUseCase;
  final UpdateGroupUseCase updateGroupUseCase;
  final LeaveGroupUseCase leaveGroupUseCase;
  final SendTypingUseCase sendTypingUseCase;
  final StopTypingUseCase stopTypingUseCase;

  StreamSubscription? _pusherSubscription;
  int? _currentChatId;

  ChatBloc({
    required this.chatRepository,
    required this.pusherService,
    required this.getChatsUseCase,
    required this.getMessagesUseCase,
    required this.sendMessageUseCase,
    required this.createPersonalChatUseCase,
    required this.createGroupChatUseCase,
    required this.markAsReadUseCase,
    required this.markAsReceivedUseCase,
    required this.getMembersUseCase,
    required this.addMembersUseCase,
    required this.removeMemberUseCase,
    required this.updateGroupUseCase,
    required this.leaveGroupUseCase,
    required this.sendTypingUseCase,
    required this.stopTypingUseCase,
  }) : super(ChatInitial()) {

    on<GetChatsEvent>(_onGetChats);
    on<GetMessagesEvent>(_onGetMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<CreatePersonalChatEvent>(_onCreatePersonalChat);
    on<CreateGroupChatEvent>(_onCreateGroupChat);
    on<MarkAsReadEvent>(_onMarkAsRead);
    on<MarkAsReceivedEvent>(_onMarkAsReceived);
    on<GetMembersEvent>(_onGetMembers);
    on<AddMembersEvent>(_onAddMembers);
    on<RemoveMemberEvent>(_onRemoveMember);
    on<UpdateGroupEvent>(_onUpdateGroup);
    on<LeaveGroupEvent>(_onLeaveGroup);
    on<ClearMessagesEvent>((event, emit) => emit(ChatInitial()));

    on<LoadChatDraftEvent>(_onLoadChatDraft);
    on<SaveChatDraftEvent>(_onSaveChatDraft);

    on<StartTypingEvent>(_onStartTyping);
    on<StopTypingEvent>(_onStopTyping);

    on<OnNewMessageReceived>(_onNewMessageReceived);
    on<OnUserTypingChanged>(_onUserTypingChanged);

    _initPusher();
  }

  void _initPusher() {
    _pusherSubscription = pusherService.eventStream.listen((event) {
      if (event.eventName == 'message.new') {
        add(OnNewMessageReceived(event.data));
      } else if (event.eventName == 'user.typing') {
        add(OnUserTypingChanged(event.data));
      }
    });
  }

  void startChatsPulling() {
    add(const GetChatsEvent(isSilent: false));
  }

  void startMessagesPulling(int chatId, {bool isGroup = false}) {
    _currentChatId = chatId;
    add(GetMessagesEvent(chatId, isSilent: false));
    final channelName = isGroup ? "presence-chat.$chatId" : "private-chat.$chatId";
    pusherService.subscribe(channelName);
  }

  void stopChatsPulling() {
  }

  void stopMessagesPulling({bool isGroup = false}) {
    if (_currentChatId != null) {
      final channelName = isGroup ? "presence-chat.$_currentChatId" : "private-chat.$_currentChatId";
      pusherService.unsubscribe(channelName);
      _currentChatId = null;
    }
  }

  void clearAllPulling() {
    stopMessagesPulling();
  }

  Future<void> _onGetChats(GetChatsEvent event, Emitter<ChatState> emit) async {
    if (!event.isSilent && state is! ChatsLoaded) {
      emit(ChatsLoading());
    }
    final failureOrChats = await getChatsUseCase();
    failureOrChats.fold(
          (failure) => emit(const ChatsError("Failed to fetch chats")),
          (chats) => emit(ChatsLoaded(chats)),
    );
  }

  Future<void> _onGetMessages(GetMessagesEvent event, Emitter<ChatState> emit) async {
    if (!event.isSilent) {
      emit(MessagesLoading());
    }
    final failureOrMessages = await getMessagesUseCase(event.chatId);
    failureOrMessages.fold(
          (failure) {
        if (!event.isSilent) {
          emit(const MessagesError("Failed to fetch messages"));
        }
      },
          (messages) => emit(MessagesLoaded(messages)),
    );
  }

  Future<void> _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    final failureOrMessage = await sendMessageUseCase(chatId: event.chatId, content: event.content);
    failureOrMessage.fold(
          (failure) => emit(const ChatsError("Failed to send message")),
          (message) {
        emit(MessageSent(message));
        add(GetMessagesEvent(event.chatId, isSilent: true));
      },
    );
  }

  Future<void> _onNewMessageReceived(OnNewMessageReceived event, Emitter<ChatState> emit) async {
    add(const GetChatsEvent(isSilent: true));
    if (_currentChatId != null) {
      add(GetMessagesEvent(_currentChatId!, isSilent: true));
    }
  }

  Future<void> _onUserTypingChanged(OnUserTypingChanged event, Emitter<ChatState> emit) async {
    final data = event.typingData;
    if (data is Map && data['user_id'] != null) {
      final chatId = int.tryParse(data['chat_id']?.toString() ?? '');
      
      // نتحقق أن الإشعار يخص المحادثة الحالية المفتوحة
      if (chatId == _currentChatId) {
        emit(UserTypingState(
          userId: int.tryParse(data['user_id'].toString()) ?? 0,
          userName: data['user_name'],
          isTyping: data['is_typing'] ?? false,
        ));
      }
    }
  }

  Future<void> _onCreatePersonalChat(CreatePersonalChatEvent event, Emitter<ChatState> emit) async {
    emit(ChatsLoading());
    final failureOrChat = await createPersonalChatUseCase(receiverId: event.receiverId, content: event.content);
    failureOrChat.fold(
          (failure) => emit(const ChatsError("Failed to create chat")),
          (chat) {
        emit(ChatCreated(chat));
        add(const GetChatsEvent(isSilent: true));
      },
    );
  }

  Future<void> _onCreateGroupChat(CreateGroupChatEvent event, Emitter<ChatState> emit) async {
    emit(ChatsLoading());

    final failureOrChat = await createGroupChatUseCase(
      name: event.name,
      memberIds: event.memberIds,
    );

    failureOrChat.fold(
          (failure) => emit(const ChatsError("Failed to create group chat")),
          (chat) {
        emit(ChatCreated(chat));
        add(const GetChatsEvent(isSilent: true));
      },
    );
  }

  Future<void> _onMarkAsRead(MarkAsReadEvent event, Emitter<ChatState> emit) async {
    final result = await markAsReadUseCase(event.chatId);
    result.fold(
          (failure) => null,
          (unit) => add(const GetChatsEvent(isSilent: true)),
    );
  }

  Future<void> _onMarkAsReceived(MarkAsReceivedEvent event, Emitter<ChatState> emit) async {
    await markAsReceivedUseCase(event.chatId);
  }

  Future<void> _onGetMembers(GetMembersEvent event, Emitter<ChatState> emit) async {
    emit(MembersLoading());
    final result = await getMembersUseCase(event.chatId);
    result.fold(
          (failure) => emit(const ChatsError("Failed to fetch members")),
          (members) => emit(MembersLoaded(members)),
    );
  }

  Future<void> _onAddMembers(AddMembersEvent event, Emitter<ChatState> emit) async {
    emit(MembersLoading());
    final result = await addMembersUseCase(event.chatId, event.userIds);
    result.fold(
          (failure) => emit(const ChatsError("Failed to add members")),
          (unit) {
        emit(const MemberActionSuccess("Member(s) added successfully"));
        add(GetMembersEvent(event.chatId));
      },
    );
  }

  Future<void> _onRemoveMember(RemoveMemberEvent event, Emitter<ChatState> emit) async {
    emit(MembersLoading());
    final result = await removeMemberUseCase(event.chatId, event.userId);
    result.fold(
          (failure) => emit(const ChatsError("Failed to remove member")),
          (unit) {
        emit(const MemberActionSuccess("Member removed successfully"));
        add(GetMembersEvent(event.chatId));
      },
    );
  }

  Future<void> _onUpdateGroup(UpdateGroupEvent event, Emitter<ChatState> emit) async {
    emit(MembersLoading());
    final result = await updateGroupUseCase(event.chatId, event.name);
    result.fold(
          (failure) => emit(const ChatsError("Failed to update group")),
          (unit) {
        emit(const MemberActionSuccess("Group updated successfully"));
        add(const GetChatsEvent(isSilent: true));
        add(GetMembersEvent(event.chatId));
      },
    );
  }

  Future<void> _onLeaveGroup(LeaveGroupEvent event, Emitter<ChatState> emit) async {
    emit(MembersLoading());
    final result = await leaveGroupUseCase(event.chatId);
    result.fold(
          (failure) => emit(const ChatsError("Failed to leave group")),
          (unit) {
        emit(const MemberActionSuccess("You left the group"));
        add(const GetChatsEvent(isSilent: false));
      },
    );
  }

  Future<void> _onLoadChatDraft(LoadChatDraftEvent event, Emitter<ChatState> emit) async {
    final draft = await chatRepository.getChatDraft(event.chatId);
    emit(ChatDraftLoaded(draft));
  }

  Future<void> _onSaveChatDraft(SaveChatDraftEvent event, Emitter<ChatState> emit) async {
    if (event.draftText.trim().isEmpty) {
      await chatRepository.clearChatDraft(event.chatId);
    } else {
      await chatRepository.saveChatDraft(event.chatId, event.draftText);
    }
  }

  Future<void> _onStartTyping(StartTypingEvent event, Emitter<ChatState> emit) async {
    await sendTypingUseCase(event.chatId);
  }

  Future<void> _onStopTyping(StopTypingEvent event, Emitter<ChatState> emit) async {
    await stopTypingUseCase(event.chatId);
  }

  @override
  Future<void> close() {
    _pusherSubscription?.cancel();
    return super.close();
  }
}
