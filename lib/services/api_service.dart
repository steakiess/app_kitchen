import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  static Future<List<dynamic>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categories.php'));
      if (response.statusCode == 200) {
        return json.decode(response.body)['categories'];
      }
    } catch (e) {
      return [];
    }
    return [];
  }

  static Future<List<dynamic>> getFeaturedMeals() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/search.php?s='));
      if (response.statusCode == 200) {
        return json.decode(response.body)['meals'] ?? [];
      }
    } catch (e) {
      return [];
    }
    return [];
  }

  static Future<List<dynamic>> getMealsByCategory(String category) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/filter.php?c=$category'));
      if (response.statusCode == 200) {
        return json.decode(response.body)['meals'] ?? [];
      }
    } catch (e) {
      return [];
    }
    return [];
  }

  static Future<Map<String, dynamic>?> getMealDetail(String mealId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/lookup.php?i=$mealId'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['meals'] != null ? data['meals'][0] : null;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  static Future<List<dynamic>> searchMeals(String query) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/search.php?s=$query'));
      if (response.statusCode == 200) {
        return json.decode(response.body)['meals'] ?? [];
      }
    } catch (e) {
      return [];
    }
    return [];
  }
}
