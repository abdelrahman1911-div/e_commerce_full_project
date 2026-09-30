import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

class CloudinaryService {
  static const String cloudName = 'naybaleu';

  static const String uploadPreset = 'ecommerce_profile';

  Future<String> uploadImage(
    Uint8List bytes,
  ) async {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );

    final request = http.MultipartRequest(
      'POST',
      uri,
    );

    request.fields['upload_preset'] = uploadPreset;

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename:
            'image_${DateTime.now().millisecondsSinceEpoch}.jpg',
      ),
    );

    final response = await request.send();

    final responseBody =
        await response.stream.bytesToString();

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        'Cloudinary upload failed: $responseBody',
      );
    }

    final data =
        jsonDecode(responseBody) as Map<String, dynamic>;

    final url = data['secure_url']?.toString();

    if (url == null || url.isEmpty) {
      throw Exception(
        'Cloudinary did not return image URL.',
      );
    }

    return url;
  }
}