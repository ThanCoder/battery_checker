import 'package:battery_checker/more_libs/setting/core/path_util.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';
import 'package:than_pkg/than_pkg.dart';
import 'package:battery_checker/app/my_app.dart';
import 'package:battery_checker/more_libs/desktop_exe/desktop_exe.dart';
import 'package:battery_checker/more_libs/setting/setting.dart';

void main() async {
  await ThanPkg.instance.init();

  await Setting.instance.init(
    appName: 'battery_checker',
    // releaseUrl: 'http',
    onSettingSaved: (context, message) {
      showTSnackBar(context, message);
    },
  );

  await TWidgets.instance.init(
    initialThemeServices: true,
    defaultImageAssetsPath: 'assets/thancoder_logo.png',
    isDarkTheme: () => Setting.getAppConfig.isDarkTheme,
  );

  if (TPlatform.isDesktop) {
    await DesktopExe.exportDesktopIcon(
      name: Setting.instance.appName,
      assetsIconPath: 'assets/thancoder_logo.png',
    );

    WindowOptions windowOptions = WindowOptions(
      size: Size(602, 568), // စတင်ဖွင့်တဲ့အချိန် window size

      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      center: false,
      title: Setting.instance.appName,
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
  await TRecentDB.getInstance
      .init(rootPath: PathUtil.getConfigPath(name: 'app.config.json'));

  runApp(const MyApp());
}
