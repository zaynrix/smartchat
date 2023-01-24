class Language {
  final int id;

  final String flag;
  final String name;
  final String languageCode;
  bool isSelected;

  Language(this.id, this.flag, this.name, this.languageCode,
      {this.isSelected = false});

  static List<Language> languageList = [
    Language(0, "flag", "Arabic", "ar"),
    Language(1, "flag", "English", "en"),
  ];
}
