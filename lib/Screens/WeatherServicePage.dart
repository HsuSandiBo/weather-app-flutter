import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class WeatherService {
  final String apiKey = '9e7a44d3f9983296c965b125e0d7ea4f';

  Future<Map<String, dynamic>?> getWeatherByCoordinates(
      double lat, double lon, String unit) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=$unit&appid=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Weather error: ${response.statusCode}');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getAirPollution(double lat, double lon) async {
    final url =
        'https://api.openweathermap.org/data/2.5/air_pollution?lat=$lat&lon=$lon&appid=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Air Pollution error: ${response.statusCode}');
      return null;
    }
  }

  Future<String> getCityName(double lat, double lon) async {
    final url =
        'https://api.openweathermap.org/geo/1.0/reverse?lat=$lat&lon=$lon&limit=1&appid=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        return data[0]['name'];
      }
    }
    return 'Unknown';
  }
}