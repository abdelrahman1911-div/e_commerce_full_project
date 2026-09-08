import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageAndNameWidget extends StatelessWidget {
  final String? image ; 
  final String? prName ; 
  const ImageAndNameWidget({super.key , this.image , this.prName});
  @override
  Widget build(BuildContext context) { 
    final colorScheme = Theme.of(context).colorScheme ; 
    return  Column(
      children: [
        CircleAvatar(
                  radius: 55,
                  backgroundImage: NetworkImage(
                   image ?? 'https://images2.minutemediacdn.com/image/upload/c_crop,x_758,y_88,w_2167,h_1218/c_fill,w_2160,ar_16:9,f_auto,q_auto,g_auto/images%2FvoltaxMediaLibrary%2Fmmsport%2Fsi%2F01m0tary1fjhr4je50n2.jpg',
                  ),
                ),
             SizedBox(height: 12.h),
            Text(
              prName ?? 'Abdelrahman Tarek',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
             SizedBox(height: 30.h)
      ],
    ); 
  }
}