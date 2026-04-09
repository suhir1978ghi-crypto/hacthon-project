import 'package:flutter/material.dart';

import '../GameWorld.dart';

class ActionBarOverlay extends StatelessWidget {
  final GameWorld gameWorld;

  const ActionBarOverlay({super.key, required this.gameWorld});

  @override
  Widget build(BuildContext context) {
    final player = gameWorld.turnManager.currentPlayer;
    final used = gameWorld.actionManager.usedActions[player];
    final selected = gameWorld.selectedAction;

    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: ActionType.values.map((action) {
              final disabled = used.contains(action);
              final isSelected = selected == action;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: GestureDetector(
                  onTap: disabled ? null : () => gameWorld.selectAction(action),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: disabled
                          ? Colors.grey
                          : isSelected
                          ? Colors.orange
                          : Colors.black,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? Colors.orangeAccent
                            : Colors.white24,
                      ),
                    ),
                    child: Text(
                      action.name.toUpperCase(),
                      style: TextStyle(
                        color: disabled ? Colors.white54 : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

enum ActionType { up1, up2, up3, topple, toast }
