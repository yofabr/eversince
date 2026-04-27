import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/event_model.dart';
import '../../widgets/app_navigation.dart';
import './widgets/add_event_form_widget.dart';
import './widgets/event_management_list_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  // TODO: Replace with Riverpod/Bloc for production
  List<EventModel> _events = [];
  bool _isLoading = true;
  late AnimationController _headerAnimCtrl;
  late Animation<double> _headerFade;

  @override
  void initState() {
    super.initState();
    _headerAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _headerAnimCtrl, curve: Curves.easeOutCubic),
    );
    _loadEvents();
    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) _headerAnimCtrl.forward();
    });
  }

  @override
  void dispose() {
    _headerAnimCtrl.dispose();
    super.dispose();
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
      if (mounted) setState(() => _events = events);
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _saveEvent(EventModel event) async {
    // TODO: Replace with repository pattern for production
    final prefs = await SharedPreferences.getInstance();
    final updated = [event, ..._events];
    await prefs.setString(
      'eversince_events',
      jsonEncode(updated.map((e) => e.toMap()).toList()),
    );
    if (mounted) {
      setState(() => _events = updated);
    }
    Fluttertoast.showToast(
      msg: 'Event added',
      toastLength: Toast.LENGTH_SHORT,
      gravity: kIsWeb ? ToastGravity.CENTER : ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFF000000),
      textColor: const Color(0xFFFFFFFF),
      fontSize: 13.0,
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
    if (mounted) setState(() => _events = updated);
    Fluttertoast.showToast(
      msg: 'Event deleted',
      toastLength: Toast.LENGTH_SHORT,
      gravity: kIsWeb ? ToastGravity.CENTER : ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFF000000),
      textColor: const Color(0xFFFFFFFF),
      fontSize: 13.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Row(
        children: [
          if (isTablet) AppNavigation(currentIndex: 1),
          Expanded(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: isTablet ? _buildTabletLayout() : _buildPhoneLayout(),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: isTablet
          ? null
          : const AppNavigation(currentIndex: 1),
    );
  }

  Widget _buildAppBar() {
    return SafeArea(
      bottom: false,
      child: FadeTransition(
        opacity: _headerFade,
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
              Text(
                'events',
                style: GoogleFonts.sora(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF000000),
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '/ manage',
                style: GoogleFonts.sora(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF888888),
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneLayout() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AddEventFormWidget(onSave: _saveEvent),
          if (_events.isNotEmpty) ...[
            _buildSectionHeader('YOUR EVENTS', _events.length),
            EventManagementListWidget(
              events: _events,
              onDelete: _deleteEvent,
              isLoading: _isLoading,
            ),
          ],
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: AddEventFormWidget(onSave: _saveEvent),
          ),
        ),
        Container(width: 2, color: const Color(0xFF000000)),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_events.isNotEmpty)
                  _buildSectionHeader('YOUR EVENTS', _events.length),
                EventManagementListWidget(
                  events: _events,
                  onDelete: _deleteEvent,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.sora(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF888888),
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF888888), width: 1),
            ),
            child: Text(
              '$count',
              style: GoogleFonts.ibmPlexMono(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF888888),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
