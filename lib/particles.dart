import 'dart:math';

import 'package:flutter/material.dart';

class Particles extends CustomPainter {
  var painter = Paint();

  var random = Random();

  List<List<Particle>> particleList;
  Color particleColor;

  // particle configuration
  var minDiameter = 1;
  var maxDiameter = 4;

  var rowSpacing = 1.5;

  Particles({required this.particleList, required this.particleColor});

  @override
  void paint(Canvas canvas, Size size) {
    _initializeParticles(size);
    _drawParticles(canvas);
  }

  /// for the glitter effect we need the particle size to remain constant
  /// but the brightness of the particles to change, hence we initialise
  /// the particles only once
  void _initializeParticles(Size size) {
    if (particleList.isEmpty && size.height != 0 && size.width != 0) {
      double y = 0;
      while (y <= size.height) {
        double x = 0;
        List<Particle> rowParticles = [];
        while (x < size.width) {
          var diameter =
              random.nextDouble() * (maxDiameter - minDiameter) + minDiameter;
          x += diameter;
          rowParticles.add(Particle(diameter, null));
        }
        y += rowSpacing;
        particleList.add(rowParticles);
      }
    }
  }

  void _drawParticles(Canvas canvas) {
    double y = 0;
    for (List<Particle> rowParticles in particleList) {
      double x = 0;
      for (Particle particle in rowParticles) {
        x += particle.diameter;
        painter.color =
            _lighten(const Color(0xFFAC3BFF), particle.lightness ?? 0);
        canvas.drawCircle(
          Offset(x - particle.diameter / 2, y),
          particle.diameter / 2,
          painter,
        );
      }
      y += rowSpacing;
    }
  }

  @override
  bool shouldRepaint(covariant Particles oldDelegate) {
    return true;
  }

  Color _lighten(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}

class Particle {
  double diameter;
  double? lightness;

  Particle(this.diameter, this.lightness);
}
