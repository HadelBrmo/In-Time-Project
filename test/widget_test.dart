// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_time/features/chat/data/datasources/chatRemoteDataSource.dart';
import 'package:in_time/features/chat/data/repository/chatRepositoryImpl.dart';
import 'package:in_time/features/chat/domain/usecases/deleteChatUseCase.dart';
import 'package:in_time/features/chat/domain/usecases/getChatsUseCase.dart';
import 'package:in_time/features/chat/domain/usecases/searchChatsUseCase.dart';

import 'package:in_time/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final remoteDataSource = ChatRemoteDataSourceImpl();
    final chatRepository = ChatRepositoryImpl(remoteDataSource: remoteDataSource);

    final getChatsUseCase = GetChatsUseCase(chatRepository);
    final deleteChatUseCase = DeleteChatUseCase(chatRepository);
    final searchChatsUseCase = SearchChatsUseCase(chatRepository);

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(
      getChatsUseCase: getChatsUseCase,
      deleteChatUseCase: deleteChatUseCase,
      searchChatsUseCase: searchChatsUseCase,
    ));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
