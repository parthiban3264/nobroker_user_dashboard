class UserModel {
  final String? id;
  final String? name;
  final String? phone;
  final String? email;
  final String? password;
  final bool? status;

  UserModel({
    this.name,
    this.phone,
    this.email,
    this.password,
    this.id,
    this.status,
  });

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      id: data['id']?.toString(),
      name: data['name'],
      phone: data['phone'],
      email: data['email'],
      password: data['password'],
      status: data['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "phone": phone,
      "email": email,
      "password": password,
      "status": status,
    };
  }
}

class TokenResponse {
  final String accessToken;
  final Map<String, dynamic> user;

  TokenResponse({required this.accessToken, required this.user});

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      accessToken: json["accessToken"],
      user: json["user"] ?? '',
    );
  }
}
