import 'package:coldbit_wallet/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() {
    Animate.restartOnHotReload = false;
  });

  testWidgets('ColdBit Wallet shows logo and title', (WidgetTester tester) async {
    await tester.pumpWidget(const ColdBitApp());
    await tester.pumpAndSettle(); // waits all animations

    expect(find.text('ColdBit Wallet'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);

    final image = tester.widget<Image>(find.byType(Image));
    final provider = image.image as AssetImage;
    expect(provider.assetName, equals('assets/icon/icon_without_bg.png'));
  });
}