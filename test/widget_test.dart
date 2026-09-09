// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_time/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:in_time/features/chat/data/repository/chat_repository_impl.dart';
import 'package:in_time/features/chat/domain/usecases/get_chats_use_case.dart';
import 'package:in_time/injection_container.dart' as di;
import 'package:in_time/main.dart';

void main() async{
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {

    await di.init();
    await tester.pumpWidget(MyApp(initialRoute: '/',

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
