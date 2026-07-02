import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/create_group_chat_usecase.dart';
import '../../../domain/usecases/create_personal_chat_usecase.dart';
import '../../../domain/usecases/getChatsUseCase.dart';
import '../../../domain/usecases/get_messages_usecase.dart';
import '../../../domain/usecases/send_message_usecase.dart';
import 'blocEvent.dart';
import 'blocState.dart';


class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetChatsUseCase getChatsUseCase;
  final GetMessagesUseCase getMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final CreatePersonalChatUseCase createPersonalChatUseCase;
  final CreateGroupChatUseCase createGroupChatUseCase;

  Timer? _chatsTimer;
  Timer? _messagesTimer;

  ChatBloc({
    required this.getChatsUseCase,
    required this.getMessagesUseCase,
    required this.sendMessageUseCase,
    required this.createPersonalChatUseCase, required this.createGroupChatUseCase,
  }) : super(ChatInitial()) {

    on<GetChatsEvent>(_onGetChats);
    on<GetMessagesEvent>(_onGetMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<CreatePersonalChatEvent>(_onCreatePersonalChat);
    on<CreateGroupChatEvent>(_onCreateGroupChat);
  }

  void startChatsPulling() {
    _chatsTimer?.cancel();
    add(const GetChatsEvent(isSilent: false));
    _chatsTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      add(const GetChatsEvent(isSilent: true));
    });
  }

  void startMessagesPulling(int chatId) {
    _messagesTimer?.cancel();
    add(GetMessagesEvent(chatId, isSilent: false));
    _messagesTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      add(GetMessagesEvent(chatId, isSilent: true));
    });
  }

  void stopChatsPulling() => _chatsTimer?.cancel();

  void stopMessagesPulling() => _messagesTimer?.cancel();

  Future<void> _onGetChats(GetChatsEvent event, Emitter<ChatState> emit) async {
    if (!event.isSilent) emit(ChatsLoading());
    final failureOrChats = await getChatsUseCase();
    failureOrChats.fold(
          (failure) => emit(const ChatsError("Failed to fetch chats")),
          (chats) => emit(ChatsLoaded(chats)),
    );
  }

  Future<void> _onGetMessages(GetMessagesEvent event, Emitter<ChatState> emit) async {
    if (!event.isSilent) emit(MessagesLoading());
    final failureOrMessages = await getMessagesUseCase(event.chatId);
    failureOrMessages.fold(
          (failure) => emit(const ChatsError("Failed to fetch messages")),
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

  Future<void> _onCreatePersonalChat(CreatePersonalChatEvent event, Emitter<ChatState> emit) async {
    emit(ChatsLoading());
    final failureOrChat = await createPersonalChatUseCase(receiverId: event.receiverId, content: event.content);
    failureOrChat.fold(
          (failure) => emit(const ChatsError("Failed to create chat")),
          (chat) {
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
        add(const GetChatsEvent(isSilent: true));
      },
    );
  }



  @override
  Future<void> close() {
    _chatsTimer?.cancel();
    _messagesTimer?.cancel();
    return super.close();
  }
}