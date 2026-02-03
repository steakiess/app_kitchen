import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/favorites_manager.dart';
import '../utils/colors.dart';
import 'recipe_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<dynamic> searchResults = [];
  bool loading = false;
  bool searched = false;
  final TextEditingController controller = TextEditingController();

  Future<void> searchMeals(String query) async {
    if (query.isEmpty) return;
    setState(() {
      loading = true;
      searched = true;
    });
    final results = await ApiService.searchMeals(query);
    setState(() {
      searchResults = results;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.search,
                  color: AppColors.background,
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
              const Text(
                'Search Recipes',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            color: AppColors.cardBackground,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Try "pasta" or "chicken"...',
                hintStyle: const TextStyle(
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
                prefixIcon: const Icon(
                  Icons.restaurant_menu,
                  color: AppColors.primary,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: AppColors.primary,
                  ),
                  onPressed: () => searchMeals(controller.text),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.cardBackground,
              ),
              onSubmitted: searchMeals,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: loading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.textSecondary,
                    ),
                  )
                : searched && searchResults.isEmpty
                    ? _buildEmptyState(
                        Icons.no_meals,
                        'No recipes found',
                      )
                    : !searched
                        ? _buildEmptyState(
                            Icons.flatware,
                            'Search for delicious recipes',
                          )
                        : ListView.builder(
                            itemCount: searchResults.length,
                            itemBuilder: (ctx, i) {
                              final meal = searchResults[i];
                              return _buildMealCard(meal);
                            },
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(IconData icon, String text) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: Colors.brown.withOpacity(0.3),
          ),
          const SizedBox(height: 15),
          Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealCard(dynamic meal) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RecipeDetailPage(mealId: meal['idMeal']),
          ),
        ).then((_) => setState(() {}));
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 15),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: AppColors.cardBackground,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  meal['strMealThumb'],
                  height: 90,
                  width: 90,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal['strMeal'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          meal['strArea'] ?? '',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                FavoritesManager.isFavorite(meal['idMeal'])
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}