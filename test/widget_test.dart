import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:adsd_maintenance_app/main.dart';

void main() {
  testWidgets('App should start without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app starts (no crashes)
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('App shows ADSD Maintenance title', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    
    // Should show the app title
    await tester.pump();
    
    // Check for the main title
    expect(find.text('ADSD Maintenance'), findsOneWidget);
    expect(find.text('ADSD Maintenance App'), findsOneWidget);
  });

  testWidgets('App shows maintenance features', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();
    
    // Check for maintenance features
    expect(find.text('Offline First'), findsOneWidget);
    expect(find.text('Auto Sync'), findsOneWidget);
    expect(find.text('Local Storage'), findsOneWidget);
  });
} 