import 'package:account_management/account_management.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('UserAccount JSON mapping', () {
    const UserAccount account = UserAccount(
      accountNumber: '0123456789',
      accountName: 'Amina Bello',
      accountType: 'Savings',
      currency: 'NGN',
      isPrimary: true,
      isActive: true,
      productCode: 'SAV-001',
      branchCode: '001',
      availableBalance: 1000,
      ledgerBalance: 1200,
    );

    expect(account.toJson(), <String, dynamic>{
      'accountNumber': '0123456789',
      'accountName': 'Amina Bello',
      'accountType': 'Savings',
      'currency': 'NGN',
      'isPrimary': true,
      'isActive': true,
      'productCode': 'SAV-001',
      'branchCode': '001',
      'availableBalance': 1000,
      'ledgerBalance': 1200,
    });

    final UserAccount parsed = UserAccount.fromJson(account.toJson());
    expect(parsed.accountNumber, account.accountNumber);
    expect(parsed.accountName, account.accountName);
    expect(parsed.isPrimary, isTrue);
  });
}

