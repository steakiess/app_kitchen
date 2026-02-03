import 'package:flutter/material.dart';
import 'dart:async';
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
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    controller.removeListener(_onSearchChanged);
    controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return; 
      
      if (controller.text.isNotEmpty) {
        searchMeals(controller.text);
      } else {

        if (!mounted) return;
        setState(() {
          searchResults = [];
          searched = false;
          loading = false;
        });
      }
    });
  }

  Future<void> searchMeals(String query) async {
    if (query.isEmpty) return;
    if (!mounted) return; 
    
    setState(() {
      loading = true;
      searched = true;
    });
    
    final results = await ApiService.searchMeals(query);
    
    if (!mounted) return; 
    
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
                hintText: 'Search... (Try "chic" or "pasta")',
                hintStyle: const TextStyle(
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
                prefixIcon: const Icon(
                  Icons.restaurant_menu,
                  color: AppColors.primary,
                ),
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: AppColors.primary,
                        ),
                        onPressed: () {
                          controller.clear();
                          setState(() {
                            searchResults = [];
                            searched = false;
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.cardBackground,
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (searched && !loading && searchResults.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Found ${searchResults.length} recipe${searchResults.length > 1 ? 's' : ''}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
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
                        'Try different keywords',
                      )
                    : !searched
                        ? _buildEmptyState(
                            Icons.flatware,
                            'Start typing to search',
                            'Find your favorite recipes',
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

  Widget _buildEmptyState(IconData icon, String text, String subtitle) {
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
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary.withOpacity(0.7),
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