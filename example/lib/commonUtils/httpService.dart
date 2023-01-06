import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class HttpService {
  // region Api Call
  Future<Map<String, dynamic>> apiCall(
  { required String apiUrl,
    required int timeOut,
    required var headerData,
  }) async {
    Map<String, dynamic> jsonResponse;

    // http header
    var header = {"content-type": "application/json"};

    // add extra header data
    if (headerData != null) header.addAll(headerData);

    //  parsed Url
    var url = Uri.parse(apiUrl);

    //  Timeout duration
    var duration = Duration(seconds: timeOut);

    //  Execute Http Get
    var response = await http.get(url, headers: header).timeout(duration);

    // region check if response is null
    if (response == null || response.body == null) {
      throw Exception("$apiUrl returned null response.");
    }
    // endregion

    // decode json
    print(
        "Url: $apiUrl\n\nHeader: ${json.encode(header)}\n\nResponse: ${response.body}");
    jsonResponse = json.decode(response.body.toString());

    return jsonResponse;
  }

// endregion
}
