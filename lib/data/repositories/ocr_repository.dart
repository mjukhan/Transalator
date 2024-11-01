import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:translation_app/data/models/ocr_model.dart';

class OcrRepository {
  final String apiUrl =
      'https://api.ocr.space/parse/imageurl'; // Replace with your API URL
  final String apiKey = 'K85137114488957'; // Replace with your API key

  Future<OcrModel> uploadFile(
    File file, {
    bool overlay = true,
    String language = 'eng',
    bool detectOrientation = false,
    bool isCreateSearchablePdf = false,
    bool isSearchablePdfHideTextLayer = false,
    bool scale = false,
    bool isTable = false,
    int ocrEngine = 1,
  }) async {
    final request = http.MultipartRequest('GET', Uri.parse(apiUrl));

    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    request.fields['isOverlayRequired'] = overlay.toString();
    request.fields['apikey'] = apiKey;
    request.fields['language'] = language;
    request.fields['detectOrientation'] = detectOrientation.toString();
    request.fields['isCreateSearchablePdf'] = isCreateSearchablePdf.toString();
    request.fields['isSearchablePdfHideTextLayer'] =
        isSearchablePdfHideTextLayer.toString();
    request.fields['scale'] = scale.toString();
    request.fields['isTable'] = isTable.toString();
    request.fields['OCREngine'] = ocrEngine.toString();

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await http.Response.fromStream(response);
      print('Response body: ${responseData.body}');
      return OcrModel.fromJson(jsonDecode(responseData.body));
    } else {
      throw Exception('Failed to load OCR data');
    }
  }

  Future<OcrModel> uploadUrl(
    String url, {
    bool overlay = true,
    String language = 'auto',
    bool detectOrientation = true,
    bool isCreateSearchablePdf = false,
    bool isSearchablePdfHideTextLayer = false,
    bool scale = true,
    bool isTable = false,
    int ocrEngine = 1,
  }) async {
    final payload = {
      'url': url,
      'isOverlayRequired': overlay,
      'apikey': apiKey,
      'language': language,
      'detectOrientation': detectOrientation.toString(),
      'isCreateSearchablePdf': isCreateSearchablePdf.toString(),
      'isSearchablePdfHideTextLayer': isSearchablePdfHideTextLayer.toString(),
      'scale': scale.toString(),
      'isTable': isTable.toString(),
      'OCREngine': ocrEngine.toString(),
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      body: payload,
    );

    if (response.statusCode == 200) {
      return OcrModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load OCR data');
    }
  }
}
