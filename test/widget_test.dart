import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:adsd_maintenance_app/main.dart';

void main() {
  testWidgets('App should start without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Verify that the app starts (no crashes)
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('App shows loading or login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    
    // Should show either loading indicator or login elements
    await tester.pump();
    
    // Check for loading or login elements
    final hasLoading = find.byType(CircularProgressIndicator).evaluate().isNotEmpty;
    final hasLoginElements = find.text('ADSD Maintenance').evaluate().isNotEmpty ||
                            find.text('Login').evaluate().isNotEmpty;
    
    expect(hasLoading || hasLoginElements, isTrue, 
           reason: 'App should show loading or login screen');
  });
} 