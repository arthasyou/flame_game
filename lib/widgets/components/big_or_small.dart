import 'package:flame_game/widgets/components/image_lable.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../protos/message.pb.dart';
import '../../provider/slot_machine_provider.dart';
import '../../services/message_service.dart';
import 'image_button.dart';

// class LabeledButtonWidget extends StatelessWidget {
//   final String buttonText;
//   final String lableText;
//   final String normalImagePath;
//   final String pressedImagePath;
//   final String labelImagePath;
//   final VoidCallback onTap;

//   const LabeledButtonWidget({
//     super.key,
//     required this.buttonText,
//     required this.lableText,
//     required this.normalImagePath,
//     required this.pressedImagePath,
//     required this.labelImagePath,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: List.generate(3, (index) {
//         return ImageButton(
//           imageSizeX: 50,
//           imageSizeY: 40,
//           buttonText: buttonText,
//           containerSizeX: 50,
//           containerSizeY: 40,
//           normalImagePath: normalImagePath,
//           pressedImagePath: pressedImagePath,
//           onTap: onTap,
//         );
//       }),
//     );
//   }
// }

class BigSmallWidget extends ConsumerWidget {
  const BigSmallWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(slotMachineProvider);
    final MessageService messageService = MessageService();

    return Row(children: <Widget>[
      ImageButton(
        buttonText: '2-6',
        imageSizeX: 50,
        imageSizeY: 40,
        containerSizeX: 50,
        containerSizeY: 40,
        normalImagePath: 'assets/images/fruit/fruit_btn_bet_112.png',
        pressedImagePath: 'assets/images/fruit/fruit_btn_bet_111.png',
        onTap: () {
          messageService.sendMessage(
              ref, 2001, FruitPlayArg(flag: '1', fruits: provider.bets));
        },
        isEnabled: !provider.isSpinning,
      ),
      const SizedBox(width: 2),
      ImageButton(
        buttonText: '8-12',
        imageSizeX: 50,
        imageSizeY: 40,
        containerSizeX: 50,
        containerSizeY: 40,
        normalImagePath: 'assets/images/fruit/fruit_btn_bet_112.png',
        pressedImagePath: 'assets/images/fruit/fruit_btn_bet_111.png',
        onTap: () {
          messageService.sendMessage(
              ref, 2001, FruitPlayArg(flag: '1', fruits: provider.bets));
        },
        isEnabled: !provider.isSpinning,
      ),
      const SizedBox(width: 2),
      ImageButton(
        buttonText: 'bet',
        imageSizeX: 50,
        imageSizeY: 40,
        containerSizeX: 50,
        containerSizeY: 40,
        normalImagePath: 'assets/images/fruit/fruit_btn_bet_112.png',
        pressedImagePath: 'assets/images/fruit/fruit_btn_bet_111.png',
        onTap: () {
          ref.read(slotMachineProvider).addBoSBet();
        },
        isEnabled: !provider.isSpinning,
      ),
      const SizedBox(width: 2),
      ImageLable(
        imagePath: 'assets/images/fruit/fruit_img_8.png',
        sizeX: 80,
        sizeY: 20,
        text: provider.bigOrSmallBet.toString(),
      ),
    ]);
  }
}
