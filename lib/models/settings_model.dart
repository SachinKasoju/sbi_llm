
class AppConfigResponse {
  final String status;
  final AppConfigData? data;

  AppConfigResponse({
    required this.status,
    this.data,
  });

  factory AppConfigResponse.fromJson(Map<String, dynamic> json) {
    return AppConfigResponse(
      status: json['status'] ?? '',
      data: json['data'] != null
          ? AppConfigData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'data': data?.toJson(),
  };
}

class AppConfigData {
  final String appName;
  final String logo;
  final String timezone;
  final String primaryColor;
  final String secondaryColor;

  AppConfigData({
    required this.appName,
    required this.logo,
    required this.timezone,
    required this.primaryColor,
    required this.secondaryColor,
  });

  factory AppConfigData.fromJson(Map<String, dynamic> json) {
    return AppConfigData(
      appName: json['app_name'] ?? '',
      logo: json['logo'] ?? '',
      timezone: json['timezone'] ?? '',
      primaryColor: json['primary_color'] ?? '',
      secondaryColor: json['secondary_color'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'app_name': appName,
    'logo': logo,
    'timezone': timezone,
    'primary_color': primaryColor,
    'secondary_color': secondaryColor,
  };
}
