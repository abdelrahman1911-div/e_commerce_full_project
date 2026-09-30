import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.buttonText,
    this.onPressed,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(buttonText),
                  if (icon != null) ...[
                    const SizedBox(width: 8),
                    Icon(icon),
                  ],
                ],
              ),
      ),
    );
  }
}