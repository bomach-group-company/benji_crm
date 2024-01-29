import '../src/providers/constants.dart';

class ItemWeight {
  final String id;
  final int start;
  final int end;
  final String title;

  ItemWeight({
    required this.id,
    required this.start,
    required this.end,
    required this.title,
  });

  factory ItemWeight.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return ItemWeight(
      id: json['id'] ?? notAvailable,
      start: json['start'] ?? 0,
      end: json['end'] ?? 0,
      title: json['title'] ?? notAvailable,
    );
  }
}
