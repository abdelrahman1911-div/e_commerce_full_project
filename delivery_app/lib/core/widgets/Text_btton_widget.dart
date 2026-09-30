import 'package:flutter/material.dart';

class ForgotPasswordButton extends StatelessWidget {
  final VoidCallback? onPressed; 
  const ForgotPasswordButton({
     this.onPressed, 
    super.key,
  }); 

  @override
  
  Widget build(BuildContext context) {
   
    final colorScheme = Theme.of(context).colorScheme;
   
    return Align(
   
      alignment: Alignment.centerRight, 

      child: TextButton(
        onPressed: onPressed ??   () {
        }, 

        style: TextButton.styleFrom(
        
          foregroundColor: colorScheme.primary,
        
          padding: EdgeInsets.zero,
        
          minimumSize: Size.zero,
        
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        
        ),
        
        child: Text(
        
          'Forgot password?',
        
          style: Theme.of(context)
        
              .textTheme
        
              .bodyMedium
        
              ?.copyWith(
        
                color: colorScheme.primary,
        
                fontWeight: FontWeight.w600,
        
              ),
        
        ),
      
      ),
    
    );
  
  }
}