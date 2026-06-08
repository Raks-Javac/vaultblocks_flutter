import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vaultblocks_mobile/di/app_di.dart';
import 'package:vaultblocks_mobile/main.dart';

void main() {
  testWidgets('renders the Vaultblocks home shell', (
    WidgetTester tester,
  ) async {
    setupAppDi();
    await tester.pumpWidget(const VaultblocksApp());
    await tester.pumpAndSettle();

    expect(find.text('Vaultblocks Mobile'), findsWidgets);
    expect(find.byType(Tab), findsNWidgets(2));
    expect(find.byType(TabBarView), findsOneWidget);
  });
}
