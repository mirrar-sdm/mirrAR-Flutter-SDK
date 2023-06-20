import 'dart:convert';
import 'package:http/http.dart' as http;

class MirrarAPI {
  
  static Future<String> myApiFunction(String _base64String) async {
    // Make the API call with the provided argument and return the result
    return await callSkinAPI(_base64String);
  }
}

 Future<String> callSkinAPI(String _base64String) async {
    if (_base64String == null) return throw Exception('API call failed with status: Null string}');

    final url = Uri.parse('https://api.lakme.mirrar.com/webhook/skin/analysis');
    final headers = {'Content-Type': 'application/json'};

    final currentDate = DateTime.now();
    final fileNameString = 'image_${currentDate.year}${currentDate.month}${currentDate.day}${currentDate.hour}${currentDate.minute}${currentDate.second}.png';

    final body = json.encode({
      'image': _base64String,
      'name': fileNameString,
    });

    final response = await http.post(url, headers: headers, body: body);
      print('Request failed with status: ${response.body}');

    if (response.statusCode == 200) {
      // Request successful
      final jsonResponse = json.decode(response.body);
      return response.body;
  
    } else {
      // Request failed
          throw Exception('API call failed with status: ${response.statusCode}');

    }
  }