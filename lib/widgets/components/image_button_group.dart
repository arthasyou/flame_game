import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../provider/slot_machine_provider.dart';
import 'image_button.dart';

class ButtonGroup extends ConsumerWidget {
  const ButtonGroup({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Define the paths for normal and pressed images
    final List<String> normalImagePaths = [
      'assets/images/fruit/fruit_btn_bet_8.png',
      'assets/images/fruit/fruit_btn_bet_7.png',
      'assets/images/fruit/fruit_btn_bet_6.png',
      'assets/images/fruit/fruit_btn_bet_5.png',
      'assets/images/fruit/fruit_btn_bet_4.png',
      'assets/images/fruit/fruit_btn_bet_3.png',
      'assets/images/fruit/fruit_btn_bet_2.png',
      'assets/images/fruit/fruit_btn_bet_1.png',
    ];

    final List<String> pressedImagePaths = [
      'assets/images/fruit/fruit_btn_bet_88.png',
      'assets/images/fruit/fruit_btn_bet_77.png',
      'assets/images/fruit/fruit_btn_bet_66.png',
      'assets/images/fruit/fruit_btn_bet_55.png',
      'assets/images/fruit/fruit_btn_bet_44.png',
      'assets/images/fruit/fruit_btn_bet_33.png',
      'assets/images/fruit/fruit_btn_bet_22.png',
      'assets/images/fruit/fruit_btn_bet_11.png',
    ];
    return Row(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(8, (index) {
        final x1 = -index * (12.0 - 1.5 * index);
        final x2 = -index * (12.0 - 0.6 * (15 - index));

        return Transform.translate(
          offset: Offset(index < 5 ? x1 : x2, 0),
          child: ImageButton(
            imageSizeX: 60,
            imageSizeY: 50,
            onTap: () {
              ref.read(slotMachineProvider).increaseBet(index, 1);
            },
            normalImagePath: normalImagePaths[index],
            pressedImagePath: pressedImagePaths[index],
          ),
        );
      }),
    );
  }
}
