import 'dart:ui';

import 'package:flutter/material.dart';

class MuteButton extends StatefulWidget {
  final bool isMuted;
  final VoidCallback onTap;

  const MuteButton({super.key, required this.isMuted, required this.onTap});

  @override
  State<MuteButton> createState() => _MuteButtonState();
}

class _MuteButtonState extends State<MuteButton> {
  bool isHovered = false;
  double scale = 1.0;

  void _onHover(bool hover) {
    setState(() {
      isHovered = hover;
      scale = hover ? 1.1 : 1.0;
    });
  }

  void _onTapDown(_) {
    setState(() => scale = 0.9);
  }

  void _onTapUp(_) {
    setState(() => scale = isHovered ? 1.1 : 1.0);
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() => scale = isHovered ? 1.1 : 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isHovered ? Colors.orangeAccent : Colors.white24,
              ),
              boxShadow: isHovered
                  ? [
                      BoxShadow(
                        color: Colors.orangeAccent.withValues(alpha: 0.4),
                        blurRadius: 15,
                      ),
                    ]
                  : [],
            ),
            child: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        widget.isMuted ? Icons.volume_off : Icons.volume_up,
                        key: ValueKey(widget.isMuted),
                        color: isHovered ? Colors.orangeAccent : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
