import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_repository.dart';
import '../data/driver_repository.dart';
import '../data/maps_repository.dart';
import '../data/ride_repository.dart';
import '../data/user_repository.dart';
import '../features/auth/session_controller.dart';
import 'location/location_service.dart';
import 'network/api_client.dart';
import 'realtime/socket_service.dart';
import 'storage/prefs.dart';
import 'storage/token_storage.dart';

/// These two are created in main() before the app starts and passed with overrides.
final prefsProvider = Provider<Prefs>((ref) => throw UnimplementedError('override in main'));
final tokenStorageProvider = Provider<TokenStorage>((ref) => throw UnimplementedError('override in main'));

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    ref.watch(tokenStorageProvider),
    onSessionExpired: () => ref.read(sessionProvider.notifier).onSessionExpired(),
  );
});

final socketProvider = Provider<SocketService>((ref) {
  final s = SocketService(ref.watch(apiClientProvider));
  ref.onDispose(s.disconnect);
  return s;
});

final locationServiceProvider = Provider<LocationService>((ref) => LocationService());

final authRepositoryProvider = Provider((ref) => AuthRepository(ref.watch(apiClientProvider), ref.watch(tokenStorageProvider)));
final userRepositoryProvider = Provider((ref) => UserRepository(ref.watch(apiClientProvider)));
final rideRepositoryProvider = Provider((ref) => RideRepository(ref.watch(apiClientProvider)));
final driverRepositoryProvider = Provider((ref) => DriverRepository(ref.watch(apiClientProvider)));
final mapsRepositoryProvider = Provider((ref) => MapsRepository(ref.watch(apiClientProvider)));
