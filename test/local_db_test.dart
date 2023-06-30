import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_db/init.dart';
import 'package:local_db/local_db.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the SharedPreferences plugin
  SharedPreferences.setMockInitialValues({});

  setUp(() async {
    await LocalDb.initialization();
  });

  test('adds one to input values', () async {
    data.storeString(value: 'Hi Meem', key: 'meem');

    print(data.getString(key: 'meem'));
  });
}
