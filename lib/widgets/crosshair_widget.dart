import 'package:flutter/material.dart';

/// Widget de réticule de visée (croix) au centre de l'écran
/// À utiliser comme overlay dans l'écran de caméra
class CrosshairWidget extends StatelessWidget {
  final Color color;
  final double size;
  final double strokeWidth;
  final double gapSize;
  final bool showCircle;
  final double opacity;

  const CrosshairWidget({
    super.key,
    this.color = Colors.white,
    this.size = 40.0,
    this.strokeWidth = 2.0,
    this.gapSize = 10.0,
    this.showCircle = true,
    this.opacity = 0.8,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity: opacity,
        child: CustomPaint(
          size: Size(size, size),
          painter: CrosshairPainter(
            color: color,
            strokeWidth: strokeWidth,
            gapSize: gapSize,
            showCircle: showCircle,
          ),
        ),
      ),
    );
  }
}

/// Painter personnalisé pour dessiner le réticule
class CrosshairPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gapSize;
  final bool showCircle;

  CrosshairPainter({
    required this.color,
    required this.strokeWidth,
    required this.gapSize,
    required this.showCircle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final lineLength = (size.width - gapSize) / 2;

    // Ligne horizontale gauche
    canvas.drawLine(
      Offset(center.dx - lineLength - gapSize / 2, center.dy),
      Offset(center.dx - gapSize / 2, center.dy),
      paint,
    );

    // Ligne horizontale droite
    canvas.drawLine(
      Offset(center.dx + gapSize / 2, center.dy),
      Offset(center.dx + lineLength + gapSize / 2, center.dy),
      paint,
    );

    // Ligne verticale haute
    canvas.drawLine(
      Offset(center.dx, center.dy - lineLength - gapSize / 2),
      Offset(center.dx, center.dy - gapSize / 2),
      paint,
    );

    // Ligne verticale basse
    canvas.drawLine(
      Offset(center.dx, center.dy + gapSize / 2),
      Offset(center.dx, center.dy + lineLength + gapSize / 2),
      paint,
    );

    // Cercle central optionnel
    if (showCircle) {
      canvas.drawCircle(center, size.width / 2, paint);
    }

    // Point central
    final centerDotPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;
    canvas.drawCircle(center, strokeWidth, centerDotPaint);
  }

  @override
  bool shouldRepaint(CrosshairPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gapSize != gapSize ||
        oldDelegate.showCircle != showCircle;
  }
}

// ============================================================
// VARIANTES DE STYLES PRÉDÉFINIS
// ============================================================

/// Style par défaut - blanc classique
class DefaultCrosshair extends StatelessWidget {
  const DefaultCrosshair({super.key});

  @override
  Widget build(BuildContext context) {
    return const CrosshairWidget();
  }
}

/// Style militaire - vert avec cercle
class MilitaryCrosshair extends StatelessWidget {
  const MilitaryCrosshair({super.key});

  @override
  Widget build(BuildContext context) {
    return const CrosshairWidget(
      color: Colors.green,
      size: 60.0,
      strokeWidth: 2.5,
      gapSize: 15.0,
      showCircle: true,
      opacity: 0.9,
    );
  }
}

/// Style sniper - rouge sans cercle
class SniperCrosshair extends StatelessWidget {
  const SniperCrosshair({super.key});

  @override
  Widget build(BuildContext context) {
    return const CrosshairWidget(
      color: Colors.red,
      size: 40.0,
      strokeWidth: 1.5,
      gapSize: 12.0,
      showCircle: false,
      opacity: 0.85,
    );
  }
}

/// Style photo - bleu cyan subtil
class PhotoCrosshair extends StatelessWidget {
  const PhotoCrosshair({super.key});

  @override
  Widget build(BuildContext context) {
    return const CrosshairWidget(
      color: Colors.cyan,
      size: 35.0,
      strokeWidth: 2.0,
      gapSize: 10.0,
      showCircle: true,
      opacity: 0.7,
    );
  }
}

/// Style minimaliste - lignes fines
class MinimalCrosshair extends StatelessWidget {
  const MinimalCrosshair({super.key});

  @override
  Widget build(BuildContext context) {
    return const CrosshairWidget(
      color: Colors.white,
      size: 25.0,
      strokeWidth: 2.0,
      gapSize: 10.0,
      showCircle: false,
      opacity: 1,
    );
  }
}
