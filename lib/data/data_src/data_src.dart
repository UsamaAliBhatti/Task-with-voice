import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:task_voice/data/models/response_model.dart';

import '../models/task_model.dart';

class DataSrc {
  final String apiKey;
  final String model = "gemini-1.5-flash";
  final Uri endpoint;

  DataSrc(this.apiKey)
      : endpoint = Uri.parse(
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey",
        );

  Future<Task> parseCommand(String prompt) async {
    final response = await http.post(
      endpoint,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contents": [
          {
            "role": "user",
            "parts": [
              {
                "text":
                    "$prompt\nRespond ONLY with raw JSON. Do NOT use markdown or code blocks. Return fields: action (create/update/delete), title, description, date (e.g., December 5th, 2025), and time (e.g., 8:50 PM)."
              }
            ]
          }
        ],
        "generationConfig": {
          "temperature": 0.2,
        }
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final geminiResponse = ResponseModel.fromMap(json);
      final task = Task.fromGeminiResponse(geminiResponse.rawJsonText);
      print(task.toString());
      return task;
    } else {
      throw Exception('Failed to get response from Gemini: ${response.body}');
    }
  }
}
