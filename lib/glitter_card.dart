import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_glitter/particles.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GlitterCard extends StatefulWidget {
  const GlitterCard({super.key});

  @override
  State<GlitterCard> createState() => _GlitterCardState();
}

class _GlitterCardState extends State<GlitterCard>
    with SingleTickerProviderStateMixin {
  List<List<Particle>> particleList = [];
  List<List<Animation>> particleAnimation = [];

  // defining the particles entropy
  double minGlitterSpreadThreshold = 0.02;
  double maxGlitterSpreadThreshold = 0.07;

  Color particleColor = const Color(0xFFAC3BFF);
  Color backgroundColor = const Color(0xFF4B0082);

  Random random = Random();

  var isAnimCompleted = true;

  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )
      ..addListener(() {
        setState(() {
          // update the particle's lightness with the current animated value
          for (int i = 0; i < particleAnimation.length; i++) {
            for (int j = 0; j < particleAnimation[i].length; j++) {
              particleList[i][j].lightness = particleAnimation[i][j].value;
            }
          }
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          isAnimCompleted = true;
        }
      });

    // wait for the custom paint to populate the particles before we can start animating their lightness
    Future.delayed(const Duration(seconds: 1), () {
      animateParticles();
      gyroscopeEvents.listen((GyroscopeEvent event) {
        var threshold = 0.03;
        if (event.x > threshold || event.y > threshold || event.z > threshold) {
          animateParticles();
        }
      });
    });
  }

  void animateParticles() {
    if (isAnimCompleted) {
      isAnimCompleted = false;

      var glitterSpread = random.nextDouble() *
              (maxGlitterSpreadThreshold - minGlitterSpreadThreshold) +
          minGlitterSpreadThreshold;

      particleAnimation.clear();

      for (List<Particle> rowParticles in particleList) {
        List<Animation> rowAnimations = [];
        for (Particle particle in rowParticles) {
          // animate each particle from it's old lightness to the new random lightness

          // lightness for a non glitter particle
          var lightGlitter = random.nextDouble() * 0.15;
          // lightness for a glitter particle
          var heavyGlitter = random.nextDouble() * (1 - 0.85) + 0.85;
          
          // we want to make the current particle as a glitter particle if it clears the threshold (decided randomly)
          var lightenAmount = (random.nextDouble() < (1 - glitterSpread))
              ? lightGlitter
              : heavyGlitter;
          var oldLightness = particle.lightness;
          var anim = Tween(begin: oldLightness ?? 0, end: lightenAmount)
              .animate(controller);
          rowAnimations.add(anim);
        }
        particleAnimation.add(rowAnimations);
      }

      controller.reset();
      controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CustomPaint(
        foregroundPainter: Particles(
          particleList: particleList,
          particleColor: particleColor,
        ),
        child: Container(
          height: 200,
          width: 200,
          color: backgroundColor,
        ),
      ),
    );
  }
}
