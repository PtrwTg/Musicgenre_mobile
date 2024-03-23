import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';

import 'constants.dart';

class NetworkService {
  final JsonDecoder _decoder = new JsonDecoder();
  final JsonEncoder _encoder = new JsonEncoder();

  Future<http.Response?> recommendsapi(String predicted) async {
    try {
      Map param = {
        'predicted_label': predicted,
      };
      var uri = Uri.parse(
        '${kServerUrl}/recommendsapi/',
      );
      var resp = await http.post(
        uri,
        body: param,
      );
      return resp;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<http.StreamedResponse?> PredictApi(File sound) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      var uri = Uri.parse('${kServerUrl}/predictapi/');
      var request = http.MultipartRequest("POST", uri);
      var multipartFileByte = http.MultipartFile.fromBytes(
        'file',
        await sound.readAsBytes(),
        filename: basename(sound.path),
      );
      request.files.add(multipartFileByte);
      Map<String, String> headersMap = {
        "Accept": "*/*",
      };
      request.headers.addAll(headersMap);
      var response = await request.send();
      return response;
    } catch (ex) {
      print(ex.toString());
    }
  }
}
