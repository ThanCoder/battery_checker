import 'dart:async';
import 'package:bat_ck/app/general_server/general_server_noti_button.dart';
import 'package:bat_ck/app/services/battery_info_services.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/index.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription<BatteryState>? _batteryStateSubscription;

  @override
  void initState() {
    // battery.onBatteryStateChanged.listen(_updateBatteryState);
    battery.batteryState.then(_updateBatteryState);
    _batteryStateSubscription =
        battery.onBatteryStateChanged.listen(_updateBatteryState);
    super.initState();
    init();
  }

  final battery = Battery();

  int currentBatteryLevel = 0;
  Color? currentColor;
  String desc = '';
  String stateText = 'စစ်ဆေးနေပါတယ်...';

  void init() async {
    try {
      final res = await battery.batteryLevel;
      currentBatteryLevel = res;
      _showInfo();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _updateBatteryState(BatteryState state) {
    if (state.name == BatteryState.charging.name) {
      stateText = 'အားသွင်းနေပါတယ်...';
    }
    if (state.name == BatteryState.discharging.name) {
      stateText = 'အားမသွင်းထားပါ..';
    }
    if (state.name == BatteryState.full.name) {
      stateText = 'အားပြည့်သွားပါပြီ...';
    }
    if (state.name == BatteryState.connectedNotCharging.name) {
      stateText = 'ကြိုးထိုးထားပေမယ့် အားမသွင်းပါ...';
    }

    _showInfo();
  }

  void _showInfo() async {
    final info = await BatteryInfoServices.getCurrentInfo(currentBatteryLevel);
    if (info == null) return;

    currentColor = Color(int.parse(info.color.replaceAll('#', '0xFF')));
    desc = info.description;

    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      contentPadding: 0,
      appBar: AppBar(
        title: Text(appTitle),
        actions: [
          GeneralServerNotiButton(),
        ],
      ),
      body: AnimatedContainer(
        duration: Duration(milliseconds: 900),
        decoration: BoxDecoration(
          color: currentColor,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 15,
            children: [
              Text(
                stateText,
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              Text(
                '$currentBatteryLevel %',
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
              desc.isNotEmpty
                  ? Text(
                      desc,
                      style: TextStyle(
                        fontSize: 17,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_batteryStateSubscription != null) {
      _batteryStateSubscription!.cancel();
    }
    super.dispose();
  }
}
