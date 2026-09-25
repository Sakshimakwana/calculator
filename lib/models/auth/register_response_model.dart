class RegisterResponseModel {
  final bool success;
  final String message;
  final RegisterUserModel data;

  RegisterResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory RegisterResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return RegisterResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: RegisterUserModel.fromJson(
        json['data'] ?? {},
      ),
    );
  }
}

class RegisterUserModel {
  final int id;
  final String fullName;
  final String email;
  final String phoneNumber;


  RegisterUserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,

  });

  factory RegisterUserModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return RegisterUserModel(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',

    );
  }
}