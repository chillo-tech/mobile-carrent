class SearchEntity {
  String title;
  List<Section> sections;

  SearchEntity({
    required this.title,
    required this.sections,
  });

  factory SearchEntity.fromJson(Map<String, dynamic> json) {
    return SearchEntity(
      title: json['title'],
      sections: (json['sections'] as List)
          .map((sectionJson) => Section.fromJson(sectionJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'sections': sections.map((section) => section.toJson()).toList(),
    };
  }
}


class Section {
  String icon;
  String title;
  String? description;

  Section({
    required this.icon,
    required this.title,
    this.description,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      icon: json['icon'],
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'icon': icon,
      'title': title,
      'description': description,
    };
  }
}
