import 'package:http/http.dart' as http;

import '../../../core/constants/the_meal_db_api.dart';
import '../../models/the_meal_db_meal_dto.dart';
import 'the_meal_db_remote_data_source.dart';

class TheMealDbRemoteDataSourceImpl implements TheMealDbRemoteDataSource {
  TheMealDbRemoteDataSourceImpl({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  @override
  Future<TheMealDbMealDto?> fetchRandomMeal() async {
    final uri = Uri.parse(TheMealDbApi.randomMealUrl);
    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw StateError('TheMealDB HTTP ${response.statusCode}');
    }
    return TheMealDbMealDto.fromApiJson(response.body);
  }
}
