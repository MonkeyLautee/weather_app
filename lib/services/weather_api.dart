import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/weather.dart';

Future<Map?> doGetHttp(String url) async {
  http.Response res;
  Uri uri = Uri.parse(url);
  res = await http.get(uri);
  if(res.statusCode >= 200 && res.statusCode < 300)return json.decode(res.body);
  throw Exception('Failed to perform GET request in "$url" with status code ${res.statusCode}.');
}

class WeatherAPI {
  
  static const String apiKey = '4ae172eec406442254831e941a1a7e22';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  
  static Future<Weather?> getWeatherFromCoordinates(double latitude, double longitude)async{
    String url = '$baseUrl?appid=$apiKey&lat=$latitude&lon=$longitude';
    Map? response = await doGetHttp(url);
    if(response==null)return null;
    return Weather(
      latitude: latitude,
      longitude: longitude,
      date: DateTime.now().millisecondsSinceEpoch,
      type: response['weather'][0]['main'],
    );
  }

}