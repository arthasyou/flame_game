import 'package:flame/game.dart';
import 'package:flame_game/games/slot_machine.dart';
import 'package:flame_game/protos/message.pb.dart';
import 'package:flame_game/widgets/components/image_lable.dart';
import 'package:flame_game/widgets/components/reward_group.dart';
import 'package:flame_game/widgets/components/switch_group.dart';
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
            left: (MediaQuery.of(context).size.width + 80) / 2,
            child: ImageLable(
              imagePath: 'assets/images/fruit/fruit_img_8.png',
              sizeX: 150,
              sizeY: 20,
              text: provider.coin.toString(),
            )),
        // 奖励
        Positioned(
          top: 190,
          left: (MediaQuery.of(context).size.width - 190) / 2,
          child: const RewardWidget(),
        ),
        // 开始按钮
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
              _messageService.sendMessage(
                  ref, 2001, FruitPlayArg(flag: '1', fruits: provider.bets));
            },
            pressedImagePath: 'assets/images/fruit/fruit_btn_bet_100.png',
            normalImagePath: 'assets/images/fruit/fruit_btn_bet_10.png',
            isEnabled: !provider.isSpinning,
          ),
        ),
        // 切换按钮
        Positioned(
          top: 438,
          left: (MediaQuery.of(context).size.width / 2) - 170,
          child: const SwitchWidget(),
        ),
        Positioned(
          top: 566,
          left: ((MediaQuery.of(context).size.width - 430) / 2),
          child: const ButtonGroup(),
        ),
        // 赌大小按钮
        Positioned(
          top: 438,
          left: ((MediaQuery.of(context).size.width - 220) / 2),
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
