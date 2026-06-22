import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cnn_3d/main.dart';

void main() {
  testWidgets('SomnoGuard muestra splash', (WidgetTester tester) async {
    await tester.pumpWidget(const SomnoGuardApp());
    expect(find.text('SomnoGuard'), findsOneWidget);
  });
}
