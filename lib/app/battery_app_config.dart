import 'package:battery_checker/app/ui/home/battery_info.dart';
import 'package:than_pkg/t_database/index.dart';

class BatteryAppConfig {
  final BatteryInfoLanguageType languageType;
  final double batteryLabelFontSize;
  final double batteryDescLabelFontSize;

  const BatteryAppConfig(
      {required this.languageType,
      required this.batteryLabelFontSize,
      required this.batteryDescLabelFontSize});
  factory BatteryAppConfig.newConfig() {
    return BatteryAppConfig(
        languageType: BatteryInfoLanguageType.myanmar,
        batteryLabelFontSize: 49,
        batteryDescLabelFontSize: 19);
  }

  BatteryAppConfig copyWith(
      {BatteryInfoLanguageType? languageType,
      double? batteryLabelFontSize,
      double? batteryDescLabelFontSize}) {
    return BatteryAppConfig(
        languageType: languageType ?? this.languageType,
        batteryLabelFontSize: batteryLabelFontSize ?? this.batteryLabelFontSize,
        batteryDescLabelFontSize:
            batteryDescLabelFontSize ?? this.batteryDescLabelFontSize);
  }

  factory BatteryAppConfig.fromRecent() {
    return BatteryAppConfig(
        languageType: BatteryInfoLanguageType.getName(
            TRecentDB.getInstance.getString('languageType')),
        batteryLabelFontSize:
            TRecentDB.getInstance.getDouble('batteryLabelFontSize', def: 49),
        batteryDescLabelFontSize: TRecentDB.getInstance
            .getDouble('batteryDescLabelFontSize', def: 19));
  }
  Future<void> saveRecent() async {
    await TRecentDB.getInstance.putString('languageType', languageType.name);
    await TRecentDB.getInstance
        .putDouble('batteryDescLabelFontSize', batteryDescLabelFontSize);
    await TRecentDB.getInstance
        .putDouble('batteryLabelFontSize', batteryLabelFontSize);
  }
}
