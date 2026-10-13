import 'package:flutter_test/flutter_test.dart';
import 'package:indrive_clone/core/utils/format.dart';
import 'package:indrive_clone/core/utils/geo.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('format', () {
    test('money', () {
      expect(pkr(1250), 'PKR 1,250');
      expect(pkr(null), '-');
    });
    test('distance', () {
      expect(distanceText(850), '850 m');
      expect(distanceText(3200), '3.2 km');
      expect(distanceText(25400), '25 km');
    });
    test('duration', () {
      expect(durationText(75), '2 min');
      expect(durationText(4000), '1 h 7 min');
    });
    test('phone', () => expect(localPhone('+923001234567'), '03001234567'));
  });

  group('geo', () {
    test('decode polyline (Google example)', () {
      final pts = decodePolyline('_p~iF~ps|U_ulLnnqC_mqNvxq`@');
      expect(pts.length, 3);
      expect(pts[0].latitude, closeTo(38.5, 1e-5));
      expect(pts[0].longitude, closeTo(-120.2, 1e-5));
      expect(pts[2].latitude, closeTo(43.252, 1e-5));
    });

    test('distance and bearing', () {
      const a = LatLng(31.5104, 74.3416);
      const b = LatLng(31.5194, 74.3416); // ~1 km north
      expect(metersBetween(a, b), closeTo(1000, 15));
      expect(bearingBetween(a, b), closeTo(0, 0.5));
    });

    test('approach tracker says if someone walks towards the pickup', () {
      final t = ApproachTracker();
      expect(t.add(300), Trend.still);
      t.add(280);
      expect(t.add(250), Trend.closer);

      final t2 = ApproachTracker();
      t2.add(100);
      t2.add(130);
      expect(t2.add(160), Trend.away);

      final t3 = ApproachTracker();
      t3.add(100);
      expect(t3.add(103), Trend.still); // GPS noise is ignored
    });
  });
}
