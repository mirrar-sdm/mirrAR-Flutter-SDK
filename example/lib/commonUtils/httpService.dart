import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class HttpService {
  // region Api Call
  Future<Map<String, dynamic>> apiCallGet({
    required String apiUrl,
    required int timeOut,
    required var headerData,
  }) async {
    Map<String, dynamic> jsonResponse;
    //  parsed Url
    var url = Uri.parse(apiUrl);

    //  Timeout duration
    var duration = Duration(seconds: timeOut);

    //  Execute Http Get
    var response = await http.get(url).timeout(duration);

    // region check if response is null
    if (response == null || response.body == null) {
      throw Exception("$apiUrl returned null response.");
    }
    // endregion

    // decode json
    print("Url: $apiUrl\n\nheader: $headerData\n\nResponse: ${response.body}");
    jsonResponse = json.decode(response.body.toString());

    return jsonResponse;
  }

  Future<Map<String, dynamic>> apiCallPost({
    required String apiUrl,
    required int timeOut,
    required Map formData,
    required var headerData,
  }) async {
    Map<String, dynamic> jsonResponse;

    // http header
    var header = {"content-type": "application/x-www-form-urlencoded"};

    // add extra header data
    if (headerData != null) header.addAll(headerData);

    //  parsed Url
    var url = Uri.parse(apiUrl);

    //  Timeout duration
    var duration = Duration(seconds: timeOut);

    //  Execute Http Get
    var response = await http.post(url, body: formData).timeout(duration);

    // region check if response is null
    if (response == null || response.body == null) {
      throw Exception("$apiUrl returned null response.");
    }
    // endregion

    // decode json
    print(
        "Url: $apiUrl\n\nheader: $headerData\n\nformDATa: $formData )}\n\nResponse: ${response.body}");
    jsonResponse = json.decode(response.body.toString());

    return jsonResponse;
  }
// endregion
}
