/// How [RecipeListViewModel] orders [RecipeEntity] rows after search/type filter.
enum RecipeListSort {
  /// Title A → Z (case-insensitive).
  titleAscending,

  /// Title Z → A.
  titleDescending,

  /// Shortest prep time first.
  prepTimeAscending,

  /// Longest prep time first.
  prepTimeDescending,
}
