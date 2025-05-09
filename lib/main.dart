import 'package:bat_ck/app/general_server/general_services.dart';
import 'package:flutter/material.dart';
import 'package:than_pkg/than_pkg.dart';

import 'app/my_app.dart';
import 'app/services/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThanPkg.windowManagerensureInitialized();

  //init config
  await initAppConfigService();

  await GeneralServices.instance.init();

  runApp(const MyApp());
}
