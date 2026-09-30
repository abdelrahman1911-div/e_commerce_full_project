import 'package:flutter/material.dart';

class TrackingStep extends StatelessWidget {
  final String title;
  final bool isActive;
  final bool isLast;

  const TrackingStep({
    super.key,
    required this.title,
    required this.isActive,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? Colors.green : Colors.transparent,

                border: Border.all(
                  color: isActive ? Colors.green : Colors.grey,
                  width: 2,
                ),
              ),
            ),
            if (!isLast)
              Container(width: 2, height: 35, color: Colors.grey.shade300),
          ],
        ),
        const SizedBox(width: 12),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? Colors.green : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
