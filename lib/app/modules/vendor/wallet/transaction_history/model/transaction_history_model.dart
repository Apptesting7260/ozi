class TransactionHistoryModel {
  bool? status;
  List<TransactionHistoryData>? data;
  TransactionHistoryPagination? pagination;

  TransactionHistoryModel({this.status, this.data, this.pagination});

  TransactionHistoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <TransactionHistoryData>[];
      json['data'].forEach((v) {
        data!.add(new TransactionHistoryData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new TransactionHistoryPagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class TransactionHistoryData {
  String? id;
  String? userName;
  String? walletId;
  String? bookingId;
  String? bookingCode;
  String? amount;
  String? type;
  String? balanceType;
  String? source;
  String? paymentMethod;
  String? referenceId;
  String? description;
  String? createdAt;

  TransactionHistoryData(
      {this.id,
        this.userName,
        this.walletId,
        this.bookingId,
        this.bookingCode,
        this.amount,
        this.type,
        this.balanceType,
        this.source,
        this.paymentMethod,
        this.referenceId,
        this.description,
        this.createdAt});

  TransactionHistoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    userName = json['user_name'];
    walletId = json['wallet_id'].toString();
    bookingId = json['booking_id'].toString();
    bookingCode = json['booking_code'];
    amount = json['amount'];
    type = json['type'];
    balanceType = json['balance_type'];
    source = json['source'];
    paymentMethod = json['payment_method'];
    referenceId = json['reference_id'];
    description = json['description'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_name'] = this.userName;
    data['wallet_id'] = this.walletId;
    data['booking_id'] = this.bookingId;
    data['booking_code'] = this.bookingCode;
    data['amount'] = this.amount;
    data['type'] = this.type;
    data['balance_type'] = this.balanceType;
    data['source'] = this.source;
    data['payment_method'] = this.paymentMethod;
    data['reference_id'] = this.referenceId;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class TransactionHistoryPagination {
  int? currentPage;
  int? perPage;
  int? total;
  int? lastPage;
  bool? hasMore;

  TransactionHistoryPagination(
      {this.currentPage,
        this.perPage,
        this.total,
        this.lastPage,
        this.hasMore});

  TransactionHistoryPagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    perPage = json['per_page'];
    total = json['total'];
    lastPage = json['last_page'];
    hasMore = json['has_more'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['per_page'] = this.perPage;
    data['total'] = this.total;
    data['last_page'] = this.lastPage;
    data['has_more'] = this.hasMore;
    return data;
  }
}