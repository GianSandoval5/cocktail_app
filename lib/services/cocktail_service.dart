import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cocktail.dart';

class CocktailService {
  static const String baseUrl = 'https://www.thecocktaildb.com/api/json/v1/1';
  static const String apiKey = '1'; // Test API key

  // Buscar cóctel por nombre
  static Future<List<Cocktail>> searchByName(String name) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/search.php?s=$name'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final cocktailResponse = CocktailResponse.fromJson(data);
        return cocktailResponse.drinks;
      }
    } catch (e) {
      print('Error searching cocktails by name: $e');
    }
    return [];
  }

  // Obtener cóctel aleatorio
  static Future<Cocktail?> getRandomCocktail() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/random.php'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final cocktailResponse = CocktailResponse.fromJson(data);
        return cocktailResponse.drinks.isNotEmpty
            ? cocktailResponse.drinks.first
            : null;
      }
    } catch (e) {
      print('Error getting random cocktail: $e');
    }
    return null;
  }

  // Buscar por primera letra
  static Future<List<Cocktail>> searchByFirstLetter(String letter) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search.php?f=$letter'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final cocktailResponse = CocktailResponse.fromJson(data);
        return cocktailResponse.drinks;
      }
    } catch (e) {
      print('Error searching cocktails by letter: $e');
    }
    return [];
  }

  // Obtener detalles completos por ID
  static Future<Cocktail?> getCocktailById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/lookup.php?i=$id'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final cocktailResponse = CocktailResponse.fromJson(data);
        return cocktailResponse.drinks.isNotEmpty
            ? cocktailResponse.drinks.first
            : null;
      }
    } catch (e) {
      print('Error getting cocktail by ID: $e');
    }
    return null;
  }

  // Filtrar por ingrediente
  static Future<List<Cocktail>> filterByIngredient(String ingredient) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/filter.php?i=$ingredient'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final cocktailResponse = CocktailResponse.fromJson(data);
        return cocktailResponse.drinks;
      }
    } catch (e) {
      print('Error filtering cocktails by ingredient: $e');
    }
    return [];
  }

  // Filtrar por categoría
  static Future<List<Cocktail>> filterByCategory(String category) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/filter.php?c=$category'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final cocktailResponse = CocktailResponse.fromJson(data);
        return cocktailResponse.drinks;
      }
    } catch (e) {
      print('Error filtering cocktails by category: $e');
    }
    return [];
  }

  // Filtrar por alcoholic/non-alcoholic
  static Future<List<Cocktail>> filterByAlcoholic(String alcoholic) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/filter.php?a=$alcoholic'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final cocktailResponse = CocktailResponse.fromJson(data);
        return cocktailResponse.drinks;
      }
    } catch (e) {
      print('Error filtering cocktails by alcoholic type: $e');
    }
    return [];
  }

  // Obtener lista de categorías
  static Future<List<String>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/list.php?c=list'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['drinks'] != null) {
          return (data['drinks'] as List)
              .map((item) => item['strCategory'] as String)
              .toList();
        }
      }
    } catch (e) {
      print('Error getting categories: $e');
    }
    return [];
  }

  // Obtener lista de ingredientes
  static Future<List<String>> getIngredients() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/list.php?i=list'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['drinks'] != null) {
          return (data['drinks'] as List)
              .map((item) => item['strIngredient1'] as String)
              .toList();
        }
      }
    } catch (e) {
      print('Error getting ingredients: $e');
    }
    return [];
  }
}
