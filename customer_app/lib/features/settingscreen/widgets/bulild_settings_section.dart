import 'package:e_commerce_full_project/features/settingscreen/widgets/settings_tile.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class BulildSettingsSection extends StatefulWidget { 
  final String title ;   
  final String firstSettingsTileTitle; 
  final String firstSettingsTileSubtitle ; 
  final IconData firstIconTile ; 
  final GestureTapCallback onTapfirst; 
  final String secondSettingsTileTitle; 
  final String secondSettingsTileSubtitle ; 
  final IconData secondIconTile ; 
  final GestureTapCallback onTapSecond; 
  final String thirdSettingsTileTitle; 
  final String thirdSettingsTileSubtitle; 
  final IconData thirdIconTile ; 
  final GestureTapCallback onTapThird;  
  const BulildSettingsSection({super.key ,
   required this.title, 
   required this.firstSettingsTileTitle,
   required this.firstSettingsTileSubtitle, 
   required this.firstIconTile,
   required this.onTapfirst, 
   required this.secondSettingsTileTitle, 
   required this.secondSettingsTileSubtitle, 
   required this.secondIconTile,
   required this.onTapSecond, 
   required this.thirdSettingsTileTitle, 
   required this.thirdSettingsTileSubtitle, 
   required this.thirdIconTile, 
   required this.onTapThird,  
    });
  @override
  State<BulildSettingsSection> createState() => _BulildSettingsSectionState();
}
class _BulildSettingsSectionState extends State<BulildSettingsSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(  
         crossAxisAlignment: CrossAxisAlignment.start, 
         children: [
      Padding(
       padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
       child: Text(
        widget.title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
         ),
       ),
      ),  
      SettingsTile(icon: widget.firstIconTile, title: widget.firstSettingsTileTitle, subtitle: widget.firstSettingsTileSubtitle, onTap: widget.onTapfirst), 
      SettingsTile(icon: widget.secondIconTile, title: widget.secondSettingsTileTitle, subtitle: widget.secondSettingsTileSubtitle, onTap: widget.onTapSecond),  
      SettingsTile(icon: widget.thirdIconTile, title: widget.thirdSettingsTileTitle, subtitle: widget.thirdSettingsTileSubtitle, onTap: widget.onTapThird),   
      SizedBox(height: 18.h),
    ], 
    ),
    );
  }
} 
  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),

      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
      ),

      child: ListTile(
        onTap: onTap,

        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),

        leading: Container(
          width: 42.w,
          height: 42.h,

          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(.08),

            borderRadius: BorderRadius.circular(12.r),
          ),

          child: Icon(icon, color: theme.colorScheme.primary),
        ),

        title: Text(
          title,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
        ),

        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 11.sp, color: Colors.grey),
        ),

        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 15.sp,
          color: Colors.grey,
        ),
      ),
    );
  }
