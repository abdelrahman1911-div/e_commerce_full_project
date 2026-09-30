import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:e_commerce_full_project/core/styling/appcolors.dart';

class AddressWidget extends StatefulWidget {
  final TextEditingController controller; 
  final bool isPhone;   
  final bool isName; 

  const AddressWidget({
     required this.isPhone, 
     super.key,
     required this.controller,  
      required this.isName
     });

  @override
  State<AddressWidget> createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {
  final FocusNode _focusNode = FocusNode();
  bool _isEditing = false;
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    if (!_isEditing) {
      setState(() {
        _isEditing = true;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _focusNode.requestFocus();
        widget.controller.selection = TextSelection.fromPosition(
          TextPosition(offset: widget.controller.text.length),
        );
      });
    } else {
      setState(() {
        _isEditing = false;
      });
      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Address title
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Text(
               widget.isName? "Reciever's Name" 
               :
                ( widget.isPhone? "Reciever's Phone Number":  
                "Shipping address"),
                style: theme.textTheme.titleSmall?.copyWith(fontSize: 10.sp),
              ),
              SizedBox(width: 3.w),
              Icon( 
                widget.isName ? Icons.person  : 
                (widget.isPhone? Icons.phone_outlined :
                Icons.home),
                color: isDark ? Colors.white : Colors.black,
                size: 15.sp,
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        // Address container
        Container(
          height: 40.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: isDark
                ? theme.colorScheme.onSecondary
                : AppColors.lightBackground,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: _isEditing
                      ? TextField(
                          controller: widget.controller,
                          focusNode: _focusNode,
                          maxLines: 2,
                          autofocus: true,
                          style: theme.textTheme.bodyMedium,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        )
                      : Text(
                          widget.controller.text,
                          maxLines: widget.isPhone? 1 : 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium,
                        ),
                ),
                SizedBox(width: 8.w),
                TextButton(
                  onPressed: _toggleEditing,
                  child: Text(
                    _isEditing ? 'Save' : 'Change',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
