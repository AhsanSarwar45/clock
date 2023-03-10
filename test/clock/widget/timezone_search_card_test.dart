import 'package:clock_app/clock/logic/timezone_database.dart';
import 'package:clock_app/clock/types/city.dart';
import 'package:clock_app/clock/widgets/timezone_search_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/data/latest_all.dart' as timezone_db;

void main() {
  group('TimeZoneSearchCard', () {
    setUp(
      () async {
        timezone_db.initializeTimeZones();
        await GetStorage.init();
        await initializeDatabases();
      },
    );
    testWidgets(
      'shows city name correctly',
      (tester) async {
        City sampleCity = await renderWidget(tester);

        // The widget code uses `replaceAll` to work around flutter's
        // limitation of cutting entire words on overflow instead of
        // individual letters, so we do the same here
        expect(find.text(sampleCity.name.replaceAll('', '\u{200B}')),
            findsOneWidget);
      },
    );
    testWidgets(
      'shows country name correctly',
      (tester) async {
        City sampleCity = await renderWidget(tester);

        expect(find.text(sampleCity.country), findsOneWidget);
      },
    );
  });
}

Future<City> renderWidget(WidgetTester tester) async {
  var sampleCity = City("Tokyo", "Japan", "Asia/Tokyo");

  await tester.pumpWidget(
    MaterialApp(
      home: TimeZoneSearchCard(
        city: sampleCity,
        onTap: () {},
      ),
    ),
  );
  //action
  return sampleCity;
}
