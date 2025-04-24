class ResponseModel {
  final String rawJsonText;

  ResponseModel({required this.rawJsonText});

  factory ResponseModel.fromMap(Map<String, dynamic> map) {
    final String text = map['candidates'][0]['content']['parts'][0]['text'];
    return ResponseModel(rawJsonText: text);
  }
}
