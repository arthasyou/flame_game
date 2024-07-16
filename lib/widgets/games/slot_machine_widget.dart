import 'package:flame/game.dart';
import 'package:flame_game/games/slot_machine.dart';
import 'package:flame_game/protos/message.pb.dart';
import 'package:flame_game/widgets/components/image_lable.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../provider/slot_machine_provider.dart';
import '../../services/message_service.dart';
import '../../services/web_socket_service.dart';
import '../components/bets.dart';
import '../components/big_or_small.dart';
import '../components/image_button.dart';
import '../components/image_button_group.dart';

class SlotMachineWidget extends ConsumerStatefulWidget {
  const SlotMachineWidget({super.key});

  @override
  SlotMachineWidgetState createState() => SlotMachineWidgetState();
}

class SlotMachineWidgetState extends ConsumerState<SlotMachineWidget> {
  late SlotMachine game;
  late MessageService _messageService;

  @override
  void initState() {
    super.initState();
    // 初始化游戏实例
    game = SlotMachine(ref.read(slotMachineProvider));
    _messageService = MessageService();
    ref
        .read(webSocketProvider)
        .addListener(() => _messageService.onMessageReceived(ref));
    _messageService.sendMessage(ref, 1001, UserInfoArg());
  }

  // void _handleSpinning(BuildContext context, SlotMachineProvider provider) {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (provider.shouldStartSpinning) {
  //       game.startSpinning();
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(slotMachineProvider);

    // 使用 SchedulerBinding 来确保在当前帧完成后再处理 shouldStartSpinning
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (provider.shouldStartSpinning) {
        provider.setShouldStartSpinning(false); // 重置状态
        provider.setIsSpinning(true);
        game.startSpinning();
      }
    });

    return Stack(
      children: [
        Center(
          child: GameWidget(game: game),
        ),
        Positioned(
            top: 85,
            left: (MediaQuery.of(context).size.width - 400 / 2),
            child: ImageLable(
              imagePath: 'assets/images/fruit/fruit_img_8.png',
              sizeX: 100,
              sizeY: 20,
              text: provider.coin.toString(),
            )),
        Positioned(
            top: 205,
            left: (MediaQuery.of(context).size.width - 400 / 2),
            child: TextButton(
              onPressed: () {
                _messageService.sendMessage(
                    ref,
                    1001,
                    UserInfoResult(
                      userId: 1,
                      icon: '1',
                      name: 'abc',
                      balance: 100,
                    ));
              },
              child: const Text("test"),
            )),
        Positioned(
          top: 438,
          left: (MediaQuery.of(context).size.width / 2) + 134,
          child: ImageButton(
            buttonText: AppLocalizations.of(context)!.go,
            imageSizeX: 60,
            imageSizeY: 40,
            containerSizeX: 60,
            containerSizeY: 40,
            onTap: () {
              // game.startSpinning();
              _messageService.sendMessage(
                  ref, 2001, FruitPlayArg(flag: '1', fruits: provider.bets));
            },
            pressedImagePath: 'assets/images/fruit/fruit_btn_bet_100.png',
            normalImagePath: 'assets/images/fruit/fruit_btn_bet_10.png',
            isEnabled: !provider.isSpinning,
          ),
        ),
        Positioned(
          top: 566,
          left: ((MediaQuery.of(context).size.width - 430) / 2),
          child: const ButtonGroup(),
        ),
        Positioned(
          top: 438,
          left: ((MediaQuery.of(context).size.width - 260) / 2),
          child: const BigSmallWidget(),
        ),
        Positioned(
          top: 520,
          left: ((MediaQuery.of(context).size.width - 374) / 2),
          child: const BetsWidget(),
        ),
      ],
    );
  }
}
