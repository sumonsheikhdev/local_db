<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# Package Name

local_db is a Flutter package inspired by Sharedpreference that makes it easy to store and retrieve data locally. It provides a simple and intuitive interface for managing local data with support for dynamic models.

## Features

- Store and retrieve boolean values
- Store and retrieve string values
- Store and retrieve integer values
- Store and retrieve double values
- Store and retrieve complex data structures using JSON serialization
- Add data to a list and retrieve list data
- Delete data by index or key

## Installation

Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
    local_db:
    git:
      url: https://github.com/sumonsheik/local_db.git


## Usage

Import the package into your Dart file to initialize:


import 'package:local_db/init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDb.initialization();
  runApp(const MyApp());}



## To get available methods to store and retrieve data:

```dart
import 'package:local_db/local_db.dart';

 data
//Such as

//To get list data
data.getListData<YourModel>(
            key: 'your key',
            fromJson: (json) => YourModel.fromJson(
                json), // Provide the correct implementation here
          ),

// To add data

await data.addToDataList(
    newData: yourData according to Model,
    key: 'dataList',
    
    toJson: (data) => data.toJson(), //Convert to json
    fromJson: (json) => YourModel.fromJson(json),
);



```

##Contribution

Contributions are welcome! If you encounter any issues or have suggestions for improvements, please file an issue. If you would like to contribute code, feel free to open a pull request with your changes.
