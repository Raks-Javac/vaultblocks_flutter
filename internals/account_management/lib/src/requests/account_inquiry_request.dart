class AccountInquiryRequest {
  const AccountInquiryRequest({
    required this.accountNumber,
    required this.bankCode,
  });

  final String accountNumber;
  final String bankCode;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'accountNumber': accountNumber,
      'bankCode': bankCode,
    };
  }
}

