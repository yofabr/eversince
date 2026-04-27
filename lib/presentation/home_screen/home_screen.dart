import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/event_model.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_navigation.dart';
import '../../widgets/empty_state_widget.dart';
import './widgets/event_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // TODO: Replace with Riverpod/Bloc for production
  List<EventModel> _events = [];
  Timer? _ticker;
  bool _isLoading = true;
  late AnimationController _titleAnimController;
  late Animation<Offset> _titleSlideAnim;
  late Animation<double> _titleFadeAnim;

  @override
  void initState() {
    super.initState();
    _titleAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _titleSlideAnim =
        Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _titleAnimController,
            curve: Curves.easeOutCubic,
          ),
        );
    _titleFadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _titleAnimController, curve: Curves.easeOutCubic),
    );

    _loadEvents();
    _startTicker();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _titleAnimController.forward();
    });
  }

  Future<void> _loadEvents() async {
    // TODO: Replace with repository pattern for production
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('eversince_events');
    if (raw != null) {
      final List<dynamic> decoded = jsonDecode(raw);
      final events = decoded
          .map((e) => EventModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();
      events.sort((a, b) => b.startDateTime.compareTo(a.startDateTime));
      if (mounted) {
        setState(() {
          _events = events;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _startTicker() {
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _titleAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Row(
        children: [
          if (isTablet) AppNavigation(currentIndex: 0),
          Expanded(
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: _isLoading
                      ? _buildSkeleton()
                      : _events.isEmpty
                      ? _buildEmpty(context)
                      : _buildEventList(context, isTablet),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: isTablet
          ? null
          : const AppNavigation(currentIndex: 0),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          color: Color(0xFFFAFAFA),
          border: Border(
            bottom: BorderSide(color: Color(0xFF000000), width: 2),
          ),
        ),
        child: Row(
          children: [
            SlideTransition(
              position: _titleSlideAnim,
              child: FadeTransition(
                opacity: _titleFadeAnim,
                child: Text(
                  'eversince',
                  style: GoogleFonts.sora(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF000000),
                    letterSpacing: -0.8,
                  ),
                ),
              ),
            ),
            const Spacer(),
            if (_events.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5FF00),
                  border: Border.all(
                    color: const Color(0xFF000000),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  '${_events.length} EVENT${_events.length == 1 ? '' : 'S'}',
                  style: GoogleFonts.sora(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: const Color(0xFF000000),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.hourglass_empty_outlined,
      title: 'No events yet',
      message:
          'Start tracking meaningful moments.\nHead to Events to add your first one.',
      ctaLabel: 'ADD YOUR FIRST EVENT',
      onCta: () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.settingsScreen,
          (r) => false,
        );
      },
    );
  }

  Widget _buildSkeleton() {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      itemCount: 4,
      itemBuilder: (_, i) => _SkeletonCard(index: i),
    );
  }

  Widget _buildEventList(BuildContext context, bool isTablet) {
    return RefreshIndicator(
      onRefresh: _loadEvents,
      color: const Color(0xFF000000),
      backgroundColor: const Color(0xFFF5FF00),
      strokeWidth: 2.5,
      child: isTablet ? _buildTabletGrid() : _buildPhoneList(),
    );
  }

  Widget _buildPhoneList() {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: _events.length,
      itemBuilder: (context, index) {
        return _AnimatedEventCard(
          event: _events[index],
          index: index,
          onDelete: () => _deleteEvent(_events[index].id),
        );
      },
    );
  }

  Widget _buildTabletGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 1.2,
      ),
      itemCount: _events.length,
      itemBuilder: (context, index) {
        return EventCardWidget(
          event: _events[index],
          onDelete: () => _deleteEvent(_events[index].id),
        );
      },
    );
  }

  Future<void> _deleteEvent(String id) async {
    // TODO: Replace with repository pattern for production
    final prefs = await SharedPreferences.getInstance();
    final updated = _events.where((e) => e.id != id).toList();
    await prefs.setString(
      'eversince_events',
      jsonEncode(updated.map((e) => e.toMap()).toList()),
    );
    if (mounted) {
      setState(() {
        _events = updated;
      });
    }
  }
}

class _AnimatedEventCard extends StatefulWidget {
  final EventModel event;
  final int index;
  final VoidCallback onDelete;

  const _AnimatedEventCard({
    required this.event,
    required this.index,
    required this.onDelete,
  });

  @override
  State<_AnimatedEventCard> createState() => _AnimatedEventCardState();
}

class _AnimatedEventCardState extends State<_AnimatedEventCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Offset> _slide;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _fade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    final delay = (widget.index * 60).clamp(0, 400);
    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: EventCardWidget(event: widget.event, onDelete: widget.onDelete),
      ),
    );
  }
}

class _SkeletonCard extends StatefulWidget {
  final int index;
  const _SkeletonCard({required this.index});

  @override
  State<_SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<_SkeletonCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimCtrl;

  @override
  void initState() {
    super.initState();
    _shimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _shimCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimCtrl,
      builder: (_, __) {
        final shimPos = _shimCtrl.value * 2 - 0.5;
        return Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFF000000), width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _shimBox(shimPos, 120, 14),
              const SizedBox(height: 12),
              _shimBox(shimPos, 200, 48),
              const SizedBox(height: 16),
              Row(
                children: [
                  _shimBox(shimPos, 60, 12),
                  const SizedBox(width: 8),
                  _shimBox(shimPos, 60, 12),
                  const SizedBox(width: 8),
                  _shimBox(shimPos, 60, 12),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _shimBox(double pos, double w, double h) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: const [
            Color(0xFFEEEEEE),
            Color(0xFFF8F8F8),
            Color(0xFFEEEEEE),
          ],
          stops: [
            (pos - 0.3).clamp(0.0, 1.0),
            pos.clamp(0.0, 1.0),
            (pos + 0.3).clamp(0.0, 1.0),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }
}
