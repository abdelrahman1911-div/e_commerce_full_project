import 'package:e_commerce_full_project/core/styling/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Icon? icon;
  final String? label;
  final bool isPassword;
  final bool isPhoneNumber;
  final String? Function(String?)? validator;
  final String? errorText;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final bool isSearchTextField;

  const CustomTextFieldWidget({
    super.key,
    this.label,
    required this.controller,
    required this.hintText,
    this.icon,
    this.errorText,
    this.isPassword = false,
    this.validator,
    this.isPhoneNumber = false,
    this.backgroundColor,
    this.borderRadius,
    this.isSearchTextField = false,
  });

  @override
  State<CustomTextFieldWidget> createState() => _CustomTextFieldWidgetState();
}

class _CustomTextFieldWidgetState extends State<CustomTextFieldWidget> {
  late FocusNode _focusNode;

  bool _isFocused = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();

    _focusNode.addListener(_onFocusChange);

    _obscureText = widget.isPassword;
  }

  void _onFocusChange() {
    if (!mounted) return;

    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    // ============================================================
    // Search TextField
    // ============================================================

    if (widget.isSearchTextField) {
      return Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? theme.inputDecorationTheme.fillColor,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(12.r),
          border: Border.all(
            color:
                theme.dividerTheme.color ??
                colorScheme.outline.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
        child: TextFormField(
          controller: widget.controller,
          validator: widget.validator,

          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
          },

          textAlignVertical: TextAlignVertical.center,

          style: theme.textTheme.bodyLarge,

          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search_outlined,
              color: colorScheme.onSurfaceVariant,
              size: 21.sp,
            ),

            hintText: widget.hintText,

            hintStyle: theme.inputDecorationTheme.hintStyle,

            border: InputBorder.none,

            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 14.h,
            ),
          ),
        ),
      );
    }

    // ============================================================
    // Normal TextField
    // ============================================================

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ========================================================
        // Label
        // ========================================================
        if (widget.label != null && widget.label!.isNotEmpty)
          Text(widget.label!, style: AppTextStyles.fieldLabel(context)),

        if (widget.label != null && widget.label!.isNotEmpty)
          SizedBox(height: 7.h),

        // ========================================================
        // TextField
        // ========================================================
        SizedBox(
          height: 40.h,
          child: TextFormField(
            focusNode: _focusNode,
            controller: widget.controller,
            validator: widget.validator,

            onTapOutside: (event) {
              FocusScope.of(context).unfocus();
            },

            obscureText: _obscureText,

            textAlignVertical: TextAlignVertical.center,

            style: theme.textTheme.bodyLarge,

            decoration: InputDecoration(
              // ==================================================
              // Background
              // ==================================================
              filled: true,

              fillColor:
                  widget.backgroundColor ??
                  theme.inputDecorationTheme.fillColor,

              // ==================================================
              // Prefix Icon / Password Icon
              // ==================================================
              prefixIcon: widget.isPassword
                  ? IconButton(
                      padding: EdgeInsets.zero,

                      constraints: BoxConstraints(
                        minWidth: 40.w,
                        minHeight: 40.h,
                        maxHeight: 40.h,
                      ),

                      icon: Icon(
                        _obscureText
                            ? Icons.lock_outline
                            : Icons.lock_open_outlined,
                        color: colorScheme.onSurfaceVariant,
                        size: 20.sp,
                      ),

                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : widget.icon,

              // ==================================================
              // Prefix Icon Constraints
              // ==================================================
              prefixIconConstraints: (widget.icon != null || widget.isPassword)
                  ? BoxConstraints(
                      minWidth: 44.w,
                      minHeight: 40.h,
                      maxHeight: 40.h,
                    )
                  : null,

              // ==================================================
              // Hide Flutter Default Error
              // ==================================================
              errorStyle: const TextStyle(fontSize: 0, height: 0),

              // ==================================================
              // TextField Density
              // ==================================================
              isDense: true,

              // ==================================================
              // Content Padding
              // ==================================================
              contentPadding: (widget.icon != null || widget.isPassword)
                  ? EdgeInsets.zero
                  : EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),

              // ==================================================
              // Hint
              // ==================================================
              hintText: widget.hintText,

              hintStyle: theme.inputDecorationTheme.hintStyle,

              // ==================================================
              // Normal Border
              // ==================================================
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    widget.borderRadius ?? BorderRadius.circular(16.r),

                borderSide: BorderSide(
                  color: _isFocused
                      ? colorScheme.onSurface
                      : colorScheme.surface,
                  width: 0.1,
                ),
              ),

              // ==================================================
              // Focused Border
              // ==================================================
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    widget.borderRadius ?? BorderRadius.circular(16.r),

                borderSide: BorderSide(
                  color: colorScheme.onSurface,
                  width: 0.1,
                ),
              ),

              // ==================================================
              // Error Border
              // ==================================================
              errorBorder: OutlineInputBorder(
                borderRadius:
                    widget.borderRadius ?? BorderRadius.circular(16.r),

                borderSide: BorderSide(color: colorScheme.error, width: 1),
              ),

              // ==================================================
              // Focused Error Border
              // ==================================================
              focusedErrorBorder: OutlineInputBorder(
                borderRadius:
                    widget.borderRadius ?? BorderRadius.circular(16.r),

                borderSide: BorderSide(color: colorScheme.error, width: 1),
              ),
            ),
          ),
        ),

        // ========================================================
        // Error Text
        // ========================================================
        if (hasError) ...[
          SizedBox(height: 6.h),

          Text(
            widget.errorText!,
            style: theme.textTheme.bodyMedium!.copyWith(
              color: colorScheme.error,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }
}
