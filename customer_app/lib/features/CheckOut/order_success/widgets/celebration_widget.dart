import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class CelebrationWidget extends StatefulWidget { 
  final bool? shouldLoop ; 
  final int? numberOfParticles; 
  final double? grav; 
  final double ? emiFreq; 
  final int? minbForce; 
  final int? maxbForce ; 
  const CelebrationWidget({ 
    this.shouldLoop, 
    this.numberOfParticles, 
    this.grav,
    this.emiFreq,  
    this.minbForce,  
    this.maxbForce, 
    super.key });
  @override
  State<CelebrationWidget> createState() => _CelebrationWidgetState();
}

class _CelebrationWidgetState extends State<CelebrationWidget> { 
  late ConfettiController confettiController;
          @override
   void initState() {
    super.initState();

    confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    Future.delayed(const Duration(milliseconds: 300), () {
      confettiController.play();
    });
  }
  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) { 
    return Align(
     alignment: Alignment.topCenter,
     child: ConfettiWidget(
       confettiController: confettiController,
       blastDirectionality: BlastDirectionality.explosive,
       shouldLoop: false,
       numberOfParticles: 25,
       gravity: 0.15,
       emissionFrequency: 0.05,
       minBlastForce: 8,
       maxBlastForce: 20,
       colors: const [
         Colors.red,
         Colors.yellow,
         Colors.blue,
         Colors.green,
         Colors.orange,
       ],
     ),
   ); 
  }
}