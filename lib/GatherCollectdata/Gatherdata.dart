import 'package:http/http.dart' as http;
import 'dart:convert';

void sendFabricData(String fabricType, double percentage, String feedback, String color) async {
  final url = 'http://your-python-server-ip:5000/add_fabric'; // Replace with your server's URL
  
  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'fabric_type': fabricType,
      'percentage': percentage,
      'feedback': feedback,
      'color': color,
    }),
  );

  if (response.statusCode == 200) {
    print('Data sent successfully: ${response.body}');
  } else {
    print('Failed to send data: ${response.statusCode}');
  }
}
