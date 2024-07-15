import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_game/games/utils/combination.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../provider/slot_machine_provider.dart';
import 'component/lable.dart';

class SlotMachine extends FlameGame with TapDetector {
  final List<SpriteComponent> _sprites = []; // 精灵列表
  final List<RectangleComponent> _frames = []; // 精灵的框架列表
  final List<LabeledSpriteComponent> _odds = []; // 赔率图片列表
  final List<LabeledSpriteComponent> _oddsActived = []; // 赔率图片列表
  final List<LabeledSpriteComponent> _bets = []; // 赔率图片列表
  final int _betsLength = 8;
  final oddActiveGroup = PositionComponent();
  final betGroup = PositionComponent();
  final double _iconSize = 40;
  final double _spacing = 2;
  final double _rectangleSpacing = 2;
  final Vector2 _oddsSize = Vector2(45, 25);
  final Vector2 _betSize = Vector2(45, 20);

  late SpriteComponent _spin;
  late SpriteComponent _backgroud;
  bool isSpinning = false;
  int _highlightedIndex = 0; // 当前高亮的精灵索引
  int _targetIndex = 0; // 目标高亮的精灵索引

  int _oddsIndex = 0;
  int _targetOdds = 0;

  late Timer _timer; // 定时器
  final AudioPlayer _audioPlayer = AudioPlayer(); // 音频播放器
  final SlotMachineProvider _provider; // Riverpod 容器

  // 图片路径列表
  final List<String> imagePaths = [
    'fruit/fruit_icon_orange_big.png',
    'fruit/fruit_icon_bell_big.png',
    'fruit/fruit_icon_bar_50.png',
    'fruit/fruit_icon_bar_100.png',
    'fruit/fruit_icon_bar_25.png',
    'fruit/fruit_icon_apple.png',
    'fruit/fruit_icon_lemon_big.png',
    'fruit/fruit_icon_watermelon_big.png',
    'fruit/fruit_icon_watermelon_small.png',
    'fruit/fruit_icon_full_screen.png',
    'fruit/fruit_icon_apple.png',
    'fruit/fruit_icon_orange_small.png',
    'fruit/fruit_icon_orange_big.png',
    'fruit/fruit_icon_bell_big.png',
    'fruit/fruit_icon_7_small.png',
    'fruit/fruit_icon_7_big.png',
    'fruit/fruit_icon_apple.png',
    'fruit/fruit_icon_lemon_small.png',
    'fruit/fruit_icon_lemon_big.png',
    'fruit/fruit_icon_star_big.png',
    'fruit/fruit_icon_star_small.png',
    'fruit/fruit_icon_full_screen.png',
    'fruit/fruit_icon_apple.png',
    'fruit/fruit_icon_bell_small.png',
  ];

  late int _numSprites; // 精灵数量

  // 图片路径列表
  final List<String> oddsImagePaths = [
    'fruit/fruit_img_4.png',
    'fruit/fruit_img_9.png',
    'fruit/fruit_img_9.png',
    'fruit/fruit_img_9.png',
    'fruit/fruit_img_9.png',
    'fruit/fruit_img_9.png',
    'fruit/fruit_img_9.png',
    'fruit/fruit_img_4.png',
  ];

  final List<String> oddsValues = [
    '100',
    '40',
    '30',
    '20',
    '20',
    '15',
    '10',
    '5',
  ];

  final List<int> _betValues = [0, 0, 0, 0, 0, 0, 0, 0];

  late int _numOdds; // 赔率数量
  final int _numOddsActived = 6; // 赔率数量

  // 开始和结束的时间间隔
  final List<double> startTimeIntervals = [
    0.000000000001,
    0.34615384615384615,
    0.11538461538461539,
    0.23076923076923078,
    0.23076923076923078,
    0.23076923076923078,
    0.23076923076923078,
  ];

  final List<double> endTimeIntervals = [
    0.11538461538461539,
    0.11538461538461539,
    0.11538461538461539,
    0.11538461538461539,
    0.15384615384615385,
    0.15384615384615385,
    0.15384615384615385
  ];

  SlotMachine(this._provider);

