import 'package:e_commerce_full_project/core/theme/themeController.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangingThemeWidget extends StatefulWidget {   
   bool valueToChange; 
  final ThemeMode? themeMode;  
  final ThemeController? themeController; 
  final String? titleOfButton;  
  final String? title ; 
  final String? subtitle; 
  final bool isTheme ;  
   ChangingThemeWidget({super.key ,   
  this.title , this.subtitle, 
   required this.isTheme,  required this.valueToChange,  this.titleOfButton  , this.themeController , this.themeMode});
  @override
  State<ChangingThemeWidget> createState() => _ChangingThemeWidgetState();
}

class _ChangingThemeWidgetState extends State<ChangingThemeWidget> {
  @override
  Widget build(BuildContext context) { 
    final currentTheme = Theme.of(context);
    final currentIsDark = currentTheme.brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: currentTheme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: currentIsDark
              ? Colors.grey.shade800
              : Colors.grey.shade200,
        ),
      ),
      child: SwitchListTile(
        value: widget.valueToChange,
        onChanged: (value) {  
          widget.isTheme ?
          ThemeController.toggleTheme() : setState(() {
            widget.valueToChange = value; 
          }); 
        }, 
        secondary: 
           widget.isTheme ?
         Icon( 
           widget.valueToChange
              ? Icons.dark_mode_outlined
              : Icons.light_mode_outlined,
        ) :  
        Icon(widget.valueToChange ? Icons.notifications_outlined
                    : Icons.notifications_off_outlined)  ,
        title:
         widget.isTheme ?
         Text(
         widget.title ?? 'dark_mode'.tr(),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ) : Text( widget.title! , style:const TextStyle(fontWeight: FontWeight.w600)), 
        subtitle: 
         widget.isTheme ? 
         Text(
          widget.valueToChange
              ? 'dark_appearance'.tr()
              : 'light_appearance'.tr(),
        ) :  
        Text(widget.subtitle!),
      ),
    );
  }
}