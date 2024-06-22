import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationService {
  final WebSocketChannel channel;
  final String apiUrl = 'http://192.168.115.164:8000';

  NotificationService(String url)
      : channel = WebSocketChannel.connect(Uri.parse(url));

  Stream<String> get notifications => channel.stream.map((event) => utf8.decode(event.toString().codeUnits));

  Future<List<String>> fetchUnreadNotifications() async {
    final response = await http.get(Uri.parse('$apiUrl/notifications/unread'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((item) => item['message'] as String).toList();
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  Future<void> markNotificationsAsRead() async {
    await http.put(Uri.parse('$apiUrl/notifications/read'));
  }

  void dispose() {
    channel.sink.close(status.goingAway);
  }
}
