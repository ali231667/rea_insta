import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/auth_repository.dart';
import '../../features/auth/onboarding_screen.dart';
import '../../features/auth/otp_screen.dart';
import '../../features/auth/phone_screen.dart';
import '../../features/auth/profile_setup_screen.dart';
import '../../features/auth/session_controller.dart';
import '../../features/auth/splash_screen.dart';
import '../../features/common/chat_screen.dart';
import '../../features/common/history_screen.dart';
import '../../features/common/legal_screens.dart';
import '../../features/common/support_screens.dart';
import '../../features/common/profile_screens.dart';
import '../../features/common/rate_screen.dart';
import '../../features/driver/driver_home_screen.dart';
import '../../features/driver/driver_register_screen.dart';
import '../../features/driver/driver_ride_screen.dart';
import '../../features/driver/earnings_screen.dart';
import '../../features/passenger/home_screen.dart';
import '../../features/passenger/pick_on_map_screen.dart';
import '../../features/passenger/place_search_screen.dart';
import '../../features/passenger/ride_screen.dart';

/// All screens of the app. The redirect sends the user to the right place for the login state.
final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<Object>(0);
  ref.listen(sessionProvider.select((s) => (s.status, s.mode)), (_, next) => refresh.value = next);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refresh,
    redirect: (context, state) {
      final s = ref.read(sessionProvider);
      final loc = state.matchedLocation;
      // Terms and Privacy can be read at any time (also before login).
      if (loc.startsWith('/legal/')) return null;
      const authPages = ['/login', '/otp'];
      switch (s.status) {
        case AuthStatus.loading:
          return loc == '/splash' ? null : '/splash';
        case AuthStatus.onboarding:
          return loc == '/welcome' ? null : '/welcome';
        case AuthStatus.loggedOut:
          return authPages.contains(loc) ? null : '/login';
        case AuthStatus.needsProfile:
          return loc == '/profile-setup' ? null : '/profile-setup';
        case AuthStatus.loggedIn:
          final home = s.mode == AppMode.driver ? '/driver' : '/home';
          if (loc == '/splash' || loc == '/welcome' || loc == '/profile-setup' || authPages.contains(loc)) return home;
          // Driver pages need an approved driver account.
          if (loc.startsWith('/driver') && !loc.startsWith('/driver/register') && !loc.startsWith('/driver/status') && !s.isApprovedDriver) {
            return s.driver == null ? '/driver/register' : '/driver/status';
          }
          return null;
      }
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/welcome', builder: (_, _) => const OnboardingScreen()),
      GoRoute(path: '/login', builder: (_, _) => const PhoneScreen()),
      GoRoute(path: '/otp', builder: (_, st) => OtpScreen(request: st.extra! as OtpRequestResult)),
      GoRoute(path: '/profile-setup', builder: (_, _) => const ProfileSetupScreen()),

      // Passenger
      GoRoute(path: '/home', builder: (_, _) => const PassengerHomeScreen()),
      GoRoute(path: '/search-place', builder: (_, st) => PlaceSearchScreen(field: st.uri.queryParameters['field'] ?? 'dropoff')),
      GoRoute(path: '/pick-on-map', builder: (_, _) => const PickOnMapScreen()),
      GoRoute(path: '/ride', builder: (_, _) => const PassengerRideScreen()),
      GoRoute(path: '/rate/:id', builder: (_, st) => RateScreen(rideId: st.pathParameters['id']!)),

      // Driver
      GoRoute(path: '/driver', builder: (_, _) => const DriverHomeScreen()),
      GoRoute(path: '/driver/ride', builder: (_, _) => const DriverRideScreen()),
      GoRoute(path: '/driver/register', builder: (_, _) => const DriverRegisterScreen()),
      GoRoute(path: '/driver/status', builder: (_, _) => const DriverStatusScreen()),
      GoRoute(path: '/driver/earnings', builder: (_, _) => const EarningsScreen()),
      GoRoute(path: '/driver/services', builder: (_, _) => const DriverServicesScreen()),

      // Both
      GoRoute(path: '/chat/:id', builder: (_, st) => ChatScreen(rideId: st.pathParameters['id']!)),
      GoRoute(path: '/history', builder: (_, _) => const HistoryScreen()),
      GoRoute(path: '/history/:id', builder: (_, st) => RideDetailsScreen(rideId: st.pathParameters['id']!)),
      GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),
      GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
      GoRoute(path: '/safety', builder: (_, _) => const SafetyScreen()),
      GoRoute(path: '/help', builder: (_, _) => const HelpScreen()),
      GoRoute(path: '/support', builder: (_, _) => const SupportScreen()),
      GoRoute(
        path: '/support/new',
        builder: (_, st) => NewTicketScreen(rideId: st.uri.queryParameters['rideId'], category: st.uri.queryParameters['category']),
      ),
      GoRoute(path: '/legal/:page', builder: (_, st) => LegalScreen(page: st.pathParameters['page']!)),
      GoRoute(path: '/about', builder: (_, _) => const AboutScreen()),
    ],
  );
});
