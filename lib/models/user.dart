class User {
  int? id; // Make id nullable to handle potential null values
  String name;
  String email;
  String password;
  int createdAt;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'createdAt': createdAt,
    };
  }
}