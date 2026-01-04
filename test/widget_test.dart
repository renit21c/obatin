import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obatin/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Splash screen shows logo', (WidgetTester tester) async {
    // Set up mock SharedPreferences to simulate no user being logged in.
    SharedPreferences.setMockInitialValues({});

    // Build the SplashScreen directly to isolate it from the rest of the app.
    await tester.pumpWidget(
      const MaterialApp(
        home: SplashScreen(),
      ),
    );

    // Verify that the splash screen shows the logo initially.
    expect(find.byType(Image), findsOneWidget);
    final Image image = tester.widget(find.byType(Image));
    expect((image.image as AssetImage).assetName, 'assets/obatinlogo.png');
  });
}

