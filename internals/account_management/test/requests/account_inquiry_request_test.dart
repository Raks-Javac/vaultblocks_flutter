import 'package:account_management/account_management.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AccountInquiryRequest JSON mapping', () {
    const AccountInquiryRequest request = AccountInquiryRequest(
      accountNumber: '0123456789',
      bankCode: '001',
    );

    expect(request.toJson(), <String, dynamic>{
      'accountNumber': '0123456789',
      'bankCode': '001',
    });
  });
}

