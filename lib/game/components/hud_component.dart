// lib/game/components/hud_component.dart
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../racing_game.dart';

class HudComponent extends PositionComponent {
  final RacingGame game;

  HudComponent({required this.game}) : super(priority: 100);

  @override
  Future<void> onLoad() async {
    size = game.size;
  }

  @override
  void render(Canvas canvas) {
    _drawSpeedBar(canvas);
    _drawProgressBar(canvas);
    _drawTimer(canvas);
    _drawNitroIndicator(canvas);
  }

  void _drawSpeedBar(Canvas canvas) {
    final speed = game.playerCar.currentSpeed;
    final maxSpeed = game.playerCarModel.maxSpeed * 1.6;
    final ratio = (speed / maxSpeed).clamp(0.0, 1.0);

    // Background
    final bgPaint = Paint()..color = Colors.black.withOpacity(0.55);
    final barBg = RRect.fromRectAndRadius(
      Rect.fromLTWH(12, game.size.y - 80, 160, 60),
      const Radius.circular(10),
    );
    canvas.drawRRect(barBg, bgPaint);

    // Speed text
    final speedText = '${speed.toInt()} km/h';
    final textPainter = TextPainter(
      text: TextSpan(
        text: speedText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Rajdhani',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, Offset(20, game.size.y - 72));

    // Speed bar fill
    final fillPaint = Paint()
      ..color = game.playerCar.isNitroActive
          ? const Color(0xFF00B0FF)
          : const Color(0xFFE53935);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(12, game.size.y - 44, ratio * 160, 10),
        const Radius.circular(5),
      ),
      fillPaint,
    );
  }

  void _drawProgressBar(Canvas canvas) {
    final w = game.size.x;
    const barH = 10.0;
    const topPad = 12.0;
    const sidePad = 60.0;
    final barW = w - sidePad * 2;

    // Background
    final bgPaint = Paint()..color = Colors.white.withOpacity(0.2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(sidePad, topPad, barW, barH),
        const Radius.circular(5),
      ),
      bgPaint,
    );

    // Opponent progress (grey)
    final oppPaint = Paint()..color = Colors.grey.withOpacity(0.7);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
            sidePad, topPad, barW * game.opponentProgress, barH),
        const Radius.circular(5),
      ),
      oppPaint,
    );

    // Player progress (red)
    final playerPaint = Paint()..color = const Color(0xFFE53935);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
            sidePad, topPad, barW * game.playerProgress, barH),
        const Radius.circular(5),
      ),
      playerPaint,
    );

    // Car icons at ends
    _drawIcon(canvas, Offset(sidePad - 20, topPad - 5), '🏎');
    _drawIcon(canvas, Offset(sidePad + barW + 5, topPad - 5), '🏁');
  }

  void _drawTimer(Canvas canvas) {
    final mins = (game.raceTimer / 60).floor();
    final secs = (game.raceTimer % 60).floor();
    final text = '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 2,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset(game.size.x / 2 - textPainter.width / 2, 28),
    );
  }

  void _drawNitroIndicator(Canvas canvas) {
    final isActive = game.playerCar.isNitroActive;
    final bgPaint = Paint()
      ..color = isActive
          ? const Color(0xFF00B0FF).withOpacity(0.85)
          : Colors.black.withOpacity(0.55);

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(game.size.x - 80, game.size.y - 70, 68, 48),
      const Radius.circular(10),
    );
    canvas.drawRRect(rect, bgPaint);

    _drawIcon(
      canvas,
      Offset(game.size.x - 64, game.size.y - 66),
      isActive ? '⚡' : '💨',
    );

    final label = TextPainter(
      text: TextSpan(
        text: 'NITRO',
        style: TextStyle(
          color: isActive ? Colors.white : Colors.white54,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    label.paint(canvas, Offset(game.size.x - 74, game.size.y - 38));
  }

  void _drawIcon(Canvas canvas, Offset offset, String emoji) {
    final tp = TextPainter(
      text: TextSpan(
        text: emoji,
        style: const TextStyle(fontSize: 18),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, offset);
  }
}
