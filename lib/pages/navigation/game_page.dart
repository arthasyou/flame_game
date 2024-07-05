import 'package:auto_route/auto_route.dart';
import 'package:flame_game/widgets/games/slot_machine_widget.dart';
import 'package:flutter/material.dart';

@RoutePage()
class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SlotMachineWidget(),
    );
  }
}
