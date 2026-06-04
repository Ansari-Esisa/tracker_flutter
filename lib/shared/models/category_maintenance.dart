class CategoryMaintenance {
  final String? id;
  final String name;
  final String? icon;

  CategoryMaintenance({
    this.id,
    required this.name,
    this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'icon': icon,
    };
  }

  factory CategoryMaintenance.fromMap(Map<String, dynamic> map) {
    return CategoryMaintenance(
      id: map['id'],
      name: map['name'],
      icon: map['icon'],
    );
  }
}
