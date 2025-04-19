import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/itinerary.dart';

class ApiService {
  static const String baseUrl = "http://localhost:8000";

  static Future<List<ItineraryStatic>> fetchItineraries() async {
    final response = await http.get(Uri.parse('$baseUrl/itineraries/static'));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((item) => ItineraryStatic.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load itineraries');
    }
  }
}