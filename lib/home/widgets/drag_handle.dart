import 'package:flutter/material.dart';

/// Drag handle following material design 3 bottom sheet specs (https://m3.material.io/components/bottom-sheets/specs)
class DragHandle extends StatelessWidget {
  const DragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.6),
          borderRadius: BorderRadius.circular(4),
        ),
        width: 32,
        height: 4,
      ),
    );
  }
}
