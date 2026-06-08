class UserAccount {
  const UserAccount({
    required this.accountNumber,
    required this.accountName,
    required this.accountType,
    required this.currency,
    required this.isPrimary,
    required this.isActive,
    this.productCode,
    this.branchCode,
    this.availableBalance,
    this.ledgerBalance,
  });

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    return UserAccount(
      accountNumber: '${json['accountNumber'] ?? ''}',
      accountName: '${json['accountName'] ?? ''}',
      accountType: '${json['accountType'] ?? ''}',
      currency: '${json['currency'] ?? ''}',
      isPrimary: json['isPrimary'] == true,
      isActive: json['isActive'] != false,
      productCode: json['productCode'] as String?,
      branchCode: json['branchCode'] as String?,
      availableBalance: _readNum(json['availableBalance']),
      ledgerBalance: _readNum(json['ledgerBalance']),
    );
  }

  final String accountNumber;
  final String accountName;
  final String accountType;
  final String currency;
  final bool isPrimary;
  final bool isActive;
  final String? productCode;
  final String? branchCode;
  final num? availableBalance;
  final num? ledgerBalance;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'accountNumber': accountNumber,
      'accountName': accountName,
      'accountType': accountType,
      'currency': currency,
      'isPrimary': isPrimary,
      'isActive': isActive,
      'productCode': productCode,
      'branchCode': branchCode,
      'availableBalance': availableBalance,
      'ledgerBalance': ledgerBalance,
    };
  }

  static num? _readNum(dynamic value) {
    if (value is num) {
      return value;
    }
    if (value is String) {
      return num.tryParse(value);
    }
    return null;
  }
}

