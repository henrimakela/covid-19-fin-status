
import 'package:http/http.dart' as http;

const url =
    'https://w3qa5ydb4l.execute-api.eu-west-1.amazonaws.com/prod/finnishCoronaData';

class CoronaApiClient {
  static Future<http.Response> fetchCorona() async {
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception("Failed to load corona data");
    }
  }
}
