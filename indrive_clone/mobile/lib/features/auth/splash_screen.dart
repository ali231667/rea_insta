import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        backgroundColor: AppColors.lime,
        body: Center(child: BrandLogo(size: 44)),
      );
}

/// "inDrive" style text logo.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.size = 32, this.dark = true});
  final double size;
  final bool dark;

  @override
  Widget build(BuildContext context) => Text.rich(
        TextSpan(children: [
          TextSpan(text: 'in', style: TextStyle(fontWeight: FontWeight.w400, color: dark ? AppColors.black : AppColors.lime)),
          TextSpan(text: 'Drive', style: TextStyle(fontWeight: FontWeight.w900, color: dark ? AppColors.black : AppColors.lime)),
          TextSpan(text: ' clone', style: TextStyle(fontSize: size * 0.4, color: dark ? AppColors.black : Colors.white70)),
        ]),
        style: TextStyle(fontSize: size, letterSpacing: -1),
      );
}
