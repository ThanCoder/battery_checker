import 'package:flutter/material.dart';
import 'package:t_release/services/t_release_services.dart';
import 'package:than_pkg/than_pkg.dart';

import 'app/my_app.dart';
import 'app/services/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThanPkg.windowManagerensureInitialized();

  //init config
  await initAppConfigService();

  await TReleaseServices.instance
      .initial('https://github.com/ThanCoder/flutter_boilerplate');

  runApp(const MyApp());
}
