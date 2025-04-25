import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/itinerary.dart';

class ApiService {
  static const String baseUrl = "http://localhost:8000";

  static Future<List<ItineraryStatic>> fetchItineraries({
    String? search,
  }) async {
    var uri = Uri.parse('$baseUrl/itineraries/static');
    if (search != null && search.isNotEmpty) {
      uri = uri.replace(queryParameters: {'search': search});
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((item) => ItineraryStatic.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load itineraries');
    }
  }

  static Future<List<ItineraryStatic>> fetchFavorites(int userId) async {
    final uri = Uri.parse('$baseUrl/users/$userId/favorites');
    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception("…");
    final data = json.decode(res.body) as List;
    return data.map((j) => ItineraryStatic.fromJson(j)).toList();
  }
}
