import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taqsi/shared/colors.dart';

class Search extends StatefulWidget {
  final Function(double, double) onLocationSelected;
  const Search({super.key, required this.onLocationSelected});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final List<Map<String, dynamic>> countries = [
    {"name": "Algeria", "lat": 28.0339, "lon": 1.6596},
    {"name": "Saudi Arabia", "lat": 23.8859, "lon": 45.0792},
    {"name": "Iraq", "lat": 33.2232, "lon": 43.6793},
    {"name": "Egypt", "lat": 26.8206, "lon": 30.8025},
    {"name": "Morocco", "lat": 31.7917, "lon": -7.0926},
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: backgroundcolor,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          "Suggestions",
          style: TextStyle(fontFamily: "font2", fontSize: 25),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double itemWidth = (constraints.maxWidth / 2) - 24;

            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: countries.map((country) {
                return GestureDetector(
                  onTap: () {
                    widget.onLocationSelected(
                      country['lat'],
                      country['lon'],
                    );
                  },
                  child: Container(
                    width: itemWidth,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        width: 2,
                        color: Theme.of(context).cardColor,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on_sharp, size: 22),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            country["name"],
                            style: const TextStyle(
                                fontFamily: "font3", fontSize: 18),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
