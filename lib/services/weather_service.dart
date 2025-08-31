import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:taqsi/utils/constants.dart'; // apiKey

class WeatherService {
  /// 📌 جلب بيانات الطقس حسب الإحداثيات
  static Future<Map<String, dynamic>?> fetchWeather(
      double lat, double lon) async {
    try {
      final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather'
        '?lat=$lat&lon=$lon&appid=$apiKey&units=metric',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        print('❌ Failed to load weather data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print("⚠️ Weather fetch error: $e");
      return null;
    }
  }
}
