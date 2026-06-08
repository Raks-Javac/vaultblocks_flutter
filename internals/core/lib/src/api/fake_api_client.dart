import '../errors/app_failure.dart';
import '../result/app_result.dart';
import 'api_client.dart';

class FakeApiClient implements ApiClient {
  const FakeApiClient();

  static const List<JsonMap> _accounts = <JsonMap>[
    <String, dynamic>{
      'accountNumber': '0123456789',
      'accountName': 'Amina Bello',
      'accountType': 'Savings',
      'currency': 'NGN',
      'isPrimary': true,
      'isActive': true,
      'productCode': 'SAV-001',
      'branchCode': '001',
      'availableBalance': 245000.50,
      'ledgerBalance': 247500.75,
    },
    <String, dynamic>{
      'accountNumber': '9876543210',
      'accountName': 'Jordan Okafor',
      'accountType': 'Current',
      'currency': 'NGN',
      'isPrimary': false,
      'isActive': true,
      'productCode': 'CUR-002',
      'branchCode': '014',
      'availableBalance': 98250.00,
      'ledgerBalance': 99500.00,
    },
  ];

  static const Map<String, String> _bankNames = <String, String>{
    '001': 'Demo First Bank',
    '014': 'Demo Trust Bank',
    '058': 'Demo Horizon Bank',
    '215': 'Demo Unity Bank',
  };

  @override
  Future<AppResult<JsonMap>> get(
    String path, {
    Map<String, String> headers = const <String, String>{},
  }) async {
    if (path == '/accounts') {
      return AppResult<JsonMap>.success(<String, dynamic>{'accounts': _accounts});
    }

    return AppResult<JsonMap>.failure(
      const AppFailure(
        code: 'not_found',
        message: 'The requested fake endpoint does not exist.',
      ),
    );
  }

  @override
  Future<AppResult<JsonMap>> post(
    String path, {
    Map<String, String> headers = const <String, String>{},
    JsonMap body = const <String, dynamic>{},
  }) async {
    if (path != '/accounts/inquiry') {
      return AppResult<JsonMap>.failure(
        const AppFailure(
          code: 'not_found',
          message: 'The requested fake endpoint does not exist.',
        ),
      );
    }

    final String accountNumber = '${body['accountNumber'] ?? ''}';
    final String bankCode = '${body['bankCode'] ?? ''}';

    if (!_isValidAccountNumber(accountNumber)) {
      return AppResult<JsonMap>.failure(
        AppFailure(
          code: 'invalid_account_number',
          message: 'The fake backend rejected the account number.',
          details: <String, dynamic>{
            'accountNumber': accountNumber,
          },
        ),
      );
    }

    final String bankName = _bankNames[bankCode] ?? 'Demo Transfer Bank';

    return AppResult<JsonMap>.success(
      <String, dynamic>{
        'accountNumber': accountNumber,
        'accountName': 'Demo Customer $accountNumber',
        'bankCode': bankCode,
        'bankName': bankName,
        'isValid': true,
      },
    );
  }

  bool _isValidAccountNumber(String value) {
    return RegExp(r'^\d{10}$').hasMatch(value);
  }
}

