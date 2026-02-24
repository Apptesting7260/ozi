class WalletDetailModel {
  bool? status;
  WalletData? data;

  WalletDetailModel({this.status, this.data});

  WalletDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? WalletData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class WalletData {
  String? availableBalance;
  String? pendingBalance;
  String? weekEarning;
  String? todayEarning;
  String? status;
  List<RecentTransactions>? recentTransactions;

  WalletData(
      {this.availableBalance,
        this.pendingBalance,
        this.weekEarning,
        this.todayEarning,
        this.status,
        this.recentTransactions});

  WalletData.fromJson(Map<String, dynamic> json) {
    availableBalance = json['available_balance']?.toString();
    pendingBalance = json['pending_balance']?.toString();
    weekEarning = json['week_earning']?.toString();
    todayEarning = json['today_earning']?.toString();
    status = json['status']?.toString();

    if (json['recent_transactions'] != null) {
      recentTransactions = <RecentTransactions>[];
      json['recent_transactions'].forEach((v) {
        recentTransactions!.add(RecentTransactions.fromJson(v));
      });
    }
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['available_balance'] = availableBalance;
    data['pending_balance'] = pendingBalance;
    data['week_earning'] = weekEarning;
    data['today_earning'] = todayEarning;
    data['status'] = status;
    if (recentTransactions != null) {
      data['recent_transactions'] =
          recentTransactions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RecentTransactions {
  int? id;
  int? walletId;
  int? bookingId;
  String? amount;
  String? type;
  String? balanceType;
  String? source;
  String? paymentMethod;
  String? referenceId;
  String? description;
  String? createdAt;

  RecentTransactions(
      {this.id,
        this.walletId,
        this.bookingId,
        this.amount,
        this.type,
        this.balanceType,
        this.source,
        this.paymentMethod,
        this.referenceId,
        this.description,
        this.createdAt});

  RecentTransactions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    walletId = json['wallet_id'];
    bookingId = json['booking_id'];
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['wallet_id'] = walletId;
    data['booking_id'] = bookingId;
    data['amount'] = amount;
    data['type'] = type;
    data['balance_type'] = balanceType;
    data['source'] = source;
    data['payment_method'] = paymentMethod;
    data['reference_id'] = referenceId;
    data['description'] = description;
    data['created_at'] = createdAt;
    return data;
  }
}