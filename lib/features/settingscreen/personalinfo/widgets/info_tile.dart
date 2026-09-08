import 'package:flutter/material.dart';

class InfoTile extends StatefulWidget {
   final IconData icon;
    final  String title;
    final  String value;
  const InfoTile({
    required this.icon,
    required this.title,
    required this.value,
    super.key});
  @override
  State<InfoTile> createState() => _InfoTileState();
}

class _InfoTileState extends State<InfoTile> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colorScheme.onSurface.withOpacity(.15),
        ),
        color: colorScheme.surface,
      ),
      child: Row(
        children: [
          Icon(
            widget.icon,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurface.withOpacity(.5),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }
}