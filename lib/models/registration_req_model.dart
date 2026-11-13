class RegistrationModel {
  String? status;
  String? message;
  Data? data;

  RegistrationModel({this.status, this.message, this.data});

  RegistrationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    
    // Handle message being either a String or a Map of errors
    if (json['message'] is Map) {
      final msgMap = json['message'] as Map;
      message = msgMap.values
          .map((e) => e is List ? e.join(', ') : e.toString())
          .join('\n');
    } else {
      message = json['message']?.toString();
    }

    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  User? user;
  bool? otpSent;
  String? phone;
  int? kycStatus;
  int? subscriptionStatus;

  Data(
      {this.user,
        this.otpSent,
        this.phone,
        this.kycStatus,
        this.subscriptionStatus});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    otpSent = json['otp_sent'];
    phone = json['phone'];
    kycStatus = json['kyc_status'];
    subscriptionStatus = json['subscription_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['otp_sent'] = this.otpSent;
    data['phone'] = this.phone;
    data['kyc_status'] = this.kycStatus;
    data['subscription_status'] = this.subscriptionStatus;
    return data;
  }
}

class User {
  String? name;
  String? email;
  String? countryCode;
  String? phoneNumber;
  String? type;
  String? lang;
  int? parentId;
  String? updatedAt;
  String? createdAt;
  int? id;
  String? apiToken;
  List<Roles>? roles;

  User(
      {this.name,
        this.email,
        this.countryCode,
        this.phoneNumber,
        this.type,
        this.lang,
        this.parentId,
        this.updatedAt,
        this.createdAt,
        this.id,
        this.apiToken,
        this.roles});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    countryCode = json['country_code'];
    phoneNumber = json['phone_number'];
    type = json['type'];
    lang = json['lang'];
    parentId = json['parent_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    apiToken = json['api_token'];
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(new Roles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['country_code'] = this.countryCode;
    data['phone_number'] = this.phoneNumber;
    data['type'] = this.type;
    data['lang'] = this.lang;
    data['parent_id'] = this.parentId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['api_token'] = this.apiToken;
    if (this.roles != null) {
      data['roles'] = this.roles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Roles {
  int? id;
  String? name;
  String? guardName;
  int? parentId;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  Roles(
      {this.id,
        this.name,
        this.guardName,
        this.parentId,
        this.createdAt,
        this.updatedAt,
        this.pivot});

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    guardName = json['guard_name'];
    parentId = json['parent_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['guard_name'] = this.guardName;
    data['parent_id'] = this.parentId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }
}

class Pivot {
  int? modelId;
  int? roleId;
  String? modelType;

  Pivot({this.modelId, this.roleId, this.modelType});

  Pivot.fromJson(Map<String, dynamic> json) {
    modelId = json['model_id'];
    roleId = json['role_id'];
    modelType = json['model_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['model_id'] = this.modelId;
    data['role_id'] = this.roleId;
    data['model_type'] = this.modelType;
    return data;
  }
}





class RegisterRequest {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "password": password,
      "password_confirmation": passwordConfirmation,
    };
  }
}
