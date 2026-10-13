/**
 * All Socket.IO event names in one place.
 * The Flutter app uses the same names (lib/core/realtime/socket_events.dart).
 */
export const Ev = {
  // ---- client -> server ----
  driverLocation: 'driver:location', // driver sends GPS every few seconds
  passengerLocation: 'passenger:location', // passenger sends GPS during an active ride

  // ---- server -> driver ----
  rideRequest: 'ride:request', // new order near the driver
  rideRequestUpdated: 'ride:request_updated', // passenger raised the price
  rideRequestClosed: 'ride:request_closed', // order taken by another driver / cancelled / expired
  offerRejected: 'offer:rejected', // passenger declined this driver's offer
  offerExpired: 'offer:expired',

  // ---- server -> passenger ----
  offerNew: 'offer:new', // a driver sent an offer
  offerUpdated: 'offer:updated', // an offer expired / was withdrawn
  searchProgress: 'ride:search_progress', // search circle got bigger
  driverLocationUpdate: 'driver:location', // assigned driver moved

  // ---- server -> driver (passenger moving) ----
  passengerLocationUpdate: 'passenger:location',

  // ---- server -> both ----
  rideUpdated: 'ride:updated', // status changed (accepted, arrived, started, completed, cancelled...)
  chatMessage: 'chat:message',
  balanceUpdated: 'driver:balance',
} as const;
