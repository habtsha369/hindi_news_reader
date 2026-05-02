import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hindi_news_reader/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NewsReaderApp());

    // Verify that our app starts and shows the 'Home' text in the bottom navigation.
    expect(find.text('Home'), findsWidgets);
  });
}
