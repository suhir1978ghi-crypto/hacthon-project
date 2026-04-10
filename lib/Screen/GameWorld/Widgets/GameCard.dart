import 'package:flutter/material.dart';

class GameCard extends StatefulWidget {
  final String asset;
  final int count;
  final bool selected;
  final bool disabled;
  final VoidCallback? onTap;

  const GameCard({
    super.key,
    required this.asset,
    required this.count,
    required this.selected,
    required this.disabled,
    this.onTap,
  });

  @override
  State<GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<GameCard>
    with SingleTickerProviderStateMixin {
  double scale = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.disabled ? null : widget.onTap,
      child: AnimatedScale(
        scale: widget.selected ? 1.2 : scale,
        duration: const Duration(milliseconds: 200),
        child: AnimatedOpacity(
          opacity: widget.disabled ? 0.4 : 1,
          duration: const Duration(milliseconds: 200),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Image.asset(widget.asset, width: 70, height: 100),

              // count badge
              if (widget.count > 1)
                Container(
                  margin: const EdgeInsets.all(4),
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "${widget.count}",
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
