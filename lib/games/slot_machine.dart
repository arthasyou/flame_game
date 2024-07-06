import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../provider/slot_machine_provider.dart';

class SlotMachine extends FlameGame with TapDetector {
  final List<SpriteComponent> _sprites = []; // 精灵列表
  final List<RectangleComponent> _frames = []; // 精灵的框架列表
  final double _iconSize = 40;
  final double _spacing = 2;
  final double _rectangleSpacing = 2;

  late SpriteComponent _spin;
  late SpriteComponent _backgroud;
  bool isSpinning = false;
  int _highlightedIndex = 0; // 当前高亮的精灵索引
  int targetIndex = 0; // 目标高亮的精灵索引
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

  // 旋转精灵
  void _rotateSprites() {
    _highlightedIndex = (_highlightedIndex + 1) % _numSprites;
    _highlightSprite(_highlightedIndex);
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

  // 停止旋转
  void stopSpinning() {
    // isSpinning = false; // 确保更新本地状态
    _provider.setIsSpinning(false);
    _timer.stop();
  }

  // 开始旋转
  void startSpinning() async {
    // isSpinning = true; // 确保更新本地状态
    _provider.setIsSpinning(true);

    // 重置音频播放器的位置
    await _audioPlayer.seek(Duration.zero);
    _audioPlayer.play();

    final random = Random();
    targetIndex = random.nextInt(_numSprites);

    final int gap = targetIndex - _highlightedIndex;
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
}
