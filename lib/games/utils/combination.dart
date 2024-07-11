import 'package:flame/components.dart';
import 'package:flame/flame.dart';

import '../component/lable.dart';

Future<void> populateGroupComponents(
  PositionComponent group,
  List<LabeledSpriteComponent> items,
  int length,
  String imagePath,
  List<int> values,
  Vector2 size,
) async {
  items.clear();
  group.removeAll(group.children); // 清空组内现有的组件
  for (int i = 0; i < length; i++) {
    final sprite = await loadSprite(imagePath);
    final label = LabeledSpriteComponent(
        sprite: sprite, label: values[i].toString(), size: size);

    items.add(label);
    group.add(label);
  }
}

Future<Sprite> loadSprite(String path) async {
  return await Flame.images.load(path).then((image) => Sprite(image));
}
