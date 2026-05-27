class InterpretationDataSource {
  Map<String, dynamic> interpretHieroglyphs(List<String> detectedSymbols) {
    final Set<String> symbols = detectedSymbols.toSet();

    final Map<String, Map<String, dynamic>> rules = {
      "Royal Titles": {
        "symbols": {"King", "Cobra", "Ring", "Ruler", "Falcon"},
        "translation":
            "هذا النقش يوضح ألقاب الملك ومكانته المقدسة وسلطته على مصر.",
      },

      "Offering Scene": {
        "symbols": {"Bread", "Loaf", "Duck", "Water", "Man", "Woman"},
        "translation":
            "هذا النقش يوضح تقديم القرابين والطقوس الدينية داخل المعبد.",
      },

      "Afterlife": {
        "symbols": {"Corpse", "To_Be_Dead", "Bandage", "Life_Spirit", "Ankh"},
        "translation":
            "هذا النقش مرتبط بالحياة بعد الموت والبعث في العقيدة المصرية القديمة.",
      },

      "Protection Symbols": {
        "symbols": {"Eye", "Cobra", "Snake", "Viper", "To_Protect"},
        "translation": "هذا النقش يرمز إلى الحماية الإلهية ودفع الشرور.",
      },

      "Religious Rituals": {
        "symbols": {"Papyrus_Scroll", "Water", "Falcon", "Ankh"},
        "translation":
            "هذا النقش يوضح طقوسًا دينية مرتبطة بالعبادة داخل المعبد.",
      },
    };

    Map<String, dynamic>? bestMatch;
    int maxMatches = 0;

    for (final entry in rules.entries) {
      final category = entry.key;
      final data = entry.value;

      final Set<String> ruleSymbols = Set<String>.from(data["symbols"] as Set);

      final matched = symbols.intersection(ruleSymbols);

      if (matched.length > maxMatches) {
        maxMatches = matched.length;

        bestMatch = {
          "category": category,
          "matchedSymbols": matched.toList(),
          "translation": data["translation"],
        };
      }
    }

    if (bestMatch != null) {
      return {
        "Detected Category": bestMatch["category"],
        "Matched Symbols": bestMatch["matchedSymbols"],
        "Tourist Translation": bestMatch["translation"],
      };
    }

    return {
      "Detected Category": "Unknown",
      "Matched Symbols": [],
      "Tourist Translation": "لم يتمكن النظام من تحديد معنى واضح لهذا النقش.",
    };
  }
}
