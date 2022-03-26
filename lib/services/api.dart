import "dart:convert";
import 'package:final_tutor/models/api_result.dart';
import 'package:http/http.dart' as http;

class Api {
  static const BASE_URL = 'https://cpsu-test-api.herokuapp.com'; // 1.เปลี่ยน URL

  Future<dynamic> fetch(
      String endPoint, {
        Map<String, dynamic>? queryParams
  }) async {
    var url = Uri.parse('$BASE_URL/$endPoint');
    final response = await http.get(url, headers: {'id': '620710135'}); // 2.เปลี่ยน id รหัสนักศึกษา
    if(response.statusCode == 200) {
      Map<String, dynamic> jsonBody = json.decode(response.body);

      var apiResult = ApiResult.fromJson(jsonBody);

      if(apiResult.status == 'ok') {
        return apiResult.data;
      }
      else {
        throw apiResult.message!;
      }
    }
    else {
      throw "Server connection failed";
    }
  }

  Future<dynamic> validate(
      String endPoint,
      Map<String, dynamic> params,
  ) async {
    var url = Uri.parse('$BASE_URL/$endPoint');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'id': '620710135'}, // 3.เปลี่ยน id รหัสนักศึกษา
      body: jsonEncode(params),
    );
    if(response.statusCode == 200) {
      Map<String, dynamic> jsonBody = json.decode(response.body);

      var apiResult = ApiResult.fromJson(jsonBody);
      if(apiResult.status == 'ok') {
        return apiResult.data;
      }
      else {
        throw apiResult.message!;
      }
    }
    else {
      throw "Server connection failed";
    }
  }
}