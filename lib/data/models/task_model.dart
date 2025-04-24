// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:intl/intl.dart';

class Task {
  final String title;
  final String description;
  final String action;
  final DateTime scheduledTime;

  Task({
    required this.title,
    required this.action,
    required this.scheduledTime,
    required this.description,
  });

  factory Task.fromGeminiResponse(String rawGeminiText) {
    // Remove escape characters
    String cleaned = rawGeminiText.replaceAll(r'\"', '"');

    // Decode JSON
    final Map<String, dynamic> json = jsonDecode(cleaned);

    // Clean natural language date/time like "December 5th, 2025"
    String naturalDateTime = '${json['date']} ${json['time']}';

    // Sanitize the date format (remove ordinal suffix like 'st', 'nd', 'rd', 'th')
    String sanitizedDateTime =
        naturalDateTime.replaceAll(RegExp(r'(st|nd|rd|th)'), '');

    DateTime parsedDateTime;

    try {
      // Try to parse the date using a standard format
      parsedDateTime =
          DateFormat('MMMM d, yyyy h:mm a').parse(sanitizedDateTime);
    } catch (e) {
      // If parsing fails (invalid date format), set the current date
      print('Invalid date format. Using current date.');
      parsedDateTime = DateTime.now();
    }

    // If the date is missing entirely, default to the current date and time
    if (json['date'] == null || json['date'].isEmpty) {
      parsedDateTime = DateTime.now();
    }

    return Task(
      title: json['title'],
      action: json['action'],
      description: json['description'] ??
          'No description provided', // Handle missing description
      scheduledTime: parsedDateTime,
    );
  }

  @override
  String toString() {
    return 'Task(title: $title, action: $action, scheduledTime: $scheduledTime, description: $description)';
  }

  Task copyWith({
    String? title,
    String? description,
    String? action,
    DateTime? scheduledTime,
  }) {
    return Task(
      title: title ?? this.title,
      description: description ?? this.description,
      action: action ?? this.action,
      scheduledTime: scheduledTime ?? this.scheduledTime,
    );
  }
}
