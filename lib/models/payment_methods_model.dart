class PaymentGatewayResponse {
  final String status;
  final PaymentGatewayData data;

  PaymentGatewayResponse({
    required this.status,
    required this.data,
  });

  factory PaymentGatewayResponse.fromJson(Map<String, dynamic> json) {
    return PaymentGatewayResponse(
      status: json['status'] ?? '',
      data: PaymentGatewayData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
    };
  }
}

class PaymentGatewayData {
  final Razorpay razorpay;

  PaymentGatewayData({
    required this.razorpay,
  });

  factory PaymentGatewayData.fromJson(Map<String, dynamic> json) {
    return PaymentGatewayData(
      razorpay: Razorpay.fromJson(json['razorpay'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'razorpay': razorpay.toJson(),
    };
  }
}

class Razorpay {
  final String name;
  final String logo;
  final bool status;

  Razorpay({
    required this.name,
    required this.logo,
    required this.status,
  });

  factory Razorpay.fromJson(Map<String, dynamic> json) {
    return Razorpay(
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
      status: json['status'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'logo': logo,
      'status': status,
    };
  }
}

class RazorpayInitiateResponse {
  final String status;
  final String? url;
  final String? message;

  RazorpayInitiateResponse({
    required this.status,
    this.url,
    this.message,
  });

  factory RazorpayInitiateResponse.fromJson(Map<String, dynamic> json) {
    return RazorpayInitiateResponse(
      status: json['status']?.toString() ?? '',
      url: json['url'] as String?,
      message: json['message'] as String?,
    );
  }
}
