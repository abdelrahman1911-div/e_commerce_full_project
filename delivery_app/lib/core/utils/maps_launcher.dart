import 'package:url_launcher/url_launcher.dart';

class MapsLauncher {
  static Future <void> openDirections ({
    required String destination, 
  }) async {
    final encodedDestination = Uri.encodeComponent(destination); 
    final uri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$encodedDestination&travelmode=driving',);
      if(!await launchUrl(uri,mode: LaunchMode.externalApplication)){
        throw Exception("could_not_open_maps");
      } 
  }
}