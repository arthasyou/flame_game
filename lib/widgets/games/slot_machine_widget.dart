import 'package:flame/game.dart';
import 'package:flame_game/games/slot_machine.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SlotMachineWidget extends ConsumerWidget {
  const SlotMachineWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = SlotMachine();
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
              onPressed: () {
                if (game.isSpinning) {
                  game.stopSpinning();
                } else {
                  game.startSpinning();
                }
              },
              child: const Text('Start'),
            ),
          ),
        ),
      ],
    );
  }
}
