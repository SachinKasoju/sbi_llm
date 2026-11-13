class OrdersResponse {
  final String status;
  final List<OrderModel> data;
  final Pagination pagination;

  OrdersResponse({
    required this.status,
    required this.data,
    required this.pagination,
  });

  factory OrdersResponse.fromJson(Map<String, dynamic> json) {
    return OrdersResponse(
      status: json['status'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class OrderModel {
  final String invoiceId;
  final String paymentMethod;
  final String paidAmount;
  final String paymentStatus;
  final String status;

  OrderModel({
    required this.invoiceId,
    required this.paymentMethod,
    required this.paidAmount,
    required this.paymentStatus,
    required this.status,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      invoiceId: json['invoice_id'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      paidAmount: json['paid_amount'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invoice_id': invoiceId,
      'payment_method': paymentMethod,
      'paid_amount': paidAmount,
      'payment_status': paymentStatus,
      'status': status,
    };
  }
}

class Pagination {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final PaginationLinks links;

  Pagination({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.links,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'] ?? 1,
      perPage: json['per_page'] ?? 0,
      total: json['total'] ?? 0,
      lastPage: json['last_page'] ?? 1,
      links: PaginationLinks.fromJson(json['links'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'per_page': perPage,
      'total': total,
      'last_page': lastPage,
      'links': links.toJson(),
    };
  }
}

class PaginationLinks {
  final String first;
  final String? prev;
  final String? next;
  final String last;

  PaginationLinks({
    required this.first,
    this.prev,
    this.next,
    required this.last,
  });

  factory PaginationLinks.fromJson(Map<String, dynamic> json) {
    return PaginationLinks(
      first: json['first'] ?? '',
      prev: json['prev'],
      next: json['next'],
      last: json['last'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first': first,
      'prev': prev,
      'next': next,
      'last': last,
    };
  }
}



class InvoiceResponse {
  final String status;
  final InvoiceData? data;

  InvoiceResponse({
    required this.status,
    this.data,
  });

  factory InvoiceResponse.fromJson(Map<String, dynamic> json) {
    return InvoiceResponse(
      status: json['status'] ?? '',
      data: json['data'] != null
          ? InvoiceData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'data': data?.toJson(),
  };
}

class InvoiceData {
  final String invoiceId;
  final String paymentMethod;
  final String paidAmount;
  final String paymentStatus;
  final String status;
  final String createdAt;
  final BilledTo? billedTo;
  final List<OrderItem> orderItems;
  final InvoiceSummary? summary;

  InvoiceData({
    required this.invoiceId,
    required this.paymentMethod,
    required this.paidAmount,
    required this.paymentStatus,
    required this.status,
    required this.createdAt,
    this.billedTo,
    required this.orderItems,
    this.summary,
  });

  factory InvoiceData.fromJson(Map<String, dynamic> json) {
    return InvoiceData(
      invoiceId: json['invoice_id'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      paidAmount: json['paid_amount'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      billedTo: json['billed_to'] != null
          ? BilledTo.fromJson(json['billed_to'])
          : null,
      orderItems: (json['order_items'] as List? ?? [])
          .map((e) => OrderItem.fromJson(e))
          .toList(),
      summary: json['summary'] != null
          ? InvoiceSummary.fromJson(json['summary'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'invoice_id': invoiceId,
    'payment_method': paymentMethod,
    'paid_amount': paidAmount,
    'payment_status': paymentStatus,
    'status': status,
    'created_at': createdAt,
    'billed_to': billedTo?.toJson(),
    'order_items': orderItems.map((e) => e.toJson()).toList(),
    'summary': summary?.toJson(),
  };
}

class BilledTo {
  final String name;
  final String email;
  final String address;
  final String phone;

  BilledTo({
    required this.name,
    required this.email,
    required this.address,
    required this.phone,
  });

  factory BilledTo.fromJson(Map<String, dynamic> json) {
    return BilledTo(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'address': address,
    'phone': phone,
  };
}

class OrderItem {
  final String price;
  final String courseTitle;
  final String instructor;

  OrderItem({
    required this.price,
    required this.courseTitle,
    required this.instructor,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      price: json['price'] ?? '',
      courseTitle: json['course_title'] ?? '',
      instructor: json['instructor'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'price': price,
    'course_title': courseTitle,
    'instructor': instructor,
  };
}

class InvoiceSummary {
  final String subTotal;
  final String discount;
  final String gatewayCharge;
  final String total;

  InvoiceSummary({
    required this.subTotal,
    required this.discount,
    required this.gatewayCharge,
    required this.total,
  });

  factory InvoiceSummary.fromJson(Map<String, dynamic> json) {
    return InvoiceSummary(
      subTotal: json['sub_total'] ?? '',
      discount: json['discount'] ?? '',
      gatewayCharge: json['gateway_charge'] ?? '',
      total: json['total'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'sub_total': subTotal,
    'discount': discount,
    'gateway_charge': gatewayCharge,
    'total': total,
  };
}
