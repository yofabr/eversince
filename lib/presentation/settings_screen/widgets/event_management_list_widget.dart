import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/event_model.dart';
import '../../../widgets/empty_state_widget.dart';

const List<Color> _accentColors = [
  Color(0xFFF5FF00),
  Color(0xFFFF3D00),
  Color(0xFF00E5FF),
  Color(0xFF76FF03),
  Color(0xFFFF4081),
  Color(0xFFFFD740),
];

class EventManagementListWidget extends StatelessWidget {
  final List<EventModel> events;
  final Future<void> Function(String id) onDelete;
  final bool isLoading;

  const EventManagementListWidget({
    super.key,
    required this.events,
    required this.onDelete,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildSkeleton();
    }

    if (events.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: EmptyStateWidget(
          icon: Icons.event_note_outlined,
          title: 'No events tracked',
          message: 'Add your first event using the form above.',
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return _EventManagementItem(
          event: events[index],
          onDelete: () => onDelete(events[index].id),
        );
      },
    );
  }

  Widget _buildSkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(
          3,
          (i) => Container(
            height: 72,
            margin: const EdgeInsets.only(bottom: 2),
            color: const Color(0xFFEEEEEE),
          ),
        ),
      ),
    );
  }
}

class _EventManagementItem extends StatefulWidget {
  final EventModel event;
  final VoidCallback onDelete;

  const _EventManagementItem({required this.event, required this.onDelete});

  @override
  State<_EventManagementItem> createState() => _EventManagementItemState();
}

class _EventManagementItemState extends State<_EventManagementItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _fade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _slide = Tween<Offset>(
      begin: const Offset(0.06, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  String _formatDateTime(DateTime dt) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}, $h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final accent =
        _accentColors[widget.event.colorIndex % _accentColors.length];

    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: Dismissible(
          key: ValueKey(widget.event.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: const Color(0xFFD50000),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.delete_outline, color: Colors.white, size: 20),
                const SizedBox(height: 2),
                Text(
                  'DELETE',
                  style: GoogleFonts.sora(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
          confirmDismiss: (_) async {
            return await _showDeleteConfirm(context);
          },
          onDismissed: (_) => widget.onDelete(),
          child: Container(
            margin: const EdgeInsets.only(bottom: 2),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1),
              ),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  // Color accent strip
                  Container(width: 5, color: accent),
                  // Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.event.label,
                                  style: GoogleFonts.sora(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF000000),
                                  ),
                                ),
                                if (widget.event.description.isNotEmpty) ...[
                                  const SizedBox(height: 3),
                                  Text(
                                    widget.event.description,
                                    style: GoogleFonts.sora(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF888888),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.schedule_outlined,
                                      size: 11,
                                      color: Color(0xFFAAAAAA),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _formatDateTime(
                                        widget.event.startDateTime,
                                      ),
                                      style: GoogleFonts.ibmPlexMono(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFFAAAAAA),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Swipe hint
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.swipe_left_outlined,
                                size: 14,
                                color: Color(0xFFCCCCCC),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'delete',
                                style: GoogleFonts.sora(
                                  fontSize: 8,
                                  color: const Color(0xFFCCCCCC),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showDeleteConfirm(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        title: Text(
          'Remove event?',
          style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        content: Text(
          '"${widget.event.label}" will be permanently removed.',
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
              'REMOVE',
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
