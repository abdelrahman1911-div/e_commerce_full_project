import 'package:flutter/material.dart';

class NoItemsWidget extends StatelessWidget {
  final String ?  mainText; 
  final IconData? icon ;  
  const NoItemsWidget({super.key ,  this.mainText ,  this.icon});
  @override
  Widget build(BuildContext context) { 
    final colorScheme = Theme.of(context).colorScheme; 
    return Center(
   child: Column(
     mainAxisAlignment: MainAxisAlignment.center,
     children: [
       Icon(
        icon ?? Icons.shopping_bag_outlined,
         size: 70,
         color: colorScheme.onSurface.withOpacity(.4),
       ),
       const SizedBox(height: 15),
       Text(
         mainText ?? 'my_orders.no_orders',
         style: TextStyle(
           fontSize: 20,
           fontWeight: FontWeight.bold,
           color: colorScheme.onSurface,
         ),
       ), 
   ] 
   ),  
   ); 
  }  
}