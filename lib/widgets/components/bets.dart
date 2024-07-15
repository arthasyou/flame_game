import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../provider/slot_machine_provider.dart';
import 'image_lable.dart';

class BetsWidget extends ConsumerWidget {
  const BetsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(slotMachineProvider);
    return Row(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(8, (index) {
        return Transform.translate(
          offset: Offset(0, 0),
          child: ImageLable(
            imagePath: 'assets/images/fruit/fruit_img_8.png',
            sizeX: 47,
            sizeY: 20,
            text: provider.getBet(index).toString(),
          ),
        );
      }),
    );
  }
}
