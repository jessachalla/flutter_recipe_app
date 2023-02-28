import 'dart:convert';
import 'package:flutter_recipe_app/models/recipe.dart';
import 'package:http/http.dart' as http;

class RecipeApi {
  static Future<List<Recipe>> getRecipe() async {
    var uri = Uri.https('yummly2.p.rapidapi.com', '/feeds/list',
        {"limit": "24", "start": "0", "tag": "list.recipe.popular"});

    const recipeApiKey = String.fromEnvironment('RECIPE_KEY');
    if (recipeApiKey.isEmpty) {
      throw AssertionError('RECIPE_KEY is not set');
    }

    final response = await http.get(uri, headers: {
      "x-rapidapi-key": recipeApiKey,
      "x-rapidapi-host": "yummly2.p.rapidapi.com",
      "useQueryString": "true"
    });

    Map data = jsonDecode(response.body);
    // ignore: no_leading_underscores_for_local_identifiers
    List _temp = [];

    for (var i in data['feed']) {
      _temp.add(i['content']['details']);
    }

    return Recipe.recipesFromSnapshot(_temp);
  }
}
