import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'local_db.dart';

final sl = GetIt.instance;

abstract class LocalDb {
  static Future<void> initialization() async {
    ///shared prefs
    final sharedPref = await SharedPreferences.getInstance();

    sl.registerLazySingleton<SharedPreferences>(() => sharedPref);

    /// local auth data source
    sl.registerLazySingleton<LocalDatabase>(
      () => LocalDatabaseImplement(sharedPreferences: sl()),
    );
  }
}
