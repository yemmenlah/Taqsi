import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taqsi/responsive/mobile.dart';
import 'package:taqsi/services/location.dart';
import 'package:taqsi/shared/colors.dart';
import 'package:geolocator/geolocator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController logoController;
  late Animation<Offset> logoSlideAnimation;
  late Animation<double> logoFadeAnimation;

  late AnimationController starsController;
  late AnimationController textFadeController;
  late Animation<double> textFadeAnimation;

  @override
  void initState() {
    super.initState();

    starsController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    logoSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: logoController, curve: Curves.easeOut));

    logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: logoController, curve: Curves.easeIn),
    );

    logoController.forward();

    textFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    textFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: textFadeController, curve: Curves.easeIn),
    );

    textFadeController.forward();
  }

  @override
  void dispose() {
    logoController.dispose();
    starsController.dispose();
    textFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: backgroundcolor,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // النجوم
            Positioned(
              top: h * 0.06,
              left: w * 0.8,
              child: RotationTransition(
                turns: starsController,
                child: SvgPicture.asset("assets/img/star1.svg", width: w * 0.06),
              ),
            ),
            Positioned(
              top: h * 0.09,
              left: w * 0.4,
              child: RotationTransition(
                turns: starsController,
                child: SvgPicture.asset("assets/img/star2.svg", width: w * 0.05),
              ),
            ),
            Positioned(
              top: h * 0.12,
              left: w * 0.15,
              child: RotationTransition(
                turns: starsController,
                child: SvgPicture.asset("assets/img/star3.svg", width: w * 0.03),
              ),
            ),

            // logo
            Positioned(
              top: h * 0.20,
              child: FadeTransition(
                opacity: logoFadeAnimation,
                child: SlideTransition(
                  position: logoSlideAnimation,
                  child: SvgPicture.asset(
                    "assets/img/logo.svg",
                    width: w * 0.55,
                  ),
                ),
              ),
            ),

            // name
            Positioned(
              top: h * 0.56,
              child: FadeTransition(
                opacity: textFadeAnimation,
                child: Text(
                  "Taqsi",
                  style: TextStyle(fontSize: w * 0.08, fontFamily: "font1"),
                ),
              ),
            ),

            // description
            Positioned(
              top: h * 0.65,
              width: w * 0.8,
              child: Text(
                "Get real-time weather updates.\nAccurate. Beautiful. Simple.",
                style: TextStyle(fontSize: w * 0.045, fontFamily: "font2"),
                textAlign: TextAlign.center,
              ),
            ),

            // button
            Positioned(
              bottom: h * 0.07,
              child: ElevatedButton(
                onPressed: () async {
                  Position? position = await LocationService.getCurrentLocation();
                  if (position != null) {
                    Navigator.of(context).pushReplacement(
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const Mobile(),
                        transitionsBuilder: (_, animation, __, child) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(
                    vertical: h * 0.02,
                    horizontal: w * 0.15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: Text(
                  "Get Started",
                  style: TextStyle(
                    fontSize: w * 0.05,
                    fontFamily: "font1",
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
