import '../../domain/entities/discover_meal_entity.dart';
import '../../domain/repositories/discover_recipe_repository.dart';
import '../datasources/remote/the_meal_db_remote_data_source.dart';
import '../mappers/the_meal_db_meal_mapper.dart';

class DiscoverRecipeRepositoryImpl implements DiscoverRecipeRepository {
  DiscoverRecipeRepositoryImpl({
    required TheMealDbRemoteDataSource remote,
    TheMealDbMealMapper mapper = const TheMealDbMealMapper(),
  })  : _remote = remote,
        _mapper = mapper;

  final TheMealDbRemoteDataSource _remote;
  final TheMealDbMealMapper _mapper;

  @override
  Future<DiscoverMealEntity?> fetchRandomMeal() async {
    final dto = await _remote.fetchRandomMeal();
    return _mapper.toDiscoverMeal(dto);
  }
}
