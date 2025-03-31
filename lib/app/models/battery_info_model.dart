// ignore_for_file: public_member_api_docs, sort_constructors_first
class BatteryInfoModel {
  int level;
  String color;
  String description;
  BatteryInfoModel({
    required this.level,
    required this.color,
    required this.description,
  });

  factory BatteryInfoModel.fromMap(Map<String, dynamic> map) {
    return BatteryInfoModel(
      level: map['level'],
      color: map['color'],
      description: map['description'],
    );
  }
}
