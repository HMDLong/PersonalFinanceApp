class TransactCategory {
  String id;
  String name;
  /// Type of categories. [false] for "Expense", [true] for "Income"
  bool type;
  int icon;
  String iconFont;

  List<TransactCategory> subCategories = [];

  TransactCategory({
    required this.id,
    required this.type,
    required this.name,
    required this.icon,
    this.iconFont = "MaterialIcons",
    this.subCategories = const [],
  });

  @override
  bool operator ==(Object other) {
    return (other is TransactCategory) && other.name == name;
  }

  TransactCategory.fromJson(Map<String, dynamic> jsonData) : 
    name = jsonData['name'] as String, 
    id = jsonData['id'] as String,
    type = jsonData['type'] as bool,
    icon = jsonData['icon'] as int, 
    iconFont = (jsonData['icon_font'] ?? "MaterialIcons") as String,
    subCategories = ((jsonData['children'] ?? []) as List<dynamic>).map(
      (e) => TransactCategory.fromJson(e as Map<String, dynamic>)
    ).toList();

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = id;
    json['name'] = name;
    json['icon'] = icon;
    json['icon_font'] = iconFont;
    if(subCategories.isNotEmpty) {
      json['children'] = subCategories.map((e) => e.toJson()).toList();
    }
    return json;
  }
}
