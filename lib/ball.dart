import 'dart:typed_data';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_midi/flutter_midi.dart';

import 'brick.dart';
import 'melodyark_game.dart';
import 'dart:math';


class Ball extends CircleComponent
    with HasGameRef<MelodyArkGame>, CollisionCallbacks {
  Vector2 velocity = Vector2.zero();

  final FlutterMidi flutterMidi;


  @override
  Future<void> onLoad() async {
    super.onLoad();
  }

  Ball(this.flutterMidi)
      : super(
      radius: 10,
      position: Vector2(100, 100)
  ) {
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Обновление позиции мяча на основе скорости
    position.add(velocity * dt);

    // Замедление мяча со временем (например, из-за трения)
    velocity.multiply(Vector2.all(0.99));

    // Отскок от левой или правой стены
    if (position.x - radius <= 0 || position.x + radius >= gameRef.size.x) {
      velocity.x = -velocity.x;
    }

    // Отскок от верхней или нижней стены
    if (position.y - radius <= 0 || position.y + radius >= gameRef.size.y) {
      velocity.y = -velocity.y;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Brick) {
      playBrickHitSound();
      Vector2 collisionNormal;

      // Определение направления столкновения
      bool hitFromTop = (position.y < other.position.y);
      bool hitFromBottom = (position.y > other.position.y + other.height);
      bool hitFromLeft = (position.x < other.position.x);
      bool hitFromRight = (position.x > other.position.x + other.width);

      if (hitFromTop) {
        collisionNormal = Vector2(0, -1); // Столкновение сверху
      } else if (hitFromBottom) {
        collisionNormal = Vector2(0, 1); // Столкновение снизу
      } else if (hitFromLeft) {
        collisionNormal = Vector2(-1, 0); // Столкновение с левой стороны
      } else if (hitFromRight) {
        collisionNormal = Vector2(1, 0); // Столкновение с правой стороны
      } else {
        // Неясно, откуда произошло столкновение, не изменяем скорость
        return;
      }

      reflectVelocity(collisionNormal);
    }
  }

  void reflectVelocity(Vector2 normal) {
    // Existing reflection logic
    double dotProduct = velocity.dot(normal);
    velocity.x = velocity.x - (2 * dotProduct) * normal.x;
    velocity.y = velocity.y - (2 * dotProduct) * normal.y;

    // Multiply the velocity by a factor greater than 1 to increase the bounce strength
    double bounceStrengthFactor = 1.2; // Adjust this factor to control the bounce strength
    velocity.multiply(Vector2.all(bounceStrengthFactor));
  }


  void move(Vector2 delta) {
    position.add(delta);
  }

  void playBrickHitSound() {
    flutterMidi.playMidiNote(midi: 60);
  }

}
