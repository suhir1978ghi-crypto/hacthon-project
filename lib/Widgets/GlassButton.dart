import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GlassButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const GlassButton({super.key, required this.text, required this.onTap});

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton> {
  double scale = 1.0;
  bool isHovered = false;

  void _onTapDown(_) {
    setState(() => scale = 0.92);
  }

  void _onTapUp(_) {
    setState(() => scale = isHovered ? 1.05 : 1.0);
    widget.onTap();
    HapticFeedback.lightImpact();
  }

  void _onTapCancel() {
    setState(() => scale = isHovered ? 1.05 : 1.0);
  }

  void _onHover(bool hovering) {
    setState(() {
      isHovered = hovering;
      scale = hovering ? 1.05 : 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            width: 240,
            height: 65,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isHovered ? Colors.orangeAccent : Colors.white24,
                width: isHovered ? 1.5 : 1,
              ),

              boxShadow: [
                if (isHovered)
                  BoxShadow(
                    color: Colors.orangeAccent.withValues(alpha: 0.35),
                    blurRadius: 18,
                    spreadRadius: 1,
                  ),

                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: scale < 1 ? 4 : 10,
                  offset: Offset(0, scale < 1 ? 2 : 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      color: isHovered
                          ? Colors.white.withValues(alpha: 0.08)
                          : Colors.white.withValues(alpha: 0.05),
                    ),
                  ),

                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isHovered ? 1 : 0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.center,
                          colors: [
                            Colors.white.withValues(alpha: 0.12),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 120),
                      curve: Curves.easeOut,
                      style: TextStyle(
                        fontSize: 20,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w600,
                        color: isHovered ? Colors.orangeAccent : Colors.white,
                      ),
                      child: Text(widget.text),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
