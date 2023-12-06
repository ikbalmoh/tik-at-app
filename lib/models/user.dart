class User {
  final int id;
  final String name;
  final String username;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
  });

  User.fromJson(Map<dynamic, dynamic> json)
      : id = int.tryParse(json['id']?.toString() ?? '') ?? 0,
        name = json['name']?.toString() ?? '',
        username = json['username']?.toString() ?? '',
        email = json['email']?.toString() ?? '';

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'username': username, 'email': email};

  @override
  String toString() {
    return '{"id": $id, "name": $name, "username": $username, "email": $email}';
  }
}
