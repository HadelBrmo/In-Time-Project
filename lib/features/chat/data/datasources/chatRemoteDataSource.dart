// chat_remote_data_source.dart
import '../Models/chatModel.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatModel>> getChats();
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  @override
  Future<List<ChatModel>> getChats() async {
    await Future.delayed(const Duration(seconds: 1));

    final List<Map<String, dynamic>> mockJson = [
      {
        'id': '1',
        'senderName': 'Aya',
        'lastMessage': 'شو رايك نطلع بكرة الساعة 3؟',
        'profileUrl': 'assets/images/images1.jpg',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 5)).toString(),
        'unreadCount': 2,
      },
      {
        'id': '2',
        'senderName': 'Flutter Developer',
        'lastMessage': 'Clean Architecture is great!',
        'profileUrl': '',
        'timestamp': DateTime.now().subtract(const Duration(hours: 1)).toString(),
        'unreadCount': 0,
      },
      {
        'id': '3',
        'senderName': 'Farah',
        'lastMessage': 'it is a good idea, let\'s do it',
        'profileUrl': 'assets/images/images3.jpg',
        'timestamp': DateTime.now().subtract(const Duration(hours: 1)).toString(),
        'unreadCount': 4,
      },
      {
        'id': '4',
        'senderName': 'Alaa',
        'lastMessage': 'يعطيك العافية , الدرس بكرة عالساعة 10',
        'profileUrl': 'assets/images/images4.jpg',
        'timestamp': DateTime.now().subtract(const Duration(hours: 1)).toString(),
        'unreadCount': 1,
      },
      {
        'id': '5',
        'senderName': 'Boushra',
        'lastMessage': 'I will travel tomorrow , see you soon!',
      'profileUrl': 'assets/images/images5.jpg',
        'timestamp': DateTime.now().subtract(const Duration(hours: 1)).toString(),
        'unreadCount': 0,
      },
      {
        'id': '6',
        'senderName': 'IT 5th Year SE(2025-2026)',
        'lastMessage': 'شو عطى الدكتور ابي اخر شي ',
        'profileUrl': 'assets/images/1761076167097.jpg',
        'timestamp': DateTime.now().subtract(const Duration(hours: 1)).toString(),
        'unreadCount': 0,
      },
      {
        'id': '7',
        'senderName': 'Sara',
        'lastMessage': 'رح استناكي بالطابق الاول ',
        'profileUrl': '',
        'timestamp': DateTime.now().subtract(const Duration(hours: 1)).toString(),
        'unreadCount': 6,
      },
      {
        'id': '8',
        'senderName': 'English Academy',
        'lastMessage': 'Hello every one , Don\'t be late please',
        'profileUrl': 'assets/images/images3.jpg',
        'timestamp': DateTime.now().subtract(const Duration(hours: 1)).toString(),
        'unreadCount': 3,
      },
      {
        'id': '9',
        'senderName': 'Ghina',
        'lastMessage': 'عم جهز حالي لامتحان الماجستير ان شاء الله',
        'profileUrl': 'assets/images/images2.jpg',
        'timestamp': DateTime.now().subtract(const Duration(hours: 1)).toString(),
        'unreadCount': 0,
      },
      {
        'id': '10',
        'senderName': 'Monna',
        'lastMessage': 'نراكم غدا ان شاء الله , كونو على استعداد تام يا صديقاتي',
        'profileUrl': 'assets/images/images1.jpg',
        'timestamp': DateTime.now().subtract(const Duration(hours: 1)).toString(),
        'unreadCount': 2,
      },
    ];

    return mockJson.map((json) => ChatModel.fromJson(json)).toList();
  }
}