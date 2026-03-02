import 'dart:async';

import 'package:battery_checker/app/battery_app_config.dart';
import 'package:battery_checker/app/ui/home/battery_app_config_page.dart';
import 'package:battery_checker/app/ui/home/battery_info.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Instantiate it
  var battery = Battery();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
  }

  bool isLoading = false;
  int batteryLevel = 0;
  List<BatteryInfo> infoList = [];
  BatteryAppConfig config = BatteryAppConfig.newConfig();
  StreamSubscription<BatteryState>? sub;
  BatteryState? _batteryState;

  void init() async {
    try {
      isLoading = true;
      batteryLevel = await battery.batteryLevel;

      // get recent config
      config = BatteryAppConfig.fromRecent();

      infoList = await BatteryInfoServices.getFromAssets(
          language: config.languageType);
      _batteryState = await battery.batteryState;
      // Be informed when the state (full, charging, discharging) changes
      sub = battery.onBatteryStateChanged.listen((BatteryState state) async {
        // Do something with new state
        batteryLevel = await battery.batteryLevel;
        _batteryState = state;
        if (!mounted) return;
        setState(() {});
      });

      if (!mounted) return;
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
      if (!mounted) return;
      showTMessageDialogError(context, e.toString());
      setState(() {});
    }
  }

  @override
  void dispose() {
    if (sub != null) {
      sub?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Battery Checker'),
        actions: [_configAction()],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _getBatteryLable(),
            _currentBatteryState(),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(onPressed: () {
      //   batteryLevel -= 5;
      //   setState(() {});
      // }),
    );
  }

  Widget _configAction() {
    return IconButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    BatteryAppConfigPage(onClosed: _onSavedConfig),
              ));
        },
        icon: Icon(Icons.settings));
  }

  Widget _currentBatteryState() {
    if (_batteryState == null) return SizedBox.shrink();
    return Column(
      children: [
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current State: ',
              style: TextStyle(fontSize: 15),
            ),
            Text(
              _batteryState!.name.toCaptalize,
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _getBatteryLable() {
    if (infoList.isEmpty) return Text('Info List Empty!');

    // ငယ်စဉ်ကြီးလိုက် စီထားတယ်လို့ ယူဆပြီး currentLevel ထက် ကြီးတဲ့ ပထမဆုံး level ကို ရှာမယ်
    final status = infoList.firstWhere(
      (info) => batteryLevel <= info.level,
      orElse: () => infoList.last, // ဘာမှမတွေ့ရင် ၁၀၀% data ကို ပြမယ်
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$batteryLevel%',
          style: TextStyle(
              fontSize: config.batteryLabelFontSize, color: status.color),
        ),
        Text(
          status.description,
          style: TextStyle(
              fontSize: config.batteryDescLabelFontSize, color: status.color),
        )
      ],
    );
  }

  void _onSavedConfig(BatteryAppConfig newConfig) async {
    config = newConfig;
    try {
      infoList = await BatteryInfoServices.getFromAssets(
          language: config.languageType);
      _batteryState = await battery.batteryState;

      if (!mounted) return;
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
      if (!mounted) return;
      showTMessageDialogError(context, e.toString());
      setState(() {});
    }
  }
}
