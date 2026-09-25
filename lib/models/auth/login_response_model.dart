class LoginResponseModel {
  final bool success;
  final String message;
  final LoginDataModel data;

  LoginResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LoginResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return LoginResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: LoginDataModel.fromJson(
        json['data'] ?? {},
      ),
    );
  }
}

class LoginDataModel {
  final LoginUserModel user;
  final String accessToken;

  LoginDataModel({
    required this.user,
    required this.accessToken,
  });

  factory LoginDataModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return LoginDataModel(
      user: LoginUserModel.fromJson(
        json['user'] ?? {},
      ),
      accessToken:
      json['access_token']?.toString() ?? '',
    );
  }
}

class LoginUserModel {
  final int id;
  final String fullName;
  final String email;
  final String phoneNumber;


  LoginUserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,

  });

  factory LoginUserModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return LoginUserModel(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber:
      json['phone_number']?.toString() ?? '',
    );
  }
}