import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomNavBarItem extends StatefulWidget {  
   
   
    final int currentIndex;     
    final IconData icon; 
    final int index; 
     bool showNotification = false;  
     final Function(int) onTap;
    Color? notificationColor; 
  CustomNavBarItem({super.key ,   required this.currentIndex    , required this.icon , required this.index , this.showNotification =false , this.notificationColor , required this.onTap});

  @override
  State<CustomNavBarItem> createState() => _CustomNavBarItemState();
}

class _CustomNavBarItemState extends State<CustomNavBarItem> {
  @override
  Widget build(BuildContext context) { 
  final bool isSelected = widget.currentIndex == widget.index;

    return GestureDetector(
      onTap: () => widget.onTap(widget.index),
      child: SizedBox(
        width: 55.w,
        height: 70.h,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              width: isSelected ? 52.w : 30.w,
              height: isSelected ? 52.w : 30.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.icon,
                size: isSelected ? 25.sp : 23.sp,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),

            if (widget.showNotification)
              Positioned(
                right: 14.w,
                top: 20.h,
                child: Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color:  widget.notificationColor ?? Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}