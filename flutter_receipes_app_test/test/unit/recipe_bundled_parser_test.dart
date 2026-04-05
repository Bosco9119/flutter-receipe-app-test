import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_receipes_app_test/data/sample/recipe_bundled_parser.dart';

void main() {
  test('parseBundledRecipesJson maps bundled fields to entities', () {
    const raw = '''
{
  "recipes": [
    {
      "id": "x1",
      "name": "Test",
      "type": "lunch",
      "description": "Desc",
      "ingredients": ["a"],
      "steps": ["b"],
      "image": "assets/data/images/recipes/friedChicken.png",
      "isHalal": true,
      "isVegetarian": true,
      "isVegan": false,
      "prep_time_minutes": 12
    }
  ]
}
''';
    final list = parseBundledRecipesJson(raw);
    expect(list, hasLength(1));
    final r = list.single;
    expect(r.id, 'x1');
    expect(r.title, 'Test');
    expect(r.typeId, 'lunch');
    expect(r.description, 'Desc');
    expect(r.prepMinutes, 12);
    expect(r.imagePath, 'assets/data/images/recipes/friedChicken.png');
    expect(r.isVegetarian, isTrue);
    expect(r.isVegan, isFalse);
  });
}