  @override
  Future<void> onLoad() async {
    _numSprites = imagePaths.length;
    _numOdds = oddsImagePaths.length;

    // 加载背景图
    _backgroud = SpriteComponent()
      ..sprite = await loadSprite('fruit/fruit_bg.png')
      ..size = Vector2(size[0], 622);
    add(_backgroud);
    _spin = SpriteComponent()
      ..sprite = await loadSprite('fruit/fruit_bg_2.png');

    // 加载精灵和框架
    for (int i = 0; i < _numSprites; i++) {
      final sprite = SpriteComponent()
        ..sprite = await loadSprite(imagePaths[i])
        ..size = Vector2(_iconSize, _iconSize);

      final frame = RectangleComponent(
        size: Vector2(
          _iconSize + _rectangleSpacing,
          _iconSize + _rectangleSpacing,
        ),
        paint: Paint()
          ..color = Colors.transparent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );

      _sprites.add(sprite);
      _frames.add(frame);
    }

    // 将背景图和转盘的精灵、框架添加到组中
    final group = PositionComponent();
    group.add(_spin);
    for (int i = 0; i < _numSprites; i++) {
      group.add(_frames[i]);
      group.add(_sprites[i]);
    }
    add(group);

    // 设置精灵和框架的位置，并高亮第一个精灵
    _positionSprites();
    _highlightSprite(0);

    // 加载赔率
    final oddGroup = PositionComponent();
    for (int i = 0; i < _numOdds; i++) {
      final sprite = await loadSprite(oddsImagePaths[i]);
      final lable = (i == 0 || i == _numOdds - 1)
          ? LabeledSpriteComponent(
              sprite: sprite, label: oddsValues[i], size: _oddsSize)
          : LabeledSpriteComponent(
              sprite: sprite,
              label: oddsValues[i],
              size: _oddsSize,
              textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            );

      _odds.add(lable);
      oddGroup.add(lable);
    }
    oddGroup
      ..x = 0
      ..y = 487;
    add(oddGroup);
    _positionOdds(_odds);

    // 加载活动赔率

    for (int i = 0; i < _numOddsActived; i++) {
      final sprite = await loadSprite('fruit/fruit_img_10.png');
      final lable = LabeledSpriteComponent(
          sprite: sprite, label: oddsValues[i + 1], size: _oddsSize);

      _oddsActived.add(lable);
    }
    oddActiveGroup
      ..x = 0
      ..y = 487;
    add(oddActiveGroup);
    _positionOdds(_oddsActived);

    // await populateGroupComponents(betGroup, _bets, _betsLength,
    //     'fruit/fruit_img_8.png', _betValues, _betSize);

    // betGroup
    //   ..x = 0
    //   ..y = 520;
    // add(betGroup);
    // _positionOdds(_bets);

    // 初始化定时器但不启动
    _timer = Timer(0.1, repeat: true, onTick: _rotateSprites);
    _timer.stop();

    // 加载音频资源
    await _audioPlayer.setAsset('assets/audio/run_light.mp3');
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_timer.isRunning()) {
      _timer.update(dt);
    }
  }

  // 设置精灵和框架的位置
  void _positionSprites() {
    final double spacing = _iconSize + _spacing;
    final int side = _numSprites ~/ 4;

    // 计算整个转盘的宽度
    final double width = spacing * (side + 1);

    for (int i = 0; i < _numSprites; i++) {
      double x, y;
      if (i < side) {
        x = spacing * i;
        y = 0;
      } else if (i < 2 * side) {
        x = spacing * side;
        y = spacing * (i - side);
      } else if (i < 3 * side) {
        x = spacing * (3 * side - i);
        y = spacing * side;
      } else {
        x = 0;
        y = spacing * (4 * side - i);
      }

      // 将所有精灵和框架的中心对齐到游戏区域的中心，并且顶部有20像素的间距
      final centerX = (size.x - width) / 2;
      const topOffset = 138.0;
      _sprites[i].position = Vector2(x + centerX, y + topOffset);
      _frames[i].position = _sprites[i].position - Vector2(_spacing, _spacing);

      // 设置背景图位置
      _spin
        ..size = Vector2(width, width)
        ..position = Vector2(centerX, topOffset);
    }
  }

  // 设置精灵和框架的位置
  void _positionOdds(List<LabeledSpriteComponent> odds) {
    const double spacing = 2;
    final totalWidth = odds.length * _oddsSize.x + (odds.length - 1) * spacing;

    final startX = (size.x - totalWidth) / 2;

    for (int i = 0; i < odds.length; i++) {
      odds[i].x = startX + i * (_oddsSize.x + spacing);
    }
  }

  // 旋转精灵
  void _rotateSprites() {
    _highlightedIndex = (_highlightedIndex + 1) % _numSprites;
    _highlightSprite(_highlightedIndex);
    _oddsIndex = (_oddsIndex - 1) % 3;
    _hightightOdds(_oddsIndex);
  }

  // 高亮指定索引的精灵
  void _highlightSprite(int index) {
    for (int i = 0; i < _sprites.length; i++) {
      _sprites[i].paint = Paint()
        ..color = i == index ? Colors.white : Colors.grey;
      _frames[i].paint = Paint()
        ..color = i == index ? Colors.yellow : Colors.transparent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
    }
  }

  void _hightightOdds(int index) {
    for (int i = 0; i < 3; i++) {
      if (i == index) {
        if (!_oddsActived[i].isMounted) {
          oddActiveGroup.add(_oddsActived[i]);
          oddActiveGroup.add(_oddsActived[i + 3]);
        }
      } else {
        if (_oddsActived[i].isMounted) {
          oddActiveGroup.remove(_oddsActived[i]);
          oddActiveGroup.remove(_oddsActived[i + 3]);
        }
      }
    }
  }

  // 停止旋转
  void stopSpinning() {
    // isSpinning = false; // 确保更新本地状态
    _provider.setIsSpinning(false);
    _timer.stop();

    // print(_oddsIndex);
  }

  // 开始旋转
  void startSpinning() async {
    _provider.setIsSpinning(true);

    updateValues([1, 2, 3, 4, 5, 6, 7, 8]);

    // 重置音频播放器的位置
    await _audioPlayer.seek(Duration.zero);
    _audioPlayer.play();

    final random = Random();
    _targetIndex = random.nextInt(_numSprites);

    final int gap = _targetIndex - _highlightedIndex;
    final int additionalSteps =
        (gap > 0 || gap > startTimeIntervals.length + endTimeIntervals.length)
            ? 3
            : 4;

    final int totalSteps = gap + additionalSteps * _numSprites;
    final int fastSteps =
        totalSteps - startTimeIntervals.length - endTimeIntervals.length;

    // 固定旋转时间
    const double spinDuration = 2.307692307692308;
    final double rotationTime = spinDuration / fastSteps;

    _timer.stop();

    // 计算总的旋转步数，确保至少转动 minRotations 圈
    final int finalSteps = totalSteps;
    int currentStep = 0;

    // 更新定时器的时间间隔
    void updateTimerInterval() {
      if (currentStep < startTimeIntervals.length) {
        _timer.stop();
        _timer =
            Timer(startTimeIntervals[currentStep], repeat: true, onTick: () {
          _rotateSprites();
          currentStep++;
          if (currentStep >= finalSteps) {
            stopSpinning();
          } else {
            updateTimerInterval();
          }
        });
        _timer.start();
      } else if (currentStep < (startTimeIntervals.length + fastSteps)) {
        _timer.stop();
        _timer = Timer(rotationTime, repeat: true, onTick: () {
          _rotateSprites();
          currentStep++;
          if (currentStep >= finalSteps) {
            stopSpinning();
          } else {
            updateTimerInterval();
          }
        });
        _timer.start();
      } else {
        _timer.stop();
        final index = currentStep - startTimeIntervals.length - fastSteps;
        _timer = Timer(endTimeIntervals[index], repeat: true, onTick: () {
          _rotateSprites();
          currentStep++;
          if (currentStep >= finalSteps) {
            stopSpinning();
          } else {
            updateTimerInterval();
          }
        });
        _timer.start();
      }
    }

    _timer = Timer(startTimeIntervals[0], repeat: true, onTick: () {
      _rotateSprites();
      currentStep++;
      if (currentStep >= finalSteps) {
        stopSpinning();
      } else {
        updateTimerInterval();
      }
    });

    _timer.start();
  }

  void updateValues(List<int> newValues) async {
    // 更新 values
    final values = newValues;

    // 调用 populateGroupComponents 重新填充组件
    await populateGroupComponents(betGroup, _bets, _betsLength,
        'fruit/fruit_img_8.png', values, _betSize);

    // 如果需要，重新设置组件的位置
    _positionOdds(_bets);
  }
}
