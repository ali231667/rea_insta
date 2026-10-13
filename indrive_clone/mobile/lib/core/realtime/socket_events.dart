/// Same names as backend/src/realtime/events.ts
class SocketEvents {
  // app -> server
  static const driverLocation = 'driver:location';
  static const passengerLocation = 'passenger:location';

  // server -> driver
  static const rideRequest = 'ride:request';
  static const rideRequestUpdated = 'ride:request_updated';
  static const rideRequestClosed = 'ride:request_closed';
  static const offerRejected = 'offer:rejected';
  static const offerExpired = 'offer:expired';
  static const passengerLocationUpdate = 'passenger:location';
  static const balanceUpdated = 'driver:balance';

  // server -> passenger
  static const offerNew = 'offer:new';
  static const offerUpdated = 'offer:updated';
  static const searchProgress = 'ride:search_progress';
  static const driverLocationUpdate = 'driver:location';

  // both
  static const rideUpdated = 'ride:updated';
  static const chatMessage = 'chat:message';

  static const all = [
    rideRequest,
    rideRequestUpdated,
    rideRequestClosed,
    offerRejected,
    offerExpired,
    passengerLocationUpdate,
    balanceUpdated,
    offerNew,
    offerUpdated,
    searchProgress,
    driverLocationUpdate,
    rideUpdated,
    chatMessage,
  ];
}
