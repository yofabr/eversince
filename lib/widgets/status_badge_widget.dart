import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum BadgeType { active, warning, muted }

class StatusBadgeWidget extends StatelessWidget {
  final String label;
  final BadgeType type;

  const StatusBadgeWidget({
    super.key,
    required this.label,
    this.type = BadgeType.active,
  });

  Color get _bg {
    switch (type) {
      case BadgeType.active:
        return const Color(0xFFF5FF00);
      case BadgeType.warning:
        return const Color(0xFFFF6D00);
      case BadgeType.muted:
        return const Color(0xFFF0F0F0);
    }
  }

  Color get _fg {
    switch (type) {
      case BadgeType.active:
        return const Color(0xFF000000);
      case BadgeType.warning:
        return const Color(0xFFFFFFFF);
      case BadgeType.muted:
        return const Color(0xFF888888);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _bg,
        border: Border.all(color: const Color(0xFF000000), width: 1),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.sora(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: _fg,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
