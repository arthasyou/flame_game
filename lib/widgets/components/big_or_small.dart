import 'package:flame_game/widgets/components/image_lable.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../provider/slot_machine_provider.dart';
import 'image_button.dart';

class LabeledButtonWidget extends StatelessWidget {
  final String buttonText;
  final String lableText;
  final String normalImagePath;
  final String pressedImagePath;
  final String labelImagePath;
  final VoidCallback onTap;

  const LabeledButtonWidget({
    super.key,
    required this.buttonText,
    required this.lableText,
    required this.normalImagePath,
    required this.pressedImagePath,
    required this.labelImagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      ImageButton(
        imageSizeX: 50,
        imageSizeY: 40,
        buttonText: buttonText,
        containerSizeX: 50,
        containerSizeY: 40,
        normalImagePath: normalImagePath,
        pressedImagePath: pressedImagePath,
        onTap: onTap,
      ),
      const SizedBox(width: 2),
      ImageLable(
        imagePath: labelImagePath,
        sizeX: 80,
        sizeY: 20,
        text: lableText,
      ),
    ]);
  }
}

class BigSmallWidget extends ConsumerWidget {
  const BigSmallWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(slotMachineProvider);

    return Row(children: <Widget>[
      LabeledButtonWidget(
        buttonText: '2-6',
        lableText: provider.bigOrSmallBet.toString(), // 使用 provider 的值
        normalImagePath: 'assets/images/fruit/fruit_btn_bet_112.png',
        pressedImagePath: 'assets/images/fruit/fruit_btn_bet_111.png',
        labelImagePath: 'assets/images/fruit/fruit_img_8.png',
        onTap: () {
          // 使用 provider 的方法
          ref.read(slotMachineProvider).addBoSBet();
          print('gggg');
        },
      ),
      const SizedBox(width: 2),
      LabeledButtonWidget(
        buttonText: '8-12',
        lableText: provider.bigOrSmallBet.toString(), // 使用 provider 的另一个值
        normalImagePath: 'assets/images/fruit/fruit_btn_bet_112.png',
        pressedImagePath: 'assets/images/fruit/fruit_btn_bet_111.png',
        labelImagePath: 'assets/images/fruit/fruit_img_8.png',
        onTap: () {
          // 使用 provider 的另一个方法

          print('jjj');
        },
      ),
    ]);
  }
}
