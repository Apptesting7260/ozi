class WalletDetailModel {
  bool? status;
  WalletData? data;

  WalletDetailModel({this.status, this.data});

  WalletDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new WalletData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['available_balance'] = this.availableBalance;
    data['pending_balance'] = this.pendingBalance;
    data['week_earning'] = this.weekEarning;
    data['today_earning'] = this.todayEarning;
    data['status'] = this.status;
    if (this.recentTransactions != null) {
      data['recent_transactions'] =
          this.recentTransactions!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['wallet_id'] = this.walletId;
    data['booking_id'] = this.bookingId;
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