import 'package:flutter/material.dart';

class PlayerTile extends StatefulWidget {
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const PlayerTile({
    super.key,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<PlayerTile> createState() => _PlayerTileState();
}

class _PlayerTileState extends State<PlayerTile> {
  bool isHovered = false;
  double scale = 1.0;

  void _onHover(bool hover) {
    setState(() {
      isHovered = hover;
      scale = hover ? 1.08 : 1.0;
    });
  }

  void _onTapDown(_) {
    setState(() => scale = 0.9);
  }

  void _onTapUp(_) {
    setState(() => scale = isHovered ? 1.08 : 1.0);
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() => scale = isHovered ? 1.08 : 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.isSelected || isHovered;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: active ? Colors.orangeAccent : Colors.white24,
                width: active ? 1.5 : 1,
              ),
              boxShadow: active
                  ? [
                      BoxShadow(
                        color: Colors.orangeAccent.withValues(alpha: 0.35),
                        blurRadius: 15,
                      ),
                    ]
                  : [],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                children: [
                  // glass layer
                  Container(
                    color: active
                        ? Colors.orangeAccent.withValues(alpha: 0.15)
                        : Colors.white.withValues(alpha: 0.05),
                  ),

                  // top light
                  if (isHovered)
                    Container(
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

                  Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 120),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: active ? Colors.orangeAccent : Colors.white,
                      ),
                      child: Text("${widget.count}"),
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
