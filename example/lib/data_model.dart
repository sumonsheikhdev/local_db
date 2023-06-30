class DataModel {
  final String name;
  final String proffession;

  DataModel({required this.name, required this.proffession});

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      name: json['name'],
      proffession: json['proffession'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'proffession': proffession,
    };
  }
}
