import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_midi/flutter_midi.dart';

import 'ball.dart';

class Brick extends PositionComponent with CollisionCallbacks {
  final double width;
  final double height;
  final double borderRadius;
  final Paint paint;
  double opacity = 1.0; // Property to track opacity
  bool isFadingOut = false; // Flag to start fade-out

  Brick({
    this.width = 40,
    this.height = 20,
    this.borderRadius = 5.0,
    Color color = Colors.white,
    required Vector2? position,
  })  : paint = Paint()..color = color,
        super(
          position: position ?? Vector2.zero(),
          size: Vector2(width, height),
          anchor: Anchor.center,
        ) {
    add(RectangleHitbox());

  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isFadingOut) {
      opacity -= dt; // Reduce opacity over time
      if (opacity <= 0) {
        removeFromParent(); // Remove brick once fully transparent
      }
    }
  }


  @override
  void render(Canvas canvas) {
    super.render(canvas);
    paint.color = paint.color.withOpacity(opacity);
    final rect = Rect.fromLTWH(0, 0, width, height);
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    canvas.drawRRect(rRect, paint);
  }
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    isFadingOut = true; // Trigger fade-out on collision
  }

}
