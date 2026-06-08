import 'package:account_management/account_management.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRemoteDataSource implements AccountRemoteDataSource {
  _FakeRemoteDataSource({
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
  test('repository returns fake accounts', () async {
    final AccountRepository repository = AccountRepositoryImpl(
      remoteDataSource: _FakeRemoteDataSource(
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
      observabilityService: const _SilentObservabilityService(),
    );

    final List<UserAccount> accounts = await repository.getAccounts();
    expect(accounts, hasLength(1));
    expect(accounts.first.accountName, 'Amina Bello');
  });

  test('repository returns controlled failure on invalid inquiry', () async {
    final AccountRepository repository = AccountRepositoryImpl(
      remoteDataSource: _FakeRemoteDataSource(
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
      observabilityService: const _SilentObservabilityService(),
    );

    expect(
      () => repository.inquireAccount(
        const AccountInquiryRequest(
          accountNumber: 'invalid',
          bankCode: '001',
        ),
      ),
      throwsA(isA<AccountFailure>()),
    );
  });
}

