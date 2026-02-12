import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../utils/constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.secondaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Icon/Logo
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppConstants.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.egg,
                size: 80,
                color: AppConstants.primaryColor,
              ),
            ),
            const SizedBox(height: 40),
            
            // App Name
            Text(
              AppConstants.appName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppConstants.primaryColor,
                letterSpacing: 2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            
            Text(
              'ML-Based Gender Detection',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 60),
            
            // Loading Indicator
            SpinKitThreeBounce(
              color: AppConstants.primaryColor,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}