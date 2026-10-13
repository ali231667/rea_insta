import 'package:intl/intl.dart';

final _money = NumberFormat.decimalPattern('en_US');

/// 1250 -> "PKR 1,250"
String pkr(num? v) => v == null ? '-' : 'PKR ${_money.format(v.round())}';

/// 850 -> "850 m", 3200 -> "3.2 km"
String distanceText(num? meters) {
  if (meters == null) return '-';
  if (meters < 1000) return '${meters.round()} m';
  return '${(meters / 1000).toStringAsFixed(meters < 10000 ? 1 : 0)} km';
}

/// 75 -> "2 min", 4000 -> "1 h 7 min"
String durationText(num? seconds) {
  if (seconds == null) return '-';
  final m = (seconds / 60).ceil();
  if (m < 60) return '$m min';
  return '${m ~/ 60} h ${m % 60} min';
}

String timeText(DateTime? t) => t == null ? '' : DateFormat('h:mm a').format(t.toLocal());
String dateText(DateTime? t) => t == null ? '' : DateFormat('d MMM yyyy, h:mm a').format(t.toLocal());

/// "03001234567" style for showing a +92 number.
String localPhone(String? phone) {
  if (phone == null) return '';
  return phone.startsWith('+92') ? '0${phone.substring(3)}' : phone;
}
