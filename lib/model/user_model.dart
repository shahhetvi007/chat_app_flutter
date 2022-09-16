class User {
  String id;
  String email;
  String username;

  User({required this.id, required this.email, required this.username});

  Map<String, dynamic> toMap(User user) {
    Map<String, dynamic> userMap = Map();
    userMap["id"] = user.id;
    userMap["email"] = user.email;
    userMap["username"] = user.username;
    return userMap;
  }

  factory User.fromJson(Map userMap) {
    return User(
        id: userMap["id"],
        email: userMap["email"],
        username: userMap["username"]);
  }
}
