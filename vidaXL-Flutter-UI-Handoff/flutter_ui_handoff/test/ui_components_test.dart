import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vidaxl_ui_handoff/vidaxl_ui_handoff.dart';
void main() {
  testWidgets('Gallery handles missing media', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: VidaProductGallery(
      images: [], labels: [], productName: 'Sample', productId: 'sample'))));
    expect(find.text('Images unavailable'), findsOneWidget);
  });
  testWidgets('Press feedback invokes the supplied action once', (tester) async {
    var taps = 0;
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: VidaPressFeedback(
      label: 'Save sample', onTap: () => taps++, child: const Text('Save')))));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(taps, 1);
  });
}
