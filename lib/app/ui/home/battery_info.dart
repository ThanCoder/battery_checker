import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:than_pkg/than_pkg.dart';

enum BatteryInfoLanguageType {
  english,
  myanmar;

  static BatteryInfoLanguageType getName(String name) {
    if (name == english.name) return english;
    return myanmar;
  }
}

class BatteryInfo {
  final int level;
  final String colorHex;
  final String description;

  const BatteryInfo(
      {required this.level, required this.colorHex, required this.description});

  factory BatteryInfo.fromMap(Map<String, dynamic> map) {
    return BatteryInfo(
        level: map.getInt(['level']),
        colorHex: map.getString(['colorHex']),
        description: map.getString(['description']));
  }

  // Hex String ကို Flutter Color Object အဖြစ် ပြောင်းပေးတဲ့ logic
  Color get color {
    // #FF0000 ကို 0xFFFF0000 ပုံစံပြောင်းတာပါ
    String hex = colorHex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex'; // Opacity (FF) မပါရင် ထည့်ပေးရပါတယ်
    }
    return Color(int.parse('0x$hex'));
  }
}

class BatteryInfoServices {
  static Future<List<BatteryInfo>> getFromAssets(
      {BatteryInfoLanguageType language =
          BatteryInfoLanguageType.myanmar}) async {
    List<BatteryInfo> list = [];
    final json = await rootBundle
        .loadString('assets/battery_info_${language.name}.json');
    List<dynamic> mapList = jsonDecode(json);
    list = mapList.map((map) => BatteryInfo.fromMap(map)).toList();

    return list;
  }
}
