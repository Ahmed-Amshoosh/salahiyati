import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ImageService {
  static Future<String?> uploadImageToImgBB(File imageFile) async {
    const apiKey = "87af72c2f17e744a675bf96e6741c8df";

    final url = Uri.parse("https://api.imgbb.com/1/upload?key=$apiKey");

    final request = http.MultipartRequest('POST', url);

    request.files.add(
      await http.MultipartFile.fromPath('image', imageFile.path),
    );

    final response = await request.send();
    final resBody = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final data = json.decode(resBody.body);
      return data['data']['url'];
    }

    return null;
  }
}