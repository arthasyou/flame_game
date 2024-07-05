import 'package:flame/game.dart';
import 'package:flame_game/games/slot_machine.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../provider/slot_machine_provider.dart';

class SlotMachineWidget extends ConsumerStatefulWidget {
  const SlotMachineWidget({super.key});

  @override
  SlotMachineWidgetState createState() => SlotMachineWidgetState();
}

class SlotMachineWidgetState extends ConsumerState<SlotMachineWidget> {
  late SlotMachine game;

  @override
  void initState() {
    super.initState();
    // 初始化游戏实例
    game = SlotMachine(ref.read(slotMachineProvider));
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(slotMachineProvider);
    return Stack(
      children: [
        Center(
          child: GameWidget(game: game),
        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Center(
            child: ElevatedButton(
              onPressed: provider.isSpinning
                  ? null // 当 isSpinning 为 true 时禁用按钮
                  : () {
                      game.startSpinning();
                    },
              child: const Text('Run'),
            ),
          ),
        ),
      ],
    );
  }
}
