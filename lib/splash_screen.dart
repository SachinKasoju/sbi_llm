import 'package:flutter/material.dart';
import 'package:sbi_riverpod_project/utils/global_colors.dart';
import 'package:sbi_riverpod_project/views/onboarding/onboarding_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_shell.dart';
import 'network/api_services.dart';
import 'network/login_handler.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off, size: 80, color: Colors.red),
            SizedBox(height: 16),
            Text(
              'No Internet Connection',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Please check your internet connection',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool internet = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      // Your function here
      print("3 seconds completed");
      initialization();
    });
  }

  Future<void> initialization() async {
    internet = await internetConnectivityCheck();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const MainShell()));
    }else if (!internet) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const NoInternetScreen(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OnboardingPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent.shade400,
      body: Stack(
        fit: StackFit.expand,
        children: [
          /// Background color or gradient
          Container(color: AppColors.primaryCardColor),
          Center(
            child: AnimatedDialogImage(
              image: Image.asset(
                'assets/splashlogo.png',
                width: 400,
                height: 350,
                //fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedDialogImage extends StatefulWidget {
  final Widget image;

  const AnimatedDialogImage({super.key, required this.image});

  @override
  _AnimatedDialogImageState createState() => _AnimatedDialogImageState();
}

class _AnimatedDialogImageState extends State<AnimatedDialogImage>  with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: ScaleTransition(scale: _animation, child: widget.image),
    );
  }
}
