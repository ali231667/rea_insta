import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app/app_config_provider.dart';
import '../../core/config/app_config.dart';
import '../../core/l10n/strings.dart';
import '../../core/theme/app_theme.dart';
import '../auth/splash_screen.dart';

// Same text as the public pages /legal/terms and /legal/privacy on the server.
const termsOfService = <(String, String)>[
  ('1. About the service', 'inDrive clone is a student project that connects passengers with independent drivers. Passengers offer a price, drivers can accept it or offer another price, and the passenger chooses a driver. We are a technology platform, not a transport company.'),
  ('2. Your account', 'You need a Pakistani mobile number to use the app. Keep your phone safe: anyone with your phone can use your account. You must be 18 years or older. Give true information (name, documents).'),
  ('3. Prices and payment', 'The fare is agreed between the passenger and the driver before the trip. The passenger pays the driver in cash at the end of the trip. Drivers pay the platform a commission (10%) from their in-app balance.'),
  ('4. Drivers', 'Drivers must have a valid CNIC, driving license and a vehicle in good condition. Drivers are responsible for following traffic laws. We can block drivers who break the rules or get many low ratings.'),
  ('5. Behaviour', 'Be respectful. No violence, harassment, discrimination, smoking without permission, or illegal items. Report problems with the Help screen or the Safety button. We may block accounts that break these rules.'),
  ('6. Cancellations', 'You can cancel a request before the trip starts. Please give a reason. Many cancellations can lead to a block.'),
  ('7. Safety', 'In an emergency call the police (15) or Rescue (1122). The SOS button in the app also alerts our team. Always check the car plate before you get in.'),
  ('8. Liability', 'We do our best to keep the service running, but we do not guarantee it is always available. As far as the law allows, we are not responsible for losses caused by drivers, passengers or third parties.'),
  ('9. Changes', 'We may change these terms. We will show the new terms in the app. If you keep using the app, you accept the new terms.'),
  ('10. Contact', 'Questions? Use Help \u2192 Contact support in the app.'),
];

const privacyPolicy = <(String, String)>[
  ('What we collect', 'Phone number, name, email (optional), profile photo, ride history, ratings, chat messages during a ride, and your location while you use the app. For drivers also: CNIC, driving license, vehicle details and document photos.'),
  ('Why we collect it', 'To log you in, find nearby drivers, show live location during a ride, calculate prices, keep you safe (SOS, trip sharing), help with support requests, and prevent fraud.'),
  ('Location', 'Passengers share location to set the pickup point and during an active ride. Drivers share location while they are online, also when the app is in the background, so passengers can see the car coming. You can turn off location in your phone settings, but the app will not work fully.'),
  ('Who can see your data', "During a ride, the passenger and the driver see each other's name, photo, rating and phone number. Phone numbers are hidden before a driver is chosen. Our support team can see ride data to help you. We do not sell your data."),
  ('Services we use', 'OpenStreetMap / Google Maps for maps and routes, Firebase Cloud Messaging for notifications, and an SMS provider for login codes.'),
  ('How long we keep data', 'Ride history is kept for safety and legal reasons. When you delete your account, we remove your name, phone, email and photo; anonymous ride records stay.'),
  ('Your rights', 'You can see and change your profile in the app, and delete your account in Settings \u2192 Delete account. For other requests contact support.'),
  ('Security', "Passwords are not used; logins use one-time SMS codes and short-lived tokens stored in your phone's secure storage. Connections should use HTTPS in production."),
  ('Children', 'The app is not for people under 18.'),
  ('Contact', 'Use Help \u2192 Contact support in the app.'),
];

/// Terms of Service or Privacy Policy, readable without internet.
class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key, required this.page});
  final String page; // terms | privacy

  @override
  Widget build(BuildContext context) {
    final isTerms = page == 'terms';
    final items = isTerms ? termsOfService : privacyPolicy;
    return Scaffold(
      appBar: AppBar(title: Text(isTerms ? tr('Terms of Service') : tr('Privacy Policy'))),
      body: ListView(padding: const EdgeInsets.fromLTRB(20, 4, 20, 32), children: [
        const Text('Student project – not affiliated with inDrive. Last updated: October 2026.', style: TextStyle(color: AppColors.grey)),
        for (final (h, t) in items) ...[
          const SizedBox(height: 18),
          Text(h, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(t, style: const TextStyle(height: 1.5)),
        ],
      ]),
    );
  }
}

/// About: app version, legal pages, open source licenses.
class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cfg = ref.watch(remoteConfigProvider).value;
    return Scaffold(
      appBar: AppBar(title: Text(tr('About'))),
      body: ListView(children: [
        const SizedBox(height: 24),
        const Center(child: BrandLogo(size: 40)),
        const SizedBox(height: 8),
        Center(child: Text('Version ${cfg?.appVersion ?? '-'}', style: const TextStyle(color: AppColors.grey))),
        if (cfg?.canUpdate == true)
          Center(
            child: TextButton(
              onPressed: () => launchUrl(Uri.parse(cfg.storeUrl), mode: LaunchMode.externalApplication),
              child: Text('Update to ${cfg!.latestAppVersion}'),
            ),
          ),
        const SizedBox(height: 16),
        ListTile(leading: const Icon(Icons.description_outlined), title: Text(tr('Terms of Service')), onTap: () => context.push('/legal/terms')),
        ListTile(leading: const Icon(Icons.privacy_tip_outlined), title: Text(tr('Privacy Policy')), onTap: () => context.push('/legal/privacy')),
        ListTile(
          leading: const Icon(Icons.code),
          title: const Text('Open source licenses'),
          onTap: () => showLicensePage(context: context, applicationName: 'inDrive clone', applicationVersion: cfg?.appVersion),
        ),
        ListTile(
          leading: const Icon(Icons.dns_outlined),
          title: const Text('Server'),
          subtitle: Text(AppConfig.apiUrl),
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Map data © OpenStreetMap contributors. This is a student project for learning. "inDrive" is a trademark of its owner.',
              style: TextStyle(color: AppColors.grey, fontSize: 12)),
        ),
      ]),
    );
  }
}
