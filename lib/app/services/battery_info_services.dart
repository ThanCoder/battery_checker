import 'dart:convert';
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
    List<dynamic> res = jsonDecode(getDataList());
    list = res.map((map) => BatteryInfoModel.fromMap(map)).toList();
    return list;
  }

  static String getDataList() {
    final res = '''[
  {
    "level": 5,
    "color": "#FF0000",
    "description": "အားအရမ်းနည်းနေပြီ ချက်ချင်းအားသွင်းပေးပါ!"
  },
  {
    "level": 10,
    "color": "#FF0000",
    "description": "အားအရမ်းနည်းနေပြီ ချက်ချင်းအားသွင်းပေးပါ!"
  },
  {
    "level": 20,
    "color": "#FF1100",
    "description": "Battery အားအတော်လေး နည်းနေပြီး။အားသွင်းပေးပါ"
  },
  {
    "level": 30,
    "color": "#FF2200",
    "description": "Battery အားနည်းနေတယ်။အားသွင်းဖို့စဥ်းစားပါ။"
  },
  {
    "level": 40,
    "color": "#FF4400",
    "description": "Battery အား 40% ရောက်နေပြီ, ဖြစ်နိုင်ရင် အားသွင်းပါ"
  },
  {
    "level": 50,
    "color": "#FF6600",
    "description": "Battery အား 50% ။သင့်တော်တဲ့ အနေအထားပဲ။"
  },
  {
    "level": 60,
    "color": "#FF8800",
    "description": "Battery အား 60% အထက်။ကောင်းမွန်တဲ့အနေအထား။"
  },
  {
    "level": 70,
    "color": "#FFAA00",
    "description": "Battery အား 70%။အသုံးပြန်ဖို့ လုံလောက်တယ်။"
  },
  {
    "level": 80,
    "color": "#FFCC00",
    "description": "Battery အား 80%။အရမ်းကောင်းမွန်တဲ့ အနေအထား။"
  },
  {
    "level": 90,
    "color": "#00FF00",
    "description": "Battery အားပြည့်တော့မယ်။အရမ်းကောင်းမွန်တဲ့ အခြေအနေပါ။"
  },
  {
    "level": 100,
    "color": "#00CC00",
    "description": "Battery အားပြည့်ပါပြီ။လိုအပ်ရင် အားသွင်းကြိုးဖြတ်ထားလိုက်ပါ။"
  }
]''';
    return res;
  }
}
