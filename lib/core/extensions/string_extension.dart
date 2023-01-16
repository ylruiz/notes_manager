extension NullableStringExtension on String? {
  bool isNullOrWhitespace() => this == null || this!.trim().isEmpty;
}
