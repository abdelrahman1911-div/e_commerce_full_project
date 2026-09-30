import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? label;
  final IconData? icon;
  final bool isPassword;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.label,
    this.icon,
    this.isPassword = false,
    this.keyboardType,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: theme.textTheme.labelLarge,
          ),
          const SizedBox(height: 8),
        ],

        TextFormField(
          controller: widget.controller,

          validator: widget.validator,

          keyboardType: widget.keyboardType,

          obscureText:
              widget.isPassword ? _obscureText : false,

          onTapOutside: (_) {
            FocusScope.of(context).unfocus();
          },

          decoration: InputDecoration(
            hintText: widget.hintText,

            prefixIcon: widget.icon != null
                ? Icon(
                    widget.icon,
                    color: colorScheme.onSurfaceVariant,
                  )
                : null,

            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}