
import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationService {
  static const String _serverUrl = "https://loneliness-notify.onrender.com/send";

  static Future<void> sendPush({
    required String token,
    required String title,
    required String body,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_serverUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "token": token,
          "title": title,
          "body": body,
        }),
      );

      if (response.statusCode == 200) {
        print("Notification sent successfully to $token");
      } else {
        print("Failed to send notification: ${response.body}");
      }
    } catch (e) {
      print("Notification error: $e");
    }
  }
}
