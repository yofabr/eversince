import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/event_model.dart';

const List<Color> _accentColors = [
  Color(0xFFF5FF00),
  Color(0xFFFF3D00),
  Color(0xFF00E5FF),
  Color(0xFF76FF03),
  Color(0xFFFF4081),
  Color(0xFFFFD740),
];

class AddEventFormWidget extends StatefulWidget {
  final Future<void> Function(EventModel event) onSave;

  const AddEventFormWidget({super.key, required this.onSave});

  @override
  State<AddEventFormWidget> createState() => _AddEventFormWidgetState();
}

class _AddEventFormWidgetState extends State<AddEventFormWidget> {
  // TODO: Replace with Riverpod/Bloc for production
  final _formKey = GlobalKey<FormState>();
  final _labelCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  DateTime _selectedDateTime = DateTime.now();
  int _selectedColorIndex = 0;
  bool _isSaving = false;

  @override
  void dispose() {
    _labelCtrl.dispose();
    _descCtrl.dispose();
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
    return '${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]} ${dt.year} — $h:$m';
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF000000),
            onPrimary: Colors.white,
            onSurface: Color(0xFF000000),
          ),
          dialogTheme: const DialogThemeData(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF000000),
              textStyle: GoogleFonts.sora(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        child: child!,
      ),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF000000),
            onPrimary: Colors.white,
            onSurface: Color(0xFF000000),
          ),
          timePickerTheme: const TimePickerThemeData(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF000000),
              textStyle: GoogleFonts.sora(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        child: child!,
      ),
    );
    if (time == null || !mounted) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final event = EventModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      label: _labelCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      startDateTime: _selectedDateTime,
      colorIndex: _selectedColorIndex,
    );

    await widget.onSave(event);

    if (mounted) {
      setState(() {
        _isSaving = false;
        _labelCtrl.clear();
        _descCtrl.clear();
        _selectedDateTime = DateTime.now();
        _selectedColorIndex = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF000000), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Form header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: const BoxDecoration(color: Color(0xFF000000)),
            child: Row(
              children: [
                const Icon(Icons.add, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  'ADD EVENT',
                  style: GoogleFonts.sora(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1.4,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label field
                  _BrutalistFieldLabel('LABEL *'),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _labelCtrl,
                    style: GoogleFonts.sora(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF000000),
                    ),
                    decoration: InputDecoration(
                      hintText: 'e.g. Quit smoking',
                      hintStyle: GoogleFonts.sora(
                        fontSize: 14,
                        color: const Color(0xFFBBBBBB),
                      ),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Label is required';
                      }
                      if (v.trim().length > 60) {
                        return 'Max 60 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Description field
                  _BrutalistFieldLabel('DESCRIPTION'),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _descCtrl,
                    style: GoogleFonts.sora(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF000000),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Optional note or context',
                      hintStyle: GoogleFonts.sora(
                        fontSize: 14,
                        color: const Color(0xFFBBBBBB),
                      ),
                    ),
                    maxLines: 2,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 24),

                  // Date/time picker
                  _BrutalistFieldLabel('START DATE & TIME *'),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _pickDateTime,
                    splashColor: const Color(0xFFF5FF00).withAlpha(80),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF000000),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 16,
                            color: Color(0xFF000000),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _formatDateTime(_selectedDateTime),
                              style: GoogleFonts.ibmPlexMono(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF000000),
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.edit_outlined,
                            size: 14,
                            color: Color(0xFF888888),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Color selector
                  _BrutalistFieldLabel('CARD ACCENT'),
                  const SizedBox(height: 10),
                  _ColorSelector(
                    selectedIndex: _selectedColorIndex,
                    onSelect: (i) => setState(() => _selectedColorIndex = i),
                  ),
                  const SizedBox(height: 32),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF000000),
                        disabledBackgroundColor: const Color(0xFF444444),
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              'ADD EVENT',
                              style: GoogleFonts.sora(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.4,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrutalistFieldLabel extends StatelessWidget {
  final String text;
  const _BrutalistFieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.sora(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF888888),
        letterSpacing: 1.2,
      ),
    );
  }
}

class _ColorSelector extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onSelect;

  const _ColorSelector({required this.selectedIndex, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_accentColors.length, (i) {
        final isSelected = i == selectedIndex;
        return GestureDetector(
          onTap: () => onSelect(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOutCubic,
            width: isSelected ? 36 : 28,
            height: isSelected ? 36 : 28,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: _accentColors[i],
              border: Border.all(
                color: const Color(0xFF000000),
                width: isSelected ? 2.5 : 1,
              ),
            ),
            child: isSelected
                ? const Icon(Icons.check, size: 16, color: Color(0xFF000000))
                : null,
          ),
        );
      }),
    );
  }
}
