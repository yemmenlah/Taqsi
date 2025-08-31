

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:taqsi/shared/colors.dart';
import 'package:taqsi/services/weather_service.dart'; // فيه fetchWeather

class HomePage extends StatefulWidget {
  final double lat;
  final double lon;
  const HomePage({super.key, required this.lat, required this.lon});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? weatherData;
  String animationPath = 'assets/lottie/default.json';

  @override
  void initState() {
    super.initState();
    _loadWeather();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: backgroundcolor,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  Future<void> _loadWeather() async {
    try {
final data = await WeatherService.fetchWeather(widget.lat, widget.lon);
      if (!mounted) return;

      setState(() {
        weatherData = data;

        final condition =
            weatherData?['weather'][0]['main'].toString().toLowerCase() ?? "";
        final isDay =
            (weatherData?['weather'][0]['icon'] ?? "").toString().contains('d');

        final animationMap = {
          'clear': isDay
              ? 'assets/lottie/sunny.json'
              : 'assets/lottie/night_clear.json',
          'clouds': isDay
              ? 'assets/lottie/cloudy.json'
              : 'assets/lottie/cloudy_night.json',
          'rain': isDay
              ? 'assets/lottie/rainy.json'
              : 'assets/lottie/rainy_night.json',
        };

        animationPath =
            animationMap[condition] ?? 'assets/lottie/default.json';
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تعذر جلب بيانات الطقس")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (weatherData == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.blue),
        ),
      );
    }

    final temp = weatherData!['main']['temp'];
    // final city = weatherData!['name'] ?? "";
    final country = weatherData!['sys']['country'] ?? "";

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, size: 50),
            const SizedBox(height: 8),
            Text(
              "$country",
              style: const TextStyle(fontFamily: "font3", fontSize: 18),
            ),
            const SizedBox(height: 30),

            // Lottie Animation
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Lottie.asset(animationPath, fit: BoxFit.contain),
            ),

            const SizedBox(height: 30),
            Text(
              "$temp°C",
              style: const TextStyle(fontFamily: "font2", fontSize: 36),
            ),
          ],
        ),
      ),
    );
  }
}
