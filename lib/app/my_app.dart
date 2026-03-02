import 'package:flutter/material.dart';
import 'package:battery_checker/app/ui/home/home_screen.dart';
import 'package:battery_checker/more_libs/setting/core/theme_listener.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeListener(
      builder: (context, themeMode) => MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: themeMode,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: HomeScreen(),
      ),
    );
  }
}
