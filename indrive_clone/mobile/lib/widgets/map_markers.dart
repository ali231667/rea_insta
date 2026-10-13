import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../core/theme/app_theme.dart';

/// Green circle = pickup ("A"), black square = destination ("B"), like InDrive.
Marker pickupMarker(LatLng p, {String label = 'A'}) => Marker(
      point: p,
      width: 34,
      height: 34,
      child: _Pin(color: AppColors.lime, textColor: AppColors.black, label: label, round: true),
    );

Marker dropoffMarker(LatLng p, {String label = 'B'}) => Marker(
      point: p,
      width: 34,
      height: 34,
      child: _Pin(color: AppColors.black, textColor: Colors.white, label: label, round: false),
    );

/// Car icon turned in the driving direction.
Marker carMarker(LatLng p, {double? heading, String vehicleType = 'mini', Key? key, double size = 40}) => Marker(
      key: key,
      point: p,
      width: size,
      height: size,
      child: Transform.rotate(
        angle: (heading ?? 0) * math.pi / 180,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 6)],
          ),
          padding: const EdgeInsets.all(6),
          child: Icon(
            vehicleType == 'moto'
                ? Icons.two_wheeler
                : vehicleType == 'rickshaw'
                    ? Icons.electric_rickshaw
                    : (vehicleType == 'loader' || vehicleType == 'truck')
                        ? Icons.local_shipping
                        : Icons.navigation,
            color: AppColors.black,
            size: size * 0.5,
          ),
        ),
      ),
    );

/// Blue dot for "me" (or the passenger on the driver's map).
Marker personMarker(LatLng p, {Color color = AppColors.blue}) => Marker(
      point: p,
      width: 24,
      height: 24,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 10, spreadRadius: 4)],
        ),
      ),
    );

class _Pin extends StatelessWidget {
  const _Pin({required this.color, required this.textColor, required this.label, required this.round});
  final Color color;
  final Color textColor;
  final String label;
  final bool round;

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          shape: round ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: round ? null : BorderRadius.circular(8),
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 6)],
        ),
        child: Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.w800)),
      );
}

/// Polyline in InDrive style (dark line with lime border).
Polyline routeLine(List<LatLng> points, {bool dashed = false}) => Polyline(
      points: points,
      strokeWidth: 5,
      color: AppColors.black,
      borderColor: AppColors.lime,
      borderStrokeWidth: 2,
      pattern: dashed ? StrokePattern.dashed(segments: const [10, 8]) : const StrokePattern.solid(),
    );
