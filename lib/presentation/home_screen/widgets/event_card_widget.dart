import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/event_model.dart';

// Accent colors for event cards (brutalist palette)
const List<Color> _accentColors = [
  Color(0xFFF5FF00), // acid yellow
  Color(0xFFFF3D00), // red-orange
  Color(0xFF00E5FF), // cyan
  Color(0xFF76FF03), // lime
  Color(0xFFFF4081), // pink
  Color(0xFFFFD740), // amber
];

class EventCardWidget extends StatelessWidget {
  final EventModel event;
  final VoidCallback onDelete;

  const EventCardWidget({
    super.key,
    required this.event,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isFuture = event.startDateTime.isAfter(now);
    final duration = isFuture
        ? event.startDateTime.difference(now)
        : now.difference(event.startDateTime);
    final accent = _accentColors[event.colorIndex % _accentColors.length];

    final cardContent = Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF000000), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Accent top strip
          Container(height: 6, color: accent),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label + start date row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        event.label,
                        style: GoogleFonts.sora(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF000000),
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _formatStartDate(event.startDateTime),
                      style: GoogleFonts.sora(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF888888),
                        letterSpacing: 0.3,
                      ),
                    ),
                    // Web-only delete button (swipe not reliable on web)
                    if (kIsWeb) ...[
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () async {
                          final confirmed = await _confirmDelete(context);
                          if (confirmed == true) onDelete();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: Color(0xFF888888),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                // Future / Past flag badge
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  color: isFuture
                      ? const Color(0xFF000000)
                      : const Color(0xFFF5FF00),
                  child: Text(
                    isFuture ? 'TIME LEFT' : 'TIME SINCE',
                    style: GoogleFonts.sora(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: isFuture ? Colors.white : const Color(0xFF000000),
                      letterSpacing: 1.4,
                    ),
                  ),
                ),
                if (event.description.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    event.description,
                    style: GoogleFonts.sora(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF666666),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 20),
                // Primary value — large monospace
                _PrimaryDuration(duration: duration, isFuture: isFuture),
                const SizedBox(height: 16),
                // Divider
                Container(height: 1, color: const Color(0xFFE0E0E0)),
                const SizedBox(height: 14),
                // Breakdown row
                _DurationBreakdownRow(duration: duration),
              ],
            ),
          ),
        ],
      ),
    );

    // On web: skip Dismissible (swipe unreliable), render card directly
    if (kIsWeb) {
      return cardContent;
    }

    return Dismissible(
      key: ValueKey(event.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: const Color(0xFFD50000),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.delete_outline, color: Colors.white, size: 24),
            const SizedBox(height: 4),
            Text(
              'DELETE',
              style: GoogleFonts.sora(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (_) async {
        return await _confirmDelete(context);
      },
      onDismissed: (_) => onDelete(),
      child: cardContent,
    );
  }

  String _formatStartDate(DateTime dt) {
    final months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    return '${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]} ${dt.year}';
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Text(
          'Delete event?',
          style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        content: Text(
          '"${event.label}" will be removed permanently.',
          style: GoogleFonts.sora(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF666666),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'CANCEL',
              style: GoogleFonts.sora(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF888888),
                letterSpacing: 0.8,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD50000),
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: Text(
              'DELETE',
              style: GoogleFonts.sora(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryDuration extends StatelessWidget {
  final Duration duration;
  final bool isFuture;

  const _PrimaryDuration({required this.duration, required this.isFuture});

  @override
  Widget build(BuildContext context) {
    final String primaryLabel;
    final String primaryValue;
    final String primaryUnit;

    if (duration.inDays >= 365) {
      final years = duration.inDays ~/ 365;
      final remDays = duration.inDays % 365;
      final months = remDays ~/ 30;
      primaryValue = years.toString();
      primaryUnit = years == 1 ? 'year' : 'years';
      primaryLabel = months > 0
          ? '+ $months ${months == 1 ? "month" : "months"}'
          : '';
    } else if (duration.inDays >= 30) {
      final months = duration.inDays ~/ 30;
      final remDays = duration.inDays % 30;
      primaryValue = months.toString();
      primaryUnit = months == 1 ? 'month' : 'months';
      primaryLabel = remDays > 0
          ? '+ $remDays ${remDays == 1 ? "day" : "days"}'
          : '';
    } else if (duration.inDays >= 1) {
      primaryValue = duration.inDays.toString();
      primaryUnit = duration.inDays == 1 ? 'day' : 'days';
      primaryLabel = '';
    } else if (duration.inHours >= 1) {
      primaryValue = duration.inHours.toString();
      primaryUnit = duration.inHours == 1 ? 'hour' : 'hours';
      primaryLabel = '';
    } else if (duration.inMinutes >= 1) {
      primaryValue = duration.inMinutes.toString();
      primaryUnit = duration.inMinutes == 1 ? 'minute' : 'minutes';
      primaryLabel = '';
    } else {
      primaryValue = duration.inSeconds.toString();
      primaryUnit = 'seconds';
      primaryLabel = '';
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          primaryValue,
          style: GoogleFonts.ibmPlexMono(
            fontSize: 48,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF000000),
            height: 1,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              primaryUnit,
              style: GoogleFonts.sora(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF000000),
              ),
            ),
            if (primaryLabel.isNotEmpty)
              Text(
                primaryLabel,
                style: GoogleFonts.ibmPlexMono(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF888888),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _DurationBreakdownRow extends StatelessWidget {
  final Duration duration;

  const _DurationBreakdownRow({required this.duration});

  @override
  Widget build(BuildContext context) {
    final totalSeconds = duration.inSeconds;
    final years = duration.inDays ~/ 365;
    final months = (duration.inDays % 365) ~/ 30;
    final days = duration.inDays % 30;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = totalSeconds % 60;

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        if (years > 0) _BreakdownChip(value: years, unit: 'yr'),
        if (months > 0 || years > 0) _BreakdownChip(value: months, unit: 'mo'),
        _BreakdownChip(value: days, unit: 'd'),
        _BreakdownChip(value: hours, unit: 'h'),
        _BreakdownChip(value: minutes, unit: 'm'),
        _BreakdownChip(value: seconds, unit: 's', isLive: true),
      ],
    );
  }
}

class _BreakdownChip extends StatelessWidget {
  final int value;
  final String unit;
  final bool isLive;

  const _BreakdownChip({
    required this.value,
    required this.unit,
    this.isLive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          value.toString().padLeft(2, '0'),
          style: GoogleFonts.ibmPlexMono(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isLive ? const Color(0xFF000000) : const Color(0xFF444444),
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(width: 2),
        Text(
          unit,
          style: GoogleFonts.sora(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF888888),
          ),
        ),
      ],
    );
  }
}
