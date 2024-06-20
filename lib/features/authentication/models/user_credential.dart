class UserCredential {

  final String email;
  final String username;
  final String rol;
  String jwt;

  UserCredential({
    required this.email,
    required this.username,
    required this.rol,
    required this.jwt
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "username": username,
      "rol": rol,
      "jwt": jwt
    };
  }

  factory UserCredential.fromJson(Map<String, dynamic> json) {
    return UserCredential(
        email: json['email'],
        username: json['username'],
        rol: json['rol'],
        jwt: json['jwt']
    );
  }
}