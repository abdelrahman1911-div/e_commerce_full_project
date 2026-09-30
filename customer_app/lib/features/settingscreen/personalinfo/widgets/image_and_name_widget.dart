import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageAndNameWidget extends StatelessWidget {
  final String? image;
  final String? prName;

  const ImageAndNameWidget({
    super.key,
    this.image,
    this.prName,
  });
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasImage = image != null && image!.isNotEmpty;
    return Column(
      children: [
        CircleAvatar(
          radius: 55,
          backgroundImage: hasImage
              ? NetworkImage(image!)
              : null,
          child: !hasImage
              ? Icon(
                  Icons.person,
                  size: 55,
                  color: colorScheme.onSurface,
                )
              : null,
        ),

        SizedBox(height: 12.h),

        Text(
          prName?.isNotEmpty == true
              ? prName!
              : 'User',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),

        SizedBox(height: 30.h),
      ],
    );
  }
}