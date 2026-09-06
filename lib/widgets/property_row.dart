import 'package:flutter/material.dart';

class PropertyRow extends StatelessWidget {
  const PropertyRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 118,
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 17,
                  color: theme.textTheme.bodyMedium?.color,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: value),
        ],
      ),
    );
  }
}
