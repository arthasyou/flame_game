import 'package:flame_game/widgets/components/image_lable.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../provider/slot_machine_provider.dart';

import 'image_button.dart';

class RewardWidget extends ConsumerWidget {
  const RewardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(slotMachineProvider);

    return Stack(children: [
      Stack(
        children: [
          Image.asset(
            'assets/images/fruit/fruit_light.png',
            width: 200,
            height: 200,
            fit: BoxFit.fill,
          ),
          Container(
            width: 200,
            height: 200,
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                ImageLable(
                  imagePath: 'assets/images/fruit/fruit_img_2.png',
                  sizeX: 60,
                  sizeY: 60,
                  text: provider.bigOrSmallBet.toString(),
                ),
                const SizedBox(height: 100),
                ImageLable(
                  imagePath: 'assets/images/fruit/fruit_img_2.png',
                  sizeX: 130,
                  sizeY: 30,
                  text: provider.bigOrSmallBet.toString(),
                ),
              ],
            ),
          ),
        ],
      ),
    ]);
  }
}
