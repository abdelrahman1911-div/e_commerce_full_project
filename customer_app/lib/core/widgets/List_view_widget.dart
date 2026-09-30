import 'package:flutter/material.dart';

class CustomListView<Modeli> extends StatelessWidget {
  final List<Modeli> items; 
  final Axis Scroll; 
  final bool? shrinkWrap; 
  final Widget Function(
    BuildContext context,
    Modeli item,
    int index,
  ) itemBuilder;

  final Widget Function(
    BuildContext context,
    int index,
  )? separatorBuilder;
    
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding; 
  const CustomListView({
    super.key,
    required this.items,
    required this.itemBuilder, 
    required this.Scroll,  
    this.shrinkWrap, 
    this.separatorBuilder,
    this.physics, 
    this.padding
  });

  @override
  Widget build(BuildContext context) {
    if (separatorBuilder != null) {
      return ListView.separated( 
        padding: padding,
        physics: physics, 
        shrinkWrap: shrinkWrap ?? false, 
        scrollDirection: Scroll ,
        itemCount: items.length,
        separatorBuilder: separatorBuilder!,
        itemBuilder: (context, index) {
          return itemBuilder(
            context,
            items[index],
            index,
          );
        },
      );
    }
    return ListView.builder( 
      padding: padding,
      physics: physics,  
      shrinkWrap: shrinkWrap ?? false,
      scrollDirection: Scroll,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return itemBuilder(
          context,
          items[index],
          index,
        );
      },
    );
  }
}