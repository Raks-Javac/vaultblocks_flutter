import 'package:account_management/account_management.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AccountInquiryResponse JSON mapping', () {
    final AccountInquiryResponse response = AccountInquiryResponse.fromJson(
      <String, dynamic>{
        'accountNumber': '0123456789',
        'accountName': 'Amina Bello',
        'bankCode': '001',
        'bankName': 'Demo First Bank',
        'isValid': true,
      },
    );

    expect(response.accountNumber, '0123456789');
    expect(response.accountName, 'Amina Bello');
    expect(response.bankName, 'Demo First Bank');
    expect(response.isValid, isTrue);
  });
}

