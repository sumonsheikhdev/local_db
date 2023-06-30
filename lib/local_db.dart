import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'init.dart';

abstract class LocalDatabase {
  //Boolean
  Future<bool> storeBool({required bool value, required String key});
  bool? getBool({required String key});

  Future<void> storeString({required String value, required String key});
  String? getString({required String key});

  Future<void> storeInt({required int value, required String key});
  int? getInt({required String key});

  Future<void> storeDouble({required double value, required String key});
  double? getDouble({required String key});

  Future<void> addToDataList<T>({
    required T newData,
    required String key,
    required Map<String, dynamic> Function(T) toJson,
    required T Function(Map<String, dynamic>) fromJson,
  });
  Future<List<T>> getListData<T>(
      {required String key,
      required T Function(Map<String, dynamic>) fromJson});

  Future<void> deleteByIndex<T>({
    required int index,
    required String key,
    required T Function(Map<String, dynamic>) fromJson,
  });

  Future<void> deleteByKey({required String key});
}

class LocalDatabaseImplement extends LocalDatabase {
  final SharedPreferences sharedPreferences;

  LocalDatabaseImplement({required this.sharedPreferences});

  @override
  Future<bool> storeBool({required bool value, required String key}) async {
    return await sharedPreferences.setBool(key, value);
  }

  @override
  Future<void> storeString({required String value, required String key}) async {
    await sharedPreferences.setString(key, value);
  }

  @override
  String? getString({required String key}) {
    return sharedPreferences.getString(key);
  }

  @override
  bool? getBool({required String key}) {
    return sharedPreferences.getBool(key);
  }

  @override
  double? getDouble({required String key}) {
    return sharedPreferences.getDouble(key);
  }

  @override
  int? getInt({required String key}) {
    return sharedPreferences.getInt(key);
  }

  @override
  Future<void> addToDataList<T>({
    required T newData,
    required String key,
    required Map<String, dynamic> Function(T) toJson,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final dataList = await getListData<T>(key: key, fromJson: fromJson);

    // Add the new data to the existing list
    dataList.add(newData);

    // Encode the list of objects into a list of JSON strings
    List<String> encodedList =
        dataList.map((data) => jsonEncode(toJson(data))).toList();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save the encoded list back to SharedPreferences
    await prefs.setStringList(key, encodedList);
  }

  @override
  Future<List<T>> getListData<T>(
      {required String key,
      required T Function(Map<String, dynamic>) fromJson}) async {
    // Retrieve the encoded list from SharedPreferences
    List<String>? encodedList = sharedPreferences.getStringList(key);

    // Decode the list of strings back into a list of maps
    List<Map<String, dynamic>> dataList = encodedList
            ?.map((str) => jsonDecode(str))
            .cast<Map<String, dynamic>>()
            .toList() ??
        [];

    // Convert the list of maps into a list of instances of type T
    List<T> resultList = dataList.map((data) => fromJson(data)).toList();

    return resultList;
  }

  @override
  Future<void> storeDouble({required double value, required String key}) async {
    await sharedPreferences.setDouble(key, value);
  }

  @override
  Future<void> storeInt({required int value, required String key}) async {
    await sharedPreferences.setInt(key, value);
  }

  @override
  Future<void> deleteByIndex<T>({
    required int index,
    required String key,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final dataList = await getListData<T>(key: key, fromJson: fromJson);

    if (index >= 0 && index < dataList.length) {
      dataList.removeAt(index);

      // Encode the updated list of objects into a list of JSON strings
      List<String> encodedList =
          dataList.map((data) => jsonEncode(data)).toList();

      // Save the updated encoded list back to SharedPreferences
      await sharedPreferences.setStringList(key, encodedList);
    }
  }

  @override
  Future<void> deleteByKey({required String key}) async {
    // Remove the entry with the specified key from SharedPreferences
    await sharedPreferences.remove(key);
  }
}

final data = sl<LocalDatabase>();
