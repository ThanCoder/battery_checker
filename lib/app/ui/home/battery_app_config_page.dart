import 'package:battery_checker/app/battery_app_config.dart';
import 'package:battery_checker/app/ui/home/battery_info.dart';
import 'package:dart_core_extensions/dart_core_extensions.dart';
import 'package:flutter/material.dart';
import 'package:t_widgets/t_widgets.dart';

class BatteryAppConfigPage extends StatefulWidget {
  final void Function(BatteryAppConfig newConfig)? onClosed;
  const BatteryAppConfigPage({super.key, required this.onClosed});

  @override
  State<BatteryAppConfigPage> createState() => _BatteryAppConfigPageState();
}

class _BatteryAppConfigPageState extends State<BatteryAppConfigPage> {
  var config = BatteryAppConfig.fromRecent();
  final batteryLabelFontSize = TextEditingController();
  final batteryDescLabelFontSize = TextEditingController();
  final languageList = BatteryInfoLanguageType.values;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    batteryLabelFontSize.dispose();
    batteryDescLabelFontSize.dispose();
    super.dispose();
  }

  void init() {
    batteryLabelFontSize.text = config.batteryLabelFontSize.toInt().toString();
    batteryDescLabelFontSize.text =
        config.batteryDescLabelFontSize.toInt().toString();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        widget.onClosed?.call(config);

        // ပြီးမှ တကယ် back ဆုတ်တယ်
        Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Battery App Config'),
          leading: IconButton(
              onPressed: () {
                // ဒီမှာ callback ကို ခေါ်ပေးရပါမယ်
                widget.onClosed?.call(config);
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back)),
        ),
        body: TScrollableColumn(children: [
          TNumberField(
            label: Text('Label Font Size'),
            controller: batteryLabelFontSize,
          ),
          TNumberField(
            label: Text('Description Font Size'),
            controller: batteryDescLabelFontSize,
          ),
          _languageChooser()
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: _save,
          child: Icon(Icons.save_as),
        ),
      ),
    );
  }

  Widget _languageChooser() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 4,
          children: [
            Text('Description Languages'),
            DropdownButton<BatteryInfoLanguageType>(
              padding: EdgeInsets.all(3),
              borderRadius: BorderRadius.circular(3),
              value: config.languageType,
              items: languageList
                  .map((e) => DropdownMenuItem<BatteryInfoLanguageType>(
                      value: e, child: Text(e.name.toCaptalize)))
                  .toList(),
              onChanged: (value) {
                config = config.copyWith(languageType: value!);
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  void _save() async {
    try {
      config = config.copyWith(
        batteryDescLabelFontSize:
            double.tryParse(batteryDescLabelFontSize.text) ?? 19,
        batteryLabelFontSize: double.tryParse(batteryLabelFontSize.text) ?? 49,
      );
      await config.saveRecent();
      if (!mounted) return;

      widget.onClosed?.call(config);
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      showTMessageDialogError(context, e.toString());
    }
  }
}
