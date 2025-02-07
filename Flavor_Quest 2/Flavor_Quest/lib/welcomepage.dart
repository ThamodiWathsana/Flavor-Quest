import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Define theme colors
    const primaryPink = Color(0xFFFF4B8A);
    const secondaryPink = Color(0xFFFFF0F5);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60.0),
              // Modern minimalist logo/brand section with candy theme
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: secondaryPink,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      '🍬',
                      style: TextStyle(
                        fontSize: 50,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40.0),
              const Text(
                'Welcome to\nFlavorQuest',
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                  color: primaryPink,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Hello, sweet friend! Let\'s find your perfect candies together!',  // Fixed string formatting
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/signin'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryPink,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, '/signup'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryPink,
                      minimumSize: const Size(double.infinity, 56),
                      side: const BorderSide(
                        color: primaryPink,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}