import 'package:chip_8_flutter/core/cpu.dart';
import 'package:chip_8_flutter/utils/size_config.dart';
import 'package:chip_8_flutter/view_models/display_view_model.dart';
import 'package:chip_8_flutter/widgets/keyboard.dart';
import 'package:chip_8_flutter/widgets/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final DisplayViewModel dvm = DisplayViewModel();

final screenBufferProvider = ChangeNotifierProvider<DisplayViewModel>((ref) {
  return dvm;
});

class Console extends StatefulWidget {
  const Console({Key? key}) : super(key: key);

  @override
  _ConsoleState createState() => _ConsoleState();
}

class _ConsoleState extends State<Console> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();

    CPU.init(dvm);
    _ticker = createTicker((Duration? _) {
      CPU.fetch();
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Chip_8'),
        titleTextStyle: AppBarTheme.of(context)
            .titleTextStyle!
            .copyWith(fontSize: SizeConfig.widthPercent * 5),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Screen(),
          SizedBox(
            width: double.infinity,
          ),
          Keyboard(),
        ],
      ),
    );
  }
}
