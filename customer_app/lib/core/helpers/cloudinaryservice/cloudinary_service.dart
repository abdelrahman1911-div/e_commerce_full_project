import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class CloudinaryService {
  static const String _cloudName = 'naybaleu';
  static const String _uploadPreset = 'ecommerce_profile';

  Future<String> uploadProfileImage(File imageFile) async {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
    );

    final request = http.MultipartRequest('POST', uri);

    request.fields['upload_preset'] = _uploadPreset;

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
      ),
    );

    final response = await request.send();

    final responseBody = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      throw Exception(
        'Cloudinary upload failed: ${response.statusCode} $responseBody',
      );
    }

    final data = jsonDecode(responseBody) as Map<String, dynamic>;

    final secureUrl = data['secure_url'] as String?;

    if (secureUrl == null || secureUrl.isEmpty) {
      throw Exception('Cloudinary did not return a secure URL');
    }

    return secureUrl;
  }
}