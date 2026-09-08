import 'package:flutter/material.dart';
class EditableField extends StatefulWidget { 
    final TextEditingController controller; 
    final IconData icon; 
    final String label; 
    final TextInputType keyboardType; 
  const EditableField({
    required this.controller,
    required this.icon,
    required this.label,
    required this.keyboardType,
    super.key});

  @override
  State<EditableField> createState() => _EditableFieldState();
}

class _EditableFieldState extends State<EditableField> {
  @override
  Widget build(BuildContext context) {
        final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        style: TextStyle(
          color: colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
           widget.icon,
            color: colorScheme.primary,
          ),
          labelText:widget.label,
          labelStyle: TextStyle(
            color: colorScheme.onSurface.withOpacity(.6),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: colorScheme.onSurface.withOpacity(.2),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: colorScheme.primary,
              width: 2,
            ),
          ),
        ),
      ),
    );

  }
}