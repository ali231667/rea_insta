// Checks that the app models can read REAL answers from the backend.
// The JSON files in test/fixtures were saved from the running server.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:indrive_clone/models/misc.dart';
import 'package:indrive_clone/models/ride.dart';
import 'package:indrive_clone/models/user.dart';

dynamic fixture(String name) => jsonDecode(File('test/fixtures/$name').readAsStringSync());

void main() {
  test('GET /users/me (driver account)', () {
    final me = Me.fromJson(fixture('me_driver.json') as Map<String, dynamic>);
    expect(me.user.phone, startsWith('+92'));
    expect(me.driver, isNotNull);
    expect(me.driver!.status, 'approved');
    expect(me.driver!.vehicle.plateNumber, isNotEmpty);
  });

  test('POST /rides/estimate', () {
    final e = FareEstimate.fromJson(fixture('estimate.json') as Map<String, dynamic>);
    expect(e.options.map((o) => o.vehicleType), containsAll(['moto', 'mini', 'ac']));
    for (final o in e.options) {
      expect(o.recommendedFare, greaterThanOrEqualTo(o.minFare));
    }
  });

  test('ride while searching, with offers, and accepted', () {
    final searching = Ride.fromJson(fixture('ride_searching.json') as Map<String, dynamic>);
    expect(searching.status, RideStatus.searching);
    expect(searching.details.childSeat, true);
    expect(searching.isActive, true);
    expect(searching.isAssigned, false);

    final withOffers = Ride.fromJson(fixture('ride_with_offers.json') as Map<String, dynamic>);
    expect(withOffers.offers, isNotEmpty);
    final o = withOffers.offers.first;
    expect(o.price, greaterThanOrEqualTo(withOffers.offeredFare));
    expect(o.driver?.vehicle.make, isNotEmpty);

    final accepted = Ride.fromJson(fixture('ride_accepted.json') as Map<String, dynamic>);
    expect(accepted.status, RideStatus.accepted);
    expect(accepted.driver?.phone, startsWith('+92'));
    expect(accepted.passenger?.phone, startsWith('+92'));
    expect(accepted.price, accepted.finalFare);
  });

  test('driver order feed', () {
    final list = (fixture('driver_requests.json') as List).map((e) => DriverRequest.fromJson(e as Map<String, dynamic>)).toList();
    expect(list, isNotEmpty);
    expect(list.first.passenger.phone, isNull); // phone is private before matching
    expect(list.first.details.packageDescription, 'Documents');
    expect(list.first.pickupDistanceM, isNotNull);
  });

  test('earnings, nearby cars, place search', () {
    final e = Earnings.fromJson(fixture('earnings.json') as Map<String, dynamic>);
    expect(e.commissionRate, 0.1);
    expect(e.transactions.first.type, 'bonus');

    final cars = ((fixture('nearby.json') as Map)['drivers'] as List).map((e) => NearbyCar.fromJson(e as Map<String, dynamic>));
    expect(cars, isNotEmpty);

    final places = (fixture('search.json') as List).map((e) => Place.fromJson(e as Map<String, dynamic>));
    expect(places.first.name, contains('Liberty'));
  });

  test('ride history', () {
    final list = (fixture('history_driver.json') as List).map((e) => Ride.fromJson(e as Map<String, dynamic>)).toList();
    expect(list, isNotEmpty);
    expect(list.first.status, anyOf(RideStatus.completed, RideStatus.cancelled));
  });
}
