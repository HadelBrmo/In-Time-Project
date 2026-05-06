
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/chatEntity.dart';
import '../../../domain/usecases/deleteChatUseCase.dart';
import '../../../domain/usecases/getChatsUseCase.dart';
import '../../../domain/usecases/searchChatsUseCase.dart';
import 'blocEvent.dart';
import 'blocState.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetChatsUseCase getChatsUseCase;
  final DeleteChatUseCase deleteChatUseCase;
  final SearchChatsUseCase searchChatsUseCase;

  List<ChatEntity> _allChats = [];
  ChatEntity? _lastDeletedChat;
  int? _lastDeletedIndex;

  ChatBloc({
    required this.getChatsUseCase,
    required this.deleteChatUseCase,
    required this.searchChatsUseCase,
  }) : super(ChatInitial()) {

    on<LoadChatsEvent>((event, emit) async {
      emit(ChatLoading());
      try {
        _allChats = await getChatsUseCase();
        emit(ChatLoaded(chats: _allChats));
      } catch (e) {
        emit(ChatError("فشل تحميل المحادثات"));
      }
    });

    on<DeleteChatEvent>((event, emit) async {
      if (state is ChatLoaded) {
        _lastDeletedIndex = _allChats.indexWhere((c) => c.id == event.chatId);
        _lastDeletedChat = _allChats[_lastDeletedIndex!];

        _allChats.removeAt(_lastDeletedIndex!);
        emit(ChatLoaded(chats: List.from(_allChats), deletedChatId: event.chatId));

      }
    });

    on<UndoDeleteEvent>((event, emit) {
      if (_lastDeletedChat != null && _lastDeletedIndex != null) {
        _allChats.insert(_lastDeletedIndex!, _lastDeletedChat!);
        emit(ChatLoaded(chats: List.from(_allChats)));
        _lastDeletedChat = null;
        _lastDeletedIndex = null;
      }
    });

    on<SearchChatsEvent>((event, emit) async {
      if (event.query.isEmpty) {
        emit(ChatLoaded(chats: _allChats));
        return;
      }
      emit(ChatLoading());

      try {
        final searchResults = await searchChatsUseCase(event.query);

        emit(ChatLoaded(chats: searchResults));
      } catch (e) {
        emit(ChatError("حدث خطأ أثناء البحث"));
      }
    });
  }
}