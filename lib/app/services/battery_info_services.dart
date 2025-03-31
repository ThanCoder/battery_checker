import 'dart:convert';
import 'dart:io';

import 'package:bat_ck/app/models/battery_info_model.dart';

class BatteryInfoServices {
  static Future<BatteryInfoModel?> getCurrentInfo(int currentLevel) async {
    final list = await getList();
    for (var info in list) {
      if (currentLevel == info.level) {
        return info;
      }
    }
    for (var info in list) {
      if (currentLevel > info.level && currentLevel <= info.level + 10) {
        return info;
      }
    }
    return null;
  }

  static Future<List<BatteryInfoModel>> getList() async {
    List<BatteryInfoModel> list = [];
    final file = File('battery_checker_info.json');
    if (file.existsSync()) {
      List<dynamic> res = jsonDecode(await file.readAsString());
      list = res.map((map) => BatteryInfoModel.fromMap(map)).toList();
    }
    return list;
  }
}
