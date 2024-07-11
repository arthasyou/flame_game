import 'package:flutter/material.dart';

import 'image_button.dart';

class ButtonGroup extends StatelessWidget {
  const ButtonGroup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(8, (index) {
        return ImageButton(
          onTap: () {
            print('gggg');
          },
          pressedImagePath: 'assets/images/fruit/fruit_btn_bet_88.png',
          normalImagePath: 'assets/images/fruit/fruit_btn_bet_8.png',
        );
      }),
    );
  }
}
