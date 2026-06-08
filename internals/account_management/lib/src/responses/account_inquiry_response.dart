class AccountInquiryResponse {
  const AccountInquiryResponse({
    required this.accountNumber,
    required this.accountName,
    required this.bankCode,
    required this.bankName,
    required this.isValid,
  });

  factory AccountInquiryResponse.fromJson(Map<String, dynamic> json) {
    return AccountInquiryResponse(
      accountNumber: '${json['accountNumber'] ?? ''}',
      accountName: '${json['accountName'] ?? ''}',
      bankCode: '${json['bankCode'] ?? ''}',
      bankName: '${json['bankName'] ?? ''}',
      isValid: json['isValid'] == true,
    );
  }

  final String accountNumber;
  final String accountName;
  final String bankCode;
  final String bankName;
  final bool isValid;
}

