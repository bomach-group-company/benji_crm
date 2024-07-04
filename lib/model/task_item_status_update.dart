class TaskItemStatusUpdate {
  bool error;
  bool action;
  bool query;
  String url;
  String buttonText;
  String detail;
  bool assigned;

  TaskItemStatusUpdate({
    required this.error,
    required this.action,
    required this.query,
    required this.url,
    required this.buttonText,
    required this.detail,
    required this.assigned,
  });

  factory TaskItemStatusUpdate.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return TaskItemStatusUpdate(
      error: json['error'] ?? true,
      action: json['action'] ?? false,
      query: json['query'] ?? false,
      assigned: json['assigned'] ?? true,
      url: json['url'] ?? "",
      buttonText: json['buttonText'] ?? "",
      detail: json['detail'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'action': action,
      'query': query,
      'url': url,
      'buttonText': buttonText,
      'detail': detail,
    };
  }
}
