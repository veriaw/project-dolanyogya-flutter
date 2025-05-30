import 'dart:convert';

import 'package:http/http.dart' as http;

class BaseNetwork {
  static const String baseUrl = 'https://api-dolan-yogya-928661779459.us-central1.run.app';

  static Future<Map<String, dynamic>> getDataByCategory(String category) async {
    final response = await http.post(
      Uri.parse(baseUrl+"/get-places-by-category"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'category': '$category'}),
    );

    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      print(data);
      return data;
    }else{
      throw Exception('Failed to Load Data!');
    }
  }
}