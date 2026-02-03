class FavoritesManager {
  static final List<String> _favorites = [];
  
  static bool isFavorite(String mealId) => _favorites.contains(mealId);
  
  static void toggle(String mealId) {
    if (_favorites.contains(mealId)) {
      _favorites.remove(mealId);
    } else {
      _favorites.add(mealId);
    }
  }
  
  static List<String> get favorites => _favorites;
}