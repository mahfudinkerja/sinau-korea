import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sinau_korea/theme.dart';
import 'package:sinau_korea/widgets/common.dart';

void main() {
  test('heading light mode memakai warna gelap eksplisit', () {
    final theme = buildLightTheme();
    expect(theme.textTheme.titleLarge!.color, isNotNull);
    expect(theme.textTheme.headlineMedium!.color, isNotNull);
    expect(theme.textTheme.headlineLarge!.color, isNotNull);
    expect(theme.textTheme.titleLarge!.color!.computeLuminance(), lessThan(0.2));
    expect(
      theme.textTheme.headlineMedium!.color!.computeLuminance(),
      lessThan(0.2),
    );
  });

  test('heading dark mode tetap terang', () {
    final theme = buildAppTheme();
    expect(theme.textTheme.titleLarge!.color, isNotNull);
    expect(theme.textTheme.titleLarge!.color!.computeLuminance(), greaterThan(0.6));
    expect(
      theme.textTheme.headlineMedium!.color!.computeLuminance(),
      greaterThan(0.6),
    );
  });

  testWidgets('SectionHeader terbaca di light mode', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildLightTheme(),
        home: const Scaffold(
          body: Padding(
            padding: EdgeInsets.all(12),
            child: SectionHeader('Judul bagian'),
          ),
        ),
      ),
    );

    final text = tester.widget<Text>(find.text('Judul bagian'));
    expect(text.style?.color, isNotNull);
    expect(text.style!.color!.computeLuminance(), lessThan(0.2));
  });
}
