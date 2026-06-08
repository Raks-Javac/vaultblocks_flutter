import 'package:account_management/account_management.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepository implements AccountRepository {
  _FakeRepository({
    required this.accounts,
    required this.response,
    this.throwOnInquiry = false,
  });

  final List<UserAccount> accounts;
  final AccountInquiryResponse response;
  final bool throwOnInquiry;

  @override
  Future<List<UserAccount>> getAccounts() async => accounts;

  @override
  Future<AccountInquiryResponse> inquireAccount(
    AccountInquiryRequest request,
  ) async {
    if (throwOnInquiry) {
      throw const AccountFailure(
        code: 'invalid_account_number',
        message: 'Invalid inquiry input.',
      );
    }
    return response;
  }
}

class _SilentObservabilityService implements ObservabilityService {
  const _SilentObservabilityService();

  @override
  void recordError(
    Object error,
    StackTrace stackTrace, {
    Map<String, Object?> tags = const <String, Object?>{},
  }) {}

  @override
  void recordEvent(
    String name, {
    Map<String, Object?> tags = const <String, Object?>{},
  }) {}
}

void main() {
  test('getAccounts updates live account state', () async {
    final AccountStateStore store = AccountStateStore();
    final AccountManagementService service = AccountManagementServiceImpl(
      repository: _FakeRepository(
        accounts: const <UserAccount>[
          UserAccount(
            accountNumber: '0123456789',
            accountName: 'Amina Bello',
            accountType: 'Savings',
            currency: 'NGN',
            isPrimary: true,
            isActive: true,
          ),
        ],
        response: const AccountInquiryResponse(
          accountNumber: '0123456789',
          accountName: 'Amina Bello',
          bankCode: '001',
          bankName: 'Demo First Bank',
          isValid: true,
        ),
      ),
      accountStateStore: store,
      observabilityService: const _SilentObservabilityService(),
    );

    final List<UserAccount> accounts = await service.getAccounts();

    expect(accounts, hasLength(1));
    expect(store.accounts.value, hasLength(1));
    expect(store.accounts.value.first.accountName, 'Amina Bello');
  });

  test('inquireAccount returns valid account details for valid input', () async {
    final AccountManagementService service = AccountManagementServiceImpl(
      repository: _FakeRepository(
        accounts: const <UserAccount>[],
        response: const AccountInquiryResponse(
          accountNumber: '0123456789',
          accountName: 'Amina Bello',
          bankCode: '001',
          bankName: 'Demo First Bank',
          isValid: true,
        ),
      ),
      accountStateStore: AccountStateStore(),
      observabilityService: const _SilentObservabilityService(),
    );

    final AccountInquiryResponse response = await service.inquireAccount(
      request: const AccountInquiryRequest(
        accountNumber: '0123456789',
        bankCode: '001',
      ),
    );

    expect(response.accountName, 'Amina Bello');
    expect(response.bankName, 'Demo First Bank');
  });

  test('invalid inquiry returns a controlled account failure', () async {
    final AccountManagementService service = AccountManagementServiceImpl(
      repository: _FakeRepository(
        accounts: const <UserAccount>[],
        response: const AccountInquiryResponse(
          accountNumber: '0123456789',
          accountName: 'Amina Bello',
          bankCode: '001',
          bankName: 'Demo First Bank',
          isValid: true,
        ),
        throwOnInquiry: true,
      ),
      accountStateStore: AccountStateStore(),
      observabilityService: const _SilentObservabilityService(),
    );

    expect(
      () => service.inquireAccount(
        request: const AccountInquiryRequest(
          accountNumber: 'invalid',
          bankCode: '001',
        ),
      ),
      throwsA(isA<AccountFailure>()),
    );
  });
}

