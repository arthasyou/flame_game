import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class LabeledSpriteComponent extends PositionComponent {
  final SpriteComponent spriteComponent;
  final TextComponent textComponent;
  bool _visible = true; // 默认可见

  LabeledSpriteComponent({
    required Sprite sprite,
    required String label,
    required Vector2 size,
    Vector2? position,
    TextStyle? textStyle, // 新增可选参数用于自定义文本样式
  })  : spriteComponent = SpriteComponent(sprite: sprite, size: size),
        textComponent = TextComponent(
          text: label,
          textRenderer: TextPaint(
            style: textStyle ??
                const TextStyle(
                  color: Colors.yellow, // 默认颜色
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        super(position: position ?? Vector2.zero(), size: size) {
    add(spriteComponent);
    add(textComponent);

    // 居中文本组件
    textComponent.position = Vector2(size.x / 2, size.y / 2);
    textComponent.anchor = Anchor.center;
  }
  set textStyle(TextStyle style) {
    textComponent.textRenderer = TextPaint(style: style);
  }

  set visible(bool value) {
    _visible = value;
  }

  @override
  void render(Canvas canvas) {
    if (!_visible) return; // 如果不可见，则不渲染
    super.render(canvas);
    // 渲染代码...
  }
}
