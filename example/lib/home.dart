import 'package:flutter/material.dart';
import 'package:local_db/local_db.dart';

import 'data_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            _showAddDataDialog(context: context);
          }),
      body: RefreshIndicator(
        onRefresh: _onrefresh,
        child: FutureBuilder(
          future: data.getListData<DataModel>(
            key: 'ListOfMap',
            fromJson: (json) => DataModel.fromJson(
                json), // Provide the correct implementation here
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final dataList = snapshot.data!;

              return dataList.isEmpty
                  ? const Center(
                      child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'No Data',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ))
                  : ListView.builder(
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        final data = dataList[index];

                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(data.name),
                              subtitle: Text(data.proffession),
                            ));
                      },
                    );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Future<void> _onrefresh() async {
    setState(() {
      data.getListData<DataModel>(
        key: 'ListOfMap',
        fromJson: (json) => DataModel.fromJson(json),
      );
    });
  }

  void _showAddDataDialog({required BuildContext context}) {
    final TextEditingController nameCtr = TextEditingController();
    final TextEditingController proffessionCtr = TextEditingController();
    showDialog(
      context: context,
      builder: (
        BuildContext context,
      ) {
        return AlertDialog(
          title: const Text('Add Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameCtr,
                decoration: InputDecoration(
                  labelText: 'Name',
                  filled: true,
                  fillColor: Colors.grey[300],
                ),
              ),
              TextFormField(
                controller: proffessionCtr,
                decoration: InputDecoration(
                  labelText: 'Profession',
                  filled: true,
                  fillColor: Colors.grey[300],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: () {
                DataModel newData = DataModel(
                  name: nameCtr.text,
                  proffession: proffessionCtr.text,
                );
                data
                    .addToDataList<DataModel>(
                  newData: newData,
                  key: 'ListOfMap',
                  fromJson: (json) => DataModel.fromJson(json),
                  toJson: (data) => data.toJson(),
                )
                    .then((value) {
                  setState(() {
                    nameCtr.clear();
                    proffessionCtr.clear();
                    Navigator.of(context).pop();
                  });
                });
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
