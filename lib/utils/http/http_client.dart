import 'dart:io';
import 'dart:convert';
import 'package:effort/features/personalization/controllers/user_controller.dart';
import 'package:effort/utils/exceptions/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EffortHttpHelper {
  static String baseUrl = dotenv.env['API_URL']!;

  static Map<String, String> headers = {'Content-Type' : 'application/json'};

  // Helpers method to make a GET request
  static Future<Map<String, dynamic>> get(String endpoint, String? jwt) async {

    if (jwt != null) headers['Authorization'] = 'Bearer $jwt';

    final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers
    );
    return _handleResponse(response);
  }

  // Helpers method to make a POST request
  static Future<Map<String, dynamic>> post(String endpoint, dynamic data, String? jwt) async {

    if (jwt != null) headers['Authorization'] = 'Bearer $jwt';

    final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
        body: data != null ? json.encode(data) : null
    );

    return _handleResponse(response);
  }

  // Helpers method to make a PUT request
  static Future<Map<String, dynamic>> put(String endpoint, dynamic data, String? jwt) async {

    if (jwt != null) headers['Authorization'] = 'Bearer $jwt';

    final response = await http.put(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
        body: json.encode(data)
    );

    return _handleResponse(response);
  }

  // Helpers method to make a DELETE request
  static Future<Map<String, dynamic>> delete(String endpoint, String? jwt) async {

    if (jwt != null) headers['Authorization'] = 'Bearer $jwt';

    final response = await http.delete(
        Uri.parse('$baseUrl/$endpoint'),
      headers: headers
    );
    return _handleResponse(response);
  }

  static Future<File> getFile(String endpoint, int fileId, String? jwt) async {

    if (jwt != null) headers['Authorization'] = 'Bearer $jwt';

    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: headers
    );

    if (response.statusCode == 200) {
      var tempDir = await getTemporaryDirectory();
      var filePath = '${tempDir.path}/image_$fileId.jpg';
      var file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      return file;
    } else {
      throw 'Failed to load image. Status code: ${response.statusCode} \n${response.body}';
    }
  }

  static Future<Map<String, dynamic>> postFile(String endpoint, String fileName, File file, String? jwt) async {
    var uri = Uri.parse('$baseUrl/$endpoint');
    var request = http.MultipartRequest('POST', uri);

    // Set the authorization header
    if (jwt != null) {
      request.headers['Authorization'] = 'Bearer $jwt';
    }

    // Add the file to the request
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        file.path,
        filename: fileName,
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    // Handle response (assuming _handleResponse is a custom function)
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> putFile(String endpoint, String fileName, File file, String? jwt) async {
    var uri = Uri.parse('$baseUrl/$endpoint');
    var request = http.MultipartRequest('PUT', uri);

    // Set the authorization header
    if (jwt != null) {
      request.headers['Authorization'] = 'Bearer $jwt';
    }

    // Add the file to the request
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        file.path,
        filename: fileName,
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    // Handle response (assuming _handleResponse is a custom function)
    return _handleResponse(response);
  }

  // Handle the HTTP response
  static Map<String, dynamic> _handleResponse(http.Response? response) {
    if (response!.statusCode == 204 || response.statusCode == 404) return <String, dynamic>{};

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.headers.containsKey('set-authorization')) {
        UserController.instance.userCredential!.jwt = response.headers['set-authorization']!;
      }
      return json.decode(response.body);
    }

    throw EffortHttpException(response.statusCode, response.body);
  }

}