import 'package:flutter/material.dart';

class TargetCard extends StatefulWidget {
  final List<int> targets;

  const TargetCard({super.key, required this.targets});

  @override
  State<TargetCard> createState() => _TargetCardState();
}

class _TargetCardState extends State<TargetCard>
    with SingleTickerProviderStateMixin {
  bool revealed = false;

  static final assets = [
    'images/tikis/NUI.png',
    'images/tikis/WIKIWIKI.png',
    'images/tikis/NANI.png',
    'images/tikis/KAPU.png',
    'images/tikis/HUhHU.png',
    'images/tikis/EEPO.png',
    'images/tikis/AKAMAI.png',
    'images/tikis/HOOKIPA.png',
    'images/tikis/lOKAHI.png',
  ];

  @override
  Widget build(BuildContext context) {
    const scores = [9, 4, 2];

    return GestureDetector(
      onTap: () {
        setState(() {
          revealed = !revealed;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: revealed ? Colors.orange : Colors.white24),
        ),
        child: revealed
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/${assets[widget.targets[i]]}',
                          width: 40,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${scores[i]}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              )
            : const Icon(Icons.help_outline, color: Colors.white, size: 32),
      ),
    );
  }
}
