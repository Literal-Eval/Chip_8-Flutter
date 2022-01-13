import 'dart:async';

import 'package:chip_8_flutter/core/cpu.dart';
import 'package:chip_8_flutter/models/registers.dart';
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

class _ConsoleState extends State<Console> with TickerProviderStateMixin {
  late final Ticker _ticker;
  // late final AnimationController _cpuCycleCap;
  late final Timer _cap;

  @override
  void initState() {
    super.initState();

    CPU.init(dvm);

    // _cpuCycleCap = AnimationController(vsync: this)
    //   ..repeat(period: const Duration(milliseconds: 1));

    // _cpuCycleCap.addListener(() {
    //   CPU.fetch();
    // });
    _cap = Timer.periodic(const Duration(milliseconds: 1), (timer) {
      CPU.fetch();
    });

    _ticker = createTicker((Duration? _) {
      Registers.handleDT();
      Registers.handleST();
    });
    _ticker.start();
  }

  @override
  void dispose() {
    // _cpuCycleCap.removeListener(() {
    //   CPU.fetch();
    // });
    _cap.cancel();
    // _cpuCycleCap.dispose();
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
