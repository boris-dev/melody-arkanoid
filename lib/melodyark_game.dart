
import 'dart:js';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';

import 'ball.dart';
import 'brick.dart';

class MelodyArkGame extends FlameGame with PanDetector, HasCollisionDetection  {
  var _ball;
  var _brick;

  final flutterMidi = FlutterMidi();
  late ByteData _soundfont;


  @override
  Future<void> onLoad() async {
    _ball = Ball(flutterMidi);
    _brick = Brick(position: Vector2(200,200));
    add(_brick);
    add(_ball);
    flutterMidi.unmute();
    _soundfont = await rootBundle.load('assets/soundfont/Piano.sf2');

    flutterMidi.prepare(sf2: _soundfont);
  }


  @override
  void onPanUpdate(DragUpdateInfo info) {
    _ball.move(info.delta.global);
  }

  @override
  void onPanEnd(DragEndInfo info) {
    // Установите скорость мяча, когда пользователь отпускает мышь
    _ball.velocity = info.velocity;
  }
}

