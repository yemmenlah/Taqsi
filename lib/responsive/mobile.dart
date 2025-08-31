import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:taqsi/screens/home_page.dart';
import 'package:taqsi/screens/search.dart';
import 'package:taqsi/screens/settings.dart';
import 'package:geolocator/geolocator.dart';


class Mobile extends StatefulWidget {
  const Mobile({super.key});

  @override
  State<Mobile> createState() => _MobileState();
}

class _MobileState extends State<Mobile> {
  int currentIndex = 0;
  double? lat;
  double? lon;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint("Location permission denied");
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        lat = position.latitude;
        lon = position.longitude;
      });
    } catch (e) {
      debugPrint("Error getting location: $e");
    }
  }

  void updateLocation(double newLat, double newLon) {
    setState(() {
      lat = newLat;
      lon = newLon;
      currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (lat == null || lon == null) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Getting location..."),
            ],
          ),
        ),
      );
    }

    final screens = [
      HomePage(lat: lat!, lon: lon!),
      Search(onLocationSelected: updateLocation),
      const Settings(),
    ];

    return SafeArea(
      child: Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: Container(
          color: Theme.of(context).bottomAppBarTheme.color,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 26),
            child: GNav(
              backgroundColor: Theme.of(context).bottomAppBarTheme.color!,
              color: Colors.white,
              activeColor: Colors.white,
              gap: 5,
              iconSize: 30,
              onTabChange: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              tabBackgroundColor: Colors.grey.shade800,
              padding: const EdgeInsets.all(15),
              tabs: const [
                GButton(icon: Icons.home, text: "Home"),
                GButton(icon: Icons.search, text: "Search"),
                GButton(icon: Icons.settings, text: "Settings"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
