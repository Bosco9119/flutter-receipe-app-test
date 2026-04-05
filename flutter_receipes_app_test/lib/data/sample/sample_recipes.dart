import '../../domain/entities/recipe_entity.dart';

/// Pre-populated recipes aligned with `assets/data/recipetypes.json` type ids.
List<RecipeEntity> buildSampleRecipes() {
  final now = DateTime.now().toUtc();
  return [
    RecipeEntity(
      id: 'sample_classic_pancakes',
      typeId: 'breakfast',
      title: 'Classic Pancakes',
      imagePath:
          'https://images.unsplash.com/photo-1528207776546-365bb710ee93?w=800&q=80',
      ingredients: const [
        '200 g flour',
        '2 eggs',
        '300 ml milk',
        '1 tbsp sugar',
      ],
      steps: const [
        'Mix dry ingredients.',
        'Whisk eggs and milk, combine.',
        'Cook on a griddle until golden.',
      ],
      prepMinutes: 20,
      servings: 4,
      updatedAt: now,
    ),
    RecipeEntity(
      id: 'sample_caesar_salad',
      typeId: 'salad',
      title: 'Caesar Salad',
      imagePath:
          'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=800&q=80',
      ingredients: const [
        'Romaine lettuce',
        'Parmesan',
        'Croutons',
        'Caesar dressing',
      ],
      steps: const [
        'Wash and chop lettuce.',
        'Toss with dressing.',
        'Top with cheese and croutons.',
      ],
      prepMinutes: 15,
      servings: 2,
      updatedAt: now,
    ),
    RecipeEntity(
      id: 'sample_grilled_salmon',
      typeId: 'dinner',
      title: 'Grilled Salmon',
      imagePath:
          'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=800&q=80',
      ingredients: const [
        '2 salmon fillets',
        'Lemon',
        'Olive oil',
        'Salt and pepper',
      ],
      steps: const [
        'Season fillets.',
        'Grill skin-side down.',
        'Finish with lemon.',
      ],
      prepMinutes: 25,
      servings: 2,
      updatedAt: now,
    ),
    RecipeEntity(
      id: 'sample_chocolate_cake',
      typeId: 'dessert',
      title: 'Chocolate Cake',
      imagePath:
          'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=800&q=80',
      ingredients: const [
        'Flour',
        'Cocoa',
        'Sugar',
        'Eggs',
        'Butter',
      ],
      steps: const [
        'Mix batter.',
        'Bake at 175°C.',
        'Cool before frosting.',
      ],
      prepMinutes: 50,
      servings: 8,
      updatedAt: now,
    ),
    RecipeEntity(
      id: 'sample_tomato_soup',
      typeId: 'soup',
      title: 'Tomato Basil Soup',
      imagePath:
          'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=800&q=80',
      ingredients: const [
        'Tomatoes',
        'Onion',
        'Garlic',
        'Basil',
        'Stock',
      ],
      steps: const [
        'Sauté aromatics.',
        'Simmer tomatoes.',
        'Blend until smooth.',
      ],
      prepMinutes: 35,
      servings: 4,
      updatedAt: now,
    ),
    RecipeEntity(
      id: 'sample_club_sandwich',
      typeId: 'lunch',
      title: 'Club Sandwich',
      imagePath:
          'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=800&q=80',
      ingredients: const [
        'Bread',
        'Turkey',
        'Bacon',
        'Lettuce',
        'Tomato',
      ],
      steps: const [
        'Toast bread.',
        'Layer ingredients.',
        'Cut and serve.',
      ],
      prepMinutes: 15,
      servings: 2,
      updatedAt: now,
    ),
  ];
}
