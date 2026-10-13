import 'package:flutter/material.dart';

import '../l10n/strings.dart';

/// Display info for vehicle types and services (same keys as backend).
class VehicleInfo {
  const VehicleInfo(this.type, this.label, this.icon, this.subtitle);
  final String type;
  final String label;
  final IconData icon;
  final String subtitle;
}

const vehicles = <String, VehicleInfo>{
  'moto': VehicleInfo('moto', 'Moto', Icons.two_wheeler, '1 seat · fastest in traffic'),
  'rickshaw': VehicleInfo('rickshaw', 'Rickshaw', Icons.electric_rickshaw, '3 seats · cheap'),
  'mini': VehicleInfo('mini', 'Ride Mini', Icons.directions_car_filled, '4 seats · economy car'),
  'ac': VehicleInfo('ac', 'Ride A/C', Icons.ac_unit, '4 seats · car with A/C'),
  'comfort': VehicleInfo('comfort', 'Comfort', Icons.local_taxi, '4 seats · newer car, more space'),
  'loader': VehicleInfo('loader', 'Loader', Icons.local_shipping_outlined, 'Suzuki pickup / Shehzore'),
  'truck': VehicleInfo('truck', 'Truck', Icons.local_shipping, 'Big loads, house shifting'),
};

VehicleInfo vehicleInfo(String type) => vehicles[type] ?? VehicleInfo(type, type, Icons.directions_car, '');

class ServiceInfo {
  const ServiceInfo(this.type, this.labelEn, this.icon, this.vehicleTypes);
  final String type;
  final String labelEn;
  final IconData icon;
  final List<String> vehicleTypes;
  String get label => tr(labelEn);
}

const services = <ServiceInfo>[
  ServiceInfo('city', 'City', Icons.directions_car, ['moto', 'rickshaw', 'mini', 'ac', 'comfort']),
  ServiceInfo('intercity', 'City to City', Icons.route, ['mini', 'ac', 'comfort']),
  ServiceInfo('courier', 'Courier', Icons.inventory_2_outlined, ['moto', 'mini']),
  ServiceInfo('freight', 'Freight', Icons.local_shipping_outlined, ['loader', 'truck']),
];

ServiceInfo serviceInfo(String type) => services.firstWhere((s) => s.type == type, orElse: () => services.first);
