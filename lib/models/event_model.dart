class EventModel {
  final String id;
  final String label;
  final String description;
  final DateTime startDateTime;
  final int colorIndex;

  EventModel({
    required this.id,
    required this.label,
    required this.description,
    required this.startDateTime,
    required this.colorIndex,
  });

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] as String,
      label: map['label'] as String,
      description: map['description'] as String? ?? '',
      startDateTime: DateTime.parse(map['startDateTime'] as String),
      colorIndex: (map['colorIndex'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'description': description,
      'startDateTime': startDateTime.toIso8601String(),
      'colorIndex': colorIndex,
    };
  }
}
