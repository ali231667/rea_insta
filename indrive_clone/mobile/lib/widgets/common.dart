import 'package:flutter/material.dart';

import '../core/network/api_exception.dart';
import '../core/theme/app_theme.dart';

void showMessage(BuildContext context, String text, {bool error = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text), backgroundColor: error ? AppColors.red : null));
}

void showError(BuildContext context, Object e) => showMessage(context, ApiException.from(e).message, error: true);

/// Button that shows a spinner while [onPressed] runs.
class LoadingButton extends StatefulWidget {
  const LoadingButton({super.key, required this.label, required this.onPressed, this.icon, this.outlined = false, this.color});
  final String label;
  final Future<void> Function()? onPressed;
  final IconData? icon;
  final bool outlined;
  final Color? color;

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool _busy = false;

  Future<void> _tap() async {
    setState(() => _busy = true);
    try {
      await widget.onPressed!();
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final onTap = widget.onPressed == null || _busy ? null : _tap;
    final child = _busy
        ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
        : Row(mainAxisSize: MainAxisSize.min, children: [
            if (widget.icon != null) ...[Icon(widget.icon, size: 20), const SizedBox(width: 8)],
            Flexible(child: Text(widget.label, overflow: TextOverflow.ellipsis)),
          ]);
    if (widget.outlined) return OutlinedButton(onPressed: onTap, child: child);
    return FilledButton(
      onPressed: onTap,
      style: widget.color == null ? null : FilledButton.styleFrom(backgroundColor: widget.color, foregroundColor: Colors.white),
      child: child,
    );
  }
}

/// Rounded grey box used for inputs and info rows.
class InfoTile extends StatelessWidget {
  const InfoTile({super.key, required this.icon, required this.text, this.subtitle, this.onTap, this.trailing, this.iconColor});
  final IconData icon;
  final String text;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: dark ? const Color(0xFF2A2A2A) : AppColors.greyLight,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(text, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                if (subtitle != null)
                  Text(subtitle!, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.grey, fontSize: 13)),
              ]),
            ),
            ?trailing,
          ]),
        ),
      ),
    );
  }
}

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, this.url, this.name, this.radius = 24});
  final String? url;
  final String? name;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final initials = (name ?? '?').trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).take(2).map((w) => w[0].toUpperCase()).join();
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.lime,
      foregroundImage: url != null ? NetworkImage(url!) : null,
      child: Text(initials.isEmpty ? '?' : initials,
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.w700, fontSize: radius * 0.7)),
    );
  }
}

/// "★ 4.9 (120)"
class RatingBadge extends StatelessWidget {
  const RatingBadge({super.key, required this.rating, this.count, this.size = 14});
  final double rating;
  final int? count;
  final double size;

  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.star_rounded, color: const Color(0xFFFFB300), size: size + 2),
        const SizedBox(width: 2),
        Text(rating.toStringAsFixed(rating == rating.roundToDouble() ? 1 : 2),
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: size)),
        if (count != null) Text(' ($count)', style: TextStyle(color: AppColors.grey, fontSize: size - 1)),
      ]);
}

class StarInput extends StatelessWidget {
  const StarInput({super.key, required this.value, required this.onChanged, this.size = 44});
  final int value;
  final ValueChanged<int> onChanged;
  final double size;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          5,
          (i) => IconButton(
            iconSize: size,
            onPressed: () => onChanged(i + 1),
            icon: Icon(i < value ? Icons.star_rounded : Icons.star_outline_rounded,
                color: i < value ? const Color(0xFFFFB300) : AppColors.grey),
          ),
        ),
      );
}

/// Small rounded label (status, tags).
class Pill extends StatelessWidget {
  const Pill(this.text, {super.key, this.color = AppColors.lime, this.textColor = AppColors.black, this.icon});
  final String text;
  final Color color;
  final Color textColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (icon != null) ...[Icon(icon, size: 14, color: textColor), const SizedBox(width: 4)],
          Text(text, style: TextStyle(color: textColor, fontWeight: FontWeight.w700, fontSize: 12)),
        ]),
      );
}

/// Circle button floating on the map (menu, my location).
class MapCircleButton extends StatelessWidget {
  const MapCircleButton({super.key, required this.icon, required this.onTap, this.tooltip});
  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) => Material(
        color: Theme.of(context).colorScheme.surface,
        shape: const CircleBorder(),
        elevation: 4,
        child: IconButton(icon: Icon(icon), onPressed: onTap, tooltip: tooltip),
      );
}
