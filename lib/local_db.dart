library local_db;

/// A Calculator.
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'init.dart';

abstract class LocalDatabase {
  Future<bool> storeBool({required bool value, required String key});
  bool? getBool({required String key});

  Future<void> storeString({required String value, required String key});
  String? getString({required String key});

  Future<void> storeInt({required int value, required String key});
  int? getInt({required String key});

  Future<void> storeDouble({required double value, required String key});
  double? getDouble({required String key});

  Future<void> addToDataList({required DataModel newData, required String key});

  Future<List<DataModel>> getListData({required String key});

  Future<void> deleteByIndex({required int index, required String key});

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
  Future<void> addToDataList({
    required DataModel newData,
    required String key,
  }) async {
    final dataList = await getListData(key: key);

    // Add the new data to the existing list
    dataList.add(newData);

    // Encode the list of maps into a list of strings
    List<String> encodedList =
        dataList.map((data) => jsonEncode(data.toJson())).toList();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save the encoded list back to SharedPreferences
    await prefs.setStringList(key, encodedList);
  }

  @override
  Future<List<DataModel>> getListData({required String key}) async {
    // Retrieve the encoded list from SharedPreferences
    List<String>? encodedList = sharedPreferences.getStringList(key);

    // Decode the list of strings back into a list of maps
    List<Map<String, dynamic>> dataList = encodedList
            ?.map((str) => Map<String, dynamic>.from(jsonDecode(str)))
            .toList() ??
        [];

    // Convert the list of maps into a list of MyDataModel instances
    List<DataModel> myDataList =
        dataList.map((data) => DataModel.fromJson(data)).toList();

    return myDataList;
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
  Future<void> deleteByIndex({required int index, required String key}) async {
    final dataList = await getListData(key: key);

    if (index >= 0 && index < dataList.length) {
      dataList.removeAt(index);

      // Encode the updated list of maps into a list of strings
      List<String> encodedList =
          dataList.map((data) => jsonEncode(data.toJson())).toList();

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

// lib/data_model.dart

class DataModel {
  final String name;
  final String profession;

  DataModel({required this.name, required this.profession});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'profession': profession,
    };
  }

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      name: json['name'],
      profession: json['profession'],
    );
  }
}

final data = sl<LocalDatabase>();
