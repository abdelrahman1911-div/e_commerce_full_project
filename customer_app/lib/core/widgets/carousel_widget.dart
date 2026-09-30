import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CarouselWidget extends StatefulWidget {
  const CarouselWidget({super.key});

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  final List<String> imgList = [
    'https://plus.unsplash.com/premium_photo-1664201889896-6a42c19e953a?w=600&auto=format&fit=crop&q=60',
    
    'https://images.unsplash.com/photo-1580828343064-fde4fc206bc6?w=600&auto=format&fit=crop&q=60',
    
    'https://images.unsplash.com/photo-1577538928305-3807c3993047?w=600&auto=format&fit=crop&q=60',
  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: imgList.map((url) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: CachedNetworkImage(
              imageUrl: url,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) {
                return Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                );
              },
              errorWidget: (context, url, error) {
                debugPrint('Image Error: $error');
                return Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                      size: 40,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }).toList(),
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        pauseAutoPlayOnTouch: true,
        enlargeCenterPage: true,
        viewportFraction: 0.9,
      ),
    );
  }
}