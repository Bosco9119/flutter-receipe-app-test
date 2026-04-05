/// Extracts the first integer from user text (e.g. "30" or "30 minutes").
int? parsePrepMinutesFromText(String input) {
  final trimmed = input.trim();
  if (trimmed.isEmpty) {
    return null;
  }
  final match = RegExp(r'\d+').firstMatch(trimmed);
  if (match == null) {
    return null;
  }
  return int.tryParse(match.group(0)!);
}
