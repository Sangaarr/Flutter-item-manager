class Item {
  final int? id;
  final String name;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  Item({
    this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  // Converts a Dart object into a Map (used for storing data in SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Converts a Map (SQLite) into a Dart Object
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  // Creates a copy of the current item with updated fields
  //Useful for updating specific values without modifying the original object
  Item copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
