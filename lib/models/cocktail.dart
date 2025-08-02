class Cocktail {
  final String id;
  final String name;
  final String? category;
  final String? alcoholic;
  final String? glass;
  final String? instructions;
  final String? image;
  final List<Ingredient> ingredients;

  Cocktail({
    required this.id,
    required this.name,
    this.category,
    this.alcoholic,
    this.glass,
    this.instructions,
    this.image,
    this.ingredients = const [],
  });

  factory Cocktail.fromJson(Map<String, dynamic> json) {
    List<Ingredient> ingredients = [];

    // Extraer ingredientes y medidas (la API tiene hasta 15 ingredientes posibles)
    for (int i = 1; i <= 15; i++) {
      String? ingredient = json['strIngredient$i'];
      String? measure = json['strMeasure$i'];

      if (ingredient != null && ingredient.isNotEmpty) {
        ingredients.add(Ingredient(name: ingredient, measure: measure?.trim()));
      }
    }

    return Cocktail(
      id: json['idDrink'] ?? '',
      name: json['strDrink'] ?? '',
      category: json['strCategory'],
      alcoholic: json['strAlcoholic'],
      glass: json['strGlass'],
      instructions: json['strInstructions'],
      image: json['strDrinkThumb'],
      ingredients: ingredients,
    );
  }
}

class Ingredient {
  final String name;
  final String? measure;

  Ingredient({required this.name, this.measure});

  String get imageUrl =>
      'https://www.thecocktaildb.com/images/ingredients/${name.toLowerCase().replaceAll(' ', '%20')}-medium.png';
}

class CocktailResponse {
  final List<Cocktail> drinks;

  CocktailResponse({required this.drinks});

  factory CocktailResponse.fromJson(Map<String, dynamic> json) {
    List<Cocktail> drinks = [];
    if (json['drinks'] != null) {
      drinks = (json['drinks'] as List)
          .map((drink) => Cocktail.fromJson(drink))
          .toList();
    }
    return CocktailResponse(drinks: drinks);
  }
}
