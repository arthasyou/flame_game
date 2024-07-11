import 'package:flame/game.dart';
import 'package:flame_game/games/slot_machine.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../provider/slot_machine_provider.dart';
import '../components/image_button.dart';
import '../components/image_button_group.dart';

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
          bottom: 145,
          right: 0,
          child: ImageButton(
            buttonText: AppLocalizations.of(context)!.go,
            onTap: () {
              if (!provider.isSpinning) {
                game.startSpinning();
              } else {
                //button disable
              }
            },
            pressedImagePath: 'assets/images/fruit/fruit_btn_bet_100.png',
            normalImagePath: 'assets/images/fruit/fruit_btn_bet_10.png',
            isEnabled: !provider.isSpinning,
          ),
        ),
        const Positioned(
          bottom: 125,
          right: 0,
          child: ButtonGroup(),
        ),
      ],
    );
  }
}
