class LocalitySuggestion {
  String name;
  String? descriptiveText;

  LocalitySuggestion(this.name, this.descriptiveText);

  static LocalitySuggestion fromDynamic(dynamic data) {
    final structuredFormatting = data["structured_formatting"];
    return LocalitySuggestion(
      structuredFormatting["main_text"],
      structuredFormatting["secondary_text"],
    );
  }
}
